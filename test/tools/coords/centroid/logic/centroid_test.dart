import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/centroid/logic/centroid.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Centroid.centroid:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coords' : [LatLng(-21.1333, -175.2), LatLng(-8.53333, 179.2167)], 'expectedOutput': LatLng(-14.833315, -177.99165)}
    ];

    for (var elem in _inputsToExpected) {
      test('coords: ${elem['coords']}', () {
        var actual = centroid(elem['coords'] as List<LatLng>);
        expect(equalsLatLng(actual!, elem['expectedOutput'] as LatLng), true);
      });
    }
  });
}