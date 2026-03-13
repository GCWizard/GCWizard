import 'dart:core';
import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/triangles.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

import '../../../science_and_technology/euclidic_triangle/logic/triangle.dart';


void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("triangle.calculateEllipsoidTriangleAngles:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': Angles(alpha: 0, beta: 0, gamma: 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': Angles(alpha: 0, beta: 0, gamma: 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': Angles(alpha: 0.02630127667657689, beta: 179.94740561118152, gamma: 0.026309127099466423)},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': Angles(alpha: 90, beta: 53.00282576179586, gamma: 37.10196090365815)},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': Angles(alpha: 158.3703675865121, beta: 11.207315582928572, gamma: 10.43608068564481)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleAngles(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        anglesTest(_actual, elem['expectedOutput'] as Angles);
      });
    }
  });

  group("triangle.calculateEllipsoidTriangleSides:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': Sides(a: 0, b: 0, c: 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': Sides(a: 0, b: 0, c: 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': Sides(a: 156829.32911607338, b: 313705.4454693029, c: 156876.14940188668)},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': Sides(a: 554058.9237526915, b: 442304.3119779007, c: 333958.4723798207)},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': Sides(a: 452263.33963598683, b: 238326.5916748951, c: 222107.8492204914)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleSides(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        sidesTest(_actual, elem['expectedOutput'] as Sides);
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
        var _actual = calculateEllipsoidTriangleCircumference(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("triangle.inverseWithArea:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0),
        'expectedOutput': 0.0},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1),
        'expectedOutput': 0.0},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2),
        'expectedOutput': 0.000058721793375566885},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3),
        'expectedOutput': double.nan},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9),
        'expectedOutput': 0.0},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']}', () {
        var _actual = inverseWithArea(elem['inputA'] as LatLng, elem['inputB'] as LatLng);
        _actual.isNaN ? expect(_actual.toString(), elem['expectedOutput'].toString()) : expect(_actual, elem['expectedOutput']);
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
        var _actual = ellipsoidTriangleArea(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        _actual.isNaN ? expect(_actual.toString(), elem['expectedOutput'].toString()) : expect(_actual, elem['expectedOutput']);
      });
    }
  });
}