import 'dart:math';

import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

// http://www.geomidpoint.com/calculation.html

LatLng? centroidCenterOfGravity(List<LatLng> coords) {
  if (coords.isEmpty) return null;

  if (coords.length == 1) return coords.first;

  var x = 0.0;
  var y = 0.0;
  var z = 0.0;
  for (LatLng coord in coords) {
    x += cos(coord.latitudeInRad) * cos(coord.longitudeInRad);
    y += cos(coord.latitudeInRad) * sin(coord.longitudeInRad);
    z += sin(coord.latitudeInRad);
  }

  var lon = atan2(y, x);
  var lat = atan2(z, sqrt(x * x + y * y));

  return LatLng(radianToDegrees(lat), radianToDegrees(lon));
}
