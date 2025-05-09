import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Projection.reverseProjection:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord' : const LatLng(-67.54191968624406, 178.01621612330604), 'expectedOutput': const LatLng(-67.48849337725231, 177.43970441425847), 'bearing': 103.87456562228434, 'distance': 25325.028166351105},
      {'coord' : const LatLng(67.52065020309101, 116.15017978871731), 'expectedOutput': const LatLng(67.46333237570478, 114.91858552958274), 'bearing': 82.5065605601814, 'distance': 53020.22653140148},
      {'coord' : const LatLng(75.96130646717049, 83.13727857890729), 'expectedOutput': const LatLng(75.93570642257264, 85.6363578154352), 'bearing': 273.62677269316185, 'distance': 67813.25176684314},
      {'coord' : const LatLng(73.72400894425445, 78.32961501166722), 'expectedOutput': const LatLng(67.48990578579877, 41.6956772704653), 'bearing': 46.33023075527244, 'distance': 1492701.569869107},
      {'coord' : const LatLng(19.793545607027113, -52.008335207337154), 'expectedOutput': const LatLng(16.86823975391602, -21.715970998711896), 'bearing': 280.50657372921285, 'distance': 3214178.0255869143},
      {'coord' : const LatLng(-78.35656674071589, -70.35858934072675), 'expectedOutput': const LatLng(6.13284033603278, -123.91294932358062), 'bearing': 170.61935386006067, 'distance': 9902447.165614301},
      {'coord' : const LatLng(-78.35656674071589, -70.35858934072675), 'expectedOutput': const LatLng(6.13284033603278, -123.91294932358062), 'bearing': 170.61935386006067, 'distance': 9902447.165614301},
      {'coord' : const LatLng(50.9824, 011.0930833333), 'expectedOutput': const LatLng(37.459265, -78.848104), 'bearing': 45.631928848, 'distance': 6885736.0},
      {'coord' : const LatLng(52.2861344, 013.4839812334), 'expectedOutput': const LatLng(52.28521511, 013.518545), 'bearing': 272.4969693, 'distance': 2360.8896896},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}, bearing: ${elem['bearing']}, distance: ${elem['distance']}', () {
        var actual = reverseProjection(elem['coord'] as LatLng, elem['bearing'] as double, elem['distance'] as double, Ellipsoid.WGS84);
        var equals = false;

        expect(false, actual == null);

        if (equalsLatLng(actual!, elem['expectedOutput'] as LatLng, tolerance: 1e-5)) {
          equals = true;
        }
        expect(equals, true);
      });
    }
  });
}