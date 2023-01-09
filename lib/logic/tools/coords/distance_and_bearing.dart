import 'package:gc_wizard/logic/tools/coords/data/distance_bearing.dart';
import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:gc_wizard/logic/tools/coords/external_libs/net.sf.geographiclib/geodesic.dart';
import 'package:gc_wizard/logic/tools/coords/external_libs/net.sf.geographiclib/geodesic_data.dart';
import 'package:gc_wizard/logic/tools/coords/vincenty/distance_bearing_vincenty.dart';
import 'package:latlong2/latlong.dart';

DistanceBearingData distanceBearing(LatLng coords1, LatLng coords2, Ellipsoid ellipsoid) {
  GeodesicData data = Geodesic(ellipsoid.a, ellipsoid.f)
      .inverse(coords1.latitude, coords1.longitude, coords2.latitude, coords2.longitude);

  DistanceBearingData result = DistanceBearingData();
  result.distance = data.s12;
  result.bearingAToB = normalizeBearing(data.azi1);
  result.bearingBToA = normalizeBearing(data.azi2 + 180.0);

  return result;
}

/* A bit less accurate... Used for Map Polylines and Interval arithmetics **/
DistanceBearingData distanceBearingVincenty(LatLng coords1, LatLng coords2, Ellipsoid ellipsoid) {
  return vincentyInverse(coords1, coords2, ellipsoid);
}
