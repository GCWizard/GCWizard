import 'dart:core';
import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/triangles.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

import '../../../science_and_technology/euclidic_triangle/logic/triangle_test_utils.dart';

List<Map<String, Object?>> ellipsoidicTriangleTestInputs = [
  //All On Same Point
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0)},
  {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1)},
  {'inputA': LatLng(52, 13), 'inputB': LatLng(52, 13), 'inputC': LatLng(52, 13)},
  {'inputA': LatLng(90, 0), 'inputB': LatLng(90, 0), 'inputC': LatLng(90, 0)},
  {'inputA': LatLng(90, 0), 'inputB': LatLng(90, 0), 'inputC': LatLng(90, 100)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(-90, 0), 'inputC': LatLng(-90, 0)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(-90, 0), 'inputC': LatLng(-90, 100)},
  {'inputA': LatLng(0,180), 'inputB': LatLng(0, -180), 'inputC': LatLng(0, 180)},

  //Two On Same Point
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(52,13)},
  {'inputA': LatLng(52,13), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0)},
  {'inputA': LatLng(90, 0), 'inputB': LatLng(90, 10), 'inputC': LatLng(52,13)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(-90, 10), 'inputC': LatLng(52,13)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(52,13), 'inputC': LatLng(-90, 10)},
  {'inputA': LatLng(52,13), 'inputB': LatLng(-90, 0), 'inputC': LatLng(-90, 10)},

  //Very narrow
  {'inputA': LatLng(70, 0), 'inputB': LatLng(13.56832726660199, 74.33418761525557), 'inputC': LatLng(38.59652460733987, 62.72751487512538)},
  {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3)}, // NOT SAME LINE IN GEODETICS!

  //On same meridian/great circle/geodetic
  {'inputA': LatLng(80, -180), 'inputB': LatLng(70, 180), 'inputC': LatLng(60, 180)},
  {'inputA': LatLng(80, 0), 'inputB': LatLng(70, 0), 'inputC': LatLng(60, 0)},
  {'inputA': LatLng(80, 10), 'inputB': LatLng(-80, 10), 'inputC': LatLng(0, -170)},
  {'inputA': LatLng(80, 0), 'inputB': LatLng(-80, 0), 'inputC': LatLng(0, 180)},
  {'inputA': LatLng(90, 100), 'inputB': LatLng(0,0), 'inputC': LatLng(-90,50)},
  {'inputA': LatLng(80, -180), 'inputB': LatLng(70, 180), 'inputC': LatLng(60, 170)},

  //Poles
  {'inputA': LatLng(90, 0), 'inputB': LatLng(90, 1), 'inputC': LatLng(90, -1)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(-90, 1), 'inputC': LatLng(-90, -1)},
  {'inputA': LatLng(90, 0), 'inputB': LatLng(0,0), 'inputC': LatLng(0, 90)},

  //Antipodes
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(90, 0), 'inputC': LatLng(-90, 1)},
  {'inputA': LatLng(-90, 0), 'inputB': LatLng(90, 0), 'inputC': LatLng(0, 0)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 180), 'inputC': LatLng(1, 1)},
  {'inputA': LatLng(1, 1), 'inputB': LatLng(-1, -179), 'inputC': LatLng(-1, -1)},

  //Around Poles
  {'inputA': LatLng(89.999, 0), 'inputB': LatLng(89.999, 120), 'inputC': LatLng(89.999, -120)},
  {'inputA': LatLng(89.999, 100), 'inputB': LatLng(89.999, 120), 'inputC': LatLng(89.999, 140)},
  {'inputA': LatLng(-89.999, 0), 'inputB': LatLng(-89.999, 120), 'inputC': LatLng(-89.999, -120)},

  //Equator
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 120), 'inputC': LatLng(0, -120)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 1), 'inputC': LatLng(0, 2)},
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, -1), 'inputC': LatLng(0, 1)},

  //Around 0/0
  {'inputA': LatLng(-0.01, 0), 'inputB': LatLng(0.01, -0.01), 'inputC': LatLng(0.01, 0.01)},
  {'inputA': LatLng(-0.01, 0), 'inputB': LatLng(0.01, 0.01), 'inputC': LatLng(0.01, -0.01)},
  {'inputA': LatLng(0.01, 0), 'inputB': LatLng(-0.01, -0.01), 'inputC': LatLng(-0.01, 0.01)},
  {'inputA': LatLng(0.01, 0), 'inputB': LatLng(-0.01, 0.01), 'inputC': LatLng(-0.01, -0.01)},

  //Around Lon +-180
  {'inputA': LatLng(-10, 180), 'inputB': LatLng(10, -179.9), 'inputC': LatLng(15, 179.9)},
  {'inputA': LatLng(-10, 179), 'inputB': LatLng(10, -179.9), 'inputC': LatLng(15, 179.9)},
  {'inputA': LatLng(-10, -179), 'inputB': LatLng(10, -179.9), 'inputC': LatLng(15, 179.9)},
  {'inputA': LatLng(-10, -179), 'inputB': LatLng(10, 179.9), 'inputC': LatLng(15, -179.9)},
  {'inputA': LatLng(10, 180), 'inputB': LatLng(-10, -179.9), 'inputC': LatLng(-15, 179.9)},
  {'inputA': LatLng(10, 179), 'inputB': LatLng(-10, -179.9), 'inputC': LatLng(-15, 179.9)},
  {'inputA': LatLng(10, -179), 'inputB': LatLng(-10, -179.9), 'inputC': LatLng(-15, 179.9)},
  {'inputA': LatLng(10, -179), 'inputB': LatLng(-10, 179.9), 'inputC': LatLng(-15, -179.9)},

  //Left and Right from 0 meridian
  {'inputA': LatLng(50, 0), 'inputB': LatLng(60, -20), 'inputC': LatLng(40, 30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(60, 20), 'inputC': LatLng(40, -30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(60, -20), 'inputC': LatLng(-40, 30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(60, 20), 'inputC': LatLng(-40, -30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(-60, 20), 'inputC': LatLng(40, -30)},
  {'inputA': LatLng(50, 0), 'inputB': LatLng(-60, -20), 'inputC': LatLng(40, 30)},
  {'inputA': LatLng(50, 10), 'inputB': LatLng(-60, -20), 'inputC': LatLng(40, 30)},
  {'inputA': LatLng(50, -10), 'inputB': LatLng(-60, -20), 'inputC': LatLng(40, 30)},

  //Huge Triangle
  {'inputA': LatLng(49, -156), 'inputB': LatLng(-31, -37), 'inputC': LatLng(67, 5)},
  {'inputA': LatLng(49, -156), 'inputB': LatLng(67, 5), 'inputC': LatLng(-31, -37)},

  //Coordinate Value Overrun // Not possible to create LatLng object with overran values
  {'inputA': LatLng(100, -10), 'inputB': LatLng(80, -20), 'inputC': LatLng(105, 30)},
  {'inputA': LatLng(-100, -10), 'inputB': LatLng(-80, -20), 'inputC': LatLng(-105, 30)},
  {'inputA': LatLng(50, -190), 'inputB': LatLng(40, 190), 'inputC': LatLng(45, 180)},
  {'inputA': LatLng(100, -190), 'inputB': LatLng(80, 190), 'inputC': LatLng(105, 180)},

  //Misc
  {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0)},
  {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8)},
  {'inputA': LatLng(40, 9), 'inputB': LatLng(38, 8), 'inputC': LatLng(42, 9)},
  {'inputA': LatLng(4, -173), 'inputB': LatLng(2, -174), 'inputC': LatLng(0, -9)},
];

void main() async {
  group("triangle.calculateEllipsoidTriangleAngles:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': TriangleInteriorAngles(alpha: 0, beta: 0, gamma: 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': TriangleInteriorAngles(alpha: 0, beta: 0, gamma: 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': TriangleInteriorAngles(alpha: 0.02630127667657689, beta: 179.94740561118152, gamma: 0.026309127099466423)},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': TriangleInteriorAngles(alpha: 90, beta: 53.00282576179586, gamma: 37.10196090365815)},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': TriangleInteriorAngles(alpha: 158.3703675865121, beta: 11.207315582928572, gamma: 10.43608068564481)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleAngles(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        anglesTest(_actual, elem['expectedOutput'] as TriangleInteriorAngles);
      });
    }
  });

  group("triangle.calculateEllipsoidTriangleSides:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': TriangleSides(a: 0, b: 0, c: 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': TriangleSides(a: 0, b: 0, c: 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': TriangleSides(a: 156829.32911607338, b: 313705.4454693029, c: 156876.14940188668)},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': TriangleSides(a: 554058.9237526915, b: 442304.3119779007, c: 333958.4723798207)},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': TriangleSides(a: 452263.33963598683, b: 238326.5916748951, c: 222107.8492204914)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleSides(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        sidesTest(_actual, elem['expectedOutput'] as TriangleSides);
      });
    }
  });

  group("triangle.calculateEllipsoidTriangleCircumference:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': 0},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': 0},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': 627410.9239872629},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': 1330321.7081104128},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': 912697.7805313733},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleCircumference(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("triangle.ellipsoidTriangleArea:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': 0},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': 0},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': 2666.187396349551},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': double.nan},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': 42186895.0235761},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = polygonArea([elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng], Ellipsoid.WGS84);
        _actual.isNaN ? expect(_actual.toString(), elem['expectedOutput'].toString()) : expect(_actual, elem['expectedOutput']);
      });
    }
  });
}