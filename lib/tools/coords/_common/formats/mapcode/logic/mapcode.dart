import 'package:gc_wizard/tools/coords/_common/formats/mapcode/logic/external_libs/mapcode.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

const Map<int, CoordinateFormatKey> MAPCODE_CODE = {
  0: CoordinateFormatKey.MAPCODE_LOCAL,
  1: CoordinateFormatKey.MAPCODE_INTERNATIONAL,
};

const int _DEFAULT_PRECISION = 0;
const defaultMapCodeType = CoordinateFormatKey.MAPCODE_LOCAL;
const mapCodeKey = 'coords_mapcode';
final _defaultCoordinate = MapCode.parse('HHHHC.X0KG')!; // MapCode.fromLatLon(LatLng(0, 0), defaultMapCodeType);

final MapCodeFormatDefinition = CoordinateFormatWithSubtypesDefinition(
    CoordinateFormatKey.MAPCODE,
    mapCodeKey,
    mapCodeKey,
    [
      CoordinateFormatDefinition(CoordinateFormatKey.MAPCODE_LOCAL, 'coords_mapcode_local', 'coords_mapcode_local',
          MapCode.parse, _defaultCoordinate),
      CoordinateFormatDefinition(CoordinateFormatKey.MAPCODE_INTERNATIONAL, 'coords_mapcode_international',
          'coords_mapcode_international', MapCode.parse, _defaultCoordinate),
    ],
    MapCode.parse,
    _defaultCoordinate);

class MapCode extends BaseCoordinateWithSubtypes {
  late CoordinateFormat _format;
  @override
  CoordinateFormat get format => _format;

  List<McInfo> coords;

  static const String _ERROR_INVALID_SUBTYPE = 'No valid MapCode subtype given.';

  MapCode(this.coords, CoordinateFormatKey subtypeKey) {
    if (subtypeKey != defaultMapCodeType && !isSubtypeOfCoordinateFormat(CoordinateFormatKey.MAPCODE, subtypeKey)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    _format = CoordinateFormat(CoordinateFormatKey.MAPCODE, subtypeKey);
  }

  @override
  LatLng? toLatLng() {
    if (coords.isEmpty || coords.first.fullmapcode.isEmpty) return null;
    return _MapCodeToLatLon(this);
  }

  static MapCode fromLatLon(LatLng coord, CoordinateFormatKey subtype, [int precision = _DEFAULT_PRECISION]) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.MAPCODE, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return _latLonToMapCode(coord, subtype: subtype, precision: precision);
  }

  static MapCode? parse(String input, {String territory = ''}) {
    return _parseMapCode(input, territory: territory);
  }

  @override
  CoordinateFormatKey get defaultSubtype => defaultMapCodeType;

  @override
  String toString([int? precision]) {
    return coords.isEmpty ? '' : coords.first.fullmapcode;
  }
}

MapCode _latLonToMapCode(LatLng coord, {required CoordinateFormatKey subtype, int precision = _DEFAULT_PRECISION}) {
  if (subtype == CoordinateFormatKey.MAPCODE_INTERNATIONAL) {
    return MapCode(encodeInternationalWithPrecision(coord.latitude, coord.longitude, precision), subtype);
  } else {
    return MapCode(encodeWithPrecision(coord.latitude, coord.longitude, precision, ''), subtype);
  }
}

LatLng? _MapCodeToLatLon(MapCode mapcode) {
  if (mapcode.coords.isEmpty) return null;
  return decode(mapcode.coords.first.fullmapcode, mapcode.coords.first.territoryAlphaCode);
}

MapCode? _parseMapCode(String input, {String territory = ''}) {
  input = input.toUpperCase();
  territory = territory.toUpperCase();
  var match = RegExp(_regexString()).firstMatch(input);
  if (match == null) return null;

  var mapCode = match.group(0).toString();
  if (territory.trim().isEmpty) {
    territory = (match.group(1) == null || match.group(1)!.isEmpty) ? '' : match.group(1).toString();
  }

  if (match.group(1) != null) {
    mapCode = mapCode.replaceFirst(match.group(1)!, '');
  }

  var latLon = decode(mapCode, territory);
  if (latLon == null) {
    return null;
  } else {
    var coords = <McInfo>[];
    var mcInfo = McInfo();
    mcInfo.mapcode = mapCode.trim();
    mcInfo.territoryAlphaCode = territory.trim();
    mcInfo.fullmapcode = (mcInfo.territoryAlphaCode.isNotEmpty ? mcInfo.territoryAlphaCode + ' ' : '') + mapCode;
    coords.add(mcInfo);

    return MapCode(coords, defaultMapCodeType);
  }
}

String _regexString() {
  // https://github.com/sindresorhus/mapcode-regex/blob/main/index.js
  var rx = "(?:(11|12|13|14|15|21|22|23|31|32|33|34|35|36|37|41|42|43|44|45|46|50|51|52|53|54|61|62|63|64|65|71|91|92";
  for (var element in iso3166alpha) {
    rx += "|" + element;
  }
  const letter = r"[ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjklmnpqrstuvwxyz\d]";

  rx += r")\s*)?" + letter + r"{2,}\." + letter + r"{2,}(-\d{1,8})?";
  return rx;
}
