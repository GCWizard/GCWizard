/*
 * Ported from:
 * GeoHex V3 for Java implemented by @chshii is licensed under MIT license. (https://github.com/chsh/geohex4j)
 *
 * which is a port from
 * GeoHex by @sa2da (http://geogames.net) is licensed under MIT license. (http://www.geohex.org/)
 */

part of 'package:gc_wizard/tools/coords/format_converter/logic/geohex.dart';

final String _VERSION = "3.2.2";
final String _h_key = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
final double _h_base = 20037508.34;
final double _h_deg = pi * (30.0 / 180.0);
final double _h_k = tan(_h_deg);

final RegExp _INC15 = RegExp(r'[15]');
final RegExp _EXC125 = RegExp(r'[^125]');

class _Zone {
  final double lat;
  final double lon;
  final int x;
  final int y;
  final String code;
  int _level;

  _Zone(this.lat, this.lon, this.x, this.y, this.code) {
    this._level = this.getLevel();
  }

  int getLevel() {
    return this.code.length - 2;
  }

  double getHexSize() {
    return _calcHexSize(this.getLevel());
  }

  List<_Loc> getHexCoords() {
    double h_lat = this.lat;
    double h_lon = this.lon;
    _XY h_xy = _loc2xy(h_lon, h_lat);
    double h_x = h_xy.x;
    double h_y = h_xy.y;
    double h_deg = tan(pi * (60.0 / 180.0));
    double h_size = this.getHexSize();
    double h_top = _xy2loc(h_x, h_y + h_deg * h_size).lat;
    double h_btm = _xy2loc(h_x, h_y - h_deg * h_size).lat;

    double h_l = _xy2loc(h_x - 2 * h_size, h_y).lon;
    double h_r = _xy2loc(h_x + 2 * h_size, h_y).lon;
    double h_cl = _xy2loc(h_x - 1 * h_size, h_y).lon;
    double h_cr = _xy2loc(h_x + 1 * h_size, h_y).lon;
    return <_Loc>[
      _Loc(h_lat, h_l),
      _Loc(h_top, h_cl),
      _Loc(h_top, h_cr),
      _Loc(h_lat, h_r),
      _Loc(h_btm, h_cr),
      _Loc(h_btm, h_cl)
    ];
  }
}

_Zone _getZoneByLocation(double lat, double lon, int level) {
  if (lat < -90 || lat > 90) throw Exception("latitude must be between -90 and 90");
  if (lon < -180 || lon > 180) throw Exception("intitude must be between -180 and 180");
  if (level < 0 || level > 35) throw Exception("level must be between 0 and 35");

  _XY xy = _getXYByLocation(lat, lon, level);
  return _getZoneByXY(xy.x, xy.y, level);
}

_Zone _getZoneByCode(String code) {
  _XY xy = _getXYByCode(code);
  int level = code.length - 2;
  _Zone zone = _getZoneByXY(xy.x, xy.y, level);
  return zone;
}

_XY _getXYByLocation(double lat, double lon, int level) {
  double h_size = _calcHexSize(level);
  _XY z_xy = _loc2xy(lon, lat);
  double lon_grid = z_xy.x;
  double lat_grid = z_xy.y;
  double unit_x = 6 * h_size;
  double unit_y = 6 * h_size * _h_k;
  double h_pos_x = (lon_grid + lat_grid / _h_k) / unit_x;
  double h_pos_y = (lat_grid - _h_k * lon_grid) / unit_y;
  int h_x_0 = (h_pos_x).floor();
  int h_y_0 = (h_pos_y).floor();
  double h_x_q = h_pos_x - h_x_0;
  double h_y_q = h_pos_y - h_y_0;
  int h_x = (h_pos_x).round();
  int h_y = (h_pos_y).round();

  if (h_y_q > -h_x_q + 1) {
    if ((h_y_q < 2 * h_x_q) && (h_y_q > 0.5 * h_x_q)) {
      h_x = h_x_0 + 1;
      h_y = h_y_0 + 1;
    }
  } else if (h_y_q < -h_x_q + 1) {
    if ((h_y_q > (2 * h_x_q) - 1) && (h_y_q < (0.5 * h_x_q) + 0.5)) {
      h_x = h_x_0;
      h_y = h_y_0;
    }
  }

  _XY inner_xy = _adjustXY(h_x, h_y, level);
  return inner_xy;
}

_XY _getXYByCode(String code) {
  int level = code.length - 2;
  int h_x = 0;
  int h_y = 0;

  String h_dec9 = (_h_key.indexOf(code[0]) * 30 + _h_key.indexOf(code[1])).toString() + code.substring(2);
  if (_regMatch(h_dec9[0], _INC15) && _regMatch(h_dec9[1], _EXC125) && _regMatch(h_dec9[2], _EXC125)) {
    if (h_dec9[0] == '5') {
      h_dec9 = "7" + h_dec9.substring(1, h_dec9.length);
    } else if (h_dec9[0] == '1') {
      h_dec9 = "3" + h_dec9.substring(1, h_dec9.length);
    }
  }

  int d9xlen = h_dec9.length;
  for (int i = 0; i < level + 3 - d9xlen; i++) {
    h_dec9 = '0' + h_dec9;
    d9xlen++;
  }

  String h_dec3 = '';
  for (int i = 0; i < d9xlen; i++) {
    int dec9i = int.tryParse(h_dec9[i]);
    String h_dec0 = dec9i.toRadixString(3);
    if (h_dec0.length == 1) {
      h_dec3 += '0';
    }
    h_dec3 += h_dec0;
  }

  List<String> h_decx = [];
  List<String> h_decy = [];

  for (int i = 0; i < h_dec3.length / 2; i++) {
    h_decx.add(h_dec3[i * 2]);
    h_decy.add(h_dec3[i * 2 + 1]);
  }

  for (int i = 0; i <= level + 2; i++) {
    int h_pow = pow(3, level + 2 - i);
    if (h_decx[i] == '0') {
      h_x -= h_pow;
    } else if (h_decx[i] == '2') {
      h_x += h_pow;
    }
    if (h_decy[i] == '0') {
      h_y -= h_pow;
    } else if (h_decy[i] == '2') {
      h_y += h_pow;
    }
  }

  _XY inner_xy = _adjustXY(h_x, h_y, level);
  return inner_xy;
}

_Zone _getZoneByXY(double x, double y, int level) {
  double h_size = _calcHexSize(level);
  int h_x = x.round();
  int h_y = y.round();
  double unit_x = 6 * h_size;
  double unit_y = 6 * h_size * _h_k;
  double h_lat = (_h_k * h_x * unit_x + h_y * unit_y) / 2;
  double h_lon = (h_lat - h_y * unit_y) / _h_k;
  _Loc z_loc = _xy2loc(h_lon, h_lat);
  double z_loc_x = z_loc.lon;
  double z_loc_y = z_loc.lat;
  int max_hsteps = pow(3, level + 2);
  int hsteps = (h_x - h_y).abs();

  if (hsteps == max_hsteps) {
    if (h_x > h_y) {
      int tmp = h_x;
      h_x = h_y;
      h_y = tmp;
    }
    z_loc_x = -180;
  }

  String h_code = '';
  List<int> code3_x = [];
  List<int> code3_y = [];
  String code3 = '';
  String code9 = '';
  int mod_x = h_x;
  int mod_y = h_y;

  for (int i = 0; i <= level + 2; i++) {
    int h_pow = (pow(3, level + 2 - i)).round();
    int h_pow_half = (h_pow / 2.0).ceil();
    if (mod_x >= h_pow_half) {
      code3_x.add(2);
      mod_x -= h_pow;
    } else if (mod_x <= -h_pow_half) {
      code3_x.add(0);
      mod_x += h_pow;
    } else {
      code3_x.add(1);
    }

    if (mod_y >= h_pow_half) {
      code3_y.add(2);
      mod_y -= h_pow;
    } else if (mod_y <= -h_pow_half) {
      code3_y.add(0);
      mod_y += h_pow;
    } else {
      code3_y.add(1);
    }

    if (i == 2 && (z_loc_x == -180 || z_loc_x >= 0)) {
      if (code3_x[0] == 2 && code3_y[0] == 1 && code3_x[1] == code3_y[1] && code3_x[2] == code3_y[2]) {
        code3_x[0] = 1;
        code3_y[0] = 2;
      } else if (code3_x[0] == 1 && code3_y[0] == 0 && code3_x[1] == code3_y[1] && code3_x[2] == code3_y[2]) {
        code3_x[0] = 0;
        code3_y[0] = 1;
      }
    }
  }

  for (int i = 0; i < code3_x.length; i++) {
    code3 += code3_x[i].toString() + code3_y[i].toString();
    code9 += int.tryParse(code3, radix: 3).toString();
    h_code += code9;
    code3 = '';
    code9 = '';
  }

  String h_2 = h_code.substring(3);
  int h_1 = int.tryParse(h_code.substring(0, 3));
  int h_a1 = (h_1 / 30).floor();
  int h_a2 = h_1 % 30;
  String h_code_r = _h_key[h_a1] + _h_key[h_a2] + h_2.toString();
  return _Zone(z_loc_y, z_loc_x, h_x, h_y, h_code_r.toString());
}

_XY _adjustXY(int x, int y, int level) {
  int max_hsteps = pow(3, level + 2);
  int hsteps = (x - y).abs();

  if (hsteps == max_hsteps && x > y) {
    int tmp = x;
    x = y;
    y = tmp;
  } else if (hsteps > max_hsteps) {
    int diff = hsteps - max_hsteps;
    int diff_x = (diff / 2.0).floor();
    int diff_y = diff - diff_x;
    int edge_x;
    int edge_y;

    if (x > y) {
      edge_x = x - diff_x;
      edge_y = y + diff_y;
      int h_xy = edge_x;
      edge_x = edge_y;
      edge_y = h_xy;
      x = edge_x + diff_x;
      y = edge_y - diff_y;
    } else if (y > x) {
      edge_x = x + diff_x;
      edge_y = y - diff_y;
      int h_xy = edge_x;
      edge_x = edge_y;
      edge_y = h_xy;
      x = edge_x - diff_x;
      y = edge_y + diff_y;
    }
  }

  return _XY(x.toDouble(), y.toDouble());
}

class _XY {
  final double x, y;

  const _XY(this.x, this.y);
}

class _Loc {
  final double lat, lon;

  const _Loc(this.lat, this.lon);
}

_XY _loc2xy(double lon, double lat) {
  double x = lon * _h_base / 180.0;
  double y = log(tan((90.0 + lat) * pi / 360.0)) / (pi / 180.0);
  y *= _h_base / 180.0;
  return _XY(x, y);
}

_Loc _xy2loc(double x, double y) {
  double lon = (x / _h_base) * 180.0;
  double lat = (y / _h_base) * 180.0;
  lat = 180 / pi * (2.0 * atan(exp(lat * pi / 180.0)) - pi / 2.0);
  return _Loc(lat, lon);
}

double _calcHexSize(int level) {
  return _h_base / pow(3.0, level + 3);
}

bool _regMatch(String cs, RegExp regExp) {
  return regExp.hasMatch(cs);
}
