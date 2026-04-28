import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing_data.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas.dart';
import 'package:latlong2/latlong.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;

DistanceBearingData distanceBearing(LatLng coords1, LatLng coords2, Ellipsoid ellipsoid) {
  var data = geodeticInverse(coords1, coords2, ellipsoid);

  DistanceBearingData result = DistanceBearingData();
  result.distance = data.s12;
  result.bearingAToB = utils.normalizeBearing(data.azi1);
  result.bearingBToA = utils.normalizeBearing(data.azi2 + 180.0);

  return result;
}

/* A bit less accurate but faster... Used for drawing Map Polylines and the Interval arithmetics **/
DistanceBearingData distanceBearingVincenty(LatLng coords1, LatLng coords2, Ellipsoid ellipsoid) {
  return vincentyInverse(coords1, coords2, ellipsoid);
}
