import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/logic/intersect_bearing.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangles.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

import 'package:latlong2/latlong.dart';

Circle? calculateEllipsoidTriangleInCircle(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(a, b, c, ellipsoid)) {
    return null;
  }

  var clockwiseOrdered = orderEllipsoidTrianglePointsClockwise(a, b, c, ellipsoid);
  var _a = clockwiseOrdered[0];
  var _b = clockwiseOrdered[1];
  var _c = clockwiseOrdered[2];

  print(clockwiseOrdered);

  var distBearAB = distanceBearing(_a, _b, ellipsoid);
  var distBearAC = distanceBearing(_a, _c, ellipsoid);
  var distBearBC = distanceBearing(_b, _c, ellipsoid);

  var bearingAB = distBearAB.bearingAToB;
  print('bearingAB: ' + bearingAB.toString());
  var bearingAC = distBearAC.bearingAToB;
  print('bearingAC: ' + bearingAC.toString());
  var bearingBA = distBearAB.bearingBToA;
  print('bearingBA: ' + bearingBA.toString());
  var bearingBC = distBearBC.bearingAToB;
  print('bearingBC: ' + bearingBC.toString());
  var bearingCA = distBearAC.bearingBToA;
  print('bearingCA: ' + bearingCA.toString());
  var bearingCB = distBearBC.bearingBToA;
  print('bearingCB: ' + bearingCB.toString());

  var distance = max(distBearAB.distance, max(distBearAC.distance, distBearBC.distance));
  print(distance);

  var segmentA = segmentBearings(_a, bearingAB, bearingAC, distance, 2, ellipsoid);
  print(segmentA.points.first.latitude.toString() + ', ' + segmentA.points.first.longitude.toString() + ', ' + segmentA.segmentAngle.toString());

  var segmentB = segmentBearings(_b, bearingBC, bearingBA, distance, 2, ellipsoid);
  print(segmentB.points.first.latitude.toString() + ', ' + segmentB.points.first.longitude.toString() + ', ' + segmentB.segmentAngle.toString());

  var segmentC = segmentBearings(_c, bearingCA, bearingCB, distance, 2, ellipsoid);
  print(segmentC.points.first.latitude.toString() + ', ' + segmentC.points.first.longitude.toString() + ', ' + segmentC.segmentAngle.toString());

  var segmentedBearingA = utils.normalizeBearing(bearingAB + segmentA.segmentAngle);
  var segmentedBearingB = utils.normalizeBearing(bearingBC + segmentB.segmentAngle);
  var segmentedBearingC = utils.normalizeBearing(bearingCA + segmentC.segmentAngle);
  print('SegA: ' + segmentedBearingA.toString());
  print('SegB: ' + segmentedBearingB.toString());
  print('SegC: ' + segmentedBearingC.toString());

  var intersection = intersectBearings(_a, segmentedBearingA, _b, segmentedBearingB, ellipsoid);
  print('Int1: ' + intersection.latitude.toString() + ', ' + intersection.longitude.toString());
  print('AP1: ' + distanceBearing(_a, intersection, ellipsoid).bearingAToB.toString());
  print('BP1: ' + distanceBearing(_b, intersection, ellipsoid).bearingAToB.toString());
  print('CP1: ' + distanceBearing(_c, intersection, ellipsoid).bearingAToB.toString());

  var intersection2 = intersectBearings(_a, segmentedBearingA, _c, segmentedBearingC, ellipsoid);
  print('Int2: ' + intersection2.latitude.toString() + ', ' + intersection2.longitude.toString());
  print('AP2: ' + distanceBearing(_a, intersection2, ellipsoid).bearingAToB.toString());
  print('BP2: ' + distanceBearing(_b, intersection2, ellipsoid).bearingAToB.toString());
  print('CP2: ' + distanceBearing(_c, intersection2, ellipsoid).bearingAToB.toString());

  var project = orthogonalProjectionTwoPoints(intersection, _a, _b, ellipsoid);
  var project2 = orthogonalProjectionTwoPoints(intersection2, _a, _c, ellipsoid);

  var radius = distanceBearing(intersection, project, ellipsoid).distance;
  var radius2 = distanceBearing(intersection2, project2, ellipsoid).distance;
  print('Radius1: ' + radius.toString());
  print('Radius2: ' + radius2.toString());

  var projPToAB = orthogonalProjectionTwoPoints(intersection, a, b, Ellipsoid.WGS84);
  var projPToBC = orthogonalProjectionTwoPoints(intersection, b, c, Ellipsoid.WGS84);
  var projPToAC = orthogonalProjectionTwoPoints(intersection, a, c, Ellipsoid.WGS84);
  var distAB = distanceBearing(intersection, projPToAB, Ellipsoid.WGS84).distance;
  var distBC = distanceBearing(intersection, projPToBC, Ellipsoid.WGS84).distance;
  var distAC = distanceBearing(intersection, projPToAC, Ellipsoid.WGS84).distance;

  var dists = [distAB, distBC, distAC];
  dists.sort();
  print(dists);

  var projPToAB2 = orthogonalProjectionTwoPoints(intersection2, a, b, Ellipsoid.WGS84);
  var projPToBC2 = orthogonalProjectionTwoPoints(intersection2, b, c, Ellipsoid.WGS84);
  var projPToAC2 = orthogonalProjectionTwoPoints(intersection2, a, c, Ellipsoid.WGS84);
  var distAB2 = distanceBearing(intersection2, projPToAB2, Ellipsoid.WGS84).distance;
  var distBC2 = distanceBearing(intersection2, projPToBC2, Ellipsoid.WGS84).distance;
  var distAC2 = distanceBearing(intersection2, projPToAC2, Ellipsoid.WGS84).distance;

  var dists2 = [distAB2, distBC2, distAC2];
  dists2.sort();
  print(dists2);

  return Circle(intersection2, radius2);
}