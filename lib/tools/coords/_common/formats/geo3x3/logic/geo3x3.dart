import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

part 'package:gc_wizard/tools/coords/_common/formats/geo3x3/logic/external_libs/taisukef.geo3x3/geo3x3.dart';

const geo3x3Key = 'coords_geo3x3';

final Geo3x3FormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.GEO3X3, geo3x3Key, geo3x3Key, Geo3x3Coordinate.parse, Geo3x3Coordinate(''));

class Geo3x3Coordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.GEO3X3);
  String text;

  Geo3x3Coordinate(this.text);

  @override
  LatLng? toLatLng() {
    return _geo3x3ToLatLon(this);
  }

  static Geo3x3Coordinate fromLatLon(LatLng coord, [int level = 20]) {
    return _latLonToGeo3x3(coord, level);
  }

  static Geo3x3Coordinate? parse(String input) {
    return _parseGeo3x3(input);
  }

  @override
  String toString([int? precision]) {
    return text.toUpperCase();
  }
}

LatLng? _geo3x3ToLatLon(Geo3x3Coordinate geo3x3) {
  if (geo3x3.text.isEmpty) return null;
  var latLon = _Geo3x3.decode(geo3x3.text.toUpperCase());
  return latLon == null ? null : LatLng(latLon[0], latLon[1]);
}

Geo3x3Coordinate? _parseGeo3x3(String input) {
  input = input.trim();
  if (input.isEmpty) return null;

  input = input.toUpperCase();
  if (RegExp(r'[EeWw][1-9]+').hasMatch(input)) {
    var geo3x3 = Geo3x3Coordinate(input);
    var latLon = _geo3x3ToLatLon(geo3x3);
    return latLon == null ? null : geo3x3;
  }

  return null;
}

Geo3x3Coordinate _latLonToGeo3x3(LatLng coord, int level) {
  return Geo3x3Coordinate(_Geo3x3.encode(coord.latitude, coord.longitude, level));
}
