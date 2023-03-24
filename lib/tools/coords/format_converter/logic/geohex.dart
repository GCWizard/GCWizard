import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

part 'package:gc_wizard/tools/coords/format_converter/logic/external_libs/chsh.geohex4j/geohex.dart';

LatLng? geoHexToLatLon(GeoHex geoHex) {
  try {
    _Zone zone = _getZoneByCode(geoHex.text);
    return LatLng(zone.lat, zone.lon);
  } catch (e) {}

  return null;
}

GeoHex? parseGeoHex(String input) {
  input = input.trim();
  if (input == '') return null;

  var _geoHex = GeoHex(input);
  return geoHexToLatLon(_geoHex) == null ? null : _geoHex;
}

GeoHex latLonToGeoHex(LatLng coord, int precision) {
  _Zone zone = _getZoneByLocation(coord.latitude, coord.longitude, precision);
  return GeoHex(zone.code);
}
