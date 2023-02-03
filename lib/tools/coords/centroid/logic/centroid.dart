import 'dart:math';

import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

// https://web.archive.org/web/20221205184246/https://carto.com/blog/center-of-points/
LatLng centroid(List<LatLng> coords) {
  if (coords == null || coords.isEmpty) return null;

  if (coords.length == 1) return coords.first;

  var centroidLat = coords.map((coord) => coord.latitude).reduce((a, b) => a + b) / coords.length;

  var lonZetaSum = 0.0;
  var lonXiSum = 0.0;
  for (LatLng coord in coords) {
    lonZetaSum += sin(coord.longitudeInRad);
    lonXiSum += cos(coord.longitudeInRad);
  }
  lonZetaSum = lonZetaSum / coords.length;
  lonXiSum = lonXiSum / coords.length;
  var centroidLon = 180.0 * atan2(lonZetaSum, lonXiSum) / pi;

  return LatLng(centroidLat, centroidLon);
}

// http://www.geomidpoint.com/calculation.html

LatLng centroidCenterOfGravity(List<LatLng> coords) {
  if (coords == null || coords.isEmpty) return null;

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

LatLng centroidArithmeticMean(List<LatLng> coords, LatLng centerOfGravity) {
  if (coords == null || coords.isEmpty) return null;

  if (coords.length == 1) return coords.first;

  var x = 0.0;
  var y = 0.0;
  for (LatLng coord in coords) {
    var lon;
    if (coord.longitude + centerOfGravity.longitude < -180.0)
      lon = coord.longitude + 360.0;
    else if (coord.longitude + centerOfGravity.longitude > 180.0)
      lon = coord.longitude - 360.0;
    else
      lon = coord.longitude;

    x += coord.latitude;
    y += lon;
  }

  return LatLng(x / coords.length, y / coords.length);
}
