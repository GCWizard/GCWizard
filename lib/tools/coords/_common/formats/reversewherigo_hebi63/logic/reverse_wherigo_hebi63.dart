import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

const reverseWherigoHebi63Key =
    'coords_reversewhereigo_hebi63'; /* typo known. DO NOT change!*/

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

const int _wLength = 6;
const int _latLonFactor = 100000;

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
  ((0 <= digit) && (digit <= 4)) ? latSign = 0 : latSign = -1;

  int latDegree10 =
          _decodeModulo10(
              int.parse(hebi63String[2]) - int.parse(hebi63String[1])) ;
  int latDegree1 = _decodeModulo10(int.parse(hebi63String[3]) - int.parse(hebi63String[2]));
  print(latDegree10.toString()+latDegree1.toString());
  latDegree = latDegree10 * 10 + latDegree1;
  print(latDegree);

  int latMinute10 = _decodeModulo10(
              int.parse(hebi63String[4]) - int.parse(hebi63String[3]));
  int latMinute1 = _decodeModulo10(int.parse(hebi63String[5]) - int.parse(hebi63String[4]));
  print(latMinute10.toString()+latMinute1.toString());
  double latMinuteDec = (latMinute10 * 10 +latMinute1).toDouble();
  print(latMinuteDec);
  int latMinute1_100 = _decodeModulo10(
                      int.parse(hebi63String[6]) - int.parse(hebi63String[5]));
  int latMinute1_10 = _decodeModulo10(
                      int.parse(hebi63String[7]) - int.parse(hebi63String[6]));
  int latMinute1_1 = _decodeModulo10(
                  int.parse(hebi63String[8]) - int.parse(hebi63String[7]));
  print(latMinute1_100.toString()+latMinute1_10.toString()+latMinute1_1.toString());
  double latMinuteFrac = (latMinute1_100 * 100 + latMinute1_10 * 10 + latMinute1_1) / 100.0;
  print(latMinuteFrac);
  latMinute = latMinuteDec + latMinuteFrac;
  print(latMinute);
  digit =
      _decodeModulo10(int.parse(hebi63String[9]) - int.parse(hebi63String[8]));
  ((0 <= digit) && (digit <= 4)) ? lonSign = -1 : lonSign = 0;

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
      _decodeModulo10(int.parse(hebi63String[14]) - int.parse(hebi63String[13]));
  print(lonMinute);
  lonMinute = lonMinute +
      (100 *
                  _decodeModulo10(int.parse(hebi63String[15]) -
                      int.parse(hebi63String[14])) +
              10 *
                  _decodeModulo10(int.parse(hebi63String[16]) -
                      int.parse(hebi63String[15])) +
              _decodeModulo10(
                  int.parse(hebi63String[17]) - int.parse(hebi63String[16]))) /
          100.0;
print('-----------------------');
print(latSign);
print(latDegree);
print(latMinute);
print(lonSign);
print(lonDegree);
print(lonMinute);
  DMMLatitude _lat = DMMLatitude(latSign, latDegree, latMinute);
  DMMLongitude _lon = DMMLongitude(lonSign, lonDegree, lonMinute);
  print(_lat.toString());
  print(_lon.toString());
  return dmmToLatLon(DMMCoordinate(_lat, _lon));
}

int _decodeModulo10(int x) {
  if (x < 0) {
    print(x+10);
    return x + 10;
  } else {
    print(x);
    return x;
  }
}

ReverseWherigoHebi63Coordinate _latLonToReverseWIGHebi63(LatLng coord) {
  var __lat = coord.latitude;
  var __lon = coord.longitude;

  String a = '';
  String b = '';
  String c = '';

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
