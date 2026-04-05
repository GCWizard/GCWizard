import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/logic/intersect_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/triangles.dart';
import 'package:latlong2/latlong.dart';

class Excircle{
  Circle circle;
  LatLng touchpoint;

  Excircle(this.circle, this.touchpoint);
}

Excircle _calcExCircleOfAOnBC(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var distBearAB = distanceBearing(a, b, ellipsoid);
  var distBearAC = distanceBearing(a, c, ellipsoid);
  var distBearBC = distanceBearing(b, c, ellipsoid);

  var bearingAB = distBearAB.bearingAToB;
  var bearingAC = distBearAC.bearingAToB;
  var bearingBC = distBearBC.bearingAToB;
  var bearingBA = distBearAB.bearingBToA;

  var distance = max(distBearAB.distance, max(distBearAC.distance, distBearBC.distance));

  var segmentA = segmentBearings(a, bearingAB, bearingAC, distance, 2, ellipsoid);
  var segmentB = segmentBearings(b, bearingBA, bearingBC, distance, 2, ellipsoid);

  var intersectionAOnBC = intersectFourPoints(a, segmentA.points.first, b, c, ellipsoid);
  var intersectionBOnAC = intersectFourPoints(b, segmentB.points.first, a, c, ellipsoid);

  var bearingA = distanceBearing(a, intersectionAOnBC, ellipsoid).bearingAToB;
  var bearingB = distanceBearing(b, intersectionBOnAC, ellipsoid).bearingAToB;
  bearingB = normalizeBearing(bearingB + 90);

  var centerPoint = intersectBearings(a, bearingA, b, bearingB, ellipsoid);

  var projectCenterOnBC = orthogonalProjectionTwoPoints(centerPoint, b, c, ellipsoid);
  var radius = distanceBearing(centerPoint, projectCenterOnBC, ellipsoid).distance;

  return Excircle(Circle(centerPoint, radius), projectCenterOnBC);
}

List<Excircle> calculateEllipsoidTriangleExCircles(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid){
  var clockwiseOrdered = orderTrianglePointsClockwise(a, b, c, ellipsoid);
  var _a = clockwiseOrdered[0];
  var _b = clockwiseOrdered[1];
  var _c = clockwiseOrdered[2];

  var circle1 = _calcExCircleOfAOnBC(_a, _b, _c, ellipsoid);
  var circle2 = _calcExCircleOfAOnBC(_b, _a, _c, ellipsoid);
  var circle3 = _calcExCircleOfAOnBC(_c, _a, _b, ellipsoid);

  if (_b == b) {
    // if points were ordered clockwise originally
    return [circle1, circle2, circle3];
  } else {
    return [circle1, circle3, circle2];
  }
}