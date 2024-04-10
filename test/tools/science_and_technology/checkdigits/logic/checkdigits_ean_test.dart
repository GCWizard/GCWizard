import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

void main() {
  group("ean.checkNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': '1234567890128',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': '1234567890127',
        'expectedOutput': CheckDigitOutput(false, '1234567890128', [
          '2234567890127',
          '1934567890127',
          '1244567890127',
          '1231567890127',
          '1234667890127',
          '1234537890127',
          '1234568890127',
          '1234567590127',
          '1234567800127',
          '1234567897127',
          '1234567890227',
          '1234567890197',
        ])
      },
      {
        'number': '12345677',
        'expectedOutput': CheckDigitOutput(false, '12345678', [
          '22345677',
          '19345677',
          '12445677',
          '12315677',
          '12346677',
          '12345377',
          '12345687',
        ])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCheckNumber(CheckDigitsMode.EAN_GTIN, elem['number'] as String);
        expect(_actual.correct, (elem['expectedOutput'] as CheckDigitOutput).correct);
        expect(_actual.correctDigit, (elem['expectedOutput'] as CheckDigitOutput).correctDigit);
        expect(_actual.correctNumbers, (elem['expectedOutput'] as CheckDigitOutput).correctNumbers);
      });
    }
  });

  group("ean.calculateCheckDigit", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': 'checkdigits_invalid_length'
      },
      {
        'number': '123456789012',
        'expectedOutput': '1234567890128'
      },
      {
        'number': '1234567',
        'expectedOutput': '12345678'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode.EAN_GTIN, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ean.calculateNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'number': '', 'expectedOutput': ['checkdigits_invalid_length']},
      {'number': '1234567?', 'expectedOutput': ['12345678']},
      {'number': '?234567?', 'expectedOutput': [
        '02345679',
        '12345678',
        '22345677',
        '32345676',
        '42345675',
        '52345674',
        '62345673',
        '72345672',
        '82345671',
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode.EAN_GTIN, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
