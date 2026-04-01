import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';

import 'triangle.dart';

void main() {
  group("triangle.intersectVectors:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'inputL1': XYLine(P1: XYPoint(x: 0, y: 0), P2: XYPoint(x: 0, y: 0)),
        'inputL2': XYLine(P1: XYPoint(x: 0, y: 0), P2: XYPoint(x: 0, y: 0)),
        'expectedOutput': null
      },
      {
        'inputL1': XYLine(P1: XYPoint(x: 1, y: 1), P2: XYPoint(x: 2, y: 2)),
        'inputL2': XYLine(P1: XYPoint(x: 2, y: 2), P2: XYPoint(x: 3, y: 3)),
        'expectedOutput': null
      },
      {
        'inputL1': XYLine(P1: XYPoint(x: -1, y: -1), P2: XYPoint(x: 2, y: 2)),
        'inputL2': XYLine(P1: XYPoint(x: -1, y: 1), P2: XYPoint(x: -3, y: 3)),
        'expectedOutput': XYPoint(x: 0, y: 0)
      },
      {
        'inputL1': XYLine(P1: XYPoint(x: -9, y: -1), P2: XYPoint(x: 2, y: 2)),
        'inputL2': XYLine(P1: XYPoint(x: -1, y: 1), P2: XYPoint(x: -3, y: 3)),
        'expectedOutput': XYPoint(x: -1.1428571428571423, y: 1.1428571428571428)
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputL1'])}  ${toString(elem['inputL2'])}',
          () {
        var _actual = intersectVectors(
            elem['inputL1'] as XYLine, elem['inputL2'] as XYLine);
        pointTest(_actual, elem['expectedOutput'] as XYPoint?);
      });
    }
  });

  group("triangle.intersectTwoCircles:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputC1': XYCircle(), 'inputC2': XYCircle(), 'expectedOutput': null},
      {
        'inputC1': XYCircle(x: 1, y: 1, r: 0),
        'inputC2': XYCircle(x: 1, y: 1, r: 0),
        'expectedOutput': null
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 1, y: 1, r: -1),
        'expectedOutput': null
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 1, y: 1, r: 100),
        'expectedOutput': null
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 1, y: 1, r: 50),
        'expectedOutput': <XYPoint>[]
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r: 1),
        'inputC2': XYCircle(x: 3, y: 1, r: 1),
        'expectedOutput': <XYPoint>[XYPoint(x: 2, y: 1)]
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 3, y: 3, r: 100),
        'expectedOutput': <XYPoint>[
          XYPoint(x: -68.70360669725413, y: 72.70360669725413),
          XYPoint(x: 72.70360669725413, y: -68.70360669725413)
        ]
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r: 100),
        'inputC2': XYCircle(x: 120, y: 120, r: 100),
        'expectedOutput': <XYPoint>[
          XYPoint(x: 22.29332519048537, y: 98.70667480951462),
          XYPoint(x: 98.70667480951462, y: 22.29332519048537)
        ]
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputC1'])}  ${toString(elem['inputC2'])}',
          () {
        var _actual = intersectTwoCircles(
            elem['inputC1'] as XYCircle, elem['inputC2'] as XYCircle);
        pointListTest(_actual, elem['expectedOutput'] as List<XYPoint>?);
      });
    }
  });

  group("triangle.lineContainsPoint", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'inputL1': XYLine(P1: XYPoint(x: 1, y: -1), P2: XYPoint(x: 5, y: 1)),
        'inputP': XYPoint(x: 1, y: 0),
        'expectedOutput': false
      },
      {
        'inputL1': XYLine(P1: XYPoint(x: 1, y: -1), P2: XYPoint(x: 5, y: 1)),
        'inputP': XYPoint(x: 7, y: 2),
        'expectedOutput': true
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputL1'])}  ${toString(elem['inputP'])}',
              () {
            var _actual = vectorContainsPoint(
                elem['inputL1'] as XYLine, elem['inputP'] as XYPoint);
            expect(_actual, elem['expectedOutput'] as bool);
          });
    }
  });

  group("triangle.circleContainsPoint", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'inputC1': XYCircle(x: 1, y: 1, r:2),
        'inputP': XYPoint(x: 1, y: 0),
        'expectedOutput': true
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r:2),
        'inputP': XYPoint(x: 1, y: -1),
        'expectedOutput': true
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r:2),
        'inputP': XYPoint(x: 3, y: 3),
        'expectedOutput': false
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputC1'])}  ${toString(elem['inputP'])}',
              () {
            var _actual = circleContainsPoint(
                elem['inputC1'] as XYCircle, elem['inputP'] as XYPoint);
            expect(_actual, elem['expectedOutput'] as bool);
          });
    }
  });

  group("triangle.circleOnCircumference", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'inputC1': XYCircle(x: 1, y: 1, r:2),
        'inputP': XYPoint(x: 1, y: 0),
        'expectedOutput': false
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r:2),
        'inputP': XYPoint(x: 1, y: -1),
        'expectedOutput': true
      },
      {
        'inputC1': XYCircle(x: 1, y: 1, r:2),
        'inputP': XYPoint(x: 3, y: 3),
        'expectedOutput': false
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputC1'])}  ${toString(elem['inputP'])}',
              () {
            var _actual = onCircumference(
                elem['inputC1'] as XYCircle, elem['inputP'] as XYPoint);
            expect(_actual, elem['expectedOutput'] as bool);
          });
    }
  });

  group("triangle.distance", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'inputP1': XYPoint(x: 1, y: 1),
        'inputP2': XYPoint(x: 1, y: 1),
        'expectedOutput': 0.0
      },
      {
        'inputP1': XYPoint(x: 1, y: 1),
        'inputP2': XYPoint(x: 1, y: -1),
        'expectedOutput': 2.0
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputC1'])}  ${toString(elem['inputP'])}',
              () {
            var _actual = distance(
                elem['inputP1'] as XYPoint, elem['inputP2'] as XYPoint);
            expect(_actual, elem['expectedOutput'] as double);
          });
    }
  });
}
