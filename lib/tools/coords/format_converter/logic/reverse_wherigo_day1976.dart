import 'package:gc_wizard/tools/coords/format_converter/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

String _valueToLetter(int value) {
  // function _SRrF6()
  switch (value.toInt()) {
    case 0:
      return "0";
    case 1:
      return "1";
    case 2:
      return "2";
    case 3:
      return "3";
    case 4:
      return "4";
    case 5:
      return "5";
    case 6:
      return "6";
    case 7:
      return "7";
    case 8:
      return "8";
    case 9:
      return "9";
    case 10:
      return "a";
    case 11:
      return "b";
    case 12:
      return "c";
    case 13:
      return "d";
    case 14:
      return "e";
    case 15:
      return "f";
    case 16:
      return "g";
    case 17:
      return "h";
    case 18:
      return "i";
    case 19:
      return "j";
    case 20:
      return "k";
    case 21:
      return "l";
    case 22:
      return "m";
    case 23:
      return "n";
    case 24:
      return "o";
    case 25:
      return "p";
    case 26:
      return "q";
    case 27:
      return "r";
    case 28:
      return "s";
    case 29:
      return "t";
    case 30:
      return "u";
    case 31:
      return "v";
    case 32:
      return "w";
    case 33:
      return "x";
    case 34:
      return "y";
    case 35:
      return "z";
    default:
      return "";
  }
}

int _letterToValue(String letter) {
  // function _0YvH()
  switch (letter) {
    case "0":
      return 0;
    case "1":
      return 1;
    case "2":
      return 2;
    case "3":
      return 3;
    case "4":
      return 4;
    case "5":
      return 5;
    case "6":
      return 6;
    case "7":
      return 7;
    case "8":
      return 8;
    case "9":
      return 9;
    case "a":
      return 10;
    case "b":
      return 11;
    case "c":
      return 12;
    case "d":
      return 13;
    case "e":
      return 14;
    case "f":
      return 15;
    case "g":
      return 16;
    case "h":
      return 17;
    case "i":
      return 18;
    case "j":
      return 19;
    case "k":
      return 20;
    case "l":
      return 21;
    case "m":
      return 22;
    case "n":
      return 23;
    case "o":
      return 24;
    case "p":
      return 25;
    case "q":
      return 26;
    case "r":
      return 27;
    case "s":
      return 28;
    case "t":
      return 29;
    case "u":
      return 30;
    case "v":
      return 31;
    case "w":
      return 32;
    case "x":
      return 33;
    case "y":
      return 34;
    case "z":
      return 35;
    default:
      return 0;
  }
}

LatLng reverseWIGDay1976ToLatLon(ReverseWherigoDay1976 day1976) {
  // function _YvIY7()

  String a = day1976.s[0];
  String b = day1976.s[1];
  String c = day1976.s[2];
  String d = day1976.s[3];
  String e = day1976.s[4];

  String _vZmW2 = day1976.t[0];
  String _2kSJl = day1976.t[1];
  String _5mF = day1976.t[2];
  String _tFCg = day1976.t[3];
  String _vRGT = day1976.t[4];

  int _IIW = _letterToValue(c);
  int _KsA = _letterToValue(e);
  int _QrbCA = _letterToValue(_vZmW2);
  int _Avr3k = _letterToValue(_2kSJl);
  int _rai = _letterToValue(_vRGT);

  int _cTzKn = _letterToValue(a);
  int _dJuU = _letterToValue(b);
  int _9Ve7 = _letterToValue(d);
  int _QWQ = _letterToValue(_5mF);
  int _ErSZ = _letterToValue(_tFCg);

  double lat = (_IIW * 1679616 + _KsA * 46656 + _QrbCA * 1296 + _Avr3k * 36 + _rai).toDouble();
  double long = (_cTzKn * 1679616 + _dJuU * 46656 + _9Ve7 * 1296 + _QWQ * 36 + _ErSZ).toDouble();

  lat = lat / 100000;
  long = long / 100000;

  lat = lat - 90;
  long = long - 180;

  return decToLatLon(DEC(lat, long));
}

ReverseWherigoDay1976 latLonToReverseWIGDay1976(LatLng coord) {
  // function _6u3VL()

  int lat = ((coord.latitude + 90) * 100000).floor();
  int long = ((coord.longitude + 180) * 100000).floor();

  int _IIW = (lat / 1679616).truncate();
  lat = lat % 1679616;
  int _KsA = (lat / 46656).truncate();
  lat = lat % 46656;
  int _QrbCA = (lat / 1296).truncate();
  lat = lat % 1296;
  int _Avr3k = (lat / 36).truncate();
  //int _rai = lat % 36;
  int _rai = _Avr3k;

  int _cTzKn = (long / 1679616).truncate();
  long = long % 1679616;
  int _dJuU = (long / 46656).truncate();
  long = long % 46656;
  int _9Ve7 = (long / 1296).truncate();
  long = long % 1296;
  int _QWQ = (long / 36).truncate();
  //int _ErSZ = long % 36;
  int _ErSZ = _QWQ;

  String c = _valueToLetter(_IIW);
  String e = _valueToLetter(_KsA);
  String _vZmW2 = _valueToLetter(_QrbCA);
  String _2kSJl = _valueToLetter(_Avr3k);
  String _vRGT = _valueToLetter(_rai);
  String a = _valueToLetter(_cTzKn);
  String b = _valueToLetter(_dJuU);
  String d = _valueToLetter(_9Ve7);
  String _5mF = _valueToLetter(_QWQ);
  String _tFCg = _valueToLetter(_ErSZ);

  return ReverseWherigoDay1976(a + b + c + d + e, _vZmW2 + _2kSJl + _5mF + _tFCg + _vRGT);
}

ReverseWherigoDay1976? parseReverseWherigoDay1976(String input) {
  input = input.toLowerCase();
  RegExp regExp = RegExp(r'^\s*([\da-z]+)(\s*,\s*|\s+)([\da-z]+)\s*$');
  var matches = regExp.allMatches(input);
  if (matches.isEmpty) return null;

  var match = matches.elementAt(0);

  var a = match.group(1);
  var b = match.group(3);

  if (a == null || b == null || a.length < 5 || b.length < 5) return null;

  return ReverseWherigoDay1976(a, b);
}
