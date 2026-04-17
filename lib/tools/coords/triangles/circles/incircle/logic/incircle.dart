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
  print(segmentA.segmentAngle * 2);
  print(segmentB.segmentAngle * 2);
  print(segmentC.segmentAngle * 2);

  var segmentedBearingA = utils.normalizeBearing(triangle.bearingAB + segmentA.segmentAngle);
  var segmentedBearingB = utils.normalizeBearing(triangle.bearingBC + segmentB.segmentAngle);
  var segmentedBearingC = utils.normalizeBearing(triangle.bearingCA + segmentC.segmentAngle);

  var intersection1 = intersectBearings(_a, segmentedBearingA, _b, segmentedBearingB, ellipsoid);
  var intersection2 = intersectBearings(_b, segmentedBearingB, _c, segmentedBearingC, ellipsoid);
  var intersection3 = intersectBearings(_c, segmentedBearingC, _a, segmentedBearingA, ellipsoid);

  var intersections = [intersection1, intersection2, intersection3];

  var minDiff = double.infinity;
  Circle circle = Circle(LatLng(double.nan, double.nan), double.nan);

  for (var intersection in intersections) {
    var projPToAB = orthogonalProjectionBearing(intersection, _a, triangle.bearingAB, Ellipsoid.WGS84);
    var projPToBC = orthogonalProjectionBearing(intersection, _b, triangle.bearingBC, Ellipsoid.WGS84);
    var projPToAC = orthogonalProjectionBearing(intersection, _c, triangle.bearingCA, Ellipsoid.WGS84);
    var distAB = distanceBearing(intersection, projPToAB, Ellipsoid.WGS84).distance;
    var distBC = distanceBearing(intersection, projPToBC, Ellipsoid.WGS84).distance;
    var distAC = distanceBearing(intersection, projPToAC, Ellipsoid.WGS84).distance;

    var dists = [distAB, distBC, distAC];
    dists.sort();
    var diff = dists[2] - dists[0];

    var radius = (dists[0] + dists[1] + dists[2]) / 3;

    if (minDiff.isInfinite || diff < minDiff) {
      minDiff = diff;
      circle = Circle(intersection, radius);
    }
  }

  return circle;
}