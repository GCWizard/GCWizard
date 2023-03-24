import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

bool equalsLatLng(LatLng a, LatLng b, {double tolerance = 1e-10}) {
  if ((a.latitude - b.latitude).abs() <= tolerance) {
    if ((a.longitude - b.longitude).abs() <= tolerance) return true;

    if ((180.0 - a.longitude.abs()) <= tolerance && (180.0 - b.longitude.abs()) <= tolerance) return true;
  }

  return false;
}

double normalizeBearing(double bearing) {
  return modulo360(bearing).toDouble();
}