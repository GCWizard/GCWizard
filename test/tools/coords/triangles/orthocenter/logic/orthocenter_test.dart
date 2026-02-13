import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/triangles/orthocenter/logic/orthocenter.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

import '../../../../science_and_technology/euclidic_triangle/logic/triangle.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("triangle.calculateEllipsoidTriangleOrthocenter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': LatLng(double.nan, double.nan)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': LatLng(double.nan, double.nan)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': LatLng(double.nan, double.nan)},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': LatLng(0.0012313627109221286, 0.0016206807781600219)},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': LatLng(37.335737041313685, 21.523070668080436)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleOrthocenter(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        latLngTest(_actual, elem['expectedOutput'] as LatLng);
      });
    }
  });
}