import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle_test_utils.dart';

void main() {
  group("triangle.triangleAltitudesXY:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': TriangleSides(a: double.nan, b: double.nan, c: double.nan)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': TriangleSides(a: double.nan, b: double.nan, c: double.nan)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 2, y: 2), 'inputC': XYPoint(x: 3, y: 3),
        'expectedOutput': TriangleSides(a: 0, b: 0, c: 0)},
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 3), 'inputC': XYPoint(x: 4, y: 0),
        'expectedOutput': TriangleSides(a: 2.4, b: 3, c: 4)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toTriangleObjectString(elem['inputA'])} ${toTriangleObjectString(elem['inputB'])} ${toTriangleObjectString(elem['inputC'])}', () {
        var _actual = triangleAltitudesXY(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint);
        sidesTest(_actual, elem['expectedOutput'] as TriangleSides);
      });
    }
  });
}
