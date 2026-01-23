import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/science_and_technology/triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

Angles calculateEllipsoidTriangleAngles(LatLng A, LatLng B, LatLng C) {
  var a = (distanceBearing(A, C, defaultEllipsoid).bearingAToB -
          distanceBearing(A, B, defaultEllipsoid).bearingAToB)
      .abs();
  var b = (distanceBearing(B, C, defaultEllipsoid).bearingAToB -
          distanceBearing(B, A, defaultEllipsoid).bearingAToB)
      .abs();
  var c = (distanceBearing(C, A, defaultEllipsoid).bearingAToB -
          distanceBearing(C, B, defaultEllipsoid).bearingAToB)
      .abs();
  return Angles(
    alpha: a > 180 ? 360 - a : a,
    beta: b > 180 ? 360 - b : b,
    gamma: c > 180 ? 360 - c : c,
  );
}

Sides calculateEllipsoidTriangleSides(LatLng A, LatLng B, LatLng C) {
  return Sides(
      a: distanceBearing(B, C, defaultEllipsoid).distance,
      b: distanceBearing(A, C, defaultEllipsoid).distance,
      c: distanceBearing(A, B, defaultEllipsoid).distance);
}
