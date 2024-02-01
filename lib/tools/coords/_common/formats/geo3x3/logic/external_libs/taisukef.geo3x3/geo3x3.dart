// written by taisukef https://github.com/taisukef/Geo3x3/blob/master/Geo3x3.dart
// CC0-1.0 License

part of 'package:gc_wizard/tools/coords/_common/formats/geo3x3/logic/geo3x3.dart';

class _Geo3x3 {
  static String encode(num lat, num lng, num level) {
    if (level < 1) {
      return '';
    }
    var res = '';
    var lng2 = lng;
    if (lng >= 0) {
      res = "E";
    } else {
      res = "W";
      lng2 += 180;
    }
    var lat2 = lat + 90.0;
    var unit = 180.0;
    for (int i = 1; i < level; i++) {
      unit /= 3;
      final x = lng2 ~/ unit;
      final y = lat2 ~/ unit;
      res += (x + y * 3 + 1).toString();
      lng2 -= x * unit;
      lat2 -= y * unit;
    }
    return res;
  }

  static List<double>? decode(String code) {
    var unit = 180.0;
    var lat = 0.0;
    var lng = 0.0;
    var level = 1;

    var begin = 0;
    var flg = false;
    var c = code[0];
    if (c == '-' || c == 'W') {
      flg = true;
      begin = 1;
    } else if (c == '+' || c == 'E') {
      begin = 1;
    } else {
      return null;
    }
    final clen = code.length;
    for (int i = begin; i < clen; i++) {
      var n = "0123456789".indexOf(code[i]);
      if (n <= 0) return null;
      unit /= 3;
      n--;
      lng += n % 3 * unit;
      lat += n ~/ 3 * unit;
      level++;
    }
    lat += unit / 2;
    lng += unit / 2;
    lat -= 90.0;
    if (flg) lng -= 180.0;
    return [lat, lng, level.toDouble(), unit];
  }
}
