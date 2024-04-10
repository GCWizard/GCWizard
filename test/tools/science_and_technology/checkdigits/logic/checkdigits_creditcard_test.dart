import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

void main() {
  group("creditcard.checkNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      // http://www.ee.unb.ca/cgi-bin/tervo/luhn.pl?N=30535335735253
      // https://www.vccgenerator.org/de/credit-card-validator-result/
      // https://www.finanzrechner.org/sonstige-rechner/kreditkartennummer-pruefen/

      // Diners Club
      {'number': '36123456700002', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '36133088888000', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '30535335735253', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '38520000023237', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '30569309025904', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '36000000000008', 'expectedOutput': CheckDigitOutput(true, '', [''])},

      // Mastercard
      {'number': '2720997206529952', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '5399000110008', 'expectedOutput': CheckDigitOutput(true, '', [''])},

      // American Express
      {'number': '375987654321004', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '373220167232001', 'expectedOutput': CheckDigitOutput(true, '', [''])},

      // Visa
      {'number': '4227012345678902', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '4000123456789017', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '4538123456789018', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '4000123456789017', 'expectedOutput': CheckDigitOutput(true, '', [''])},

      // PayPak
      {'number': '2205450000000006', 'expectedOutput': CheckDigitOutput(true, '', [''])},

      // Other
      {'number': '1778800000000001', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '1788801234567896', 'expectedOutput': CheckDigitOutput(true, '', [''])},
      {'number': '8576494376432235', 'expectedOutput': CheckDigitOutput(true, '', [''])},


      {
        'number': '5399000110003',
        'expectedOutput': CheckDigitOutput(false, '5399000110008', [
          '0399000110003',
          '5599000110003',
          '5349000110003',
          '5392000110003',
          '5399500110003',
          '5399070110003',
          '5399005110003',
          '5399000810003',
          '5399000160003',
          '5399000117003',
          '5399000110503',
          '5399000110073',
        ])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCheckNumber(CheckDigitsMode.CREDITCARD, elem['number'] as String);
        expect(_actual.correct, (elem['expectedOutput'] as CheckDigitOutput).correct);
        expect(_actual.correctDigit, (elem['expectedOutput'] as CheckDigitOutput).correctDigit);
        expect(_actual.correctNumbers, (elem['expectedOutput'] as CheckDigitOutput).correctNumbers);
      });
    }
  });

  group("creditcard.calculateCheckDigit", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': 'checkdigits_invalid_length'
      },
      {
        'number': '539900011000',
        'expectedOutput': '5399000110008'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode.CREDITCARD, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("creditcard.calculateNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'number': '', 'expectedOutput': ['checkdigits_invalid_length']},
      {'number': '?39900011000?', 'expectedOutput': [
        '0399000110003',
        '1399000110002',
        '2399000110001',
        '3399000110000',
        '4399000110009',
        '5399000110008',
        '6399000110007',
        '7399000110006',
        '8399000110005',
        '9399000110004'
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode.CREDITCARD, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
