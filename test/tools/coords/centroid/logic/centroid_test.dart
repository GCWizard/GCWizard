import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/centroid/logic/centroid.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Centroid.centroid:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'coords' : [LatLng(-21.1333, -175.2), LatLng(-8.53333, 179.2167)], 'expectedOutput': LatLng(-14.833315, -177.99165)},
      {'coords' : [LatLng(34.088869, 33.3238855), LatLng(68.3433821667, 5.3754655667), LatLng(54.3917007667, -11.53589395)], 'expectedOutput': LatLng(54.017923, 12.893674)}
    ];

    _inputsToExpected.forEach((elem) {
      test('coords: ${elem['coords']}', () {
        var actual = centroid(elem['coords']);
        expect(equalsLatLng(actual, elem['expectedOutput']), true);
      });
    });
  });

  group("Centroid.centroidCenterOfGravity:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'coords' : [LatLng(34.088869, 33.3238855), LatLng(68.3433821667, 5.3754655667), LatLng(54.3917007667, -11.53589395)], 'expectedOutput': LatLng(54.017923, 12.893674)},
      {'coords' : [LatLng(34.088869, -157.6761145), LatLng(68.3433821667, 174.3754655667), LatLng(54.3917007667, 157.4641061)], 'expectedOutput': LatLng(54.017923, -178.106326)},
      {'coords' : [LatLng(34.088869, 157.6761145), LatLng(68.3433821667, -174.3754655667), LatLng(54.3917007667, -157.4641061)], 'expectedOutput': LatLng(54.017923, 178.106326)}
    ];

    _inputsToExpected.forEach((elem) {
      test('coords: ${elem['coords']}', () {
        var actual = centroidCenterOfGravity(elem['coords']);
        expect(equalsLatLng(actual, elem['expectedOutput']), true);
      });
    });
  });

  group("Centroid.centroidArithmeticMean:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'coords' : [LatLng(34.088869, 33.3238855), LatLng(68.3433821667, 5.3754655667), LatLng(54.3917007667, -11.53589395)], 'expectedOutput': LatLng(52.274651, 9.054486)},
      {'coords' : [LatLng(34.088869, -157.6761145), LatLng(68.3433821667, 174.3754655667), LatLng(54.3917007667, 157.4641061)], 'expectedOutput': LatLng(52.274651, 178.054486)},
      {'coords' : [LatLng(34.088869, 157.6761145), LatLng(68.3433821667, -174.3754655667), LatLng(54.3917007667, -157.4641061)], 'expectedOutput': LatLng(52.274651, -178.054486)}
    ];

    _inputsToExpected.forEach((elem) {
      test('coords: ${elem['coords']}', () {
        var cog = centroidCenterOfGravity(elem['coords']);
        var actual = centroidArithmeticMean(elem['coords'], cog);
        expect(equalsLatLng(actual, elem['expectedOutput']), true);
      });
    });
  });
}