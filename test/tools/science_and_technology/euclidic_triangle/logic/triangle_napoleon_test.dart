import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle.dart';

void main() {
  group("triangle.multiplyWithOmega:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0),
        'expectedOutput': XYPoint(x: 0, y: 0)},
      {'inputA': XYPoint(x: 1, y: 1),
        'expectedOutput': XYPoint(x: -1.3660254037844386, y: 0.3660254037844386)},
      {'inputA': XYPoint(x: 2, y: 2),
        'expectedOutput': XYPoint(x: -2.732050807568877, y: 0.7320508075688772)},
      {'inputA': XYPoint(x: 4, y: 0),
        'expectedOutput': XYPoint(x: -2, y: 3.4641016151377544)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])}', () {
        var _actual = multiplyWithOmega(elem['inputA'] as XYPoint);
        pointTest(_actual, elem['expectedOutput'] as XYPoint);
      });
    }
  });

  group("triangle.multiplyWithOmega2:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0),
        'expectedOutput': XYPoint(x: 0, y: 0)},
      {'inputA': XYPoint(x: 1, y: 1),
        'expectedOutput': XYPoint(x: 0.3660254037844386, y: -1.3660254037844386)},
      {'inputA': XYPoint(x: 2, y: 2),
        'expectedOutput': XYPoint(x: 0.7320508075688772, y: -2.732050807568877)},
      {'inputA': XYPoint(x: 4, y: 0),
        'expectedOutput': XYPoint(x: -2, y: -3.4641016151377544)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])}', () {
        var _actual = multiplyWithOmega2(elem['inputA'] as XYPoint);
        pointTest(_actual, elem['expectedOutput'] as XYPoint);
      });
    }
  });

  group("triangle.triangleNapoleonInnerXY:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': XYPoint(x: 0, y: 0)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': XYPoint(x: 0, y: 0)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 2, y: 2), 'inputC': XYPoint(x: 3, y: 3),
        'expectedOutput': XYPoint(x: -0.21132486540518705, y: -0.788675134594813)},
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 3), 'inputC': XYPoint(x: 4, y: 0),
        'expectedOutput': XYPoint(x: -1.5326920704511053, y: -1.6547005383792515)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])} ${toString(elem['inputB'])} ${toString(elem['inputC'])}', () {
        var _actual = triangleNapoleonInnerPointXY(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint);
        pointTest(_actual, elem['expectedOutput'] as XYPoint);
      });
    }
  });

  group("triangle.triangleNapoleonOuterXY:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': XYPoint(x: 0, y: 0)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': XYPoint(x: 0, y: 0)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 2, y: 2), 'inputC': XYPoint(x: 3, y: 3),
        'expectedOutput': XYPoint(x: -0.788675134594813, y: -0.21132486540518705)},
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 3), 'inputC': XYPoint(x: 4, y: 0),
        'expectedOutput': XYPoint(x: 0.199358737117772, y: 0.6547005383792515)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])} ${toString(elem['inputB'])} ${toString(elem['inputC'])}', () {
        var _actual = triangleNapoleonOuterPointXY(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint);
        pointTest(_actual, elem['expectedOutput'] as XYPoint);
      });
    }
  });
}

