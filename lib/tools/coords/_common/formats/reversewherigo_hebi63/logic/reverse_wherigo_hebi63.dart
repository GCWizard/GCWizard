import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

const reverseWherigoHebi63Key = 'coords_reversewhereigo_hebi63'; /* typo known. DO NOT change!*/

final ReverseWherigoHebi63FormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.REVERSE_WIG_HEBI63,
    reverseWherigoHebi63Key,
    reverseWherigoHebi63Key,
    ReverseWherigoHebi63Coordinate.parse,
    ReverseWherigoHebi63Coordinate(0, 0, 0));

class ReverseWherigoHebi63Coordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.REVERSE_WIG_HEBI63);
  int a, b, c;
  var _stateCode = StateCode.OK;

  ReverseWherigoHebi63Coordinate(this.a, this.b, this.c);

  @override
  StateCode get stateCode => _stateCode;

  @override
  LatLng? toLatLng() {
    var result = _reverseWIGHebi63ToLatLon(this);
    _stateCode = (result == null) ? StateCode.Checksum_Error : StateCode.OK;
    return result;
  }

  static ReverseWherigoHebi63Coordinate fromLatLon(LatLng coord) {
    return _latLonToReverseWIGHebi63(coord);
  }

  static ReverseWherigoHebi63Coordinate? parse(String input) {
    var result = _parseReverseWherigoHebi63(input);
    result?.toLatLng();
    return result;
  }

  String _leftPadComponent(int x) {
    return x.toString().padLeft(6, '0');
  }

  @override
  String toString([int? precision]) {
    return [a, b, c].map((e) => _leftPadComponent(e)).join('\n');
  }
}

const int _wLength = 6;
const int _latLonFactor = 100000;

LatLng? _reverseWIGHebi63ToLatLon(ReverseWherigoHebi63Coordinate hebi63) {
  var a = hebi63.a;
  var b = hebi63.b;
  var c = hebi63.c;

  double _lon = 0.0;
  double _lat = 0.0;

  return decToLatLon(DECCoordinate(_lat, _lon));
}

ReverseWherigoHebi63Coordinate _latLonToReverseWIGHebi63(LatLng coord) {
  var __lat = coord.latitude;
  var __lon = coord.longitude;

  String a = '';
  String b = '';
  String c = '';

  return ReverseWherigoHebi63Coordinate(int.parse(a), int.parse(b), int.parse(c));
}


ReverseWherigoHebi63Coordinate? _parseReverseWherigoHebi63(String input) {
  RegExp regExp = RegExp(r'^\s*(\d+)(\s*,\s*|\s+)(\d+)(\s*,\s*|\s+)(\d+)\s*$');
  var matches = regExp.allMatches(input);
  if (matches.isEmpty) return null;

  var match = matches.elementAt(0);

  if (match.group(1) == null || match.group(3) == null || match.group(5) == null) {
    return null;
  }

  var a = int.tryParse(match.group(1)!);
  var b = int.tryParse(match.group(3)!);
  var c = int.tryParse(match.group(5)!);

  if (a == null || b == null || c == null) return null;

  return ReverseWherigoHebi63Coordinate(a, b, c);
}

int _numberAtBackPosition(int number, int position) {
  return (number % pow(10, position + 1) - number % pow(10, position)) ~/ pow(10, position);
}
