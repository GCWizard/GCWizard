import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/math_utils.dart';

void main() {
  group("MathUtils.modulo:", () {
    List<Map<String, double>> _inputsToExpected = [
      {'value' : 0, 'modulator': 1, 'expectedOutput' : 0},
      {'value' : -1, 'modulator': 1, 'expectedOutput' : 0},
      {'value' : -2, 'modulator': 1, 'expectedOutput' : 0},
      {'value' : 1, 'modulator': 1, 'expectedOutput' : 0},
      {'value' : 2, 'modulator': 1, 'expectedOutput' : 0},

      {'value' : 0, 'modulator': 2, 'expectedOutput' : 0},
      {'value' : -1, 'modulator': 2, 'expectedOutput' : 1},
      {'value' : -2, 'modulator': 2, 'expectedOutput' : 0},
      {'value' : 1, 'modulator': 2, 'expectedOutput' : 1},
      {'value' : 2, 'modulator': 2, 'expectedOutput' : 0},

      {'value' : 0.0, 'modulator': 1, 'expectedOutput' : 0.0},
      {'value' : -1.0, 'modulator': 1, 'expectedOutput' : 0.0},
      {'value' : -2.0, 'modulator': 1, 'expectedOutput' : 0.0},
      {'value' : 1.0, 'modulator': 1, 'expectedOutput' : 0.0},
      {'value' : 2.0, 'modulator': 1, 'expectedOutput' : 0.0},

      {'value' : 0.0, 'modulator': 2, 'expectedOutput' : 0.0},
      {'value' : -1.0, 'modulator': 2, 'expectedOutput' : 1.0},
      {'value' : -2.0, 'modulator': 2, 'expectedOutput' : 0.0},
      {'value' : 1.0, 'modulator': 2, 'expectedOutput' : 1.0},
      {'value' : 2.0, 'modulator': 2, 'expectedOutput' : 0.0},

      {'value' : 0, 'modulator': 1.0, 'expectedOutput' : 0.0},
      {'value' : -1, 'modulator': 1.0, 'expectedOutput' : 0.0},
      {'value' : -2, 'modulator': 1.0, 'expectedOutput' : 0.0},
      {'value' : 1, 'modulator': 1.0, 'expectedOutput' : 0.0},
      {'value' : 2, 'modulator': 1.0, 'expectedOutput' : 0.0},

      {'value' : 0, 'modulator': 2.0, 'expectedOutput' : 0.0},
      {'value' : -1, 'modulator': 2.0, 'expectedOutput' : 1.0},
      {'value' : -2, 'modulator': 2.0, 'expectedOutput' : 0.0},
      {'value' : 1, 'modulator': 2.0, 'expectedOutput' : 1.0},
      {'value' : 2, 'modulator': 2.0, 'expectedOutput' : 0.0},

      {'value' : 0, 'modulator': 2.5, 'expectedOutput' : 0.0},
      {'value' : -1, 'modulator': 2.5, 'expectedOutput' : 1.5},
      {'value' : -2, 'modulator': 2.5, 'expectedOutput' : 0.5},
      {'value' : 1, 'modulator': 2.5, 'expectedOutput' : 1.0},
      {'value' : 2, 'modulator': 2.5, 'expectedOutput' : 2.0},
      {'value' : 2.5, 'modulator': 2.5, 'expectedOutput' : 0.0},
      {'value' : 2.6, 'modulator': 2.5, 'expectedOutput' : 0.10000000000000009},
    ];

    for (var elem in _inputsToExpected) {
      test('value: ${elem['value']}, modulator:  ${elem['modulator']}', () {
        var _actual = modulo(elem['value'] as num, elem['modulator'] as num);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("MathUtils.round:", () {
    List<Map<String, Object>> _inputsToExpected = [
      {'input' : 0.0, 'precision': 0, 'expectedOutput' : 0},

      {'input' : 0.1, 'precision': 0, 'expectedOutput' : 0},
      {'input' : 0.9, 'precision': 0, 'expectedOutput' : 1},
      {'input' : -0.1, 'precision': 0, 'expectedOutput' : 0},
      {'input' : -0.9, 'precision': 0, 'expectedOutput' : -1},

      {'input' : 0.1, 'precision': 1, 'expectedOutput' : 0.1},
      {'input' : 0.9, 'precision': 1, 'expectedOutput' : 0.9},
      {'input' : -0.1, 'precision': 1, 'expectedOutput' : -0.1},
      {'input' : -0.9, 'precision': 1, 'expectedOutput' : -0.9},

      {'input' : 0.11, 'precision': 1, 'expectedOutput' : 0.1},
      {'input' : 0.19, 'precision': 1, 'expectedOutput' : 0.2},
      {'input' : 0.91, 'precision': 1, 'expectedOutput' : 0.9},
      {'input' : 0.99, 'precision': 1, 'expectedOutput' : 1.0},
      {'input' : -0.11, 'precision': 1, 'expectedOutput' : -0.1},
      {'input' : -0.19, 'precision': 1, 'expectedOutput' : -0.2},
      {'input' : -0.91, 'precision': 1, 'expectedOutput' : -0.9},
      {'input' : -0.99, 'precision': 1, 'expectedOutput' : -1.0},

      {'input' : 1.257, 'precision': 2, 'expectedOutput' : 1.26},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, precision: ${elem['precision']}', () {
        var _actual = round(elem['input'] as double, precision: elem['precision'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}