import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Centroid.centroid:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord1': LatLng(50.269379, 8.383377), 'coord2': LatLng(50.263548, 8.389584), 'coord3': LatLng(50.262632, 8.372956), 'expectedOutput': LatLng(50.26413560415198, 8.381129007542059)}
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    for (var elem in _inputsToExpected) {
      test('coord1: ${elem['coord1']}, coord2: ${elem['coord2']}, coord2: ${elem['coord3']}', () {
        var actual = centerPointThreePoints(elem['coord1'] as LatLng, elem['coord2'] as LatLng, elem['coord3'] as LatLng, ells!);
        expect(equalsLatLng(actual.first.centerPoint, elem['expectedOutput'] as LatLng), true);
      });
    }
  });
}