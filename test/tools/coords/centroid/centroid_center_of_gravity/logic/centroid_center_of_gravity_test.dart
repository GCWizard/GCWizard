import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/logic/centroid_center_of_gravity.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {

  group("Centroid.centroidCenterOfGravity:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coords' : [const LatLng(34.088869, 33.3238855), const LatLng(68.3433821667, 5.3754655667), const LatLng(54.3917007667, -11.53589395)], 'expectedOutput': const LatLng(54.017923, 12.893674)},
      {'coords' : [const LatLng(34.088869, -157.6761145), const LatLng(68.3433821667, 174.3754655667), const LatLng(54.3917007667, 157.4641061)], 'expectedOutput': const LatLng(54.017923, -178.106326)},
      {'coords' : [const LatLng(34.088869, 157.6761145), const LatLng(68.3433821667, -174.3754655667), const LatLng(54.3917007667, -157.4641061)], 'expectedOutput': const LatLng(54.017923, 178.106326)}
    ];

    for (var elem in _inputsToExpected) {
      test('coords: ${elem['coords']}', () {
        var actual = centroidCenterOfGravity(elem['coords'] as List<LatLng>);
        expect(equalsLatLng(actual!, elem['expectedOutput'] as LatLng, tolerance: 1e-5), true);
      });
    }
  });
}