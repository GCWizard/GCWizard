import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:latlong2/latlong.dart';

Circle calculateEllipsoidTriangleInCircle(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var distBearAB = distanceBearing(a, b, ellipsoid);
  var distBearAC = distanceBearing(a, c, ellipsoid);
  var distBearBC = distanceBearing(b, c, ellipsoid);

  var bearingAB = distBearAB.bearingAToB;
  var bearingAC = distBearAC.bearingAToB;
  var bearingBA = distBearAB.bearingBToA;
  var bearingBC = distBearBC.bearingAToB;

  var distance = max(distBearAB.distance, max(distBearAC.distance, distBearBC.distance));

  var segmentA = segmentBearings(a, bearingAB, bearingAC, distance, 2, ellipsoid);
  var segmentB = segmentBearings(b, bearingBA, bearingBC, distance, 2, ellipsoid);

  var intersection = intersectFourPoints(a, segmentA.points.first, b, segmentB.points.first, ellipsoid);
  var project = orthogonalProjectionTwoPoints(intersection, a, b, ellipsoid);

  var radius = distanceBearing(intersection, project, ellipsoid).distance;
  return Circle(intersection, radius);
}