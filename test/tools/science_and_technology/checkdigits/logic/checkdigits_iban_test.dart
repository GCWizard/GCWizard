import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

void main() {
  group("iban.checkNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': 'GB29NWBK60161331926819', // Great Britain
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': 'HR1210010051863000160', //Croatia
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': 'BE68539007547034', //Belgium
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': 'NO9386011117947', //Norway
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },

      {
        'number': 'NO9386011117946',
        'expectedOutput': CheckDigitOutput(false, 'NO789386011117946', [
          'NO9386611117946',
        ])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCheckNumber(CheckDigitsMode.IBAN, elem['number'] as String);
        expect(_actual.correct, (elem['expectedOutput'] as CheckDigitOutput).correct);
        expect(_actual.correctDigit, (elem['expectedOutput'] as CheckDigitOutput).correctDigit);
        expect(_actual.correctNumbers, (elem['expectedOutput'] as CheckDigitOutput).correctNumbers);
      });
    }
  });

  group("iban.calculateCheckDigit", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': 'checkdigits_invalid_length'
      },
      {
        'number': 'NO86011117947',
        'expectedOutput': 'NO9386011117947'
      },
      {
        'number': 'PKSCBL0000001123456702',
        'expectedOutput': 'PK36SCBL0000001123456702'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode.IBAN, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("iban.calculateNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'number': '', 'expectedOutput': ['checkdigits_invalid_length']},
      {'number': 'NO?38601111794?', 'expectedOutput': [
        'NO2386011117946',
        'NO9386011117947',
      ]},
      {'number': 'PK36S?BL000000112345670?', 'expectedOutput': [
        'PK36SBBL000000112345670G',
        'PK36SCBL0000001123456702',
        'PK36SDBL000000112345670B',
        'PK36SGBL0000001123456701',
        'PK36SKBL0000001123456700',
        'PK36SOBL000000112345670W',
        'PK36SQBL000000112345670R',
        'PK36SSBL000000112345670M',
        'PK36SUBL000000112345670H',
        'PK36SWBL000000112345670C',
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode.IBAN, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
