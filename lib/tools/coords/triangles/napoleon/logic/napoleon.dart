import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/logic/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/logic/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> calculateEllipsoidTriangleNapoleonPoints(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {

  if (distanceBearing(a, b, ellipsoid).distance == 0.0 ||
      distanceBearing(a, b, ellipsoid).distance == 0.0 ||
      distanceBearing(a, b, ellipsoid).distance == 0.0)   {
    return [
      LatLng(double.nan, double.nan), LatLng(double.nan, double.nan),
    ];
  }

  List<LatLng> pointsA = equilateralTriangle(b, c, ellipsoid);
  List<LatLng> pointsB = equilateralTriangle(c, a, ellipsoid);

  LatLng nacOut;
  LatLng nacIn;
  LatLng nbcOut;
  LatLng nbcIn;


  if (distanceBearing(a, pointsA[0], ellipsoid).distance >
      distanceBearing(a, pointsA[1], ellipsoid).distance) {
    nbcOut = centroidCenterOfGravity([b, c, pointsA[0]])!;
    nbcIn = centroidCenterOfGravity([b, c, pointsA[1]])!;
  } else {
    nbcOut = centroidCenterOfGravity([b, c, pointsA[1]])!;
    nbcIn = centroidCenterOfGravity([b, c, pointsA[0]])!;
  }

  if (distanceBearing(b, pointsB[0], ellipsoid).distance >
      distanceBearing(b, pointsB[1], ellipsoid).distance) {
    nacOut = centroidCenterOfGravity([a, c, pointsB[0]])!;
    nacIn = centroidCenterOfGravity([a, c, pointsB[1]])!;
  } else {
    nacOut = centroidCenterOfGravity([a, c, pointsB[1]])!;
    nacIn = centroidCenterOfGravity([a, c, pointsB[0]])!;
  }

  return [
    intersectFourPoints(nacOut, b, nbcOut, a, ellipsoid),
    intersectFourPoints(nacIn, b, nbcIn, a, ellipsoid),
  ];
}
