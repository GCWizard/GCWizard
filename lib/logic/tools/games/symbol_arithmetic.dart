import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:isolate';
import 'dart:math';
import 'dart:collection';
import "package:collection/collection.dart";
import 'dart:math';
import 'dart:typed_data';

import 'package:gc_wizard/logic/common/parser/variable_string_expander.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/book_cipher.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/logic/tools/formula_solver/formula_parser.dart';
import 'package:gc_wizard/utils/common_utils.dart';
import 'package:math_expressions/math_expressions.dart';

class SymbolMatrix {
  List<List<String>> matrix;
  Map<String, String> substitutions;
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

  String buildRowFromula(int y) {
    var formula = '';
    for (var x = 0; x < matrix[y].length; x++) {
      if (x % 2 == 0)
        formula += matrix[y][x];
      else if (x < getColumnsCount() - 2)
        formula += operatorList[matrix[y][x]];
      else
        formula += '-('; //=
    }
    return formula + ')';
  }

  String buildColumnFormula(int x) {
    var formula = '';
    for (var y = 0; y < matrix.length; y++) {
      if (y % 2 == 0)
        formula += matrix[y][x];
      else if (y < getRowsCount() - 2)
        formula += operatorList[matrix[y][x]];
      else
        formula += '-('; //=
    }
    return formula + ')';
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

    return (jsonEncode({'columns': columnCount, 'rows': rowCount,
      'values': list.toString(), 'substitutions': _toJsonSubstitutions(substitutions)}).toString());
  }

  static _toJsonSubstitutions(Map<String, String> substitutions) {
    if (substitutions == null) return null;
    var list = <String>[];
    substitutions.forEach((key, value) {
      list.add(jsonEncode({'key': key, 'value': value}));
    });

    if (list.isEmpty) return null;

    return jsonEncode(list);
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
    matrix.substitutions = _fromJsonSubstitutions(jsonDecode(json)['substitutions']);
    return matrix;
  }

  static Map<String, String> _fromJsonSubstitutions(List<dynamic> json) {
    var substitutions = Map<String, String>();
    if (json == null) return null;
    String key;
    String value;

    json.forEach((jsonEntry) {
      var json = jsonDecode(jsonEntry);
      key = json['key'];
      value = json['value'];
      if (key != null && value != null) substitutions.addAll({key: value});
    });

    return substitutions.length == 0 ? null : substitutions;
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
  Parser parser = Parser();
  List<Map<String, dynamic>> solutions;
  var orderdSubstitutions = _sortSubstitutionsByLength(substitutions);

  try {
    solutions = _solver(formulas, orderdSubstitutions, parser, _context);
  } catch (e) {
    return {'state': FormulaState.STATE_SINGLE_ERROR, 'result': formulas};
  }

print(solutions);

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
   if (solutions == null) return {'state': 'not_found'};

  var results = <Map<String, dynamic>>[];
  for (var solution in solutions)
    results.add({'variables': solution});

  return {'state': 'ok', 'results': results};
}

List<Map<String, String>> _solver(List<String> formulas, Map<String, String> substitutions,
    Parser parser, ContextModel _context) {

  List<Map<String, dynamic>> solutions;
  List<Map<String, String>> newSubstitutions;

  for (int i = 0; i < formulas.length; i++) {
    solutions = _solveFormula(formulas[i], _getCurrentSubstitutions(formulas[i], substitutions), parser, _context);
    if (solutions != null && solutions.length > 0) {
      // formula solved ?
      if (solutions.length == 1) {
        formulas.removeAt(i);
        i--;
      }
      newSubstitutions = mergeSolutions(substitutions, solutions);
      // all formulas solved ?
      if (formulas.length == 0)
        return newSubstitutions;

      newSubstitutions.forEach((_newSubstitutions) {
        // check other substitution in solution tree
        newSubstitutions = _solver(formulas, _newSubstitutions, parser, _context);
        // all formulas solved ?
        if (formulas.length == 0)
          return newSubstitutions;
      });
    }
  }

  return newSubstitutions;
}

List<Map<String, dynamic>> _solveFormula(String formula, Map<String, String> substitutions,
    Parser parser, ContextModel _context) {
  var expander = VariableStringExpander(formula, substitutions, onAfterExpandedText: (expandedText) {
    Expression expression = parser.parse(expandedText);
    return expression.evaluate(EvaluationType.REAL, _context) == 0 ? '' : null;
  });
  return expander.run();
}

/// create new possible substitutions lists
List<Map<String, String>> mergeSolutions(Map<String, String> substitutions, List<Map<String, dynamic>> solutions) {
  var newSubstitutions = <Map<String, String>>[];
  solutions.forEach((solution) {
    var _substitutions= Map<String, String>();

    substitutions.forEach((key, value) {
      if (solution['variables'].containsKey(key))
        _substitutions.addAll({key: solution['variables'][key]});
      else
        _substitutions.addAll({key: value});
    });
    newSubstitutions.add(_substitutions);
  });

  return newSubstitutions;
}

List<String> sortFormulasByUsedSubstitutionsCount(List<String> formulas, Map<String, String> substitutions) {
  var usedSubstitutionsCount = <int>[];

  formulas.forEach((formula) {
    usedSubstitutionsCount.add(_getCurrentSubstitutions(formula, substitutions).length);
  });

  return _sortByCurrentSubstitutionsCount(formulas, usedSubstitutionsCount);
}

Map<String, String> _sortSubstitutionsByLength(Map<String, String> substitutions) {
  return Map.fromEntries(
      substitutions.entries.toList()..sort((e1, e2) => e1.key.length.compareTo(e2.key.length)));
}

Map<String, String> _getCurrentSubstitutions(String formula, Map<String, String> substitutions) {
  var currentSubstitutions = Map<String, String>();

  substitutions.forEach((key, value) {
    if (formula.contains(key)) {
      currentSubstitutions.addAll({key: value});
      formula = formula.replaceAll(key, '');
    }
  });

  return currentSubstitutions;
}

List<String> _sortByCurrentSubstitutionsCount(List<String> formulas, List<int> keyCount) {
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

Map<String, int> Solve(String equation)
{
  var chars = Helper.Unknowns(equation);
  var k = chars.length;
  var tokens = Helper.Tokenise(Helper.MapCharsToTokens(chars), equation);
  var columns = Helper.Parse(tokens);
  var zeroMask = Helper.BuildZeroMask(Helper.NoLeadingZero(tokens), k);

  bool CanBeZero(Iterable<int> perm)
  {
    var found = perm.toList().indexOf(0);
    return found == -1 || zeroMask[found];
  }

  var res1 = Helper.KPerms(Range, k).first;
  var res = Helper.KPerms(Range, k).where((l) => CanBeZero(l)).where((p) => ColSum(columns, p)).first;
  return res != null
      ? Map<String, int>.fromIterables(chars, res)// res.Zip(chars, (i, c) => (c, i)).ToDictionary((kvp) => kvp.c, kvp => kvp.i)
      : null; // throw new ArgumentException();
}

final List<int> Range = Iterable<int>.generate(10).toList();

bool ColSum(List<MapEntry<int, List<MapEntry<int, int>>>> cols, List<int> perm){
  var carry = 0;

  cols.forEach((e) {
    var y = e.key;
    var xs =  e.value;
    var sum = xs.map((k) => k.value * perm[k.key]).sum + carry;
    if (perm[y] == sum % 10)
      carry = (sum / 10).toInt();
    else
      return false;
  });
  return carry == 0;
}

void Swap(List<int> list, int from, int to) {
  var temp = list[to];
  list[to] = list[from];
  list[from] = temp;
}

class Helper {
  static void Swap(List<int> list, int from, int to) {
    var temp = list[to];
    list[to] = list[from];
    list[from] = temp;
  }

  static Iterable<Iterable<int>> IterativeHeapPermute(List<int> A) sync* {
    var n = A.length;
    var c = <int>[n];

    yield A;

    var i = 0; // error on wiki page says 1 should be 0

    while (i < n) {
      if (c[i] < i) {
        if ((i & 1) == 0)
          Swap(A, 0, i);
        else
          Swap(A, c[i], i);

        yield A;

        c[i]++;
        i = 0; // error on wiki page says 1 should be 0
      }
      c[i] = 0;
      i++;
    }
  }


  static Iterable<Iterable<int>> Combinations(Iterable<int> values, int k) {
    return (k == 0)
      ? {<int>[]}
      : selectMany(mapIndexed(values, (e, i) => Combinations(values.skip(i + 1), k - 1).map((c) => e.followedBy(c))));
    }

  static Iterable<E> mapIndexed<T, E>(Iterable<T> items, E Function(T item, int index) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(item, index);
      index = index + 1;
    }
  }

  static Iterable<TResult> selectMany<TResult>(Iterable<Iterable<TResult>> items) {
    return items.reduce((a, b) => a.followedBy(b));
  }


  static Iterable<Iterable<int>> KPerms(List<int> values, int k) {
    return (k == values.length)
      ? IterativeHeapPermute(values)
      : selectMany(Combinations(values, k).map((e) => IterativeHeapPermute(e)));

    //    : Combinations(values, k).SelectMany(v => IterativeHeapPermute(v.ToList()));
  }


  static Iterable<Iterable<int>> Transpose(Iterable<Iterable<int>> list) {
    return (list.isEmpty)
        ? list
        : Iterable<int>.generate(list.first.length).map((x) => list.map((y) => y.elementAt(x) ?? 0));
    //Enumerable.Range(0, list.First().Count()).Select(x => list.Select(y => y.ElementAtOrDefault(x)));
  }

  static Iterable<String> Unknowns(String equation) {
    return equation.split('').where((c) => !" +=".contains(c)).toSet();
  }


  static Map<String, int> MapCharsToTokens(Iterable<String> chars) {
    //return mapIndexed(chars, (e, i)
    return switchMapKeyValue(chars.toList().asMap());
    //return chars.map((c, i) => (c, i)).ToDictionary(kvp => kvp.c, kvp => kvp.i)
    // return chars.map((c, i) => (c, i)).ToDictionary(kvp => kvp.c, kvp => kvp.i);
  }

  static List<List<int>> Tokenise(Map<String, int> tokens, String input) {
    return input.replaceAll("==", "=").replaceAll(" ", "")
        .split(RegExp(r"\+|="))
        .map((item) => item.split('').map((c) => tokens[c]).toList()).toList();
  }


  static HashSet<int> NoLeadingZero(Iterable<Iterable<int>> input) {
    return HashSet.from(input.map((f) => f.first));
  }

  static List<bool> BuildZeroMask(HashSet<int> noZeroSet, int size) {
    return Iterable<int>.generate(size).map((z) => !noZeroSet.contains(z)).toList();
  }

// List<(int target, List<MapEntry<int key, int count>>)>
  static List<MapEntry<int, List<MapEntry<int, int>>>> Parse(Iterable<Iterable<int>> input) {
    var list = input.map((l) => l.toList().reversed.map((i) => i + 1)) // ElementAtOrDefault default is 0
        .toList().reversed;

    var l1 = Transpose(list);
    var l2 = l1.map((r) => r.where((i) => i > 0).map((i) => i - 1)); // ElementAtOrDefault default is 0
    var l3 = l2.map((col) => MapEntry<int, List<MapEntry<int, int>>>(col.first, groupBy(col.skip(1), (i) => i).map((grpKey, grpValue) => MapEntry<int, int>(grpKey, grpValue.length)).entries .toList())); //.map((grp) => (grp.Key, grp.Count())).toList())).toList();
    return l3.toList();
  }

}

