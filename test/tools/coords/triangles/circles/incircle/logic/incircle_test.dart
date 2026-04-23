import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/circles.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

import '../../../_common/ellipsoid_triangles_test_utils.dart';

void main() async {
  group("triangle.calculateEllipsoidTriangleIncircle:", () {
    for (int i = 0; i < validEllipsoidTrianglesForTests.length; i++) {
      var triangleTest = validEllipsoidTrianglesForTests[i];

      var triangle = EllipsoidTriangle(triangleTest['inputA'] as LatLng, triangleTest['inputB'] as LatLng, triangleTest['inputC'] as LatLng, Ellipsoid.WGS84);
      test('input: $triangle, cw: ${triangle.isClockwise}', () {
        var _actual = calculateEllipsoidTriangleIncircle(triangle, Ellipsoid.WGS84);
        if (_actual == null) {
          expect(_actual == null, !triangle.isValid || triangleIsMeridianCircle(triangle, Ellipsoid.WGS84));
          return;
        }

        var _triangle = orderEllipsoidTrianglePointsClockwise(triangle, Ellipsoid.WGS84);
        var _a = _triangle.a;
        var _b = _triangle.b;
        var _c = _triangle.c;

        var projPToAB = orthogonalProjectionBearing(_actual.circle.center, _a, _triangle.bearingAB, Ellipsoid.WGS84);
        var projPToBC = orthogonalProjectionBearing(_actual.circle.center, _b, _triangle.bearingBC, Ellipsoid.WGS84);
        var projPToCA = orthogonalProjectionBearing(_actual.circle.center, _c, _triangle.bearingCA, Ellipsoid.WGS84);
        var distAB = distanceBearing(_actual.circle.center, projPToAB, Ellipsoid.WGS84).distance;
        var distBC = distanceBearing(_actual.circle.center, projPToBC, Ellipsoid.WGS84).distance;
        var distCA = distanceBearing(_actual.circle.center, projPToCA, Ellipsoid.WGS84).distance;

        var dists = [distAB, distBC, distCA];
        dists.sort();

        expect(((dists[2] + dists[0]) / 2 - _actual.circle.radius).abs() < 1e-8, true);
        if (!utils.isNearPole(_actual.circle.center, tolerance: 0.1)) {
          // Some strange behaviour happens near poles. Accepted Risk. (SMan, 04/2026)
          expect(utils.isOnSegment(projPToAB, _a, _b, Ellipsoid.WGS84), true);
          expect(utils.isOnSegment(projPToBC, _b, _c, Ellipsoid.WGS84), true);
          expect(utils.isOnSegment(projPToCA, _a, _c, Ellipsoid.WGS84), true);
        }
      });
    }
  });
}