import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/segment_bearings/logic/segment_bearings.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/triangles.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

Circle calculateEllipsoidTriangleInCircle(LatLng A, LatLng B, LatLng C) {
  var dist = calculateEllipsoidTriangleCircumference(A, B, C);
  var p1 = segmentBearings(
      A,
      distanceBearing(A, C, defaultEllipsoid).bearingAToB,
      distanceBearing(A, B, defaultEllipsoid).bearingAToB,
      dist,
      2,
      defaultEllipsoid);
  var p2 = segmentBearings(
      B,
      distanceBearing(B, C, defaultEllipsoid).bearingAToB,
      distanceBearing(B, A, defaultEllipsoid).bearingAToB,
      dist,
      2,
      defaultEllipsoid);
  var incircle = intersectFourPoints(A, p1.points.first, B, p2.points.first, defaultEllipsoid);

  // calculations provided by Gemini
  // Normale einer Seite, z.B. BC
  final bVec = latLngToVec3(B);
  final cVec = latLngToVec3(C);
  final n = bVec.cross(cVec).normalized();

  // Winkelabstand Incenter → Seite
  final incenterVec = latLngToVec3(incircle).normalized();
  final r = asin((incenterVec.dot(n)).abs()); // in Radiant

  final radius = defaultEllipsoid.a * r; // Meter

  return Circle(incircle, radius,);
}