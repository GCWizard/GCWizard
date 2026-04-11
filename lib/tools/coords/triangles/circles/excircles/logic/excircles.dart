part of 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/circles.dart';

class Excircle{
  Circle circle;
  LatLng touchpoint;

  Excircle(this.circle, this.touchpoint);
}

Excircle _calcExcircleOfAOnBC(LatLng a, LatLng b, LatLng c, double dAB, double dBC, double dCA, Ellipsoid ellipsoid) {
  var distBearAB = distanceBearing(a, b, ellipsoid);
  var distBearAC = distanceBearing(a, c, ellipsoid);
  var distBearBC = distanceBearing(b, c, ellipsoid);

  var bearingAB = distBearAB.bearingAToB;
  var bearingAC = distBearAC.bearingAToB;
  var bearingBC = distBearBC.bearingAToB;
  var bearingBA = distBearAB.bearingBToA;

  var distance = max(distBearAB.distance, max(distBearAC.distance, distBearBC.distance));

  var segmentA = segmentBearings(a, bearingAC, bearingAB, distance, 2, ellipsoid);
  var segmentB = segmentBearings(b, bearingBA, bearingBC, distance, 2, ellipsoid);

  var intersectionAOnBC = intersectFourPoints(a, segmentA.points.first, b, c, ellipsoid);
  var intersectionBOnAC = intersectFourPoints(b, segmentB.points.first, a, c, ellipsoid);

  var bearingA = distanceBearing(a, intersectionAOnBC, ellipsoid).bearingAToB;
  var bearingB = distanceBearing(b, intersectionBOnAC, ellipsoid).bearingAToB;
  bearingB = utils.normalizeBearing(bearingB + 90);

  var centerPoint = intersectBearings(a, bearingA, b, bearingB, ellipsoid);

  var circle = _optimizeCircle(centerPoint, a, b, c, dAB, dBC, dCA, _CircleType.EXCIRCLE, ellipsoid);
  var projectCenterOnBC = orthogonalProjectionTwoPoints(circle.center, b, c, ellipsoid);

  return Excircle(circle, projectCenterOnBC);
}

List<Excircle>? calculateEllipsoidTriangleExcircles(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid){
  if (!isValidEllipsoidTriangle(a, b, c, ellipsoid)) {
    return null;
  }

  LatLng _a = utils.normalizeLatLon(a.latitude, a.longitude);
  LatLng _b = utils.normalizeLatLon(b.latitude, b.longitude);
  LatLng _c = utils.normalizeLatLon(c.latitude, c.longitude);

  var clockwiseOrdered = orderEllipsoidTrianglePointsClockwise(_a, _b, _c, ellipsoid);
  _a = clockwiseOrdered[0];
  _b = clockwiseOrdered[1];
  _c = clockwiseOrdered[2];

  double dAB = distanceBearing(_a, _b, ellipsoid).distance;
  double dBC = distanceBearing(_b, _c, ellipsoid).distance;
  double dCA = distanceBearing(_c, _a, ellipsoid).distance;

  var circle1 = _calcExcircleOfAOnBC(_a, _b, _c, dAB, dBC, dCA, ellipsoid);
  var circle2 = _calcExcircleOfAOnBC(_b, _a, _c, dAB, dCA, dBC, ellipsoid);
  var circle3 = _calcExcircleOfAOnBC(_c, _a, _b, dCA, dAB, dBC, ellipsoid);

  if (_b == b) {
    // if points were ordered clockwise originally
    return [circle1, circle2, circle3];
  } else {
    return [circle1, circle3, circle2];
  }
}