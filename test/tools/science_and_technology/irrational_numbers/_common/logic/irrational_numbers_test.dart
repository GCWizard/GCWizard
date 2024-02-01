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

  group("IrrationalNumberCalculator.decimalOccurence:", () {
    var irCalculator = IrrationalNumberCalculator(irrationalNumber: PI);

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutputCount' : 0},

      {'input' : '1', 'expectedOutputCount' : 110808, 'expectedOutputFirst' : 1, 'expectedValueFirst': '1'},
      {'input' : '141', 'expectedOutputCount' : 1097, 'expectedOutputFirst' : 1, 'expectedValueFirst': '141'},
      {'input' : '41', 'expectedOutputCount' : 11074, 'expectedOutputFirst' : 2, 'expectedValueFirst': '41'},
      {'input' : '939937510', 'expectedOutputCount' : 1, 'expectedOutputFirst' : 42, 'expectedValueFirst': '939937510'},
      {'input' : '19851026', 'expectedOutputCount' : 0},

      {'input' : '3.14', 'expectedOutputCount' : 1059, 'expectedOutputFirst': 668, 'expectedValueFirst': '3014'},
      {'input' : '3.*14', 'expectedOutputCount' : 1059, 'expectedOutputFirst': 668, 'expectedValueFirst': '3014'}, // * and + not allowed due to massive result sizes
      {'input' : '3214', 'expectedOutputCount' : 116, 'expectedOutputFirst': 2842, 'expectedValueFirst': '3214'},
      {'input' : '32+14', 'expectedOutputCount' : 116, 'expectedOutputFirst': 2842, 'expectedValueFirst': '3214'}, // * and + not allowed due to massive result sizes
      {'input' : '32{2}14', 'expectedOutputCount' : 19, 'expectedOutputFirst': 58267, 'expectedValueFirst': '32214'},
      {'input' : '32{2,3}14', 'expectedOutputCount' : 20, 'expectedOutputFirst': 58267, 'expectedValueFirst': '32214'},
      {'input' : '32{2,3}1?4', 'expectedOutputCount' : 153, 'expectedOutputFirst': 16402, 'expectedValueFirst': '3224'},
      {'input' : '32{2}1.', 'expectedOutputCount' : 127, 'expectedOutputFirst': 12811, 'expectedValueFirst': '32211'},

      {'input' : '32ABC14', 'expectedOutputCount' : 116, 'expectedOutputFirst': 2842, 'expectedValueFirst': '3214'},
    ];

    for (var elem in _inputsToExpected) {
      test('index: ${elem['input']}', () {
        var _actual = irCalculator.decimalOccurences(elem['input'] as String);
        expect(_actual.length, elem['expectedOutputCount']);
        if (elem['expectedOutputCount'] != 0) {
          expect(_actual.first.start, elem['expectedOutputFirst']);
          expect(_actual.first.value, elem['expectedValueFirst']);
        }
      });
    }
  });
}