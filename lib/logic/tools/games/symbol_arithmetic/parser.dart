import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/logic/common/parser/variable_string_expander.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/logic/tools/formula_solver/formula_parser.dart';
import 'package:math_expressions/math_expressions.dart';

class SymbolMatrix {
  List<List<String>> matrix;
  var columnCount;
  var rowCount;

  SymbolMatrix (int rowCount, int columnCount, {SymbolMatrix oldMatrix}) {
    this.columnCount = columnCount;
    this.rowCount = rowCount;

    matrix =<List<String>>[];
    for(var y = 0; y < getRowsCount(); y++)
      matrix.add(List<String>.filled(getColumnsCount(), null));

    if (oldMatrix != null) {
      for(var y = 0; y < min(matrix.length, oldMatrix.matrix.length); y++)
        for(var x = 0; x < min(matrix[y].length, oldMatrix.matrix[y].length); x++)
          matrix[y][x] = oldMatrix.matrix[y][x];
    }
  }

  int getColumnsCount() {
    return columnCount * 2 + 1;
  }
  int getRowsCount() {
    return rowCount * 2 + 1;
  }

  String getOperator(int y, int x) {
    if  (!_validPosition(y, x))
      return null;
    var value = matrix[y][x];
    if (!operatorList.containsKey(value)) {
      value = operatorList.keys.first;
      setValue(y, x, value);
    }
    return value;
  }

  String getValue(int y, int x) {
    if (!_validPosition(y, x))
      return null;
    return matrix[y][x];
  }
  void setValue(int y, int x, String text) {
    if (!_validPosition(y, x))
      return;
    matrix[y][x] = text;
  }

  bool _validPosition(int y, int x) {
    return !(matrix == null || y >= matrix.length || matrix[y] == null || x >= matrix[y].length);
  }

  bool isValidMatrix() {
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (y % 2 == 0) {
          if (x % 2 == 0) {
            if (matrix[y][x] == null || matrix[y][x].length == 0)
              return false;
          } else if (x < getColumnsCount() - 2 && y < getRowsCount() - 2) {
            if (!operatorList.keys.contains(matrix[y][x]))
              return false;
          }
        } else {
          if (x % 2 == 0 && x < getColumnsCount() - 1) {
            if (y < getRowsCount() - 2)
              if (!operatorList.keys.contains(matrix[y][x]))
                return false;
          }
        }
      }
    }
    return true;
  }

  String buildRow(int y) {
    var formula = '';
    for (var x = 0; x < matrix[y].length; x++) {
      if (x % 2 == 0)
        formula += matrix[y][x];
      else if (x < getColumnsCount() - 2)
        formula += operatorList[matrix[y][x]];
      else
        formula += '=';
    }
    return formula;
  }

  String buildColumn(int x) {
    var formula = '';
    for (var y = 0; y < matrix.length; y++) {
      if (y % 2 == 0)
        formula += matrix[y][x];
      else if (y < getRowsCount() - 2)
        formula += operatorList[matrix[y][x]];
      else
        formula += '=';
    }
    return formula;
  }

  String toJson() {
    var list = <String>[];
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (matrix[y][x] != null && matrix[y][x].isNotEmpty) {
          list.add(({'x': x, 'y': y, 'v': matrix[y][x]}).toString());
        }
      }
    }

    return (jsonEncode({'columns': columnCount, 'rows': rowCount, 'values': list.toString()}).toString());
  }


  static SymbolMatrix fromJson(String text) {
    if (text == null) return null;
    var json = jsonDecode(text);
    if (json == null) return null;

    SymbolMatrix matrix;
    var rowCount = jsonDecode(json)['rows'];
    var columnCount = jsonDecode(json)['columns'];
    var values = jsonDecode(json)['values'];
    if (rowCount == null || columnCount == null) return null;

    matrix = SymbolMatrix(rowCount, columnCount);
    if (values != null) {
      for (var jsonElement in values) {
        var element = jsonDecode(jsonElement);
        var x = element['x'];
        var y = element['y'];
        var value = element['v'];
        if (x != null && y != null && value != null)
          matrix.setValue(y, x, value);
      }
    }
    return matrix;
  }
}

final Map<String, String> operatorList = {
  '+':'+',
  '-':'-',
  '*':'*',
  '÷':'/'
};


class SymbolArithmeticJobData {
  final List<String> formulas;
  final Map<String, String> substitutions;

  SymbolArithmeticJobData({
    this.formulas,
    this.substitutions,
  });
}

Future<Map<String, dynamic>> solveSymbolArithmeticAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = solveSymbolArithmetic(jobData.parameters.formulas, jobData.parameters.substitutions,
      sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

Map<String, dynamic> solveSymbolArithmetic(
    List<String> formulas, Map<String, String> substitutions,
    {SendPort sendAsyncPort}) {
  if (formulas == null ||
      formulas.length == 0 ||
      substitutions == null) return null;

  ContextModel _context = ContextModel();
  Parser parser;
  var substitutedFormula = formulas.first;
  List<Map<String, dynamic>> expandedFormulas;


  try {
    expandedFormulas = VariableStringExpander(substitutedFormula, substitutions).run();
  } catch (e) {
    return {'state': FormulaState.STATE_SINGLE_ERROR, 'result': substitutedFormula};
  }

  Expression expression = parser.parse(formulas.first);
  var result = expression.evaluate(EvaluationType.REAL, _context);


  // var expander = VariableStringExpander(formulas.first, substitutions, onAfterExpandedText: (expandedText) {
  //   var withoutBrackets = expandedText.replaceAll(RegExp(r'[\[\]]'), '');
  //
  //   if (hashValue == input)
  //     return withoutBrackets;
  //   else
  //     return null;
  // }, sendAsyncPort: sendAsyncPort);
  //
  // var results = expander.run();
  //
  // if (results == null || results.length == 0) return {'state': 'not_found'};
  //
  // return {'state': 'ok', 'text': results[0]['text']};
}

// bool _solveFormula(String formula, Dictionary<String, int> binds)
// {
//   foreach (var bind in binds)
//   {
//     formula = formula.Replace(bind.Key, bind.Value.ToString());
//   }
//   var exp = new Expression(formula);
//   return (bool)exp.Eval();
// }


List<String> sortFormulasByUsedSubstitutionsCount(List<String> formulas, Map<String, String> substitutions) {
  var sortedKeys = _sortSubstitutionsByLength(substitutions);
  var usedSubstitutionsCount = <int>[];

  formulas.forEach((formula) {
    usedSubstitutionsCount.add(_usedSubstitutions(formula, sortedKeys).length);
  });

  return _sortByUsedSubstitutionsCount(formulas, usedSubstitutionsCount);
}

Map<String, String> _sortSubstitutionsByLength(Map<String, String> substitutions) {
  return Map.fromEntries(
      substitutions.entries.toList()..sort((e1, e2) => e1.key.length.compareTo(e2.key.length)));
}

Map<String, String> _usedSubstitutions(String formula, Map<String, String> sortedSubstitutions) {
  var usedKeys = Map<String, String>();

  sortedSubstitutions.forEach((key, value) {
    if (formula.contains(key)) {
      usedKeys.addAll({key: value});
      formula = formula.replaceAll(key, '');
    }
  });

  return usedKeys;
}

List<String> _sortByUsedSubstitutionsCount(List<String> formulas, List<int> keyCount) {
  var changed = true;

  while (changed) {
    changed = false;

    for (int i = 0; i < keyCount.length - 1; i++) {
      if (keyCount[i] > keyCount[i + 1]) {
        var tmp = keyCount[i];
        keyCount[i] = keyCount[i + 1];
        keyCount[i + 1] = tmp;

        var tmp1 = formulas[i];
        formulas[i] = formulas[i + 1];
        formulas[i + 1] = tmp1;

        changed = true;
      }
    }
  }

  return formulas;
}

