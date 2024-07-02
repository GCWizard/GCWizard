import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

part 'package:gc_wizard/tools/coords/_common/formats/makaney/logic/external_libs/net.makaney/makaney.dart';

const makaneyKey = 'coords_makaney';

final MakaneyFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.MAKANEY, makaneyKey, makaneyKey, MakaneyCoordinate.parse, MakaneyCoordinate(''));

class MakaneyCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.MAKANEY);
  String text;

  MakaneyCoordinate(this.text);

  @override
  LatLng? toLatLng() {
    return __makaneyToLatLon(this);
  }

  static MakaneyCoordinate fromLatLon(LatLng coord) {
    return __latLonToMakaney(coord);
  }

  static MakaneyCoordinate? parse(String input) {
    return _parseMakaney(input);
  }

  @override
  String toString([int? precision]) {
    return text;
  }
}

LatLng? __makaneyToLatLon(MakaneyCoordinate makaney) {
  if (makaney.text.isEmpty) return null;

  var _text = makaney.text.toLowerCase();

  var regexCheck = RegExp(r'^-?[a-z\d]{1,4}([+\-])[a-z\d]{1,5}$');
  if (!regexCheck.hasMatch(_text)) {
    return null;
  }

  var latLon = _makaneyToLatLon(_text);
  if (latLon.contains(null)) return null;

  try {
    return LatLng(latLon[0], latLon[1]);
  } catch (e) {
    return null;
  }
}

MakaneyCoordinate __latLonToMakaney(LatLng latLon) {
  return MakaneyCoordinate(_latLonToMakaney(latLon.latitude, latLon.longitude).toUpperCase());
}

MakaneyCoordinate? _parseMakaney(String input) {
  var makaney = MakaneyCoordinate(input);
  return __makaneyToLatLon(makaney) == null ? null : makaney;
}
