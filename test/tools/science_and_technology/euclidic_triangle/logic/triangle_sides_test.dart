import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle.dart';

void main() {
  group("triangle.triangleSidesXY:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': Sides(a: 0.0, b: 0.0, c: 0.0)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': Sides(a: 0.0, b: 0.0, c: 0.0)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 2, y: 2), 'inputC': XYPoint(x: 3, y: 3),
        'expectedOutput': Sides(a: 1.4142135623730951, b: 2.8284271247461903, c: 1.4142135623730951)},
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 3), 'inputC': XYPoint(x: 4, y: 0),
        'expectedOutput': Sides(a: 5, b: 4, c: 3)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])} ${toString(elem['inputB'])} ${toString(elem['inputC'])}', () {
        var _actual = triangleSidesXY(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint);
        sidesTest(_actual, elem['expectedOutput'] as Sides);
      });
    }
  });
}

