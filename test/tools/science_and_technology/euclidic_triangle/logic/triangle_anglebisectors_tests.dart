import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle_tests.dart';

void main() {
  group("triagle.triangleAngleBiSectorsXY:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': Sides(a: double.nan, b: double.nan, c: double.nan)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': Sides(a: double.nan, b: double.nan, c: double.nan)},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 2, y: 2), 'inputC': XYPoint(x: 3, y: 3),
        'expectedOutput': Sides(a: 1.885618083164127, b: 1.0536712214319115e-8, c: 1.885618083164127)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])} ${toString(elem['inputB'])} ${toString(elem['inputC'])}', () {
        var _actual = triangleAngleBiSectorsXY(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint);
        sidesTest(_actual, elem['expectedOutput'] as Sides);
      });
    }
  });
}

