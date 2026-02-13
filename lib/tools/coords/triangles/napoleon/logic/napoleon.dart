import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/logic/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/logic/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> calculateEllipsoidTriangleNapoleonPoints(LatLng a, LatLng b, LatLng c) {

  if (distanceBearing(a, b, defaultEllipsoid).distance == 0.0 ||
      distanceBearing(a, b, defaultEllipsoid).distance == 0.0 ||
      distanceBearing(a, b, defaultEllipsoid).distance == 0.0)   {
    return [
      LatLng(double.nan, double.nan), LatLng(double.nan, double.nan),
    ];
  }

  List<LatLng> pointsA = equilateralTriangle(b, c, defaultEllipsoid);
  List<LatLng> pointsB = equilateralTriangle(c, a, defaultEllipsoid);

  LatLng nacOut;
  LatLng nacIn;
  LatLng nbcOut;
  LatLng nbcIn;


  if (distanceBearing(a, pointsA[0], defaultEllipsoid).distance >
      distanceBearing(a, pointsA[1], defaultEllipsoid).distance) {
    nbcOut = centroidCenterOfGravity([b, c, pointsA[0]])!;
    nbcIn = centroidCenterOfGravity([b, c, pointsA[1]])!;
  } else {
    nbcOut = centroidCenterOfGravity([b, c, pointsA[1]])!;
    nbcIn = centroidCenterOfGravity([b, c, pointsA[0]])!;
  }

  if (distanceBearing(b, pointsB[0], defaultEllipsoid).distance >
      distanceBearing(b, pointsB[1], defaultEllipsoid).distance) {
    nacOut = centroidCenterOfGravity([a, c, pointsB[0]])!;
    nacIn = centroidCenterOfGravity([a, c, pointsB[1]])!;
  } else {
    nacOut = centroidCenterOfGravity([a, c, pointsB[1]])!;
    nacIn = centroidCenterOfGravity([a, c, pointsB[0]])!;
  }

  return [
    intersectFourPoints(nacOut, b, nbcOut, a, defaultEllipsoid),
    intersectFourPoints(nacIn, b, nbcIn, a, defaultEllipsoid),
  ];
}
