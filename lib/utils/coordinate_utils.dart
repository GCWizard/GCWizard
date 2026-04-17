import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/antipodes/logic/antipodes.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

bool equalsLatLng(LatLng a, LatLng b, {double tolerance = 1e-10}) {
  var _a = normalizeLatLon(a.latitude, a.longitude);
  var _b = normalizeLatLon(b.latitude, b.longitude);

  if (doubleEquals(_a.latitude.abs(), 90.0, tolerance: tolerance) &&
      doubleEquals(_b.latitude.abs(), 90.0, tolerance: tolerance) &&
      _a.latitude.sign == _b.latitude.sign) {
    return true;
  }

  if (doubleEquals(_a.latitude, _b.latitude, tolerance: tolerance)) {

    if (doubleEquals(_a.longitude.abs(), 180.0, tolerance: tolerance)
        && doubleEquals(_b.longitude.abs(), tolerance: tolerance, 180.0)) {
      return true;
    }

    if (doubleEquals(_a.longitude, _b.longitude, tolerance: tolerance)) return true;
  }

  return false;
}

bool equalsLatLngList(List<LatLng> a, List<LatLng> b, {double tolerance = 1e-10}) {
  if (a.length != b.length) {
    return false;
  }

  for(var i = 0; i < a.length; i++) {
    if (equalsLatLng(a[i], b[i], tolerance: tolerance)) {
      continue;
    } else {
      return false;
    }
  }

  return true;
}

double normalizeBearing(double bearing) {
  return modulo360(bearing).toDouble();
}

// Normalizing Lat without keeping an eye on Lon is problematic, that's why there's no single "normalizeLat"
// E.g. Lat 92 means: The Lat value turns 2 degrees more then 90, which is in fact 88. But on the other side of the
// northern hemisphere. So in fact, it changes the Lon value by 180 degrees: (92, 10) == (88, -170)

LatLng normalizeLatLon(double lat, double lon) {
  var normalizedLat = lat;
  var normalizedLon = lon;

  while (normalizedLat > 90.0 || normalizedLat < -90) {
    if (normalizedLat > 90.0) {
      normalizedLat = 180.0 - normalizedLat;
    } else {
      normalizedLat = -180.0 + -normalizedLat;
    }

    normalizedLon += 180.0;
  }

  normalizedLon = normalizeLon(normalizedLon);

  return LatLng(normalizedLat, normalizedLon);
}

double normalizeLon(double lon) {
  lon = modulo360(lon).toDouble();

  if (lon > 180) {
    return lon - 360;
  }

  return lon;
}

bool equalsBearing(double a, double b, {double tolerance = 1e-10}) {
  a = normalizeBearing(a);
  b = normalizeBearing(b);

  if (doubleEquals(a, b, tolerance: tolerance)) {
    return true;
  }

  if (360.0 - a <= tolerance && b <= tolerance) {
    return 360.0 - a + b <= tolerance;
  }

  if (360.0 - b <= tolerance && a <= tolerance) {
    return 360.0 - b + a <= tolerance;
  }

  return false;
}

// Calculates Angle (-360 <= angle <= 360) between two bearings.
// If bearingB >= bearingA -> Angle is Clockwise, Result is >= 0
// If bearingA > bearingB -> Angle is Counterclockwise, Result is < 0
double normalizedAngleBetweenBearings(double bearingA, double bearingB) {
  var angle = bearingB - bearingA;

  while (angle > 360) {
    angle -= 360;
  }

  while (angle < -360) {
    angle += 360;
  }

  return angle;
}

bool isOnGeodesic(LatLng point, LatLng start, LatLng end, Ellipsoid ellipsoid) {
  var _point = normalizeLatLon(point.latitude, point.longitude);
  var _start = normalizeLatLon(start.latitude, start.longitude);
  var _end = normalizeLatLon(end.latitude, end.longitude);

  var projected = orthogonalProjectionTwoPoints(_point, _start, _end, ellipsoid);
  var distance = distanceBearing(projected, _point, ellipsoid).distance;

  return distance < 1e-8;
}

bool isOnSegment(LatLng point, LatLng start, LatLng end, Ellipsoid ellipsoid) {
  var isOnGeod = isOnGeodesic(point, start, end, ellipsoid);
  if (!isOnGeod) {
    return false;
  }

  var _point = normalizeLatLon(point.latitude, point.longitude);
  var _start = normalizeLatLon(start.latitude, start.longitude);
  var _end = normalizeLatLon(end.latitude, end.longitude);

  var distStartP = distanceBearing(_start, _point, ellipsoid).distance;
  var distPEnd = distanceBearing(_point, _end, ellipsoid).distance;
  var distStartEnd = distanceBearing(_start, _end, ellipsoid).distance;

  return ((distStartP + distPEnd) - distStartEnd).abs() < 1e-8;
}

bool isAntipode(LatLng point, LatLng pointToCheck) {
  var compare = antipodes(point);
  return equalsLatLng(compare, pointToCheck);
}

bool isNearPole(LatLng coord, {double tolerance = 1e-2}) {
  var isNorth = equalsLatLng(coord, LatLng(90.0, 0), tolerance: tolerance);
  var isSouth = equalsLatLng(coord, LatLng(-90.0, 0), tolerance: tolerance);

  return isNorth || isSouth;
}