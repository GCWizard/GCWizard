import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

void main() {
  group("de_taxid.checkNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': '12345678903',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': '12345678901',
        'expectedOutput': CheckDigitOutput(false, '12345678903', [
          '02345678901',
          '19345678901',
          '12745678901',
          '12325678901',
          '12342678901',
          '12345178901',
          '12345688901',
          '12345671901',
          '12345678501',
          '12345678911',
        ])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCheckNumber(CheckDigitsMode.DETAXID, elem['number'] as String);
        expect(_actual.correct, (elem['expectedOutput'] as CheckDigitOutput).correct);
        expect(_actual.correctDigit, (elem['expectedOutput'] as CheckDigitOutput).correctDigit);
        expect(_actual.correctNumbers, (elem['expectedOutput'] as CheckDigitOutput).correctNumbers);
      });
    }
  });

  group("de_taxid.calculateCheckDigit", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': 'checkdigits_invalid_length'
      },
      {
        'number': '1234567890',
        'expectedOutput': '12345678903'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode.DETAXID, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("de_taxid.calculateNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'number': '', 'expectedOutput': ['checkdigits_invalid_length']},
      {'number': '12?4567890?', 'expectedOutput': [
        '12045678909',
        '12145678904',
        '12245678900',
        '12345678903',
        '12445678907',
        '12545678906',
        '12645678905',
        '12745678901',
        '12845678902',
        '12945678908',
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode.DETAXID, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
