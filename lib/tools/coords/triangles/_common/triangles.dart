import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> orderTrianglePointsClockwise(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var distBearAB = distanceBearing(a, b, ellipsoid);
  var distBearBC = distanceBearing(b, c, ellipsoid);
  var distBearCA = distanceBearing(c, a, ellipsoid);

  var directionABC = distBearAB.bearingAToB + distBearBC.bearingAToB + distBearCA.bearingAToB;
  var directionACB = distBearCA.bearingBToA + distBearBC.bearingBToA + distBearAB.bearingBToA;

  if (directionABC <= directionACB) {
    return [a, b, c];
  } else {
    return [a, c, b];
  }
}

Angles calculateEllipsoidTriangleAngles(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var aAngle = (distanceBearing(a, c, ellipsoid).bearingAToB -
          distanceBearing(a, b, ellipsoid).bearingAToB)
      .abs();
  var bAngle = (distanceBearing(b, c, ellipsoid).bearingAToB -
          distanceBearing(b, a, ellipsoid).bearingAToB)
      .abs();
  var cAngle = (distanceBearing(c, a, ellipsoid).bearingAToB -
          distanceBearing(c, b, ellipsoid).bearingAToB)
      .abs();
  return Angles(
    alpha: aAngle > 180 ? 360 - aAngle : aAngle,
    beta: bAngle > 180 ? 360 - bAngle : bAngle,
    gamma: cAngle > 180 ? 360 - cAngle : cAngle,
  );
}

Sides calculateEllipsoidTriangleSides(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  return Sides(
      a: distanceBearing(b, c, ellipsoid).distance,
      b: distanceBearing(a, c, ellipsoid).distance,
      c: distanceBearing(a, b, ellipsoid).distance);
}

double calculateEllipsoidTriangleCircumference(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var sides = calculateEllipsoidTriangleSides(a, b, c, ellipsoid);
  return sides.a + sides.b + sides.c;
}

double ellipsoidTriangleArea(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  return polygonArea([a, b, c], ellipsoid);
}