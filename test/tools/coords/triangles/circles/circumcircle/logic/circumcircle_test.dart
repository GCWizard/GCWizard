import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centerpoint/center_three_points/logic/center_three_points.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint_distance.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../science_and_technology/euclidic_triangle/logic/triangle_test_utils.dart';

void main() async {
  group("triangle.calculateEllipsoidTriangleCircumCircle:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': CenterPointDistance(LatLng(0, 0), 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': CenterPointDistance(LatLng(1, 1), 0)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': CenterPointDistance(LatLng(1934.7030372679465, 92.79740521391386), 10229740.418693105)},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': CenterPointDistance(LatLng(1.9993350317701704, 1.5), 277029.5775555018)},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': CenterPointDistance(LatLng(40.77890091674158, 1.8662936979758342), 611666.4729970332)},
      {'inputA': LatLng(38.6354371601, -42.330168972), 'inputB': LatLng(55.8881704836, 22.3103825218), 'inputC': LatLng(-12.3483461684, 12.8507896202),
        'expectedOutput': CenterPointDistance(LatLng(22.6493097017, -2.1015397981), 4200906.419948773)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = centerPointThreePoints(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng, Ellipsoid.WGS84);
        var _expected = elem['expectedOutput'] as CenterPointDistance;
        circleTest(Circle(_actual.centerPoint, _actual.distance), Circle(_expected.centerPoint, _expected.distance));
      });
    }
  });
}