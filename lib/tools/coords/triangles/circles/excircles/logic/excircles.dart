part of 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/circles.dart';

class Excircle{
  Circle circle;
  LatLng touchpoint;

  Excircle(this.circle, this.touchpoint);
}

Excircle _calcExcircleOfAOnBC(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  var a = triangle.a;
  var b = triangle.b;
  var c = triangle.c;

  var bearingAB = triangle.bearingAB;
  var bearingAC = triangle.bearingAC;
  var bearingBC = triangle.bearingBC;
  var bearingBA = triangle.bearingBA;

  var distance = max(triangle.distanceAB, max(triangle.distanceAC, triangle.distanceBC));

  var segmentA = segmentBearings(a, bearingAC, bearingAB, distance, 2, ellipsoid);
  var segmentB = segmentBearings(b, bearingBA, bearingBC, distance, 2, ellipsoid);

  var intersectionAOnBC = intersectFourPoints(a, segmentA.points.first, b, c, ellipsoid);
  var intersectionBOnAC = intersectFourPoints(b, segmentB.points.first, a, c, ellipsoid);

  var bearingA = distanceBearing(a, intersectionAOnBC, ellipsoid).bearingAToB;
  var bearingB = distanceBearing(b, intersectionBOnAC, ellipsoid).bearingAToB;
  bearingB = utils.normalizeBearing(bearingB + 90);

  var centerPoint = intersectBearings(a, bearingA, b, bearingB, ellipsoid);

  var circle = _optimizeCircle(centerPoint, triangle, _CircleType.EXCIRCLE, ellipsoid);
  var projectCenterOnBC = orthogonalProjectionTwoPoints(circle.center, b, c, ellipsoid);

  return Excircle(circle, projectCenterOnBC);
}

List<Excircle>? calculateEllipsoidTriangleExcircles(ELlipsoidTriangle triangle, Ellipsoid ellipsoid){
  if (!triangle.isValid) {
    return null;
  }

  var _triangle = triangle;

  if (!triangle.isClockwise) {
    _triangle = orderEllipsoidTrianglePointsClockwise(triangle, ellipsoid);
  }

  var circle1 = _calcExcircleOfAOnBC(_triangle, ellipsoid);
  var circle2 = _calcExcircleOfAOnBC(_triangle, ellipsoid);
  var circle3 = _calcExcircleOfAOnBC(_triangle, ellipsoid);

  if (triangle.isClockwise) {
    return [circle1, circle2, circle3];
  } else {
    return [circle1, circle3, circle2];
  }
}