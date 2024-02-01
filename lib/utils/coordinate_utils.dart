import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

bool equalsLatLng(LatLng a, LatLng b, {double tolerance = 1e-10}) {
  if (doubleEquals(a.latitude.abs(), 90.0) &&
      doubleEquals(b.latitude.abs(), 90.0) &&
      a.latitude.sign == b.latitude.sign) {
    return true;
  }

  if ((a.latitude - b.latitude).abs() <= tolerance) {
    if (doubleEquals(a.longitude.abs(), 180.0) && doubleEquals(b.longitude.abs(), 180.0)) return true;

    if ((a.longitude - b.longitude).abs() <= tolerance) return true;

    if ((180.0 - a.longitude.abs()) <= tolerance && (180.0 - b.longitude.abs()) <= tolerance) return true;
  }

  return false;
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
