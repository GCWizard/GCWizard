import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

part 'package:gc_wizard/tools/coords/_common/formats/geohex/logic/external_libs/chsh.geohex4j/geohex.dart';

const geoHexKey = 'coords_geohex';

final GeoHexFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.GEOHEX, geoHexKey, geoHexKey, GeoHexCoordinate.parse, GeoHexCoordinate(''));

class GeoHexCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.GEOHEX);
  String text;

  GeoHexCoordinate(this.text);

  @override
  LatLng? toLatLng() {
    return _geoHexToLatLon(this);
  }

  static GeoHexCoordinate fromLatLon(LatLng coord, [int precision = 20]) {
    return _latLonToGeoHex(coord, precision);
  }

  static GeoHexCoordinate? parse(String input) {
    return _parseGeoHex(input);
  }

  @override
  String toString([int? precision]) {
    return text;
  }
}

LatLng? _geoHexToLatLon(GeoHexCoordinate geoHex) {
  try {
    _Zone zone = _getZoneByCode(geoHex.text);
    return LatLng(zone.lat, zone.lon);
  } catch (e) {}

  return null;
}

GeoHexCoordinate? _parseGeoHex(String input) {
  input = input.trim();
  if (input == '') return null;

  var _geoHex = GeoHexCoordinate(input);
  return _geoHexToLatLon(_geoHex) == null ? null : _geoHex;
}

GeoHexCoordinate _latLonToGeoHex(LatLng coord, int precision) {
  _Zone zone = _getZoneByLocation(coord.latitude, coord.longitude, precision);
  return GeoHexCoordinate(zone.code);
}
