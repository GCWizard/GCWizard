import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle_tests.dart';

void main() {
  group("triagle.intersectVectors:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputL1': XYLine(P1: XYPoint(x: 0, y: 0), P2: XYPoint(x: 0, y: 0)),
        'inputL2': XYLine(P1: XYPoint(x: 0, y: 0), P2: XYPoint(x: 0, y: 0)),
        'expectedOutput': XYPoint(x: double.nan, y: double.nan)},
      {'inputL1': XYLine(P1: XYPoint(x: 1, y: 1), P2: XYPoint(x: 2, y: 2)),
        'inputL2': XYLine(P1: XYPoint(x: 2, y: 2), P2: XYPoint(x: 3, y: 3)),
        'expectedOutput': XYPoint(x: double.nan, y: double.nan)},
      {'inputL1': XYLine(P1: XYPoint(x: -1, y: -1), P2: XYPoint(x: 2, y: 2)),
        'inputL2': XYLine(P1: XYPoint(x: -1, y: 1), P2: XYPoint(x: -3, y: 3)),
        'expectedOutput': XYPoint(x: 0, y: 0)},
      {'inputL1': XYLine(P1: XYPoint(x: -9, y: -1), P2: XYPoint(x: 2, y: 2)),
        'inputL2': XYLine(P1: XYPoint(x: -1, y: 1), P2: XYPoint(x: -3, y: 3)),
        'expectedOutput': XYPoint(x: -4, y: 4)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputL1']}  ${elem['inputL2']}', () {
        var _actual = intersectVectors(elem['inputL1'] as XYLine, elem['inputL2'] as XYLine);
          pointTest(_actual, elem['expectedOutput'] as XYPoint);
      });
    }
  });


  group("triagle.intersectTwoCircles:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputC1': XYCircle(),
        'inputC2': XYCircle(),
        'expectedOutput': <XYPoint>[]},
      {'inputC1': XYCircle(x: 1, y: 1, r: 0),
        'inputC2': XYCircle(x: 1, y: 1, r: 0),
        'expectedOutput': <XYPoint>[]},
      {'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 1, y: 1, r: -1),
        'expectedOutput': <XYPoint>[]},
      {'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 1, y: 1, r: 100),
        'expectedOutput': <XYPoint>[]},
      {'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 1, y: 1, r: 50),
        'expectedOutput': <XYPoint>[]},
      {'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 3, y: 3, r: 100),
        'expectedOutput': <XYPoint>[XYPoint(x: -68.70360669725413, y: 72.70360669725413), XYPoint(x: 72.70360669725413, y: -68.70360669725413)]},
      {'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 120, y: 120, r: 100),
        'expectedOutput': <XYPoint>[XYPoint(x: 22.293325190485362, y: 98.70667480951464), XYPoint(x: 98.70667480951464, y: 22.293325190485362)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputC1']}  ${elem['inputC2']}', () {
        var _actual = intersectTwoCircles(elem['inputC1'] as XYCircle, elem['inputC2'] as XYCircle);
        pointListTest(_actual, elem['expectedOutput'] as List<XYPoint>);
      });
    }
  });
}


