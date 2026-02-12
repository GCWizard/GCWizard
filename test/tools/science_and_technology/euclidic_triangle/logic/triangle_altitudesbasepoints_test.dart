import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle.dart';

void main() {
  group("triangle.triangleAltitudesBasePointsXY:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 0), 'inputC': XYPoint(x: 0, y: 0),
        'expectedOutput': <XYPoint>[XYPoint(x: double.nan, y:double.nan), XYPoint(x: double.nan, y: double.nan), XYPoint(x: double.nan, y: double.nan)]},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 1, y: 1), 'inputC': XYPoint(x: 1, y: 1),
        'expectedOutput': <XYPoint>[XYPoint(x: double.nan, y:double.nan), XYPoint(x: double.nan, y: double.nan), XYPoint(x: double.nan, y: double.nan)]},
      {'inputA': XYPoint(x: 1, y: 1), 'inputB': XYPoint(x: 2, y: 2), 'inputC': XYPoint(x: 3, y: 3),
        'expectedOutput': <XYPoint>[XYPoint(x: double.nan, y:double.nan), XYPoint(x: double.nan, y: double.nan), XYPoint(x: double.nan, y: double.nan)]},
      {'inputA': XYPoint(x: 0, y: 0), 'inputB': XYPoint(x: 0, y: 3), 'inputC': XYPoint(x: 4, y: 0),
        'expectedOutput': <XYPoint>[XYPoint(x: double.nan, y: double.nan), XYPoint(x: 0, y: 0), XYPoint(x: 0, y: 0)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])} ${toString(elem['inputB'])} ${toString(elem['inputC'])}', () {
        var _actual = triangleAltitudesBasePointsXY(elem['inputA'] as XYPoint, elem['inputB'] as XYPoint, elem['inputC'] as XYPoint);
        pointListTest(_actual, elem['expectedOutput'] as List<XYPoint>);
      });
    }
  });
}

