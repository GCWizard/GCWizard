import 'dart:convert';
import 'dart:core';
import 'dart:isolate';
import 'dart:math';
import 'dart:collection';
import "package:collection/collection.dart";
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';
import 'package:math_expressions/math_expressions.dart';

class SymbolMatrix {
  List<List<String>> matrix =[];
  Map<String, String> substitutions = {};
  late int columnCount;
  late int rowCount;

  SymbolMatrix (this.rowCount, this.columnCount, {SymbolMatrix? oldMatrix}) {
    matrix = <List<String>>[];
    for(var y = 0; y < getRowsCount(); y++) {
      matrix.add(List<String>.filled(getColumnsCount(), ''));
    }

    if (oldMatrix != null) {
      for(var y = 0; y < min(matrix!.length, oldMatrix.matrix.length); y++) {
        for (var x = 0; x < min(matrix![y].length, oldMatrix.matrix[y].length); x++) {
          matrix[y][x] = oldMatrix.matrix![y][x];
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

  String? getOperator(int y, int x) {
    if  (!_validPosition(y, x)) {
      return null;
    }
    var value = matrix[y][x];
    if (!operatorList.containsKey(value)) {
      value = operatorList.keys.first;
      setValue(y, x, value);
    }
    return value;
  }

  String? getValue(int y, int x) {
    if (!_validPosition(y, x)) {
      return null;
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
            if (matrix[y][x].isEmpty) {
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

  String buildRowFormula(int y) {
    var formula = '';
    for (var x = 0; x < matrix[y].length; x++) {
      if (x % 2 == 0) {
        formula += matrix[y][x];
      } else if (x < getColumnsCount() - 2) {
        formula += operatorList[matrix[y][x]]!;
      } else {
        formula += '-('; //=
      }
    }
    return formula + ')';
  }

  String buildColumnFormula(int x) {
    var formula = '';
    for (var y = 0; y < matrix.length; y++) {
      if (y % 2 == 0) {
        formula += matrix[y][x];
      } else if (y < getRowsCount() - 2) {
        formula += operatorList[matrix[y][x]]!;
      }else {
        formula += '-('; //=
      }
    }
    return formula + ')';
  }

  String toJson() {
    var list = <String>[];
    for(var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        if (matrix[y][x].isNotEmpty) {
          list.add(({'x': x, 'y': y, 'v': matrix[y][x]}).toString());
        }
      }
    }

    return (jsonEncode({'columns': columnCount, 'rows': rowCount,
      'values': list.toString(), 'substitutions': _toJsonSubstitutions(substitutions)}).toString());
  }

  static String? _toJsonSubstitutions(Map<String, String>? substitutions) {
    if (substitutions == null) return null;
    var list = <String>[];
    substitutions.forEach((key, value) {
      list.add(jsonEncode({'key': key, 'value': value}));
    });

    if (list.isEmpty) return null;

    return jsonEncode(list);
  }


  static SymbolMatrix? fromJson(String text) {
    if (text.isEmpty) return null;
    var json = asJsonMap(jsonDecode(text));

    SymbolMatrix matrix;
    // var rowCount = toIntOrNull(json['rows']);
    // var columnCount = toIntOrNull(json['columns']);
    // var values = asJsonMap(json['values']);
    // if (rowCount == null || columnCount == null) return null;
    //
    // matrix = SymbolMatrix(rowCount, columnCount);
    // if (values.isNotEmpty) {
    //   values.forEach((key, value) {
    //     var element = asJsonMap(jsonDecode(value));
    //     var x = toIntOrNull(element['x']);
    //     var y = toIntOrNull(element['y']);
    //     var value = toStringOrNull(element['v']);
    //     if (x != null && y != null && value != null) {
    //       matrix.setValue(y, x, value);
    //     }
    //   }
    // }
    // matrix.substitutions = _fromJsonSubstitutions(jsonDecode(json)['substitutions']);
    // return matrix;
  }

  static Map<String, String> _fromJsonSubstitutions(List<dynamic> json) {
    var substitutions = <String, String>{};
    String? key;
    String? value;

    // json.forEach((jsonEntry) {
    //   var json = jsonDecode(jsonEntry);
    //   key = toStringOrNull(json['key']);
    //   value = toStringOrNull(json['value']);
    //   if (key != null && value != null) substitutions.addAll({key: value});
    // });

    return substitutions;
  }
}

const Map<String, String> operatorList = {
  '+':'+',
  '-':'-',
  '*':'*',
  '÷':'/'
};


class SymbolArithmeticJobData {
  final List<String> formulas;
  final Map<String, String> substitutions;

  SymbolArithmeticJobData({
    required this.formulas,
    required this.substitutions,
  });
}

class SymbolArithmeticOutput {
  final List<String> formulas;
  final List<Map<String, String>> solutions;
  final bool error;

  SymbolArithmeticOutput({
    required this.formulas,
    required this.solutions,
    required this.error,
  });
}

Future<SymbolArithmeticOutput> solveAlphameticsAsync(GCWAsyncExecuterParameters?  jobData) async {
  if (jobData?.parameters is! SymbolArithmeticJobData) {
    return SymbolArithmeticOutput(formulas: [], solutions: [], error: true);
  };

  var data = jobData!.parameters as SymbolArithmeticJobData;

  var output = solveSymbolArithmetic(data.formulas, data.substitutions,
      sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort!.send(output);

  return output;
}

SymbolArithmeticOutput solveSymbolArithmetic(
    List<String> formulas, Map<String, String> substitutions,
    {SendPort? sendAsyncPort}) {
  if (formulas.isEmpty || substitutions.isEmpty) {
    SymbolArithmeticOutput(formulas: formulas, solutions: [], error: true);
  }

  ContextModel _context = ContextModel();
  Parser parser = Parser();
  List<Map<String, String>> solutions;
  var orderdSubstitutions = _sortSubstitutionsByLength(substitutions);

  try {
    solutions = _solver(formulas, orderdSubstitutions, parser, _context);
  } catch (e) {
    return SymbolArithmeticOutput(formulas: formulas, solutions: [], error: true);
  }

print(solutions);

   if (solutions.isEmpty) {
     return SymbolArithmeticOutput(formulas: formulas, solutions: [], error: true);
   }

  var results = <Map<String, dynamic>>[];
  for (var solution in solutions) {
    results.add({'variables': solution});
  }

  return SymbolArithmeticOutput(formulas: formulas, solutions: solutions, error: false);
}

List<Map<String, String>> _solver(List<String> formulas, Map<String, String> substitutions,
    Parser parser, ContextModel _context) {

  List<Map<String, dynamic>> solutions;
  List<Map<String, String>> newSubstitutions = [];

  for (int i = 0; i < formulas.length; i++) {
    solutions = _solveFormula(formulas[i], _getCurrentSubstitutions(formulas[i], substitutions), parser, _context);
    if (solutions.isNotEmpty) {
      // formula solved ?
      if (solutions.length == 1) {
        formulas.removeAt(i);
        i--;
      }
      newSubstitutions = mergeSolutions(substitutions, solutions);
      // all formulas solved ?
      if (formulas.isEmpty) {
        return newSubstitutions;
      }

      for (var _newSubstitutions in newSubstitutions) {
        // check other substitution in solution tree
        newSubstitutions = _solver(formulas, _newSubstitutions, parser, _context);
        // all formulas solved ?
        if (formulas.isEmpty) {
          continue;
        }
      }
    }
  }

  return newSubstitutions;
}

List<VariableStringExpanderValue> _solveFormula(String formula, Map<String, String> substitutions,
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
  for (var solution in solutions) {
    var _substitutions= <String, String>{};

    substitutions.forEach((key, value) {
      if (solution['variables'].containsKey(key)) {
        _substitutions.addAll({key: solution['variables'][key]});
      } else {
        _substitutions.addAll({key: value});
      }
    });
    newSubstitutions.add(_substitutions);
  }

  return newSubstitutions;
}

List<String> sortFormulasByUsedSubstitutionsCount(List<String> formulas, Map<String, String> substitutions) {
  var usedSubstitutionsCount = <int>[];

  for (var formula in formulas) {
    usedSubstitutionsCount.add(_getCurrentSubstitutions(formula, substitutions).length);
  }

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

Map<String, int> Solve(String equation) {
  if (equation.isEmpty) return {};

  var chars = Helper._unknowns(equation);
  if (chars.isEmpty) return {};
  var k = chars.length;
  var tokens = Helper._tokenise(Helper._mapCharsToTokens(chars), equation);
  var columns = Helper._parse(tokens);
  var zeroMask = Helper._buildZeroMask(Helper._noLeadingZero(tokens), k);

  bool _canBeZero(Iterable<int> perm) {
    var found = perm.toList().indexOf(0);
    return found == -1 || zeroMask[found];
  }

  var res = Helper._kPerms(_range, k).where((l) => _canBeZero(l)).where((p) => _colSum(columns, p)).first;
  return res != null
    ? Map<String, int>.fromIterables(chars, res)// res.Zip(chars, (i, c) => (c, i)).ToDictionary((kvp) => kvp.c, kvp => kvp.i)
    : {}; // throw new ArgumentException();
}

final List<int> _range = Iterable<int>.generate(10).toList();

bool _colSum(List<MapEntry<int, List<MapEntry<int, int>>>> cols, Iterable<int> perm){
  var carry = 0;

  for (var e in cols) {
    var y = e.key;
    var xs =  e.value;
    var sum = xs.map((k) => k.value * perm.elementAt(k.key)).sum + carry;
    if (perm.elementAt(y) == sum % 10) {
      carry = sum ~/ 10;
    } else {
      continue;
    }
  }
  return carry == 0;
}


class Helper {
  static void _swap(List<int> list, int from, int to) {
    var temp = list[to];
    list[to] = list[from];
    list[from] = temp;
  }

  static Iterable<Iterable<int>> _iterativeHeapPermute(Iterable<int> A) sync* {
    var n = A.length;
    var c = <int>[n];

    yield A;

    var i = 0; // error on wiki page says 1 should be 0

    while (i < n) {
      if (c[i] < i) {
        if ((i & 1) == 0) {
          _swap(A.toList(), 0, i);
        } else {
          _swap(A.toList(), c[i], i);
        }

        yield A;

        c[i]++;
        i = 0; // error on wiki page says 1 should be 0
      }
      c[i] = 0;
      i++;
    }
  }


  static Iterable<Iterable<int>> _combinations(Iterable<int> values, int k) {
    return (k == 0)
      ? [<int>[]]
      : _selectMany(_mapIndexed(values, (e, i) => _combinations(values.skip(i + 1), k - 1).map((c) => (e == null || c.isEmpty)
        ? [<int>[]]
        : e.followedBy(c))));
  }

  static Iterable<Iterable<int>> _kPerms(List<int> values, int k) {

    // var l1= <int>[1,2,3];
    // var l2= <int>[1,2,3];
    //  var l3 = _selectMany({l1,l2});
    //  l3=l3;
    return (k == values.length)
      ? _iterativeHeapPermute(values)
      : _selectMany(_combinations(values, k).map((e) => _iterativeHeapPermute(e)));

    //    : Combinations(values, k).SelectMany(v => IterativeHeapPermute(v.ToList()));
  }

  static Iterable<Iterable<int>> _transpose(Iterable<Iterable<int>> list) {
    return (list.isEmpty)
      ? list
      : Iterable<int>.generate(list.first.length).map((x) => list.map((y) => _elementAtOrDefault(y, x, 0)));
  }

  static Iterable<String> _unknowns(String equation) {
    return equation.split('').where((c) => !" +=".contains(c)).toSet();
  }

  static Map<String, int> _mapCharsToTokens(Iterable<String> chars) {
    return switchMapKeyValue(chars.toList().asMap());
  }

  static List<List<int>> _tokenise(Map<String, int> tokens, String input) {
    return input.replaceAll("==", "=").replaceAll(" ", "")
        .split(RegExp(r"\+|="))
        .map((item) => item.split('').map((c) => tokens[c]).whereType<int>().toList()).toList();
  }

  static HashSet<int> _noLeadingZero(Iterable<Iterable<int>> input) {
    return HashSet.from(input.map((f) => f.first));
  }

  static List<bool> _buildZeroMask(HashSet<int> noZeroSet, int size) {
    return Iterable<int>.generate(size).map((z) => !noZeroSet.contains(z)).toList();
  }

  static List<MapEntry<int, List<MapEntry<int, int>>>> _parse(Iterable<Iterable<int>> input) {
    var list = input.map((l) => l.toList().reversed.map((i) => i + 1)) // ElementAtOrDefault default is 0
        .toList().reversed;

    var l1 = _transpose(list);
    var l2 = l1.map((r) => r.where((i) => i > 0).map((i) => i - 1)); // ElementAtOrDefault default is 0
    var l3 = l2.map((col) => MapEntry<int, List<MapEntry<int, int>>>(col.first, groupBy(col.skip(1), (i) => i).map((grpKey, grpValue) => MapEntry<int, int>(grpKey, grpValue.length)).entries .toList())); //.map((grp) => (grp.Key, grp.Count())).toList())).toList();
    return l3.toList();
  }

  static Iterable<E> _mapIndexed<T, E>(Iterable<T> items, E Function(T item, int index) f) sync* {
    var index = 0;

    for (final item in items) {
      if (item == null ) {
        continue;
      }
      yield f(item, index);
      index += 1;
    }
  }

// https://stackoverflow.com/questions/15413248/how-to-flatten-a-list

//var flat = a.expand((i) => i).toList();

  ///List<T> flatten<T>(Iterable<Iterable<T>> list) =>
  //     [for (var sublist in list) ...sublist];
  static Iterable<TResult> _selectMany<TResult>(Iterable<Iterable<TResult>> items) { //Iterable<TResult>
    if (items.isEmpty) {
      return {};
    }
    var result = items.elementAt(0);
    items.skip(1).forEach((element) {
      result = result.followedBy(element);
    });
    return result;
    // var planets = <String>['Earth', 'Jupiter'];
    // var updated = planets.followedBy(['Mars', 'Venus']);
    // updated=updated;
    // planets.
    // // var lt = items.reduce((a, b) => a.followedBy(b));
    // // lt=lt;
    // // Set<TResult> kk = lt;
    // mergeSolutions(substitutions, solutions)
    // return items.merge(items);
    // return items..merge ((index, r) => r);
    // return items.reduce((value, element) => null).mapIndexed ((index, r) => r);


    // items.mapIndexed((index, element) => null)
    // var index = 0;
    // for (final item in items) {
    //   yield items.elementAt(index);
    //   index += 1;
    // };
    // if (items.isEmpty)
    //   return null;
    // var result = items.first;
    // items.skip(1).forEach((element) {
    //   result = result.followedBy(element);
    // });
    // return result; //items..elementAt(0).followedBy(items.elementAt(1)); //items.reduce((a, b) => a.followedBy(b));
  }

  static TResult _elementAtOrDefault<TResult>(Iterable<TResult> items, int index, TResult _default) {
    try{
      return items.elementAt(index);
    } catch (e) {
      return _default;
    }
  }

}

String getOutput(String equation, Map<String, int> result) {
  Map<String,String> substitutions = Map.from(result);
  return substitution(equation, substitutions);
}

Iterable<Iterable<int>> Permutations1(Iterable<Iterable<int>> sequences) {
  Iterable<Iterable<int>> emptyList = [<int>[]];

  return sequences.fold( emptyList, (accumulator, sequence) =>
          accumulator.map((Iterable<int> accseq) {
            sequence.where((value) => !accseq.contains(value)).forEach((item) {
              accseq.followedBy(<int>[item]);
            });
          }
        )
      });
    );
  }
}
// return sequences.fold( emptyList,
// (accumulator, sequence) =>
// accumulator.map((accseq) =>
// sequence.where((value) => !accseq.contains(value)).map((item) {
// accseq.followedBy({item ?? 0}) ?? 0;
// });
// });
// );
// }

  //     from item in sequence.Where(value => !accseq.Contains(value))
  // select accseq.Concat(new[] { item }));

  // return sequences.Aggregate( emptyList,
  //     (accumulator, sequence) =>
  //     from accseq in accumulator
  //     from item in sequence.Where(value => !accseq.Contains(value))
  //     select accseq.Concat(new[] { item }));
// }


