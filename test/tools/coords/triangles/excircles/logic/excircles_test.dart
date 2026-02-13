import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/triangles/excircles/logic/excircles.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

import '../../../../science_and_technology/euclidic_triangle/logic/triangle.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("triangle.calculateEllipsoidTriangleExCircles:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': [Circle(LatLng(double.nan, double.nan), double.nan), Circle(LatLng(double.nan, double.nan), double.nan), Circle(LatLng(double.nan, double.nan), double.nan)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': [Circle(LatLng(double.nan, double.nan), double.nan), Circle(LatLng(double.nan, double.nan), double.nan), Circle(LatLng(double.nan, double.nan), double.nan)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': [Circle(LatLng(double.nan, double.nan), double.nan), Circle(LatLng(double.nan, double.nan), double.nan), Circle(LatLng(double.nan, double.nan), double.nan)]},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': [Circle(LatLng(5.983896321527141, 5.977224638371354), 661808.7769463151), Circle(LatLng(2.990927083046817, -2.9753304858554657), 330763.7095326205), Circle(LatLng(-2.0137766942498136, 2.00174926974978), 222672.82012224355)]},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': [Circle(LatLng(40.67991037914872, -18.4955260903198), 2284720.18143741), Circle(LatLng(37.88890910683774, 8.491435708899644), 44735.62133955817), Circle(LatLng(41.96210524028433, 9.50228817893526), 41639.40105911964)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleExCircles(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        circleListTest(_actual, elem['expectedOutput'] as List<Circle>);
      });
    }
  });

  group("triangle.calculateEllipsoidTriangleExCirclesTouchPoints:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': [LatLng(double.nan, double.nan), LatLng(double.nan, double.nan), LatLng(double.nan, double.nan)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': [LatLng(double.nan, double.nan), LatLng(double.nan, double.nan), LatLng(double.nan, double.nan)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': [LatLng(2.9999999547992937, 2.9999999547439984), LatLng(1.0000000904862194, 1.0000000903478394), LatLng(1.9999999547922287, 1.9999999547576408)]},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': [LatLng(2.391693519598998, 1.2086407438740707), LatLng(2.99498418720933, 0.0), LatLng(1.2337259154840623e-16, 2.0017492449758265)]},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': [LatLng(39.92971701581364, 8.467521458921283), LatLng(38.03437356063817, 8.016683216826323), LatLng(41.96320398941941, 9.0)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleExCirclesTouchPoints(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        latLngListTest(_actual, elem['expectedOutput'] as List<LatLng>);
      });
    }
  });
}