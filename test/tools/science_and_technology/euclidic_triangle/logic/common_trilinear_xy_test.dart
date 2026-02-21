import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle.dart';

void main() {
  group("triangle.TriLinearToXYPoint:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputP': TriLinearPoint(),
        'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': XYPoint(x: double.nan, y: double.nan)},
      {'inputP': TriLinearPoint(),
        'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': XYPoint(x: double.nan, y: double.nan)},
      {'inputP': TriLinearPoint(a: 1, b: 1, c: 1),
        'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': XYPoint(x: double.nan, y: double.nan)},
      {'inputP': TriLinearPoint(a: 1, b: 1, c: 1),
        'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 3), 'inputC': XYPoint(x: 4, y: 0),
        'expectedOutput': XYPoint(x: -1, y: 5)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputP'])} ${toString(elem['inputA'])} ${toString(elem['inputB'])} ${toString(elem['inputC'])}', () {
        var _actual = XYPoint.fromTriLinear(Triangle(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint), elem['inputP'] as TriLinearPoint);
        pointTest(_actual, elem['expectedOutput'] as XYPoint);
      });
    }
  });
}

