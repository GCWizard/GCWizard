import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

void main() {
  group("euro.checkNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': CheckDigitOutput(false, 'checkdigits_invalid_length', [''])
      },
      {
        'number': 'NA3509770816',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': 'N61137837714',
        'expectedOutput': CheckDigitOutput(true, '', [''])
      },
      {
        'number': 'NA3509770815',
        'expectedOutput': CheckDigitOutput(false, 'NA3509770816', [
          'FA3509770815',
          'XA3509770815',
          'NB3509770815',
          'NK3509770815',
          'NT3509770815',
          'NA4509770815',
          'NA3609770815',
          'NA3519770815',
          'NA3501770815',
          'NA3509870815',
          'NA3509780815',
          'NA3509771815',
          'NA3509770015',
          'NA3509770915',
          'NA3509770825',
        ])
      },
      {
        'number': 'N61137837713',
        'expectedOutput': CheckDigitOutput(false, 'N61137837714', [
          'F61137837713',
          'X61137837713',
          'NF1137837713',
          'NO1137837713',
          'NX1137837713',
          'N62137837713',
          'N61237837713',
          'N61147837713',
          'N61138837713',
          'N61137037713',
          'N61137937713',
          'N61137847713',
          'N61137838713',
          'N61137837813',
          'N61137837723',
        ])
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCheckNumber(CheckDigitsMode.EURO, elem['number'] as String);
        expect(_actual.correct, (elem['expectedOutput'] as CheckDigitOutput).correct);
        expect(_actual.correctDigit, (elem['expectedOutput'] as CheckDigitOutput).correctDigit);
        expect(_actual.correctNumbers, (elem['expectedOutput'] as CheckDigitOutput).correctNumbers);
      });
    }
  });

  group("euro.calculateCheckDigit", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'number': '',
        'expectedOutput': 'checkdigits_invalid_length'
      },
      {
        'number': 'NA350977081',
        'expectedOutput': 'NA3509770816'
      },
      {
        'number': 'N6113783771',
        'expectedOutput': 'N61137837714'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode.EURO, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("euro.calculateNumber", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'number': '', 'expectedOutput': ['checkdigits_invalid_length']},
      {'number': 'N?350977081?', 'expectedOutput': [
        'N03509770818',
        'N13509770817',
        'N23509770816',
        'N33509770815',
        'N43509770814',
        'N53509770813',
        'N63509770812',
        'N73509770811',
        'N93509770818',
        'NA3509770816',
        'NB3509770815',
        'NC3509770814',
        'ND3509770813',
        'NE3509770812',
        'NF3509770811',
        'NH3509770818',
        'NI3509770817',
        'NJ3509770816',
        'NK3509770815',
        'NL3509770814',
        'NM3509770813',
        'NN3509770812',
        'NO3509770811',
        'NQ3509770818',
        'NR3509770817',
        'NS3509770816',
        'NT3509770815',
        'NU3509770814',
        'NV3509770813',
        'NW3509770812',
        'NX3509770811',
        'NZ3509770818',
      ]},
      {'number': 'N6113?837714', 'expectedOutput': [
        'N61137837714',
      ]},
    ];

    for (var elem in _inputsToExpected) {
      test('number: ${elem['number']}', () {
        var _actual = checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode.EURO, elem['number'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
