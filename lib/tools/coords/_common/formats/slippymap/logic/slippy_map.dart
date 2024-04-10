import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

// Source: https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames

const Map<int, CoordinateFormatKey> SLIPPY_MAP_ZOOM = {
  0: CoordinateFormatKey.SLIPPYMAP_0,
  1: CoordinateFormatKey.SLIPPYMAP_1,
  2: CoordinateFormatKey.SLIPPYMAP_2,
  3: CoordinateFormatKey.SLIPPYMAP_3,
  4: CoordinateFormatKey.SLIPPYMAP_4,
  5: CoordinateFormatKey.SLIPPYMAP_5,
  6: CoordinateFormatKey.SLIPPYMAP_6,
  7: CoordinateFormatKey.SLIPPYMAP_7,
  8: CoordinateFormatKey.SLIPPYMAP_8,
  9: CoordinateFormatKey.SLIPPYMAP_9,
  10: CoordinateFormatKey.SLIPPYMAP_10,
  11: CoordinateFormatKey.SLIPPYMAP_11,
  12: CoordinateFormatKey.SLIPPYMAP_12,
  13: CoordinateFormatKey.SLIPPYMAP_13,
  14: CoordinateFormatKey.SLIPPYMAP_14,
  15: CoordinateFormatKey.SLIPPYMAP_15,
  16: CoordinateFormatKey.SLIPPYMAP_16,
  17: CoordinateFormatKey.SLIPPYMAP_17,
  18: CoordinateFormatKey.SLIPPYMAP_18,
  19: CoordinateFormatKey.SLIPPYMAP_19,
  20: CoordinateFormatKey.SLIPPYMAP_20,
  21: CoordinateFormatKey.SLIPPYMAP_21,
  22: CoordinateFormatKey.SLIPPYMAP_22,
  23: CoordinateFormatKey.SLIPPYMAP_23,
  24: CoordinateFormatKey.SLIPPYMAP_24,
  25: CoordinateFormatKey.SLIPPYMAP_25,
  26: CoordinateFormatKey.SLIPPYMAP_26,
  27: CoordinateFormatKey.SLIPPYMAP_27,
  28: CoordinateFormatKey.SLIPPYMAP_28,
  29: CoordinateFormatKey.SLIPPYMAP_29,
  30: CoordinateFormatKey.SLIPPYMAP_30
};

const defaultSlippyMapType = CoordinateFormatKey.SLIPPYMAP_10;
const slippyMapKey = 'coords_slippymap';
final _defaultCoordinate = SlippyMapCoordinate(0, 0, defaultSlippyMapType);

final SlippyMapFormatDefinition = CoordinateFormatWithSubtypesDefinition(
  CoordinateFormatKey.SLIPPY_MAP, slippyMapKey, slippyMapKey,
  [
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_0, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_1, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_2, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_3, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_4, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_5, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_6, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_7, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_8, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_9, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_10, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_11, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_12, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_13, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_14, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_15, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_16, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_17, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_18, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_19, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_20, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_21, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_22, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_23, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_24, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_25, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_26, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_27, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_28, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_29, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
    CoordinateFormatDefinition(CoordinateFormatKey.SLIPPYMAP_30, '', '',
        SlippyMapCoordinate.parse, _defaultCoordinate),
  ],
    SlippyMapCoordinate.parse, _defaultCoordinate);

class SlippyMapCoordinate extends BaseCoordinateWithSubtypes {
  late CoordinateFormat _format;
  @override
  CoordinateFormat get format => _format;
  double x;
  double y;

  static const String _ERROR_INVALID_SUBTYPE = 'No valid SlippyMap subtype given.';

  SlippyMapCoordinate(this.x, this.y, CoordinateFormatKey subtypeKey) {
    if (subtypeKey != defaultSlippyMapType && !isSubtypeOfCoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtypeKey)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    _format = CoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtypeKey);
  }

  @override
  LatLng? toLatLng() {
    return _slippyMapToLatLon(this);
  }

  static SlippyMapCoordinate fromLatLon(LatLng coord, CoordinateFormatKey subtype) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _latLonToSlippyMap(coord, subtype);
  }

  static SlippyMapCoordinate? parse(String input, {CoordinateFormatKey subtype = defaultSlippyMapType}) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _parseSlippyMap(input, subtype: subtype);
  }

  @override
  CoordinateFormatKey get defaultSubtype => defaultSlippyMapType;

  @override
  String toString([int? precision]) {
    return 'X: $x\nY: $y\nZoom: ${switchMapKeyValue(SLIPPY_MAP_ZOOM)[_format.subtype]}';
  }
}

LatLng _slippyMapToLatLon(SlippyMapCoordinate slippyMap) {
  int subtype = switchMapKeyValue(SLIPPY_MAP_ZOOM)[slippyMap.format.subtype]!;
  var lon = slippyMap.x / pow(2.0, subtype) * 360.0 - 180.0;

  var n = pi - 2.0 * pi * slippyMap.y / pow(2.0, subtype);
  var lat = 180.0 / pi * atan(0.5 * (exp(n) - exp(-n)));

  return normalizeLatLon(lat, lon);
}

SlippyMapCoordinate _latLonToSlippyMap(LatLng coords, CoordinateFormatKey subtype) {
  if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtype)) {
    subtype = defaultSlippyMapType;
  }

  int zoom = switchMapKeyValue(SLIPPY_MAP_ZOOM)[subtype]!;

  var x = (coords.longitude + 180.0) / 360.0 * pow(2.0, zoom);
  var y = (1 - log(tan(coords.latitude * pi / 180.0) + 1.0 / cos(coords.latitude * pi / 180.0)) / pi) /
      2.0 *
      pow(2.0, zoom);

  return SlippyMapCoordinate(x, y, subtype);
}

SlippyMapCoordinate? _parseSlippyMap(String input, {CoordinateFormatKey subtype = defaultSlippyMapType}) {
  RegExp regExp = RegExp(r'^\s*([\0-9.]+)(\s*,\s*|\s+)([\0-9.]+)\s*$');
  var matches = regExp.allMatches(input);
  String? xString = '';
  String? yString = '';

  if (matches.isNotEmpty) {
    var match = matches.elementAt(0);
    xString = match.group(1);
    yString = match.group(3);
  }
  if (matches.isEmpty) {
    regExp = RegExp(r'^\s*([Xx]):?\s*([\0-9.]+)(\s*,?\s*)([Yy]):?\s*([\0-9.]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.isNotEmpty) {
      var match = matches.elementAt(0);
      xString = match.group(2);
      yString = match.group(5);
    }
  }

  if (matches.isEmpty) return null;
  if (xString == null || yString == null) {
    return null;
  }

  var x = double.tryParse(xString);
  if (x == null) return null;

  var y = double.tryParse(yString);
  if (y == null) return null;

  return SlippyMapCoordinate(x, y, subtype);
}
