import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:latlong2/latlong.dart';

LatLng intersectFourPoints(LatLng coord11, LatLng coord12, LatLng coord21, LatLng coord22, Ellipsoid ellipsoid) {
  var distBear = geodeticInverse(coord11, coord12, ellipsoid);
  var azimuth1 = distBear.azi1;

  distBear = geodeticInverse(coord21, coord22, ellipsoid);
  var azimuth2 = distBear.azi1;

  return intersectGeodesics(coord11, azimuth1, coord21, azimuth2, ellipsoid);
}