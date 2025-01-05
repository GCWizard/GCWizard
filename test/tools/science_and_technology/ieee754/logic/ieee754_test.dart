import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/ieee754/logic/ieee754.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';

// https://zahlensysteme-rechner.de/ieee-754-konverter/
// https://www.h-schmidt.net/FloatConverter/IEEE754.html

void main() {
  group("ieee754.float2binary:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '0.0', '32': true, 'expectedOutput' : '00000000000000000000000000000000'},
      {'input' : '1.0', '32': true, 'expectedOutput' : '00111111100000000000000000000000'},
      {'input' : '-1.0', '32': true, 'expectedOutput' : '10111111100000000000000000000000'},
      {'input' : '1.02', '32': true, 'expectedOutput' : '00111111100000101000111101011100'},
      {'input' : '-1.02', '32': true, 'expectedOutput' : '10111111100000101000111101011100'},
      {'input' : '54.23456', '32': true, 'expectedOutput' : '01000010010110001111000000110000'},
      {'input' : '-54.23456', '32': true, 'expectedOutput' : '11000010010110001111000000110000'},
      {'input' : '0.2', '32': true, 'expectedOutput' : '00111110010011001100110011001101'},
      {'input' : '0.2', '32': false, 'expectedOutput' : '0011111111001001100110011001100110011001100110011001100110011010'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, 32: ${elem['32']}', () {
        var _actual = encodeIEEE754(double.parse(elem['input'] as String), elem['32'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ieee754.binary2float:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : 0.0},
      {'input' : '00000000000000000000000000000000', 'expectedOutput' : 0.0},
      {'input' : '00111111100000000000000000000000', 'expectedOutput' : 1.0},
      {'input' : '10111111100000000000000000000000', 'expectedOutput' : -1.0},
      {'input' : '00111111100000101000111101011100', 'expectedOutput' : 1.02},
      {'input' : '10111111100000101000111101011100', 'expectedOutput' : -1.02},
      {'input' : '01000010010110001111000000110000', 'expectedOutput' : 54.23456},
      {'input' : '11000010010110001111000000110000', 'expectedOutput' : -54.23456},

      {'input' : '01000001100100110011001100110011', 'expectedOutput' : 18.4},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeIEEE754(elem['input'] as String);
        expect(doubleEquals(_actual, elem['expectedOutput'] as double, tolerance: 1e-5), true);
      });
    }
  });
}