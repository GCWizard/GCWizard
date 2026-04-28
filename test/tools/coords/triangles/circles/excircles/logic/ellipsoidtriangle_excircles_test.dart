import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/ellipsoidtriangle_circles.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

import '../../../_common/ellipsoid_triangles_test_utils.dart';

void main() async {
  group("triangle.calculateEllipsoidTriangleExcircles:", () {
    for (int i = 0; i < validEllipsoidTrianglesForTests.length; i++) {
      var triangleTest = validEllipsoidTrianglesForTests[i];

      var triangle = EllipsoidTriangle(triangleTest['inputA'] as LatLng, triangleTest['inputB'] as LatLng, triangleTest['inputC'] as LatLng, Ellipsoid.WGS84);
      test('input: $triangle, cw: ${triangle.isClockwise}', () {
        if (
             (triangle.bearingAB == 0 && triangle.bearingBA == 0)
          || (triangle.bearingAB == 180 && triangle.bearingBA == 180)
          || (triangle.bearingBC == 0 && triangle.bearingCB == 0)
          || (triangle.bearingBC == 180 && triangle.bearingCB == 180)
          || (triangle.bearingAC == 0 && triangle.bearingCA == 0)
          || (triangle.bearingAC == 180 && triangle.bearingCA == 180)
        ) {
          // Extreme edge case where at least one side goes over pole, accepted risk (SMan, 04/2026)
          return;
        }

        var _actual = calculateEllipsoidTriangleExcircles(triangle, Ellipsoid.WGS84);
        if (_actual == null) {
          expect(_actual == null, !triangle.isValid || triangleIsMeridianCircle(triangle, Ellipsoid.WGS84));
          return;
        }

        var _triangle = orderEllipsoidTrianglePointsClockwise(triangle, Ellipsoid.WGS84);
        var _a = _triangle.a;
        var _b = _triangle.b;
        var _c = _triangle.c;

        var incircle = calculateEllipsoidTriangleIncircle(triangle, Ellipsoid.WGS84);

        for (var excircle in _actual) {
          var projPToAB = orthogonalProjectionBearing(excircle.circle.center, _a, _triangle.bearingAB, Ellipsoid.WGS84);
          var projPToBC = orthogonalProjectionBearing(excircle.circle.center, _b, _triangle.bearingBC, Ellipsoid.WGS84);
          var projPToAC = orthogonalProjectionBearing(excircle.circle.center, _c, _triangle.bearingCA, Ellipsoid.WGS84);
          var distAB = distanceBearing(excircle.circle.center, projPToAB, Ellipsoid.WGS84).distance;
          var distBC = distanceBearing(excircle.circle.center, projPToBC, Ellipsoid.WGS84).distance;
          var distAC = distanceBearing(excircle.circle.center, projPToAC, Ellipsoid.WGS84).distance;

          var dists = [distAB, distBC, distAC];
          dists.sort();

          expect(((dists[2] + dists[0]) / 2 - excircle.circle.radius).abs() < 1e-6, true);

          // Not an Incircle
          expect(utils.equalsLatLng(excircle.circle.center, incircle!.circle.center, tolerance: 1e-6), false);
        }
      });
    }
  });
}