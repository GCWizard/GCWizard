import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:latlong2/latlong.dart';

LatLng orthogonalProjectionBearing(LatLng coord, LatLng start, double azimuth, Ellipsoid ellipsoid) {
  return perpendicularIntercept(coord, start, azimuth, ellipsoid);
}

LatLng orthogonalProjectionTwoPoints(LatLng coord, LatLng a, LatLng b, Ellipsoid ellipsoid) {
  var bearing = distanceBearing(a, b, ellipsoid).bearingAToB;
  return orthogonalProjectionBearing(coord, a, bearing, ellipsoid);
}