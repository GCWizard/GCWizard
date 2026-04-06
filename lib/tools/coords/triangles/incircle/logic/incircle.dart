import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/triangles.dart';
import 'package:latlong2/latlong.dart';

Circle calculateEllipsoidTriangleInCircle(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var clockwiseOrdered = orderEllipsoidTrianglePointsClockwise(a, b, c, ellipsoid);
  var _a = clockwiseOrdered[0];
  var _b = clockwiseOrdered[1];
  var _c = clockwiseOrdered[2];

  var distBearAB = distanceBearing(_a, _b, ellipsoid);
  var distBearAC = distanceBearing(_a, _c, ellipsoid);
  var distBearBC = distanceBearing(_b, _c, ellipsoid);

  var bearingAB = distBearAB.bearingAToB;
  var bearingAC = distBearAC.bearingAToB;
  var bearingBA = distBearAB.bearingBToA;
  var bearingBC = distBearBC.bearingAToB;

  var distance = max(distBearAB.distance, max(distBearAC.distance, distBearBC.distance));

  var segmentA = segmentBearings(_a, bearingAB, bearingAC, distance, 2, ellipsoid);
  var segmentB = segmentBearings(_b, bearingBA, bearingBC, distance, 2, ellipsoid);

  var intersection = intersectFourPoints(_a, segmentA.points.first, _b, segmentB.points.first, ellipsoid);
  var project = orthogonalProjectionTwoPoints(intersection, _a, _b, ellipsoid);

  var radius = distanceBearing(intersection, project, ellipsoid).distance;
  return Circle(intersection, radius);
}