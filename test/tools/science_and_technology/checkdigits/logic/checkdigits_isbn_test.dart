import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

void main() {
  group("isbn.checkNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': '9783446469471',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': '9783446469470',
        'expectedOutput': CheckDigitOutput(false, '9783446469471', [])
      },
      {
        'number': '9783446469472',
        'expectedOutput': CheckDigitOutput(false, '9783446469471', [
          '8783446469472',
          '9083446469472',
          '9773446469472',
          '9786446469472',
          '9783346469472',
          '9783476469472',
          '9783445469472',
          '9783446769472',
          '9783446459472',
          '9783446462472',
          '9783446469372',
          '9783446469402',
        ])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCheckNumber(CheckDigitsMode.ISBN, elem['number'] as String);
        expect(_actual.correct, (elem['expectedOutput'] as CheckDigitOutput).correct);
        expect(_actual.correctDigit, (elem['expectedOutput'] as CheckDigitOutput).correctDigit);
        expect(_actual.correctNumbers, (elem['expectedOutput'] as CheckDigitOutput).correctNumbers);
      });
    }
  });

  group("isbn.calculateCheckDigit", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': 'checkdigits_invalid_length'
      },
      {
        'number': '978344646947',
        'expectedOutput': '9783446469471'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode.ISBN, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("isbn.calculateNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'number': '', 'expectedOutput': ['checkdigits_invalid_length']},
      {'number': '978?44646947?', 'expectedOutput': [
        '9781446469477',
        '9782446469474',
        '9783446469471',
        '9784446469478',
        '9785446469475',
        '9786446469472',
        '9787446469479',
        '9788446469476',
        '9789446469473',
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode.ISBN, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
