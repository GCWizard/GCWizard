import 'package:latlong2/latlong.dart';

// http://www.geomidpoint.com/calculation.html

LatLng? centroidArithmeticMean(List<LatLng> coords, LatLng centerOfGravity) {
  if (coords.isEmpty) return null;

  if (coords.length == 1) return coords.first;

  var x = 0.0;
  var y = 0.0;
  for (LatLng coord in coords) {
    double lon;
    if (coord.longitude + centerOfGravity.longitude < -180.0) {
      lon = coord.longitude + 360.0;
    } else if (coord.longitude + centerOfGravity.longitude > 180.0) {
      lon = coord.longitude - 360.0;
    } else {
      lon = coord.longitude;
    }

    x += coord.latitude;
    y += lon;
  }

  return LatLng(x / coords.length, y / coords.length);
}
