import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> intersectGeodeticAndCircle(
    LatLng startGeodetic, double bearingGeodetic, LatLng centerPoint, double radiusCircle, Ellipsoid ells) {
  bearingGeodetic = normalizeBearing(bearingGeodetic);
  List<LatLng> output = geodesicArcIntercept(startGeodetic, bearingGeodetic, centerPoint, radiusCircle, ells);

  return output;
}