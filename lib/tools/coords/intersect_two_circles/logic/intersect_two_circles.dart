import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> intersectTwoCircles(LatLng coord1, double radius1, LatLng coord2, double radius2, Ellipsoid ellipsoid) {
  return arcArcIntercept(coord1, radius1, coord2, radius2, ellipsoid);
}