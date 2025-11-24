import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

const reverseWherigoHebi63Key =
    'coords_reversewherigo_hebi63';

final ReverseWherigoHebi63FormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.REVERSE_WIG_HEBI63,
    reverseWherigoHebi63Key,
    reverseWherigoHebi63Key,
    ReverseWherigoHebi63Coordinate.parse,
    ReverseWherigoHebi63Coordinate(0, 0, 0));

class ReverseWherigoHebi63Coordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format =>
      CoordinateFormat(CoordinateFormatKey.REVERSE_WIG_HEBI63);
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

LatLng? _reverseWIGHebi63ToLatLon(ReverseWherigoHebi63Coordinate hebi63) {
  var a = hebi63.a;
  var b = hebi63.b;
  var c = hebi63.c;

  String hebi63String = a.toString().padLeft(6, '0') +
      b.toString().padLeft(6, '0') +
      c.toString().padLeft(6, '0');

  int latSign = 0;
  int latDegree = 0;
  double latMinute = 0.0;

  int lonSign = 0;
  int lonDegree = 0;
  double lonMinute = 0.0;

  int digit = 0;

  digit =
      _decodeModulo10(int.parse(hebi63String[1]) - int.parse(hebi63String[0]));
  ((0 <= digit) && (digit <= 4)) ? latSign = 1 : latSign = -1;

  int latDegree10 =
      _decodeModulo10(int.parse(hebi63String[2]) - int.parse(hebi63String[1]));
  int latDegree1 =
      _decodeModulo10(int.parse(hebi63String[3]) - int.parse(hebi63String[2]));
  latDegree = latDegree10 * 10 + latDegree1;

  latMinute = (_decodeModulo10(
                      int.parse(hebi63String[4]) - int.parse(hebi63String[3])) *
                  10 +
              _decodeModulo10(
                  int.parse(hebi63String[5]) - int.parse(hebi63String[4])))
          .toDouble() +
      (_decodeModulo10(
                      int.parse(hebi63String[6]) - int.parse(hebi63String[5])) *
                  100 +
              _decodeModulo10(
                      int.parse(hebi63String[7]) - int.parse(hebi63String[6])) *
                  10 +
              _decodeModulo10(
                  int.parse(hebi63String[8]) - int.parse(hebi63String[7]))) /
          1000.0;

  digit =
      _decodeModulo10(int.parse(hebi63String[9]) - int.parse(hebi63String[8]));
  ((0 <= digit) && (digit <= 4)) ? lonSign = -1 : lonSign = 1;

  digit =
      _decodeModulo10(int.parse(hebi63String[10]) - int.parse(hebi63String[9]));
  ((0 <= digit) && (digit <= 4)) ? lonDegree = 0 : lonSign = 100;
  lonDegree = lonDegree +
      10 *
          _decodeModulo10(
              int.parse(hebi63String[11]) - int.parse(hebi63String[10])) +
      _decodeModulo10(
          int.parse(hebi63String[12]) - int.parse(hebi63String[11]));

  lonMinute = 10.0 *
          _decodeModulo10(
              int.parse(hebi63String[13]) - int.parse(hebi63String[12])) +
      _decodeModulo10(
          int.parse(hebi63String[14]) - int.parse(hebi63String[13]));

  lonMinute = lonMinute +
      (100 *
                  _decodeModulo10(int.parse(hebi63String[15]) -
                      int.parse(hebi63String[14])) +
              10 *
                  _decodeModulo10(int.parse(hebi63String[16]) -
                      int.parse(hebi63String[15])) +
              _decodeModulo10(
                  int.parse(hebi63String[17]) - int.parse(hebi63String[16]))) /
          1000.0;

  return DMMCoordinate(DMMLatitude(latSign, latDegree, latMinute),
          DMMLongitude(lonSign, lonDegree, lonMinute))
      .toLatLng();
  //return dmmToLatLon(DMMCoordinate(_lat, _lon));
}

int _decodeModulo10(int x) {
  if (x < 0) {
    return x + 10;
  } else {
    return x;
  }
}

ReverseWherigoHebi63Coordinate _latLonToReverseWIGHebi63(LatLng coord) {
  String a = '';
  String b = '';
  String c = '';

  String hebi63 = '';

  var rndInt = Random();

  String dmmCoordString = rndInt.nextInt(10).toString() + DMMCoordinate.fromLatLon(coord)
      .toString(3)
      .replaceAll('.', '')
      .replaceAll('°', '')
      .replaceAll("'", '')
      .replaceAll('\n', '')
      .replaceAll(' ', '')
      .replaceAll('N', rndInt.nextInt(5).toString())
      .replaceAll('S', (5 + rndInt.nextInt(5)).toString())
      .replaceAll('W', rndInt.nextInt(5).toString())
      .replaceAll('E', (5 + rndInt.nextInt(5)).toString());

  if (dmmCoordString[10] == '0') {
    dmmCoordString = dmmCoordString.substring(0,10) + rndInt.nextInt(5).toString() + dmmCoordString.substring(11);
  } else {
    dmmCoordString = dmmCoordString.substring(0,10) + (5 + rndInt.nextInt(5)).toString() + dmmCoordString.substring(11);
  }

  hebi63 = dmmCoordString[0];
  for (int i = 1; i <= 17; i++) {
    hebi63 = hebi63 + ((int.parse(hebi63[i - 1]) + int.parse(dmmCoordString[i])) % 10).toString();
  }

  a = hebi63.substring(0, 6);
  b = hebi63.substring(6, 12);
  c = hebi63.substring(12);

  return ReverseWherigoHebi63Coordinate(
      int.parse(a), int.parse(b), int.parse(c));
}

ReverseWherigoHebi63Coordinate? _parseReverseWherigoHebi63(String input) {
  RegExp regExp = RegExp(r'^\s*(\d+)(\s*,\s*|\s+)(\d+)(\s*,\s*|\s+)(\d+)\s*$');
  var matches = regExp.allMatches(input);
  if (matches.isEmpty) return null;

  var match = matches.elementAt(0);

  if (match.group(1) == null ||
      match.group(3) == null ||
      match.group(5) == null) {
    return null;
  }

  var a = int.tryParse(match.group(1)!);
  var b = int.tryParse(match.group(3)!);
  var c = int.tryParse(match.group(5)!);

  if (a == null || b == null || c == null) return null;

  return ReverseWherigoHebi63Coordinate(a, b, c);
}
