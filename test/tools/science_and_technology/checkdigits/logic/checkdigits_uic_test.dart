import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

void main() {
  group("uic.checkNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': '91806193296', // to short
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': '9180619329610', // to long
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': '918061932961',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': '218099039149',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': '318166502860',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': '123456789012',
        'expectedOutput': CheckDigitOutput(false, '123456789015', [
          '723456789012',
          '153456789012',
          '129456789012',
          '123756789012',
          '123426789012',
          '123459789012',
          '123456489012',
          '123456719012',
          '123456781012',
          '123456789312',
          '123456789072',
        ])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCheckNumber(CheckDigitsMode.UIC, elem['number'] as String);
        expect(_actual.correct, (elem['expectedOutput'] as CheckDigitOutput).correct);
        expect(_actual.correctDigit, (elem['expectedOutput'] as CheckDigitOutput).correctDigit);
        expect(_actual.correctNumbers, (elem['expectedOutput'] as CheckDigitOutput).correctNumbers);
      });
    }
  });

  group("uic.calculateCheckDigit", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': 'checkdigits_invalid_length'
      },
      {
        'number': '12345678901',
        'expectedOutput': '123456789015'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode.UIC, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("uic.calculateNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'number': '', 'expectedOutput': ['checkdigits_invalid_length']},
      {'number': '1?345678?901', 'expectedOutput': [
        '103456784901',
        '113456788901',
        '123456783901',
        '133456787901',
        '143456782901',
        '153456786901',
        '163456781901',
        '173456785901',
        '183456780901',
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode.UIC, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
