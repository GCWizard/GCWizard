import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

bool isValidEllipsoidTriangle(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (a.latitude.isNaN || a.longitude.isNaN
    || b.latitude.isNaN || b.longitude.isNaN
    || c.latitude.isNaN || c.longitude.isNaN
  ) {
    return false;
  }

  if (a.latitude.isInfinite || a.longitude.isInfinite
      || b.latitude.isInfinite || b.longitude.isInfinite
      || c.latitude.isInfinite || c.longitude.isInfinite
  ) {
    return false;
  }

  var _a = normalizeLatLon(a.latitude, a.longitude);
  var _b = normalizeLatLon(b.latitude, b.longitude);
  var _c = normalizeLatLon(c.latitude, c.longitude);

  if (equalsLatLng(_a, _b) || equalsLatLng(_a, _c) || equalsLatLng(_b, _c)) {
    return false;
  }

  if (
    (_a.latitude.abs() == 90 && _b.latitude.abs() == 90 && _a.latitude.sign == _b.latitude.sign)
    || (_b.latitude.abs() == 90 && _c.latitude.abs() == 90 && _b.latitude.sign == _c.latitude.sign)
    || (_c.latitude.abs() == 90 && _a.latitude.abs() == 90 && _c.latitude.sign == _a.latitude.sign)
  ) {
    return false;
  }

  var distAB = distanceBearing(_a, _b, ellipsoid).distance;
  var distAC = distanceBearing(_a, _c, ellipsoid).distance;
  var distBC = distanceBearing(_b, _c, ellipsoid).distance;

  var dists = [distAB, distAC, distBC];
  dists.sort();

  if (dists[2] >= dists[0] + dists[1]) {
    return false;
  }

  if (_ellipsoidTriangleAreaWithValidInput(_a, _b, _c, ellipsoid) < 0.001) {
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

TriangleInteriorAngles ellipsoidTriangleAngles(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(a, b, c, ellipsoid)) {
    return TriangleInteriorAngles(alpha: 0.0, beta: 0.0, gamma: 0.0);
  }

  var _a = normalizeLatLon(a.latitude, a.longitude);
  var _b = normalizeLatLon(b.latitude, b.longitude);
  var _c = normalizeLatLon(c.latitude, c.longitude);

  var aAngle = (distanceBearing(_a, _c, ellipsoid).bearingAToB - distanceBearing(_a, _b, ellipsoid).bearingAToB).abs();
  var bAngle = (distanceBearing(_b, _c, ellipsoid).bearingAToB - distanceBearing(_b, _a, ellipsoid).bearingAToB).abs();
  var cAngle = (distanceBearing(_c, _a, ellipsoid).bearingAToB - distanceBearing(_c, _b, ellipsoid).bearingAToB).abs();

  return TriangleInteriorAngles(
    alpha: aAngle > 180 ? 360 - aAngle : aAngle,
    beta: bAngle > 180 ? 360 - bAngle : bAngle,
    gamma: cAngle > 180 ? 360 - cAngle : cAngle,
  );
}

TriangleSides ellipsoidTriangleSides(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(a, b, c, ellipsoid)) {
    return TriangleSides(a: 0.0, b: 0.0, c: 0.0);
  }

  var _a = normalizeLatLon(a.latitude, a.longitude);
  var _b = normalizeLatLon(b.latitude, b.longitude);
  var _c = normalizeLatLon(c.latitude, c.longitude);

  return TriangleSides(
      a: distanceBearing(_b, _c, ellipsoid).distance,
      b: distanceBearing(_a, _c, ellipsoid).distance,
      c: distanceBearing(_a, _b, ellipsoid).distance);
}

double ellipsoidTriangleCircumference(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(a, b, c, ellipsoid)) {
    return 0.0;
  }

  var sides = ellipsoidTriangleSides(
      normalizeLatLon(a.latitude, a.longitude),
      normalizeLatLon(b.latitude, b.longitude),
      normalizeLatLon(c.latitude, c.longitude),
      ellipsoid
  );
  return sides.a + sides.b + sides.c;
}

double _ellipsoidTriangleAreaWithValidInput(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  return polygonArea([
    normalizeLatLon(a.latitude, a.longitude),
    normalizeLatLon(b.latitude, b.longitude),
    normalizeLatLon(c.latitude, c.longitude),
  ], ellipsoid).abs();
}

double ellipsoidTriangleArea(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  if (!isValidEllipsoidTriangle(a, b, c, ellipsoid)) {
    return 0.0;
  }

  return _ellipsoidTriangleAreaWithValidInput(a, b, c, ellipsoid);
}