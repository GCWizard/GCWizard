import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/circles.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

import '../../../_common/ellipsoid_triangles_test_utils.dart';

void main() async {
  group("triangle.calculateEllipsoidTriangleInCircle:", () {
    for (int i = 0; i < validEllipsoidTrianglesForTests.length; i++) {
      var triangle = validEllipsoidTrianglesForTests[i];

      var a = triangle['inputA'] as LatLng;
      var b = triangle['inputB'] as LatLng;
      var c = triangle['inputC'] as LatLng;

      test('input: $a $b $c', () {
        var _actual = calculateEllipsoidTriangleIncircle(a, b, c, Ellipsoid.WGS84);

        LatLng _a = utils.normalizeLatLon(a.latitude, a.longitude);
        LatLng _b = utils.normalizeLatLon(b.latitude, b.longitude);
        LatLng _c = utils.normalizeLatLon(c.latitude, c.longitude);

        var projPToAB = orthogonalProjectionTwoPoints(_actual!.center, _a, _b, Ellipsoid.WGS84);
        var projPToBC = orthogonalProjectionTwoPoints(_actual.center, _b, _c, Ellipsoid.WGS84);
        var projPToAC = orthogonalProjectionTwoPoints(_actual.center, _a, _c, Ellipsoid.WGS84);
        var distAB = distanceBearing(_actual.center, projPToAB, Ellipsoid.WGS84).distance;
        var distBC = distanceBearing(_actual.center, projPToBC, Ellipsoid.WGS84).distance;
        var distAC = distanceBearing(_actual.center, projPToAC, Ellipsoid.WGS84).distance;

        var dists = [distAB, distBC, distAC];
        dists.sort();
        expect(((dists[2] + dists[0]) / 2 - _actual.radius).abs() < 1e-8, true);
        print(projPToAB);
        print(_a); print(_b);
        print(distanceBearing(_a, _b, Ellipsoid.WGS84).bearingAToB);
        expect(utils.isOnSegment(projPToAB, _a, _b, Ellipsoid.WGS84), true);
        expect(utils.isOnSegment(projPToBC, _b, _c, Ellipsoid.WGS84), true);
        expect(utils.isOnSegment(projPToAC, _a, _c, Ellipsoid.WGS84), true);
      });
    }
  });
}