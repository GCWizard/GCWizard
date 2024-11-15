import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/constants.dart';
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

  group("MathUtils.gcd", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input_a' : 0, 'input_b' : 0, 'expectedOutput' : 0},
      {'input_a' : 1, 'input_b' : 0, 'expectedOutput' : 1},
      {'input_a' : 0, 'input_b' : 1, 'expectedOutput' : 1},
      {'input_a' : 36, 'input_b' : 24, 'expectedOutput' : 12},
      {'input_a' : 24, 'input_b' : 36, 'expectedOutput' : 12},
      {'input_a' : 24, 'input_b' : -36, 'expectedOutput' : 12},
      {'input_a' : -24, 'input_b' : -36, 'expectedOutput' : 12},
      {'input_a' : -36, 'input_b' : -24, 'expectedOutput' : 12},
      {'input_a' : -24, 'input_b' : 36, 'expectedOutput' : 12},
    ];

    for (var elem in _inputsToExpected) {
      test('input_a: ${elem['input_a']}, input_b: ${elem['input_b']}', () {
        var _actual = gcd(elem['input_a'] as int, elem['input_b'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("MathUtils.lcm", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input_a' : 0, 'input_b' : 0, 'expectedOutput' : 0},
      {'input_a' : 1, 'input_b' : 0, 'expectedOutput' : 0},
      {'input_a' : 0, 'input_b' : 1, 'expectedOutput' : 0},
      {'input_a' : 24, 'input_b' : 36, 'expectedOutput' : 72},
      {'input_a' : 36, 'input_b' : 24, 'expectedOutput' : 72},
      {'input_a' : -36, 'input_b' : 24, 'expectedOutput' : -72},
      {'input_a' : -36, 'input_b' : -24, 'expectedOutput' : -72},
      {'input_a' : -24, 'input_b' : -36, 'expectedOutput' : -72},
      {'input_a' : -24, 'input_b' : 36, 'expectedOutput' : -72},
    ];

    for (var elem in _inputsToExpected) {
      test('input_a: ${elem['input_a']}, input_b: ${elem['input_b']}', () {
        var _actual = lcm(elem['input_a'] as int, elem['input_b'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("MathUtils.matrixMultiplication", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'m1' : <List<double>>[[]], 'm2' : [[0.0], [2.0], [19.0]], 'expectedOutput' : null},
      {'m1' : [[7.0, 8.0], [11.0, 11.0]], 'm2' : <List<double>>[[]], 'expectedOutput' : null},
      {'m1' : [[7.0, 8.0], [11.0, 11.0]], 'm2' : [[18.0]], 'expectedOutput' : null},
      {'m1' : [[7.0, 8.0]], 'm2' : [[18.0], [7.0], [7.0]], 'expectedOutput' : null},

      {'m1' : [[7.0, 8.0]], 'm2' : [[18.0], [7.0]], 'expectedOutput' : [[182.0, 0.0]]},

      {'m1' : [[7.0, 8.0], [11.0, 11.0]], 'm2' : [[18.0], [7.0]], 'expectedOutput' : [[182.0, 0.0], [275.0, 0.0]]},
      {'m1' : [[7.0, 8.0], [11.0, 11.0]], 'm2' : [[14.0], [17.0]], 'expectedOutput' : [[234.0, 0.0], [341.0, 0.0]]},
      {'m1' : [[7.0, 8.0], [11.0, 11.0]], 'm2' : [[19.0], [4.0]], 'expectedOutput' : [[165.0, 0.0], [253.0, 0.0]]},
      {'m1' : [[7.0, 8.0], [11.0, 11.0]], 'm2' : [[23.0], [0.0]], 'expectedOutput' : [[161.0, 0.0], [253.0, 0.0]]},
      {'m1' : [[7.0, 8.0], [11.0, 11.0]], 'm2' : [[23.0], [0.0]], 'expectedOutput' : [[161.0, 0.0], [253.0, 0.0]]},

      {'m1' : [[6.0, 24.0, 1.0], [13.0, 16.0, 10.0], [20.0, 17.0, 15.0]], 'm2' : [[0.0], [2.0], [19.0]], 'expectedOutput' : [[67.0, 0.0, 0.0], [222.0, 0.0, 0.0], [319.0, 0.0, 0.0]]},
      {'m1' : [[7.0, 8.0, 11.0], [11.0, 12.0, 0.0], [6.0, 8.0, 2.0]], 'm2' : [[6.0], [5.0], [6.0]], 'expectedOutput' : [[148.0, 0.0, 0.0], [126.0, 0.0, 0.0], [88.0, 0.0, 0.0]]},
      {'m1' : [[1.0, 0.0, 2.0], [10.0, 20.0, 15.0], [0.0, 1.0, 2.0]], 'm2' : [[17.0], [4.0], [19.0]], 'expectedOutput' : [[55.0, 0.0, 0.0], [535.0, 0.0, 0.0], [42.0, 0.0, 0.0]]},
    ];

    for (var elem in _inputsToExpected) {
      test('m1: ${elem['m1']}, m2: ${elem['m2']}', () {
        var _actual = matrixMultiplication(elem['m1'] as List<List<double>>, elem['m2'] as List<List<double>>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("MathUtils.matrixDeterminant", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'m' : <List<double>>[[]], 'expectedOutput' : 0.0},

      {'m' : [[7.0, 8.0], [0.0, -1.5714285714285712]], 'expectedOutput' : -11.0},
      {'m' : [[6.0, 24.0, 1.0], [0.0, -36.0, 7.833333333333334], [0.0, 0.0, -2.041666666666668]], 'expectedOutput' : 441.0},
      {'m' : [[7.0, 8.0, 11.0], [0.0, -0.5714285714285712, -17.285714285714285], [0.0, -2.220446049250313e-16, -42.00000000000003]], 'expectedOutput' : 168.0},
      {'m' : [[1.0, 0.0, 2.0], [0.0, 20.0, -5.0], [0.0, 0.0, 2.25]], 'expectedOutput' : 45.0},
      {'m' : [[15.0, 0.0, 11.0], [0.0, 7.0, -0.7333333333333333], [0.0, 0.0, 19.419047619047618]], 'expectedOutput' : 2039.0},
    ];

    for (var elem in _inputsToExpected) {
      test('m: ${elem['m']}', () {
        var _actual = matrixDeterminant(elem['m'] as List<List<double>>);
        if (elem['expectedOutput'] != null) {
          expect((_actual - (elem['expectedOutput'] as double)).abs() <= doubleTolerance, true);
        } else {
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });

  group("MathUtils.matrixInvert", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'m' : <List<double>>[[]], 'expectedOutput' : null},
      {'m' : [[0.0, 0.0], [11.0, 11.0]], 'expectedOutput' : null},

      {'m' : [[7.0, 8.0], [11.0, 11.0]], 'expectedOutput' : [[-1.0, 0.7272727272727273], [1.0, -0.6363636363636364]]},

      {'m' : [[0.0, 11.0, 15.0], [7.0, 0.0, 1.0], [4.0, 19.0, 0.0]], 'expectedOutput' : [[-0.009318293281020107, 0.1397743992153016, 0.005394801373222168], [0.0019617459538989698, -0.02942618930848455, 0.051495831289847964], [0.06522805296714075, 0.02157920549288867, -0.03776360961255518]]},
      {'m' : [[6.0, 24.0, 1.0], [13.0, 16.0, 10.0], [20.0, 17.0, 15.0]], 'expectedOutput' : [[0.15873015873015875, -0.7777777777777776, 0.5079365079365078], [0.011337868480725627, 0.1587301587301587, -0.10657596371882083], [-0.22448979591836735, 0.8571428571428569, -0.48979591836734676]]},
      {'m' : [[7.0, 8.0, 11.0], [11.0, 12.0, 0.0], [6.0, 8.0, 2.0]], 'expectedOutput' : [[0.1428571428571428, 0.4285714285714284, -0.7857142857142854], [-0.1309523809523809, -0.3095238095238094, 0.720238095238095], [0.09523809523809523, -0.0476190476190476, -0.023809523809523843]]},
      {'m' : [[1.0, 0.0, 2.0], [10.0, 20.0, 15.0], [0.0, 1.0, 2.0]], 'expectedOutput' : [[0.5555555555555556, 0.044444444444444446, -0.8888888888888888], [-0.4444444444444444, 0.044444444444444446, 0.1111111111111111], [0.2222222222222222, -0.022222222222222223, 0.4444444444444444]]},
    ];

    for (var elem in _inputsToExpected) {
      test('m: ${elem['m']}', () {
        var _actual = matrixInvert(elem['m'] as List<List<double>>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}