import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/intersect_bearing_and_circle/logic/intersect_geodetic_and_circle.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Intersection.intersection:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord1': const LatLng(48.736666666667, 8.004666667), 'bearing': 11.25, 'center': const LatLng(48.7533333333333, 8.020833333333), 'radius': 2000.0,
        'expectedOutput': [
          const LatLng(48.738596, 8.005247),
          const LatLng(48.770895, 8.014967)
        ]},
    ];

    for (var elem in _inputsToExpected) {
      test('coord1: ${elem['coord1']}, bearing: ${elem['bearing']}, center: ${elem['center']}, radius: ${elem['radius']}', () {
        var actual = intersectGeodeticAndCircle(elem['coord1'] as LatLng, elem['bearing'] as double, elem['center'] as LatLng, elem['radius'] as double, Ellipsoid.WGS84);
        var expected = elem['expectedOutput'] as List<LatLng>;
        expect(actual.length, expected.length);
        for (int i = 0; i < actual.length; i++) {
          expect(equalsLatLng(actual[i], expected[i], tolerance: 1e-5), true);
        }
      });
    }
  });
}