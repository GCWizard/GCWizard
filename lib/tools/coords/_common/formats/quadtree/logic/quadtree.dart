import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

var _TILESIZE = 256;
const int _DEFAULT_PRECISION = 40;
const quadtreeKey = 'coords_quadtree';

final QuadtreeFormatDefinition = CoordinateFormatDefinition(
  CoordinateFormatKey.QUADTREE, quadtreeKey, quadtreeKey,
  QuadtreeCoordinate.parse, QuadtreeCoordinate([]));

class QuadtreeCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.QUADTREE);
  List<int> coords;

  QuadtreeCoordinate(this.coords);

  @override
  LatLng toLatLng() {
    return _quadtreeToLatLon(this);
  }

  static QuadtreeCoordinate? parse(String input) {
    return _parseQuadtree(input);
  }

  static QuadtreeCoordinate fromLatLon(LatLng coord, [int precision = 40]) {
    return _latLonToQuadtree(coord, precision: precision);
  }

  @override
  String toString([int? precision]) {
    return coords.join();
  }
}

QuadtreeCoordinate _latLonToQuadtree(LatLng coord, {int precision = _DEFAULT_PRECISION}) {
  var x = (_TILESIZE / 2.0) + coord.longitude * (_TILESIZE / 360.0);

  var siny = sin(degreesToRadian(coord.latitude));
  var y = (_TILESIZE / 2.0) + 0.5 * log((1.0 + siny) / (1.0 - siny)) * -(_TILESIZE / (2.0 * pi));

  //Original code: 1 << precision (must be changed due to web version issues)
  var countTiles = int.parse('1' + '0' * precision, radix: 2);

  var tileX = (x * countTiles / _TILESIZE).floor();
  var tileY = (y * countTiles / _TILESIZE).floor();

  var out = <int>[];
  for (int i = 0; i < precision; i++) {
    var quadrant = 2 * (tileY % 2) + tileX % 2;
    out.add(quadrant);

    tileX = (tileX / 2).floor();
    tileY = (tileY / 2).floor();
  }

  return QuadtreeCoordinate(out.reversed.toList());
}

LatLng _quadtreeToLatLon(QuadtreeCoordinate quadtree) {
  var tileX = 0;
  var tileY = 0;

  for (var i = 0; i < quadtree.coords.length; i++) {
    tileX = 2 * tileX + quadtree.coords[i] % 2;
    tileY = 2 * tileY + (quadtree.coords[i] / 2.0).floor();
  }

  //Original code: 1 << quadtree.coords.length (must be changed due to web version issues)
  var countTiles = int.parse('1' + '0' * quadtree.coords.length, radix: 2);

  var x = (tileX) * _TILESIZE / countTiles;
  var y = (tileY) * _TILESIZE / countTiles;

  var lon = (x - _TILESIZE / 2.0) / (_TILESIZE / 360.0);

  var latRadians = (y - _TILESIZE / 2.0) / -(_TILESIZE / (2.0 * pi));
  var lat = radianToDegrees(2 * atan(exp(latRadians)) - pi / 2);
  return LatLng(lat, lon);
}

QuadtreeCoordinate? _parseQuadtree(String input) {
  if (input.isEmpty) return null;

  if (input.length != input.replaceAll(RegExp(r'[^0123]'), '').length) return null;

  return QuadtreeCoordinate(input.split('').map((character) => int.parse(character)).toList());
}
