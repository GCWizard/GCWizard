import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/intersection/logic/intersection.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
 group("Intersection.intersection:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord1': LatLng(47.409333333333336, 8.706033333333334), 'alpha': 60.0, 'coord2': LatLng(47.41005, 8.706816666666667), 'beta': 60.0,
        'expectedOutput': [
          LatLng(47.409231, 8.707339),
          LatLng(47.410152, 8.705511)
        ]},
    ];

    for (var elem in _inputsToExpected) {
      test('coord1: ${elem['coord1']}, alpha: ${elem['alpha']}, coord2: ${elem['coord2']}, beta: ${elem['beta']}', () {
        var actual = intersection(elem['coord1'] as LatLng, elem['alpha'] as double, elem['coord2'] as LatLng, elem['beta'] as double, getEllipsoidByName(ELLIPSOID_NAME_WGS84)!);
        var expected = elem['expectedOutput'] as List<LatLng>;
        expect(actual.length, expected.length);
        for (int i = 0; i < actual.length; i++) {
          if (actual[i] == null) {
            expect(null, expected[i]);
          } else {
            expect(equalsLatLng(actual[i]!, expected[i], tolerance: 1e-5), true);
          }

        }
      });
    }
  });
}