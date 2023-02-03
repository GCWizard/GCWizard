import 'package:latlong2/latlong.dart';

bool equalsLatLng(LatLng a, LatLng b) {
  final TOLERANCE = 1e-5;

  if ((a.latitude.abs() - 90.0) <= TOLERANCE &&
      (b.latitude.abs() - 90.0) <= TOLERANCE &&
      a.latitude.sign == b.latitude.sign) return true;

  if ((a.latitude - b.latitude).abs() <= TOLERANCE) {
    if ((a.longitude - b.longitude).abs() <= TOLERANCE) return true;

    if ((a.longitude.abs() - 180.0) <= TOLERANCE && (b.longitude.abs() - 180.0) <= TOLERANCE) return true;
  }

  return false;
}