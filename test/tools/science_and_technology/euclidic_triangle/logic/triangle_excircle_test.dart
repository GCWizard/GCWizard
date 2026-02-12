import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle.dart';

void main() {
  group("triangle.triangleExCirclesXY:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': <XYCircle>[XYCircle(x: double.nan, y: double.nan, r: double.nan), XYCircle(x: double.nan, y: double.nan, r: double.nan), XYCircle(x: double.nan, y: double.nan, r: double.nan)]},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
      'expectedOutput': <XYCircle>[XYCircle(x: double.nan, y: double.nan, r: double.nan), XYCircle(x: double.nan, y: double.nan, r: double.nan), XYCircle(x: double.nan, y: double.nan, r: double.nan)]},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 2, y: 2), 'inputC': XYPoint(x: 3, y: 3),
      'expectedOutput': <XYCircle>[XYCircle(x: 2.9999999999999996, y: 2.9999999999999996, r: 0), XYCircle(x: double.nan, y: double.nan, r: double.nan), XYCircle(x: 0.9999999999999997, y: 0.9999999999999997, r: 0)]},
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 3), 'inputC': XYPoint(x: 4, y: 0),
        'expectedOutput': <XYCircle>[XYCircle(x: 6.0, y: 6.0, r: 6.0), XYCircle(x: 3.0, y: -3.0, r: 3.0), XYCircle(x: -2.0, y: 2.0, r: 2.0)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])} ${toString(elem['inputB'])} ${toString(elem['inputC'])}', () {
        var _actual = triangleExCirclesXY(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint);
        circlesListTest(_actual, elem['expectedOutput'] as List<XYCircle>);
      });
    }
  });

  group("triangle.triangleTouchPointsExcircleXY:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': <XYPoint>[XYPoint(x: 0, y: 0), XYPoint(x: 0, y: 0), XYPoint(x: 0, y: 0)]},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': <XYPoint>[XYPoint(x: 1, y: 1), XYPoint(x: 1, y: 1), XYPoint(x: 1, y: 1)]},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 2, y: 2), 'inputC': XYPoint(x: 3, y: 3),
        'expectedOutput': <XYPoint>[XYPoint(x: 2.9999999999999996, y: 2.9999999999999996), XYPoint(x: double.nan, y: double.nan), XYPoint(x: 0.9999999999999997, y: 0.9999999999999997)]},
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 3), 'inputC': XYPoint(x: 4, y: 0),
        'expectedOutput': <XYPoint>[XYPoint(x: 2.4, y: 1.2000000000000002), XYPoint(x: 3, y: 0), XYPoint(x: 0, y: 2)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])} ${toString(elem['inputB'])} ${toString(elem['inputC'])}', () {
        var _actual = triangleTouchPointsExcircleXY(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint);
        pointListTest(_actual, elem['expectedOutput'] as List<XYPoint>);
      });
    }
  });
}