import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/_common/logic/irrational_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/pi/logic/pi.dart';

void main() {
  group("IrrationalNumberCalculator.decimalAt:", () {
    var irCalculator = IrrationalNumberCalculator(irrationalNumber: PI);

    List<Map<String, Object?>> _inputsToExpected = [
      {'index' : -1, 'expectedOutput' : ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL},
      {'index' : PI.decimalPart.length + 1, 'expectedOutput' : ERROR_IRRATIONALNUMBERS_INDEXTOOBIG},

      {'index' : 1, 'expectedOutput' : '1'},
      {'index' : 2, 'expectedOutput' : '4'},
      {'index' : 3, 'expectedOutput' : '1'},
      {'index' : 10, 'expectedOutput' : '5'},
      {'index' : 100, 'expectedOutput' : '9'},
      {'index' : PI.decimalPart.length, 'expectedOutput' : PI.decimalPart[PI.decimalPart.length - 1]},
    ];

    for (var elem in _inputsToExpected) {
      test('index: ${elem['index']}', () {
        try {
          var _actual = irCalculator.decimalAt(elem['index'] as int);
          expect(_actual, elem['expectedOutput']);
        } on FormatException catch(e) {
          expect(e.message, elem['expectedOutput']);
        }
      });
    }
  });

  group("IrrationalNumberCalculator.decimalRange:", () {
    var irCalculator = IrrationalNumberCalculator(irrationalNumber: PI);

    List<Map<String, Object?>> _inputsToExpected = [
      {'start' : -1, 'length': 1, 'expectedOutput' : ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL},
      {'start' : 0, 'length': 1, 'expectedOutput' : ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL},
      {'start' : 1, 'length': -2, 'expectedOutput' : ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL},
      {'start' : 10, 'length': -11, 'expectedOutput' : ERROR_IRRATIONALNUMBERS_INDEXTOOSMALL},

      {'start' : 10, 'length': 0, 'expectedOutput' : ''},

      {'start' : 1, 'length': 1, 'expectedOutput' : '1'},
      {'start' : 1, 'length': 2, 'expectedOutput' : '14'},
      {'start' : 1, 'length': 3, 'expectedOutput' : '141'},

      {'start' : 50, 'length': 1, 'expectedOutput' : '0'},
      {'start' : 50, 'length': 2, 'expectedOutput' : '05'},
      {'start' : 50, 'length': 30, 'expectedOutput' : '058209749445923078164062862089'},

      {'start' : 10, 'length': -1, 'expectedOutput' : '5'},
      {'start' : 10, 'length': -2, 'expectedOutput' : '35'},
      {'start' : 10, 'length': -5, 'expectedOutput' : '26535'},
      {'start' : 10, 'length': -10, 'expectedOutput' : '1415926535'},

      {'start' : 50, 'length': -1, 'expectedOutput' : '0'},
      {'start' : 50, 'length': -2, 'expectedOutput' : '10'},
      {'start' : 50, 'length': -30, 'expectedOutput' : '264338327950288419716939937510'},
    ];

    for (var elem in _inputsToExpected) {
      test('start: ${elem['start']}, length: ${elem['length']}', () {
        try {
          var _actual = irCalculator.decimalRange(elem['start'] as int, elem['length'] as int);
          expect(_actual, elem['expectedOutput']);
        } on FormatException catch(e) {
          expect(e.message, elem['expectedOutput']);
        }
      });
    }
  });

  group("IrrationalNumberCalculator.decimalOccurence:", () { // ToDo Mark test not working
    var irCalculator = IrrationalNumberCalculator(irrationalNumber: PI);

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : []},

      {'input' : '1', 'expectedOutput' : 1},
      {'input' : '141', 'expectedOutput' : 1},
      {'input' : '41', 'expectedOutput' : 2},
      {'input' : '939937510', 'expectedOutput' : 42},
      {'input' : '19851026', 'expectedOutput' : []},
    ];

    for (var elem in _inputsToExpected) {
      test('index: ${elem['input']}', () {
        var _actual = irCalculator.decimalOccurences(elem['input'] as String);
        expect(_actual.length, elem['expectedOutput']);
      });
    }
  });
}