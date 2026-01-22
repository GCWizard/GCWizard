import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/logic/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/logic/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> calculateEllipsoidTriangleNapoleonPoints(LatLng A, LatLng B, LatLng C) {
  List<LatLng> pointsA = equilateralTriangle(B, C, defaultEllipsoid);
  List<LatLng> pointsB = equilateralTriangle(C, A, defaultEllipsoid);

  LatLng NACout;
  LatLng NACin;
  LatLng NBCout;
  LatLng NBCin;

  if (distanceBearing(A, pointsA[0], defaultEllipsoid).distance >
      distanceBearing(A, pointsA[1], defaultEllipsoid).distance) {
    NBCout = centroidCenterOfGravity([B, C, pointsA[0]])!;
    NBCin = centroidCenterOfGravity([B, C, pointsA[1]])!;
  } else {
    NBCout = centroidCenterOfGravity([B, C, pointsA[1]])!;
    NBCin = centroidCenterOfGravity([B, C, pointsA[0]])!;
  }

  if (distanceBearing(B, pointsB[0], defaultEllipsoid).distance >
      distanceBearing(B, pointsB[1], defaultEllipsoid).distance) {
    NACout = centroidCenterOfGravity([A, C, pointsB[0]])!;
    NACin = centroidCenterOfGravity([A, C, pointsB[1]])!;
  } else {
    NACout = centroidCenterOfGravity([A, C, pointsB[1]])!;
    NACin = centroidCenterOfGravity([A, C, pointsB[0]])!;
  }

  return [
    intersectFourPoints(NACout, B, NBCout, A, defaultEllipsoid),
    intersectFourPoints(NACin, B, NBCin, A, defaultEllipsoid),
  ];
}
