import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';
import 'package:latlong2/latlong.dart';

LatLng orthogonalProjection(LatLng coord, LatLng start, double azimuth, Ellipsoid ellipsoid) {
  return perpendicularIntercept(coord, start, azimuth, ellipsoid);
}