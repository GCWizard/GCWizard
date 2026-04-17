import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:latlong2/latlong.dart';

LatLng intersectBearings(LatLng coord1, double azimuth1, LatLng coord2, double azimuth2, Ellipsoid ellipsoid, {bool strict = false}) {
  // print('IB: ' + coord1.toString() + ', $azimuth1' + ' | ' + coord2.toString() + ', $azimuth2');

  return intersectGeodesics(coord1, azimuth1, coord2, azimuth2, ellipsoid, strict: strict);
}