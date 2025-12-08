import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

const reverseWherigoHebi63Key = 'coords_reversewherigo_hebi63';

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

  String latlonString = '';
  for (int i = 1; i <= 17; i++) {
    latlonString = latlonString +
        _decodeModulo10(
                int.parse(hebi63String[i]) - int.parse(hebi63String[i - 1]))
            .toString();
  }

  int digit = 0;

  digit = int.parse(latlonString[0]);
  int latSign = ((0 <= digit) && (digit <= 4)) ? 1 : -1;

  int latDegree = int.parse(latlonString.substring(1, 3));
  double latMinute = double.parse(latlonString.substring(3, 8)) / 1000.0;

  digit = int.parse(latlonString[8]);
  int lonSign = ((0 <= digit) && (digit <= 4)) ? -1 : 1;

  digit = int.parse(latlonString[9]);
  int lonDegree = ((0 <= digit) && (digit <= 4)) ? 0 : 100;

  lonDegree = lonDegree + int.parse(latlonString.substring(10, 12));

  double lonMinute = double.parse(latlonString.substring(12)) / 1000.0;

  return DMMCoordinate(DMMLatitude(latSign, latDegree, latMinute),
          DMMLongitude(lonSign, lonDegree, lonMinute))
      .toLatLng();
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

  var rndInt = Random(0);

  String dmmCoordString = rndInt.nextInt(10).toString() +
      DMMCoordinate.fromLatLon(coord)
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
    dmmCoordString = dmmCoordString.substring(0, 10) +
        rndInt.nextInt(5).toString() +
        dmmCoordString.substring(11);
  } else {
    dmmCoordString = dmmCoordString.substring(0, 10) +
        (5 + rndInt.nextInt(5)).toString() +
        dmmCoordString.substring(11);
  }

  hebi63 = dmmCoordString[0];
  for (int i = 1; i <= 17; i++) {
    hebi63 = hebi63 +
        ((int.parse(hebi63[i - 1]) + int.parse(dmmCoordString[i])) % 10)
            .toString();
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
