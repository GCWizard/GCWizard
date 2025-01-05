import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

// source: https://patentimages.storage.googleapis.com/8c/d1/46/c983120d1aea7b/DE10239432A1.pdf

const boschKey = 'coords_bosch';
const int _DEFAULT_PRECISION = 15;

final BoschFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.BOSCH, boschKey, boschKey, BoschCoordinate.parse, BoschCoordinate(''));

class BoschCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.BOSCH);
  String text;

  BoschCoordinate(this.text);

  @override
  LatLng? toLatLng() {
    return _boschToLatLon(this);
  }

  static BoschCoordinate? parse(String input) {
    return _parseBosch(input);
  }

  static BoschCoordinate fromLatLon(LatLng coord, [int precision = _DEFAULT_PRECISION]) {
    return _latLonToBosch(coord, precision: precision);
  }

  @override
  String toString([int? precision]) {
    return text;
  }
}

const _FIRST_MATRIX = [
  'ABCDEFGHI',
  'JKLMNOPQR',
  'STUVWXYZ0',
  '123456789'
];

const _ITERATIVE_MATRIX = [
  'ABCDEF',
  'GHIJKL',
  'MNOPQR',
  'STUVWX',
  'YZ0123',
  '456789'
];

BoschCoordinate _latLonToBosch(LatLng coord, {int precision = _DEFAULT_PRECISION}) {
  var lat = coord.latitude;
  var lon = coord.longitude;

  var firstY = min<int>((lon + 180) ~/ 40, 8); // min is for edge cases: exact 90° lat or 180° lon
  var firstX = min<int>((lat + 90) ~/ 45, 3);

  var out = _FIRST_MATRIX[firstX][firstY];

  var stepY = 40.0;
  var stepX = 45.0;
  var lowerBoundY = firstY * stepY - 180;
  var lowerBoundX = firstX * stepX - 90;

  for (int i = 1; i <= precision; i++) {
    stepX = stepX / 6;
    stepY = stepY / 6;

    var x = ((lat - lowerBoundX) / stepX).toInt();
    x = min<int>(x, 5);  // min is for edge cases for hitting max outer bound
    var y = ((lon - lowerBoundY) / stepY).toInt();
    y = min<int>(y, 5);

    out += _ITERATIVE_MATRIX[x][y];

    lowerBoundX = lowerBoundX + x * stepX;
    lowerBoundY = lowerBoundY + y * stepY;
  }

  return BoschCoordinate(out);
}

LatLng? _boschToLatLon(BoschCoordinate bosch) {
  var text = bosch.text.toUpperCase();
  var char = text[0];

  var firstX = _FIRST_MATRIX.indexWhere((String element) => element.contains(char));
  var firstY = _FIRST_MATRIX[firstX].indexOf(char);

  var stepY = 40.0;
  var stepX = 45.0;
  var lon = firstY * stepY - 180;
  var lat = firstX * stepX - 90;

  for (int i = 1; i < text.length; i++) {
    stepX = stepX / 6;
    stepY = stepY / 6;

    char = text[i];

    var x = _ITERATIVE_MATRIX.indexWhere((String element) => element.contains(char));
    var y = _ITERATIVE_MATRIX[x].indexOf(char);

    lat += x * stepX;
    lon += y * stepY;
  }

  return LatLng(lat, lon);
}

BoschCoordinate? _parseBosch(String input) {
  if (input.isEmpty) return null;

  if (input.length != input.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').length) return null;

  return BoschCoordinate(input);
}
