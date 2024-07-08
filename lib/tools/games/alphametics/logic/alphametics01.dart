// import 'dart:collection';
// import 'dart:math';
//import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';



part of 'alphametics.dart';



class Alphametics01 {

  static List<Map<String, int>>? solve(Formula equation, PossibleValues possibleValues, {bool allSolutions = false}) {
    var solutions = <Map<String, int>>[];
    var members = equation.formula.split('=');
    var result = members[1];
    var terms = members[0].split(operators); //RegExp(r'\+\-\*\/'));
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
