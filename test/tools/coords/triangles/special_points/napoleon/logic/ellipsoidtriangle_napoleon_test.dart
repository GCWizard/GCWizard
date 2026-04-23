import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/special_points/napoleon/logic/ellipsoidtriangle_napoleon.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../science_and_technology/euclidic_triangle/logic/triangle_test_utils.dart';

void main() async {
  group("triangle.calculateEllipsoidTriangleNapoleonPoints:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': [LatLng(double.nan, double.nan), LatLng(double.nan, double.nan)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': [LatLng(double.nan, double.nan), LatLng(double.nan, double.nan)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': [LatLng(1.8067181300927935, 2.191037609753793), LatLng(2.194009649931147, 1.8083808049015455)]},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': [LatLng(1.00176091013359, 0.923820236371675), LatLng(2.4197147005253923, 0.7585637973793522)]},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': [LatLng(39.98309716608685, 9.146750508939933), LatLng(40.1866389195436, 8.171521627780027)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var triangle = EllipsoidTriangle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        var _actual = calculateEllipsoidTriangleNapoleonPoints(triangle, Ellipsoid.WGS84);
        latLngListTest([_actual.first.centerpoint, _actual.last.centerpoint], elem['expectedOutput'] as List<LatLng>);
      });
    }
  });
}