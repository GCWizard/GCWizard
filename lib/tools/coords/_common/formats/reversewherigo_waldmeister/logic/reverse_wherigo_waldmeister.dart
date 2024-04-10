import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'dart:math';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:latlong2/latlong.dart';

const reverseWhereigoWaldmeisterKey = 'coords_reversewhereigo_waldmeister'; /* typo known. DO NOT change!*/

final ReverseWherigoWaldmeisterFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.REVERSE_WIG_WALDMEISTER, reverseWhereigoWaldmeisterKey, reverseWhereigoWaldmeisterKey,
    ReverseWherigoWaldmeisterCoordinate.parse, ReverseWherigoWaldmeisterCoordinate(0, 0, 0));


class ReverseWherigoWaldmeisterCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.REVERSE_WIG_WALDMEISTER);
  int a, b, c;

  ReverseWherigoWaldmeisterCoordinate(this.a, this.b, this.c);

  @override
  LatLng? toLatLng() {
    return _reverseWIGWaldmeisterToLatLon(this);
  }

  static ReverseWherigoWaldmeisterCoordinate fromLatLon(LatLng coord) {
    return _latLonToReverseWIGWaldmeister(coord);
  }

  static ReverseWherigoWaldmeisterCoordinate? parse(String input) {
    return _parseReverseWherigoWaldmeister(input);
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

LatLng? _reverseWIGWaldmeisterToLatLon(ReverseWherigoWaldmeisterCoordinate waldmeister) {
  var a = waldmeister.a;
  var b = waldmeister.b;
  var c = waldmeister.c;

  if (!_checkSumTest(waldmeister)) return null;

  int _latSign = 1;
  int _lonSign = 1;
  double _lon, _lat;
  var _a2 = _numberAtBackPosition(a, 2);

  if (_a2 == 1) {
    _latSign = 1;
    _lonSign = 1;
  } else if (_a2 == 2) {
    _latSign = -1;
    _lonSign = 1;
  } else if (_a2 == 3) {
    _latSign = 1;
    _lonSign = -1;
  } else if (_a2 == 4) {
    _latSign = -1;
    _lonSign = -1;
  }

  if (__variante1(c)) {
    // a3 b5 . b2 c4 a1 c5 a6
    _lat = (_latSign * (
        _numberAtBackPosition(a, _wLength - 3) * 10 +
            _numberAtBackPosition(b, _wLength - 5) * 1 +
            _numberAtBackPosition(b, _wLength - 2) * 0.1 +
            _numberAtBackPosition(c, _wLength - 4) * 0.01 +
            _numberAtBackPosition(a, _wLength - 1) * 0.001 +
            _numberAtBackPosition(c, _wLength - 5) * 1.0E-4 +
            _numberAtBackPosition(a, _wLength - 6) * 1.0E-5));
    // a2 c1 c6 . b4 b1 a5 c2 b6
    _lon = (_lonSign * (
        _numberAtBackPosition(a, _wLength - 2) * 100 +
            _numberAtBackPosition(c, _wLength - 1) * 10 +
            _numberAtBackPosition(c, _wLength - 6) * 1 +
            _numberAtBackPosition(b, _wLength - 4) * 0.1 +
            _numberAtBackPosition(b, _wLength - 1) * 0.01 +
            _numberAtBackPosition(a, _wLength - 5) * 0.001 +
            _numberAtBackPosition(c, _wLength - 2) * 1.0E-4 +
            _numberAtBackPosition(b, _wLength - 6) * 1.0E-5));
  } else {
    // b1 a6 . a3 c1 c4 c5 a1
    _lat = (_latSign * (
        _numberAtBackPosition(b, _wLength - 1) * 10 +
            _numberAtBackPosition(a, _wLength - 6) * 1 +
            _numberAtBackPosition(a, _wLength - 3) * 0.1 +
            _numberAtBackPosition(c, _wLength - 1) * 0.01 +
            _numberAtBackPosition(c, _wLength - 4) * 0.001 +
            _numberAtBackPosition(c, _wLength - 5) * 1.0E-4 +
            _numberAtBackPosition(a, _wLength - 1) * 1.0E-5));
    // b5 c6 a5 . a2 b4 b6 c2 b2
    _lon = (_lonSign * (
        _numberAtBackPosition(b, _wLength - 5) * 100 +
            _numberAtBackPosition(c, _wLength - 6) * 10 +
            _numberAtBackPosition(a, _wLength - 5) * 1 +
            _numberAtBackPosition(a, _wLength - 2) * 0.1 +
            _numberAtBackPosition(b, _wLength - 4) * 0.01 +
            _numberAtBackPosition(b, _wLength - 6) * 0.001 +
            _numberAtBackPosition(c, _wLength - 2) * 1.0E-4 +
            _numberAtBackPosition(b, _wLength - 2) * 1.0E-5));
  }

  return decToLatLon(DECCoordinate(_lat, _lon));
}

ReverseWherigoWaldmeisterCoordinate _latLonToReverseWIGWaldmeister(LatLng coord) {
  var __lat = coord.latitude;
  var __lon = coord.longitude;

  double _a4 = 0;
  String a, b, c;

  if (__lat < 0 && __lon < 0) {
    _a4 = 4;
    __lat *= -1;
    __lon *= -1;
  } else if (__lat < 0 && __lon > 0) {
    _a4 = 2;
    __lat *= -1;
  } else if (__lat > 0 && __lon < 0) {
    _a4 = 3;
    __lon *= -1;
  } else if (__lat >= 0 && __lon >= 0) {
    _a4 = 1;
  }

  __lon += 1.0E-12;
  __lat += 1.0E-12;
  int _lat = (__lat * _latLonFactor - __lat * _latLonFactor % 1).toInt();
  int _lon = (__lon * _latLonFactor - __lon * _latLonFactor % 1).toInt();

  var _b3 = _b3CheckSum(_lat, _lon, _a4);
  var _c3 = _c3CheckSum(_lat, _lon);

  if (_variante1(_lat, _lon)) {
    a = _numberAtBackPosition(_lat, 2).toString() +
        _numberAtBackPosition(_lon, 7).toString() +
        _numberAtBackPosition(_lat, 6).toString() +
        _a4.toInt().toString() +
        _numberAtBackPosition(_lon, 2).toString() +
        _numberAtBackPosition(_lat, 0).toString();
    b = _numberAtBackPosition(_lon, 3).toString() +
        _numberAtBackPosition(_lat, 4).toString() +
        _b3.toInt().toString() +
        _numberAtBackPosition(_lon, 4).toString() +
        _numberAtBackPosition(_lat, 5).toString() +
        _numberAtBackPosition(_lon, 0).toString();
    c = _numberAtBackPosition(_lon, 6).toString() +
        _numberAtBackPosition(_lon, 1).toString() +
        _c3.toInt().toString() +
        _numberAtBackPosition(_lat, 3).toString() +
        _numberAtBackPosition(_lat, 1).toString() +
        _numberAtBackPosition(_lon, 5).toString();
  } else {
    a = _numberAtBackPosition(_lat, 0).toString() +
        _numberAtBackPosition(_lon, 4).toString() +
        _numberAtBackPosition(_lat, 4).toString() +
        _a4.toInt().toString() +
        _numberAtBackPosition(_lon, 5).toString() +
        _numberAtBackPosition(_lat, 5).toString();
    b = _numberAtBackPosition(_lat, 6).toString() +
        _numberAtBackPosition(_lon, 0).toString() +
        _b3.toInt().toString() +
        _numberAtBackPosition(_lon, 3).toString() +
        _numberAtBackPosition(_lon, 7).toString() +
        _numberAtBackPosition(_lon, 2).toString();
    c = _numberAtBackPosition(_lat, 3).toString() +
        _numberAtBackPosition(_lon, 1).toString() +
        _c3.toInt().toString() +
        _numberAtBackPosition(_lat, 2).toString() +
        _numberAtBackPosition(_lat, 1).toString() +
        _numberAtBackPosition(_lon, 6).toString();
  }

  return ReverseWherigoWaldmeisterCoordinate(int.parse(a), int.parse(b), int.parse(c));
}

bool _variante1(int lat, int lon) {
  return (((_numberAtBackPosition(lon, 1) + _numberAtBackPosition(lat, 1)) % 2) == 0);
}

bool __variante1(int c) {
  return (_numberAtBackPosition(c, _wLength - 2) + _numberAtBackPosition(c, _wLength - 5)) % 2 == 0;
}

double _b3CheckSum(int _lat, int _lon, double _a4) {
  double _tempb3 = 0;

  if (_variante1(_lat, _lon)) {
    //b3 = 11 – ((2*a4 + 4*n1 + 7*n3 + 8*n5 + 5*n7 + 6*e1 + 9*e5 + 3*e6) mod 11)
    _tempb3 = (11 - (
        _a4 * 2 +
        _numberAtBackPosition(_lat, 6) * 4 +
        _numberAtBackPosition(_lat, 4) * 7 +
        _numberAtBackPosition(_lat, 2) * 8 +
        _numberAtBackPosition(_lat, 0) * 5 +
        _numberAtBackPosition(_lon, 7) * 6 +
        _numberAtBackPosition(_lon, 3) * 9 +
        _numberAtBackPosition(_lon, 2) * 3) % 11);
  } else {
    //b3 = 11 – ((2*a4 + 9*n1 + 5*n2 + 4*n3 + 8*n7 + 3*e3 + 6*e4 + 7*e8) mod 11)
    _tempb3 = (11 - (
        _a4 * 2 +
        _numberAtBackPosition(_lat, 6) * 9 +
        _numberAtBackPosition(_lat, 5) * 5 +
        _numberAtBackPosition(_lat, 4) * 4 +
        _numberAtBackPosition(_lat, 0) * 8 +
        _numberAtBackPosition(_lon, 5) * 3 +
        _numberAtBackPosition(_lon, 4) * 6 +
        _numberAtBackPosition(_lon, 0) * 7) % 11);
  }
  return _transformCheckSum(_tempb3);
}

double __b3CheckSum(ReverseWherigoWaldmeisterCoordinate waldmeister) {
  var a = waldmeister.a;
  var b = waldmeister.b;
  var c = waldmeister.c;
  double _tempb3 = 0;

  if (__variante1(c)) {
    //b3 = 11 – ((2*a4 + 4*n1 + 7*n3 + 8*n5 + 5*n7 + 6*e1 + 9*e5 + 3*e6) mod 11)
    _tempb3 = (11 - (
        _numberAtBackPosition(a, _wLength - 4) * 2 +
        _numberAtBackPosition(a, _wLength - 3) * 4 +
        _numberAtBackPosition(b, _wLength - 2) * 7 +
        _numberAtBackPosition(a, _wLength - 1) * 8 +
        _numberAtBackPosition(a, _wLength - 6) * 5 +
        _numberAtBackPosition(a, _wLength - 2) * 6 +
        _numberAtBackPosition(b, _wLength - 1) * 9 +
        _numberAtBackPosition(a, _wLength - 5) * 3) % 11);
  } else {
    //b3 = 11 – ((2*a4 + 9*n1 + 5*n2 + 4*n3 + 8*n7 + 3*e3 + 6*e4 + 7*e8) mod 11)
    _tempb3 = (11 - (
        _numberAtBackPosition(a, _wLength - 4) * 2 +
        _numberAtBackPosition(b, _wLength - 1) * 9 +
        _numberAtBackPosition(a, _wLength - 6) * 5 +
        _numberAtBackPosition(a, _wLength - 3) * 4 +
        _numberAtBackPosition(a, _wLength - 1) * 8 +
        _numberAtBackPosition(a, _wLength - 5) * 3 +
        _numberAtBackPosition(a, _wLength - 2) * 6 +
        _numberAtBackPosition(b, _wLength - 2) * 7) % 11);
  }
  return _transformCheckSum(_tempb3);
}

double _c3CheckSum(int _lat, int _lon) {
  double _tempc3 = 0;

  if (_variante1(_lat, _lon)) {
    //c3 = 11 – ((6*n2 + 5*n4 + 9*n6 + 2*e2 + 7*e3 + 8*e4 + 3*e7 + 4*e8) mod 11)
    _tempc3 = (11 - (
        _numberAtBackPosition(_lat, 5) * 6 +
        _numberAtBackPosition(_lat, 3) * 5 +
        _numberAtBackPosition(_lat, 1) * 9 +
        _numberAtBackPosition(_lon, 6) * 2 +
        _numberAtBackPosition(_lon, 5) * 7 +
        _numberAtBackPosition(_lon, 4) * 8 +
        _numberAtBackPosition(_lon, 1) * 3 +
        _numberAtBackPosition(_lon, 0) * 4) % 11);
  } else {
    //c3 = 11 – ((2*n4 + 5*n5 + 9*n6 + 6*e1 + 7*e2 + 8*e5 + 4*e6 + 3*e7) mod 11)
    _tempc3 = (11 - (
        _numberAtBackPosition(_lat, 3) * 2 +
        _numberAtBackPosition(_lat, 2) * 5 +
        _numberAtBackPosition(_lat, 1) * 9 +
        _numberAtBackPosition(_lon, 7) * 6 +
        _numberAtBackPosition(_lon, 6) * 7 +
        _numberAtBackPosition(_lon, 3) * 8 +
        _numberAtBackPosition(_lon, 2) * 4 +
        _numberAtBackPosition(_lon, 1) * 3) % 11);
  }
  return _transformCheckSum(_tempc3);
}

double __c3CheckSum(ReverseWherigoWaldmeisterCoordinate waldmeister) {
  var b = waldmeister.b;
  var c = waldmeister.c;
  double _tempc3 = 0;

  if (__variante1(c)) {
    //c3 = 11 – ((6*n2 + 5*n4 + 9*n6 + 2*e2 + 7*e3 + 8*e4 + 3*e7 + 4*e8) mod 11)
    _tempc3 = (11 - (
        _numberAtBackPosition(b, _wLength - 5) * 6 +
        _numberAtBackPosition(c, _wLength - 4) * 5 +
        _numberAtBackPosition(c, _wLength - 5) * 9 +
        _numberAtBackPosition(c, _wLength - 1) * 2 +
        _numberAtBackPosition(c, _wLength - 6) * 7 +
        _numberAtBackPosition(b, _wLength - 4) * 8 +
        _numberAtBackPosition(c, _wLength - 2) * 3 +
        _numberAtBackPosition(b, _wLength - 6) * 4) % 11);
  } else {
    //c3 = 11 – ((2*n4 + 5*n5 + 9*n6 + 6*e1 + 7*e2 + 8*e5 + 4*e6 + 3*e7) mod 11)
    _tempc3 = (11 - (
        _numberAtBackPosition(c, _wLength - 1) * 2 +
        _numberAtBackPosition(c, _wLength - 4) * 5 +
        _numberAtBackPosition(c, _wLength - 5) * 9 +
        _numberAtBackPosition(b, _wLength - 5) * 6 +
        _numberAtBackPosition(c, _wLength - 6) * 7 +
        _numberAtBackPosition(b, _wLength - 4) * 8 +
        _numberAtBackPosition(b, _wLength - 6) * 4 +
        _numberAtBackPosition(c, _wLength - 2) * 3) % 11);
  }
  return _transformCheckSum(_tempc3);
}

double _transformCheckSum(double value) {
  if (value == 10) {
    return 0;
  } else if (value == 11) {
    return 5;
  } else {
    return value;
  }
}

ReverseWherigoWaldmeisterCoordinate? _parseReverseWherigoWaldmeister(String input) {
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

  var waldmeister = ReverseWherigoWaldmeisterCoordinate(a, b, c);

  if (!_checkSumTest(waldmeister)) return null;
  return waldmeister;
}

bool _checkSumTest(ReverseWherigoWaldmeisterCoordinate waldmeister) {
  var b3Calc = __b3CheckSum(waldmeister).toInt();
  var c3Calc = __c3CheckSum(waldmeister).toInt();

  var b3Ref = _numberAtBackPosition(waldmeister.b, _wLength - 3);
  var c3Ref = _numberAtBackPosition(waldmeister.c, _wLength - 3);

  return b3Calc == b3Ref && c3Calc == c3Ref;
}

int _numberAtBackPosition(int number, int position) {
  return (number % pow(10, position + 1) - number % pow(10, position)) ~/ pow(10, position);
}
