import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/orthocenter/logic/ellipsoidtriangle_orthocenter.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../science_and_technology/euclidic_triangle/logic/triangle_test_utils.dart';

void main() async {
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
        var triangle = EllipsoidTriangle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        var _actual = calculateEllipsoidTriangleOrthocenter(triangle, Ellipsoid.WGS84);
        latLngTest(_actual.centerpoint, elem['expectedOutput'] as LatLng);
      });
    }
  });
}