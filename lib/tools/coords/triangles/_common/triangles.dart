import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

bool isValidTriangle(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (equalsLatLng(a, b) || equalsLatLng(a, c) || equalsLatLng(b, c)) {
    return false;
  }

  if (
    (a.latitude.abs() == 90 && b.latitude.abs() == 90)
    || (b.latitude.abs() == 90 && c.latitude.abs() == 90)
    || (c.latitude.abs() == 90 && a.latitude.abs() == 90)
  ) {
    return false;
  }

  var distAB = distanceBearing(a, b, ellipsoid).distance;
  var distAC = distanceBearing(a, c, ellipsoid).distance;
  var distBC = distanceBearing(b, c, ellipsoid).distance;

  var dists = [distAB, distAC, distBC];
  dists.sort();

  if (dists[2] >= dists[0] + dists[1]) {
    return false;
  }

  if (ellipsoidTriangleArea(a, b, c, ellipsoid) < 0.001) {
    return false;
  }

  return true;
}

bool _isClockwiseOrderedPolygon(List<LatLng> coords, Ellipsoid ellipsoid) {
  var area = polygonArea(coords, ellipsoid);
  return area < 0;
}

List<LatLng> orderEllipsoidTrianglePointsClockwise(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (_isClockwiseOrderedPolygon([a, b, c], ellipsoid)) {
    return [a, b, c];
  } else {
    return [a, c, b];
  }
}

TriangleInteriorAngles calculateEllipsoidTriangleAngles(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var aAngle = (distanceBearing(a, c, ellipsoid).bearingAToB - distanceBearing(a, b, ellipsoid).bearingAToB).abs();
  var bAngle = (distanceBearing(b, c, ellipsoid).bearingAToB - distanceBearing(b, a, ellipsoid).bearingAToB).abs();
  var cAngle = (distanceBearing(c, a, ellipsoid).bearingAToB - distanceBearing(c, b, ellipsoid).bearingAToB).abs();

  return TriangleInteriorAngles(
    alpha: aAngle > 180 ? 360 - aAngle : aAngle,
    beta: bAngle > 180 ? 360 - bAngle : bAngle,
    gamma: cAngle > 180 ? 360 - cAngle : cAngle,
  );
}

TriangleSides calculateEllipsoidTriangleSides(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  return TriangleSides(
      a: distanceBearing(b, c, ellipsoid).distance,
      b: distanceBearing(a, c, ellipsoid).distance,
      c: distanceBearing(a, b, ellipsoid).distance);
}

double calculateEllipsoidTriangleCircumference(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var sides = calculateEllipsoidTriangleSides(a, b, c, ellipsoid);
  return sides.a + sides.b + sides.c;
}

double ellipsoidTriangleArea(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  return polygonArea([a, b, c], ellipsoid).abs();
}