import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

void main() {
  group("imei.checkNumber", () {
    // https://www.imei.info/de/
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': '352099001761481',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': '352099001761482',
        'expectedOutput': CheckDigitOutput(false, '352099001761481', [
          '252099001761482',
          '302099001761482',
          '351099001761482',
          '352999001761482',
          '352089001761482',
          '352094001761482',
          '352099901761482',
          '352099091761482',
          '352099000761482',
          '352099001261482',
          '352099001751482',
          '352099001765482',
          '352099001761382',
          '352099001761432',
        ])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCheckNumber(CheckDigitsMode.IMEI, elem['number'] as String);
        expect(_actual.correct, (elem['expectedOutput'] as CheckDigitOutput).correct);
        expect(_actual.correctDigit, (elem['expectedOutput'] as CheckDigitOutput).correctDigit);
        expect(_actual.correctNumbers, (elem['expectedOutput'] as CheckDigitOutput).correctNumbers);
      });
    }
  });

  group("imei.calculateCheckDigit", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': 'checkdigits_invalid_length'
      },
      {
        'number': '35209900176148',
        'expectedOutput': '352099001761481'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode.IMEI, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("imei.calculateNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'number': '', 'expectedOutput': ['checkdigits_invalid_length']},
      {'number': '35?09900176148?', 'expectedOutput': [
        '350099001761483',
        '351099001761482',
        '352099001761481',
        '354099001761489',
        '355099001761488',
        '356099001761487',
        '357099001761486',
        '358099001761485',
        '359099001761484',
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode.IMEI, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
