import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

part 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas/geoformulas.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas/vincenty_destination.dart';
part 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas/vincenty_distance.dart';

DistanceBearingData vincentyInverse(LatLng coords1, LatLng coords2, Ellipsoid ellipsoid) {
  _InverseResult result = _distVincenty(_LLPoint.fromLatLng(coords1), _LLPoint.fromLatLng(coords2), ellipsoid);
  var distBear = DistanceBearingData();
  distBear.bearingAToBInRadian = result.azimuth;
  distBear.bearingBToAInRadian = result.reverseAzimuth;
  distBear.distance = result.distance;
  return distBear;
}

LatLng vincentyDirect(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  _LLPoint result = _destVincenty(_LLPoint.fromLatLng(coord), degToRadian(bearing), distance, ellipsoid);
  return result.toLatLng();
}