import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

const mercatorKey = 'coords_mercator';

final MercatorFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.MERCATOR, mercatorKey, mercatorKey, MercatorCoordinate.parse, MercatorCoordinate(0, 0));

class MercatorCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.MERCATOR);
  double easting;
  double northing;

  MercatorCoordinate(this.easting, this.northing);

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return _mercatorToLatLon(this, ells);
  }

  static MercatorCoordinate fromLatLon(LatLng coord, Ellipsoid ells) {
    return _latLonToMercator(coord, ells);
  }

  static MercatorCoordinate? parse(String input) {
    return _parseMercator(input);
  }

  @override
  String toString([int? precision]) {
    return 'Y: $easting\nX: $northing';
  }
}

LatLng _mercatorToLatLon(MercatorCoordinate mercator, Ellipsoid ells) {
  var y = mercator.easting;
  var x = mercator.northing;

  var lat = 180 / pi * (2 * atan(exp(((y / (2 * pi * ells.a / 2.0)) * 180.0) * pi / 180.0)) - pi / 2.0);
  var lon = (x / (2 * pi * ells.a / 2.0)) * 180.0;

  return LatLng(lat, lon);
}

MercatorCoordinate _latLonToMercator(LatLng coord, Ellipsoid ells) {
  var x = coord.longitude * (2 * pi * ells.a / 2.0) / 180.0;
  var y = (log(tan((90 + coord.latitude) * pi / 360.0)) / (pi / 180.0)) * (2 * pi * ells.a / 2.0) / 180.0;

  return MercatorCoordinate(y, x);
}

MercatorCoordinate? _parseMercator(String input) {
  RegExp regExp = RegExp(r'^\s*([\-\d.]+)(\s*,\s*|\s+)([\-\d.]+)\s*$');
  var matches = regExp.allMatches(input);

  String? _eastingString = '';
  String? _northingString = '';

  if (matches.isNotEmpty) {
    var match = matches.elementAt(0);
    _eastingString = match.group(1);
    _northingString = match.group(3);
  }
  if (matches.isEmpty) {
    regExp = RegExp(r'^\s*(Y|y)\:?\s*([\-\d\.]+)(\s*\,?\s*)(X|x)\:?\s*([\-\d\.]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.isNotEmpty) {
      var match = matches.elementAt(0);
      _eastingString = match.group(2);
      _northingString = match.group(5);
    }
  }

  if (matches.isEmpty) return null;
  if (_eastingString == null || _northingString == null) {
    return null;
  }

  var _easting = double.tryParse(_eastingString);
  if (_easting == null) return null;

  var _northing = double.tryParse(_northingString);
  if (_northing == null) return null;

  return MercatorCoordinate(_easting, _northing);
}
