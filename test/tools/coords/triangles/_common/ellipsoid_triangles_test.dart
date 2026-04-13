import 'dart:core';
import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

import '../../../science_and_technology/euclidic_triangle/logic/triangle_test_utils.dart';
import 'ellipsoid_triangles_test_utils.dart';

void main() async {
  group("triangle.isValidTriangle:", () {

    for (var elem in validEllipsoidTrianglesForTests) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var triangle = ELlipsoidTriangle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        var _actual = isValidEllipsoidTriangle(triangle, Ellipsoid.WGS84);
        expect(_actual, true);
      });
    }

    for (var elem in invalidEllipsoidTrianglesForTests) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var triangle = ELlipsoidTriangle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        var _actual = isValidEllipsoidTriangle(triangle, Ellipsoid.WGS84);
        expect(_actual, false);
      });
    }
  });

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
        var triangle = ELlipsoidTriangle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        var _actual = ellipsoidTriangleAngles(triangle, Ellipsoid.WGS84);
        anglesTest(_actual, elem['expectedOutput'] as TriangleInteriorAngles);
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
        var triangle = ELlipsoidTriangle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        var _actual = ellipsoidTriangleCircumference(triangle, Ellipsoid.WGS84);
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
        var triangle = ELlipsoidTriangle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        var _actual = polygonAreaEdges(
          triangle.a,
          [triangle.bearingAB, triangle.bearingBC, triangle.bearingCA],
          [triangle.distanceAB, triangle.distanceBC, triangle.distanceAC],
          Ellipsoid.WGS84
        );
        _actual.isNaN ? expect(_actual.toString(), elem['expectedOutput'].toString()) : expect(_actual, elem['expectedOutput']);
      });
    }
  });
}