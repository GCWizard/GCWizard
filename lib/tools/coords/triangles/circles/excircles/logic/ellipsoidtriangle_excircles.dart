part of 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/ellipsoidtriangle_circles.dart';

EllipsoidTriangleCircle _calcExcircleOfAOnBC(EllipsoidTriangle triangle, EllipsoidTriangleCircleType type, Ellipsoid ellipsoid) {
  var a = triangle.a;
  var b = triangle.b;
  var c = triangle.c;

  var distance = max(triangle.distanceAB, max(triangle.distanceAC, triangle.distanceBC));

  var segmentA = segmentBearings(a, triangle.bearingAB, triangle.bearingAC, distance, 2, ellipsoid);
  var segmentB = segmentBearings(b, triangle.bearingBC, triangle.bearingBA, distance, 2, ellipsoid);
  var segmentC = segmentBearings(c, triangle.bearingCA, triangle.bearingCB, distance, 2, ellipsoid);

  var segmentedBearingA = utils.normalizeBearing(triangle.bearingAB + segmentA.segmentAngle);
  var segmentedBearingB = utils.normalizeBearing(triangle.bearingBC + segmentB.segmentAngle - 90);
  var segmentedBearingC = utils.normalizeBearing(triangle.bearingCA + segmentC.segmentAngle + 90);

  var strict = true;
  var intersection1 = intersectBearings(a, segmentedBearingA, b, segmentedBearingB, ellipsoid, strict: strict);
  var intersection2 = intersectBearings(b, segmentedBearingB, c, segmentedBearingC, ellipsoid, strict: strict);
  var intersection3 = intersectBearings(c, segmentedBearingC, a, segmentedBearingA, ellipsoid, strict: strict);

  var intersections = [intersection1, intersection2, intersection3];

  var minDiff = double.infinity;
  Circle circle = Circle(LatLng(double.nan, double.nan), double.nan);

  for (var intersection in intersections) {
    var projPToAB = orthogonalProjectionBearing(intersection, a, triangle.bearingAB, Ellipsoid.WGS84);
    var projPToBC = orthogonalProjectionBearing(intersection, b, triangle.bearingBC, Ellipsoid.WGS84);
    var projPToAC = orthogonalProjectionBearing(intersection, c, triangle.bearingCA, Ellipsoid.WGS84);
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

  return optimizeEllipsoidTriangleCircle(circle.center, triangle, type, ellipsoid);
}

List<EllipsoidTriangleCircle>? calculateEllipsoidTriangleExcircles(EllipsoidTriangle triangle, Ellipsoid ellipsoid){
  if (!triangle.isValid || triangleIsMeridianCircle(triangle, ellipsoid)) {
    return null;
  }

  var _triangle = triangle.getClockwised();

  var circle1 = _calcExcircleOfAOnBC(_triangle, EllipsoidTriangleCircleType.EXCIRCLE, ellipsoid);
  var _triangleBCA = EllipsoidTriangle(_triangle.b, _triangle.c, _triangle.a, ellipsoid);
  var circle2 = _calcExcircleOfAOnBC(_triangleBCA, EllipsoidTriangleCircleType.EXCIRCLE, ellipsoid);
  var _triangleCAB = EllipsoidTriangle(_triangle.c, _triangle.a, _triangle.b, ellipsoid);
  var circle3 = _calcExcircleOfAOnBC(_triangleCAB, EllipsoidTriangleCircleType.EXCIRCLE, ellipsoid);

  if (triangle.isClockwise) {
    return [circle1, circle2, circle3];
  } else {
    return [circle1, circle3, circle2];
  }
}