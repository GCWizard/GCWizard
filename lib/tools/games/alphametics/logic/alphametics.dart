import 'dart:core';
import 'dart:collection';
import 'dart:math';

import 'package:math_expressions/math_expressions.dart';
part 'alphametics01.dart';

final operators = r'\+|\-|\*|\/';


class Formula {
  late String formula;
  bool onlyAddition = false;
  late HashSet<String> usedMembers;

  Formula(String equations) {
    formula = equations;
  }
}

List<Formula> ConvertAndCleanEquations(List<String> equations) {
  List<Formula> _equations = [];
  for (int i = 0; i < equations.length; i++)
  {
    _equations.add(Formula(equations[i].replaceAll("==", "=").replaceAll(" ", "")));
  }
  return _equations;
}

void removeLeadingZero(List<Formula> equations, PossibleValues possibleValues) {
  for (var equation in equations) {
    if (equation.onlyAddition) {
      var members = equation.formula.split('=');
      var result = members[1];
      var terms = members[0].split(RegExp(operators));

      possibleValues.removeLeadingZero(terms, result);
    }
  }}

class PossibleValues {
  final Map<String, List<int>> _possibleValues;

  PossibleValues(this._possibleValues);

  bool isSuccess() {
    return _possibleValues.values.every((v) => v.length == 1);
  }

  List<Map<String, int>> getPossibleDictionaries(String letter, int possibleValue, Set<String> usedMembers) {
    var result = <Map<String, int>>[];
    var keysSortedByCountOfValues = _possibleValues.keys.where((member) => usedMembers.contains(member)).toList()
      ..sort((a, b) => _possibleValues[a]!.length.compareTo(_possibleValues[b]!.length));

    for (var key in keysSortedByCountOfValues) {
      var values = key == letter ? [possibleValue] : _possibleValues[key]!;

      if (result.isEmpty) {
        for (var i in values) {
          result.add({key: i});
        }
      } else {
        var tmp = <Map<String, int>>[];

        for (var j = 0; j < result.length; j++) {
          var curDic = result[j];
          var curValues = values.where((v) => !curDic.containsValue(v)).toList();

          if (curValues.isEmpty) {
            result.removeAt(j);
            j--;
            continue;
          }

          for (var curValue in curValues) {
            if (!curDic.containsKey(key)) {
              curDic[key] = curValue;
            } else {
              var newDictionary = Map<String, int>.from(curDic);
              newDictionary[key] = curValue;
              tmp.add(newDictionary);
            }
          }
        }
        result.addAll(tmp);
      }
    }

    return result.where((dic) => dic.keys.length == usedMembers.length).toList();
  }

  Map<String, int> getResult() {
    return Map.fromEntries(_possibleValues.entries.map((e) => MapEntry(e.key, e.value[0])));
  }

  Map<String, List<int>> getPossibleValues() {
    return Map.from(_possibleValues);
  }

  Map<String, List<int>> getPossibleValues_(Set<String> usedMembers) {
    return Map.fromEntries(_possibleValues.entries.where((entry) => usedMembers.contains(entry.key)));
  }

  void set(String ch, int val) {
    _possibleValues[ch] = [val];

    for (var key in _possibleValues.keys.where((k) => k != ch)) {
      remove(key, val);
    }
  }

  void remove(String ch, int val) {
    if (!_possibleValues[ch]!.contains(val)) {
      return;
    }

    _possibleValues[ch]!.remove(val);

    if (_possibleValues[ch]!.isEmpty) {
      throw ArgumentError("No solution");
    }

    if (_possibleValues[ch]!.length == 1) {
      for (var key in _possibleValues.keys.where((k) => k != ch)) {
        remove(key, _possibleValues[ch]![0]);
      }
    }
  }

  void removeLeadingZero(List<String> terms, String result) {
    if (_possibleValues.containsKey(result[0])) remove(result[0], 0);

    for (var ch in terms.map((t) => t[0]).toSet()) {
      if (_possibleValues.containsKey(ch)) remove(ch, 0);
    }
  }

  void checkFirstLetterInResult(List<String> terms, String result) {
    var maxSum = terms.map((t) => pow(10, t.length) as int).reduce((a, b) => a + b);
    var maxSumStr = maxSum.toString();

    if (maxSumStr.length > result.length) {
      return;
    }

    if (maxSumStr.startsWith('1')) {
      set(result[0], 1);
    } else {
      for (var i = int.parse(maxSumStr[0]) + 1; i < 10; i++) {
        remove(result[0], i);
      }
    }
  }

  Iterable<Iterable<int>> permutations(Set<String> usedMembers) {
    Iterable<Iterable<int>> emptyList = [<int>[]];
    var val = getPossibleValues_(usedMembers).values;
    var r = val.fold(emptyList, (accumulator, sequence) {
      return accumulator.expand((accseq) {
        return sequence.where((value) => !accseq.contains(value)).map((item) => [...accseq, item]);
      });
    });
    return r;
  }
}