import 'dart:collection';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/text_analysis/logic/text_analysis.dart';

void main() {
  bool _equalMaps(Map<String, int> a, Map<String, int> b) {
    if (a == null && b == null)
      return true;

    if ((a != null && b == null) || (a == null && b != null))
      return false;

    if (a.length != b.length)
      return false;

    for (MapEntry e in a.entries) {
      if (!b.containsKey(e.key) || b[e.key] != e.value)
        return false;
    }

    return true;
  }

  bool equalsTextAnalysisResults(TextAnalysisCharacterCounts a, TextAnalysisCharacterCounts b) {
    if (a == null && b == null)
      return true;

    if ((a != null && b == null) || (a == null && b != null))
      return false;

    if (!_equalMaps(a.letters, b.letters))
      return false;

    if (!_equalMaps(a.numbers, b.numbers))
      return false;

    if (!_equalMaps(a.whiteSpaces, b.whiteSpaces))
      return false;

    if (!_equalMaps(a.controlChars, b.controlChars))
      return false;

    if (!_equalMaps(a.specialChars, b.specialChars))
      return false;

    return true;
  }

  group("TextAnalysis.analyseText:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : '', 'expectedOutput' :
        TextAnalysisCharacterCounts(
          SplayTreeMap<String, int>(),
          SplayTreeMap<String, int>(),
          SplayTreeMap<String, int>(),
          SplayTreeMap<String, int>(),
          SplayTreeMap<String, int>()
      )},
      {'input' : 'ABC 123 ABC123', 'expectedOutput' :
        TextAnalysisCharacterCounts(
          SplayTreeMap<String, int>.from(<String, int>{'A': 2, 'B': 2, 'C': 2}),
          SplayTreeMap<String, int>.from(<String, int>{'1': 2, '2': 2, '3': 2}),
          SplayTreeMap<String, int>(),
          SplayTreeMap<String, int>.from(<String, int>{' ': 2}),
          SplayTreeMap<String, int>()
      )},
      {'input' : 'dAS.KL\u0013 2u 3)=FOS\u000BDI "!)=EU "ER-DJS\u0001(Q§)"E\$OPQWDJ KLSAÖj =§")\$U E\u0013"§=\u0085\u000B', 'expectedOutput' :
      TextAnalysisCharacterCounts(
          SplayTreeMap<String, int>.from(<String, int>{'A': 2, 'D': 3, 'E': 4, 'F': 1, 'I': 1, 'J': 2, 'K': 2, 'L': 2, 'O': 2, 'P': 1, 'Q': 2, 'R': 1, 'S': 4, 'U': 2, 'W': 1, 'd': 1, 'j': 1, 'u': 1, 'Ö': 1}),
          SplayTreeMap<String, int>.from(<String, int>{'2': 1, '3': 1}),
          SplayTreeMap<String, int>.from(<String, int>{'!': 1, '"': 5, '\$': 2, '(': 1, ')': 4, '-': 1, '.': 1, '=': 4, '§': 3}),
          SplayTreeMap<String, int>.from(<String, int>{'\u000B': 2, ' ': 7, '\u0085': 1}),
          SplayTreeMap<String, int>.from(<String, int>{'\u0001': 1, '\u0013': 2})
      )},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = analyzeText(elem['input']);
        expect(equalsTextAnalysisResults(_actual, elem['expectedOutput']), true);
      });
    });
  });

  group("TextAnalysis.analyseTextNotCaseSensitive:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : 'ABC-def d123D', 'expectedOutput' :
        TextAnalysisCharacterCounts(
          SplayTreeMap<String, int>.from(<String, int>{'A': 1, 'B': 1, 'C': 1, 'D': 3, 'E': 1, 'F': 1}),
          SplayTreeMap<String, int>.from(<String, int>{'1': 1, '2': 1, '3': 1}),
          SplayTreeMap<String, int>.from(<String, int>{'-': 1}),
          SplayTreeMap<String, int>.from(<String, int>{' ': 1}),
          SplayTreeMap<String, int>()
      )},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = analyzeText(elem['input'], caseSensitive: false);
        expect(equalsTextAnalysisResults(_actual, elem['expectedOutput']), true);
      });
    });
  });
}