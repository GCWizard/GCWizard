import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';
import 'package:latlong2/latlong.dart';

bool _isNearPole(double lat) {
  return lat.abs() > 90 - 1e-5;
}

DistanceBearingData distanceBearing(LatLng coords1, LatLng coords2, Ellipsoid ellipsoid) {
  RhumbInverseReturn data = Rhumb(ellipsoid.a, ellipsoid.f)
      .inverse(coords1.latitude, coords1.longitude, coords2.latitude, coords2.longitude);

  var distance = data.s12;
  var bearing = data.azi12;

  if (distance == 0.0 || (_isNearPole(coords1.latitude) && _isNearPole(coords2.latitude))) {
    if (bearing.isNaN) {
      bearing = 0.0;
    }
  }

  DistanceBearingData result = DistanceBearingData();
  result.distance = distance;
  result.bearingAToB = normalizeBearing(bearing);
  result.bearingBToA = normalizeBearing(bearing + 180.0);

  return result;
}

LatLng projection(LatLng coord, double bearingDeg, double distance, Ellipsoid ellipsoid) {
  if (distance == 0.0) return coord;

  bearingDeg = normalizeBearing(bearingDeg);

  RhumbDirectReturn projected = Rhumb(ellipsoid.a, ellipsoid.f).direct(coord.latitude, coord.longitude, bearingDeg, distance);

  var lat = projected.lat2;
  var lon = projected.lon2;
  if (_isNearPole(lat) && lon.isNaN) {
    lon = 0.0;
  }

  return LatLng(lat, lon);
}

List<LatLng> reverseProjection(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  return <LatLng>[projection(coord, normalizeBearing(bearing + 180.0), distance, ellipsoid)];
}