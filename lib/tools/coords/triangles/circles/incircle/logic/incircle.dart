part of 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/circles.dart';

Circle? calculateEllipsoidTriangleIncircle(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  if (!triangle.isValid || triangleIsMeridianCircle(triangle, ellipsoid)) {
    return null;
  }

  var _triangle = triangle;

  if (!triangle.isClockwise) {
    _triangle = orderEllipsoidTrianglePointsClockwise(triangle, ellipsoid);
  }

  LatLng initialGuess = _guessStartpointByIntersectBisectors(_triangle, ellipsoid)!.center;

  return _optimizeCircle(initialGuess, _triangle, _CircleType.INCIRCLE, ellipsoid);
}

Circle? _guessStartpointByIntersectBisectors(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  var _a = triangle.a;
  var _b = triangle.b;
  var _c = triangle.c;

  var distance = max(triangle.distanceAB, max(triangle.distanceAC, triangle.distanceBC));

  var segmentA = segmentBearings(_a, triangle.bearingAB, triangle.bearingAC, distance, 2, ellipsoid);
  var segmentB = segmentBearings(_b, triangle.bearingBC, triangle.bearingBA, distance, 2, ellipsoid);
  var segmentC = segmentBearings(_c, triangle.bearingCA, triangle.bearingCB, distance, 2, ellipsoid);

  var segmentedBearingA = utils.normalizeBearing(triangle.bearingAB + segmentA.segmentAngle);
  var segmentedBearingB = utils.normalizeBearing(triangle.bearingBC + segmentB.segmentAngle);
  var segmentedBearingC = utils.normalizeBearing(triangle.bearingCA + segmentC.segmentAngle);

  var intersection1 = intersectBearings(_a, segmentedBearingA, _b, segmentedBearingB, ellipsoid);
  var intersection2 = intersectBearings(_a, segmentedBearingA, _c, segmentedBearingC, ellipsoid);
  var intersection3 = intersectBearings(_b, segmentedBearingB, _c, segmentedBearingC, ellipsoid);

  var projPToAB1 = orthogonalProjectionBearing(intersection1, _a, triangle.bearingAB, Ellipsoid.WGS84);
  var projPToBC1 = orthogonalProjectionBearing(intersection1, _b, triangle.bearingBC, Ellipsoid.WGS84);
  var projPToAC1 = orthogonalProjectionBearing(intersection1, _c, triangle.bearingCA, Ellipsoid.WGS84);
  var distAB1 = distanceBearing(intersection1, projPToAB1, Ellipsoid.WGS84).distance;
  var distBC1 = distanceBearing(intersection1, projPToBC1, Ellipsoid.WGS84).distance;
  var distAC1 = distanceBearing(intersection1, projPToAC1, Ellipsoid.WGS84).distance;

  var dists1 = [distAB1, distBC1, distAC1];
  dists1.sort();
  var diff1 = dists1[2] - dists1[0];

  var projPToAB2 = orthogonalProjectionBearing(intersection2, _a, triangle.bearingAB, Ellipsoid.WGS84);
  var projPToBC2 = orthogonalProjectionBearing(intersection2, _b, triangle.bearingBC, Ellipsoid.WGS84);
  var projPToAC2 = orthogonalProjectionBearing(intersection2, _c, triangle.bearingCA, Ellipsoid.WGS84);
  var distAB2 = distanceBearing(intersection2, projPToAB2, Ellipsoid.WGS84).distance;
  var distBC2 = distanceBearing(intersection2, projPToBC2, Ellipsoid.WGS84).distance;
  var distAC2 = distanceBearing(intersection2, projPToAC2, Ellipsoid.WGS84).distance;

  var dists2 = [distAB2, distBC2, distAC2];
  dists2.sort();
  var diff2 = dists2[2] - dists2[0];

  var projPToAB3 = orthogonalProjectionBearing(intersection3, _a, triangle.bearingAB, Ellipsoid.WGS84);
  var projPToBC3 = orthogonalProjectionBearing(intersection3, _b, triangle.bearingBC, Ellipsoid.WGS84);
  var projPToAC3 = orthogonalProjectionBearing(intersection3, _c, triangle.bearingCA, Ellipsoid.WGS84);
  var distAB3 = distanceBearing(intersection3, projPToAB3, Ellipsoid.WGS84).distance;
  var distBC3 = distanceBearing(intersection3, projPToBC3, Ellipsoid.WGS84).distance;
  var distAC3 = distanceBearing(intersection3, projPToAC3, Ellipsoid.WGS84).distance;

  var dists3 = [distAB3, distBC3, distAC3];
  dists3.sort();
  var diff3 = dists3[2] - dists3[0];

  var radius1 = (dists1[0] + dists1[1] + dists1[2]) / 3;
  var radius2 = (dists2[0] + dists2[1] + dists2[2]) / 3;
  var radius3 = (dists3[0] + dists3[1] + dists3[2]) / 3;

  if (diff1 <= diff2) {
    if (diff1 <= diff3) {
      return Circle(intersection1, radius1);
    } else {
      return Circle(intersection3, radius3);
    }
  } else {
    if (diff2 <= diff3) {
      return Circle(intersection2, radius2);
    } else {
      return Circle(intersection3, radius3);
    }
  }
}