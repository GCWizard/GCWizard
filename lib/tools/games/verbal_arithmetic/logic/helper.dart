import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:utility/utility.dart';

const int MAX_SOLUTIONS = 100;
const int MAX_GRIDSIZE = 20;

class VerbalArithmeticJobData {
  final List<String> equations;
  final Map<String, String> substitutions;
  final bool allSolutions;
  final bool allowLeadingZeros;

  VerbalArithmeticJobData({
    required this.equations,
    required this.substitutions,
    required this.allSolutions,
    required this.allowLeadingZeros,
  });
}

class VerbalArithmeticOutput {
  final List<Equation> equations;
  final List<HashMap<String, int>> solutions;
  final String error;

  VerbalArithmeticOutput({
    required this.equations,
    required this.solutions,
    required this.error,
  });
}

const Map<String, String> operatorList = {
  '+':'+',
  '-':'-',
  '*':'*',
  '÷':'/'
};


final parser = Parser();

class Equation {
  late String equation;
  late String formatedEquation;
  late Expression exp;
  late List<Token> token;
  bool singleLetter = false;
  bool rearrange = false;
  bool validFormula = true;
  Set<String> usedMembers = <String>{};
  Set<String> leadingLetters = <String>{};

  Equation(this.equation, {this.singleLetter = false, this.rearrange = false}) {
    equation = equation.toUpperCase();
    formatedEquation = _formatEquation();
    validFormula &= !(formatedEquation.count('=') > 1);
    if (rearrange) {
      formatedEquation = _rearrange(formatedEquation);
    }
    if (singleLetter) {
      // Extract all letters and determine the leading letters
      for (var token in formatedEquation.split(RegExp(r'[^A-Z]'))) {
        if (token.isNotEmpty) {
          usedMembers.addAll(token.split(''));
          leadingLetters.add(token[0]);
        }
      }
    } else {
      token = parser.lex.tokenize(formatedEquation);
      if (formatedEquation.isNotEmpty) {
        exp = parser.parse(formatedEquation);
      } else {
        validFormula = false;
      }

      usedMembers = token.where((t) => t.type == TokenType.VAR).map((t) => t.text).toSet();
    }
  }

  Iterable<int> get Values {
    return token.where((t) => t.type == TokenType.VAL).map((t) => int.parse(t.text));
  }

  bool get onlyAddition {
    for (var op in ['-','*','/']) {
      if (formatedEquation.contains(op)) {
        return false;
      }
    }
    return formatedEquation.contains('+');
  }

  bool get containsNumbers {
    return RegExp(r'\d').hasMatch(formatedEquation);
  }

  String _formatEquation() {
    const  operatorReplaceList = {
      '÷':'/'
    };
    var out = equation.replaceAll('==', '=');
    for (var op in operatorReplaceList.entries) {
      out = out.replaceAll(op.key, op.value);
    }
    return out.trim();
  }

  String _rearrange(String equation) {
    if (equation.contains('=')) {
      var members = equation.split('=');
      equation = members[0] + '-(' + members[1]+ ')';
    }
    return equation;
  }

  String getOutput(HashMap<String, int> result) {
    return replaceValues(equation, result);
  }

  static String replaceValues(String equation, Map<String, int> mapping) {
    for (var key in mapping.keys) {
      equation = equation.replaceAll(key, mapping[key].toString());
    }
    return equation;
  }
}

class SymbolMatrixString {
  static List<String> buildEquations(String input) {
    if (input.trim().isEmpty) return [];
    var equations = const LineSplitter().convert(input);
    deleteEmptyLines(equations);
    equations = equations.map((equation) => equation.trim()).toList();
    return equations;
  }

  static void deleteEmptyLines(List<String> equations) {
    equations.removeWhere((equation) => equation.trim().isEmpty);
  }
}

class SymbolMatrixGrid {
  List<List<String>> matrix = [];
  late int columnCount;
  late int rowCount;

  SymbolMatrixGrid (this.rowCount, this.columnCount, {SymbolMatrixGrid? oldMatrix}) {
    matrix = <List<String>>[];
    rowCount = min(max(2, rowCount), MAX_GRIDSIZE);
    columnCount = min(max(2, columnCount), MAX_GRIDSIZE);
    for(var y = 0; y < getRowsCount(); y++) {
      matrix.add(List<String>.filled(getColumnsCount(), ''));
    }

    if (oldMatrix != null) {
      for(var y = 0; y < min(matrix.length, oldMatrix.matrix.length); y++) {
        for (var x = 0; x < min(matrix[y].length, oldMatrix.matrix[y].length); x++) {
          matrix[y][x] = oldMatrix.matrix[y][x];
        }
      }
    }
  }

  int getColumnsCount() {
    return columnCount * 2 + 1;
  }
  int getRowsCount() {
    return rowCount * 2 + 1;
  }

  String getOperator(int y, int x) {
    if (!_validPosition(y, x)) {
      return '';
    }
    var value = matrix[y][x];
    if (!operatorList.containsKey(value)) {
      if (x != getColumnsCount() - 1 && y != getRowsCount() - 1) {
        value = operatorList.keys.first;
        setValue(y, x, value);
      } else if (value != '') {
        value = operatorList.keys.first;
        setValue(y, x, value);
      }
    }
    return value;
  }

  String getValue(int y, int x) {
    if (!_validPosition(y, x)) {
      return '';
    }
    return matrix[y][x];
  }

  void setValue(int y, int x, String text) {
    if (!_validPosition(y, x)) {
      return;
    }
    matrix[y][x] = text;
  }

  bool _validPosition(int y, int x) {
    return !(y >= matrix.length || matrix[y].isEmpty || x >= matrix[y].length);
  }

  bool isValidMatrix() {
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (y % 2 == 0) {
          if (x % 2 == 0) {
            if (matrix[y][x].isEmpty && y != matrix.length -1) {
              return false;
            }
          } else if (x < getColumnsCount() - 2 && y < getRowsCount() - 2) {
            if (!operatorList.keys.contains(matrix[y][x])) {
              return false;
            }
          }
        } else {
          if (x % 2 == 0 && x < getColumnsCount() - 1) {
            if ((y < getRowsCount() - 2) && (!operatorList.keys.contains(matrix[y][x]))) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  String _buildRowEquation(int y) {
    var formula = '';
    for (var x = 0; x < matrix[y].length; x++) {
      if (x % 2 == 0) {
        if (getValue(y, x).isEmpty) return '';
        formula += getValue(y, x);
      } else if (x < getColumnsCount() - 2) {
        if (getOperator(y, x).isEmpty) return '';
        formula += ' ' + getOperator(y, x) + ' ';
      } else {
        formula += ' = ';
      }
    }
    return formula;
  }

  String _buildColumnEquation(int x) {
    var formula = '';
    for (var y = 0; y < matrix.length; y++) {
      if (y % 2 == 0) {
        if (getValue(y, x).isEmpty) return '';
        formula += matrix[y][x];
      } else if (y < getRowsCount() - 2) {
        if (getOperator(y, x).isEmpty) return '';
        formula += ' ' + getOperator(y, x) + ' ';
      } else {
        formula += ' = ';
      }
    }
    return formula;
  }

  List<String> buildEquations() {
    var equations = <String>[];
    String equation;

    if (!isValidMatrix()) return equations;
    for(var y = 0; y < getRowsCount() - (calcLastRow() ? 0 : 2); y += 2) {
      equation = _buildRowEquation(y);
      if (equation.isEmpty) {
        if (y != getRowsCount() - 1) return [];
      } else {
        equations.add(equation);
      }
    }
    for(var x = 0; x < getColumnsCount() - (calcLastColumn() ? 0 : 2); x += 2) {
      equation = _buildRowEquation(x);
      if (equation.isEmpty) {
        if (x != getColumnsCount() - 1) return [];
      } else {
        equations.add(equation);
      }
    }
    return equations;
  }

  bool calcLastColumn() {
    var rowsCount = getRowsCount() - 1;
    var columnsCount = getColumnsCount() - 1;

    for(var rowIndex = 1; rowIndex < rowsCount - 1; rowIndex += 2) {
      if (getOperator(rowIndex, columnsCount).isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  bool calcLastRow() {
    var rowsCount = getRowsCount() - 1;
    var columnsCount = getColumnsCount() - 1;

    for(var columnIndex = 1; columnIndex < columnsCount - 1; columnIndex += 2) {
      if (getOperator(rowsCount, columnIndex).isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  String toJson() {
    var list = <String>[];
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (matrix[y][x].isNotEmpty) {
          list.add(jsonEncode(<String, Object>{'x': x, 'y': y, 'v': matrix[y][x]}));
        }
      }
    }
    return jsonEncode({'columns': columnCount, 'rows': rowCount, 'values': jsonEncode(list)});
  }

  static SymbolMatrixGrid? fromJson(String text) {
    if (text.isEmpty) return null;
    try {
      var json = asJsonMap(jsonDecode(text));

      var rowCount = toIntOrNull(json['rows']);
      var columnCount = toIntOrNull(json['columns']);
      var valueString = toStringOrNull(json['values']);
      if (valueString == null) return null;
      var values = toStringListOrNull(jsonDecode(valueString));
      if (rowCount == null || columnCount == null || values == null) return null;

      var matrix = SymbolMatrixGrid(rowCount, columnCount);
      if (values.isNotEmpty) {
        for (var _value in values) {
          var element = asJsonMap(jsonDecode(_value.toString()));
          var x = toIntOrNull(element['x']);
          var y = toIntOrNull(element['y']);
          var value = toStringOrNull(element['v']);
          if (x != null && y != null && value != null) {
            matrix.setValue(y, x, value);
          }
        }
      }
      return matrix;
    } catch (e) {
      return null;
    }
  }
}

int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

