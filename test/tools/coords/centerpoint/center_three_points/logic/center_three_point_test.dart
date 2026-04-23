import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_three_points/logic/center_three_points.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint_distance.dart';
import 'package:latlong2/latlong.dart';

import '../../../../science_and_technology/euclidic_triangle/logic/triangle_test_utils.dart';

void main() async {
  group("triangle.calculateEllipsoidTriangleCircumCircle:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord1': LatLng(0, 0), 'coord2': LatLng(0, 0), 'coord3': LatLng(0, 0),
        'expectedOutput': CenterPointDistance(LatLng(0, 0), 0)},
      {'coord1': LatLng(1, 1), 'coord2': LatLng(1, 1), 'coord3': LatLng(1, 1),
        'expectedOutput': CenterPointDistance(LatLng(1, 1), 0)},
      {'coord1': LatLng(1, 1), 'coord2': LatLng(2, 2), 'coord3': LatLng(3, 3),
        'expectedOutput': CenterPointDistance(LatLng(45.296962764149036, -86.77768513489207), 9757529.044598734)},
      {'coord1': LatLng(0, 0), 'coord2': LatLng(0, 3), 'coord3': LatLng(4, 0),
        'expectedOutput': CenterPointDistance(LatLng(1.999335031770143, 1.5000000000000009), 277029.5775555354)},
      {'coord1': LatLng(40, 9), 'coord2': LatLng(42, 9), 'coord3': LatLng(38, 8),
        'expectedOutput': CenterPointDistance(LatLng(40.77890091674048, 1.8662936977998468), 611666.4730080959)},
      {'coord1': LatLng(38.6354371601, -42.330168972), 'coord2': LatLng(55.8881704836, 22.3103825218), 'coord3': LatLng(-12.3483461684, 12.8507896202),
        'expectedOutput': CenterPointDistance(LatLng(22.64930970170015, -2.1015397981253727), 4200906.419948776)},
      {'coord1': const LatLng(50.269379, 8.383377), 'coord2': const LatLng(50.263548, 8.389584), 'coord3': const LatLng(50.262632, 8.372956),
        'expectedOutput': CenterPointDistance(LatLng(50.264123796723936, 8.38113136386326), 606.0888202459223)}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['coord1']} ${elem['coord2']} ${elem['coord3']}', () {
        var _actual = centerPointThreePoints(elem['coord1'] as LatLng, elem['coord2'] as LatLng, elem['coord3'] as LatLng, Ellipsoid.WGS84);
        var _expected = elem['expectedOutput'] as CenterPointDistance;
        circleTest(Circle(_actual.centerPoint, _actual.distance), Circle(_expected.centerPoint, _expected.distance));
      });
    }
  });
}