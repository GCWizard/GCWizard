import'dart:collection';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

class Formula {
  late String formula;
  bool onlyAddition = false;
  late HashSet<String> usedMembers;

  Formula(String equations) {
    formula = equations;
  }
}

class Alphametics01 {
  // static var operators = { '+', '-', '*', '/' };

  static List<Map<String, int>>? solve(Formula equation, PossibleValues possibleValues, {bool allSolutions = false}) {
    var solutions = <Map<String, int>>[];
    var members = equation.formula.split('=');
    var result = members[1];
    var terms = members[0].split(RegExp(r'\+\-\*\/'));
    Parser parser = Parser();

    if (equation.onlyAddition) {
      checkEquality(terms, result);
    }

    terms.sort((a, b) => a.compareTo(b));

    if (equation.onlyAddition) {
      possibleValues.checkFirstLetterInResult(terms, result);
    }

    try {
      while (!possibleValues.isSuccess()) {
        var tmpPv = possibleValues.getPossibleValues_(equation.usedMembers);
        var candidateChar = tmpPv.keys.reduce((a, b) => tmpPv[a]!.length > tmpPv[b]!.length ? a : b);
        if (tmpPv[candidateChar]!.isEmpty) break;

        int candidateNum = tmpPv[candidateChar]![0];

        var tmpDics = possibleValues.getPossibleDictionaries(candidateChar, candidateNum, equation.usedMembers);

        for (var tmpDic in tmpDics) {
          if (isCorrect(tmpDic, terms, result, equation.formula, equation.onlyAddition, parser)) {
            solutions.add(buildResult(tmpDic));
            if (!allSolutions) {
              return solutions;
            }
          }
        }
        possibleValues.remove(candidateChar, candidateNum);
      }
    } catch (ex) {
      if (ex.toString() != "No solution") {
        print(ex.toString());
      }
    }

    return solutions.isNotEmpty ? solutions : null;
  }

  static Map<String, int> buildResult(Map<String, int> tmpDic) {
    return Map.fromEntries(tmpDic.entries.map((e) => MapEntry(e.key, e.value)));
  }

  static bool isCorrect(Map<String, int> tmpDic, List<String> terms, String result, String equation, bool onlyAddition, Parser parser) {
    return onlyAddition ? isCorrectAddition(tmpDic, terms, result) : isCorrectOther(tmpDic, equation, parser);
  }

  static bool isCorrectAddition(Map<String, int> tmpDic, List<String> terms, String result) {
    var numResult = replaceLetters(tmpDic, result);
    var sum = int.parse(numResult);
    var prevTerm = "";
    var prevNumber = 0;

    for (var term in terms) {
      if (prevTerm != term) {
        prevTerm = term;
        var number = replaceLetters(tmpDic, term);
        prevNumber = int.parse(number);
      }

      sum -= prevNumber;
      if (sum < 0) return false;
    }

    return sum == 0;
  }

  static String replaceLetters(Map<String, int> tmpDic, String term) {
    for (var entry in tmpDic.entries) {
      term = term.replaceAll(entry.key, entry.value.toString());
    }
    return term;
  }

  static bool isCorrectOther(Map<String, int> tmpDic, String equation, Parser parser) {
    var context = ContextModel(); //??? Speed
    var exp = parser.parse(replaceLetters(tmpDic, equation));
    return exp.evaluate(EvaluationType.REAL, context) == 0;
  }

  static void checkEquality(List<String> terms, String result) {
    if (terms.any((t) => t.length > result.length)) {
      throw ArgumentError("No solution");
    }
    if (terms.length == 1) {
      // Commented out as per original code
      // throw ArgumentError(terms[0] == result ? "More than one solution" : "No solution");
    }
  }

  static String getOutput(String equation, Map<String, int> result) {
    return replaceLetters(result, equation);
  }
}

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

  Iterable<Iterable<int>> permutations1(Set<String> usedMembers) {
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

