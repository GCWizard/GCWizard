import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/triangles/circumcircle/logic/circumcircle.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

import '../../../../science_and_technology/euclidic_triangle/logic/triangle.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("triangle.calculateEllipsoidTriangleCircumCircle:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': Circle(LatLng(0, 0), 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': Circle(LatLng(1, 1), 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': Circle(LatLng(1934.7030372679465, 92.79740521391386), 10229740.418693105)},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': Circle(LatLng(1.9993350317701704, 1.5), 277029.5775555018)},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': Circle(LatLng(40.77890091674158, 1.8662936979758342), 611666.4729970332)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleCircumCircle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        circleTest(_actual, elem['expectedOutput'] as Circle);
      });
    }
  });
}