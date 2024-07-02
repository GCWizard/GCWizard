// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

const xyzKey = 'coords_xyz';

final XYZFormatDefinition =
    CoordinateFormatDefinition(CoordinateFormatKey.XYZ, xyzKey, xyzKey, XYZCoordinate.parse, XYZCoordinate(0, 0, 0));

class XYZCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.XYZ);
  double x, y, z;

  XYZCoordinate(this.x, this.y, this.z);

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return _xyzToLatLon(this, ells);
  }

  static XYZCoordinate fromLatLon(LatLng coord, Ellipsoid ells, {double h = 0.0}) {
    return _latLonToXYZ(coord, ells, h: h);
  }

  static XYZCoordinate? parse(String input) {
    return _parseXYZ(input);
  }

  @override
  String toString([int? precision]) {
    var numberFormat = NumberFormat('0.######');
    return 'X: ${numberFormat.format(x)}\nY: ${numberFormat.format(y)}\nZ: ${numberFormat.format(z)}';
  }
}

LatLng _xyzToLatLon(XYZCoordinate xyz, Ellipsoid ells) {
  var x = xyz.x;
  var y = xyz.y;
  var z = xyz.z;

  var p = sqrt(x * x + y * y);
  var r = sqrt(p * p + z * z);
  var m = atan((z / p) * ((1 - ells.f) + (ells.e2 * ells.a) / r));

  var lon = atan(y / x);
  if (lon < 0) lon = pi + lon;

  var lat_top = z * (1 - ells.f) + ells.e2 * ells.a * sin(m) * sin(m) * sin(m);
  var lat_bottom = (1 - ells.f) * (p - ells.e2 * ells.a * cos(m) * cos(m) * cos(m));
  var lat = atan(lat_top / lat_bottom);

  var h = p * cos(lat) + z * sin(lat) - ells.a * sqrt(1 - ells.e2 * sin(lat) * sin(lat));

  return LatLng(radianToDeg(lat), radianToDeg(lon));
}

XYZCoordinate _latLonToXYZ(LatLng coord, Ellipsoid ells, {double h = 0.0}) {
  var lat = coord.latitudeInRad;
  var lon = coord.longitudeInRad;
  var v = ells.a / sqrt(1 - ells.e2 * sin(lat) * sin(lat));

  var x = (v + h) * cos(lat) * cos(lon);
  var y = (v + h) * cos(lat) * sin(lon);
  var z = ((1 - ells.e2) * v + h) * sin(lat);

  return XYZCoordinate(x, y, z);
}

XYZCoordinate? _parseXYZ(String input) {
  RegExp regExp = RegExp(r'^\s*([\-0-9\.]+)(\s*,\s*|\s+)([\-0-9\.]+)(\s*,\s*|\s+)([\-0-9\.]+)\s*$');
  var matches = regExp.allMatches(input);

  String? xString = '';
  String? yString = '';
  String? zString = '';

  if (matches.isNotEmpty) {
    var match = matches.elementAt(0);
    xString = match.group(1);
    yString = match.group(3);
    zString = match.group(5);
  }
  if (matches.isEmpty) {
    regExp =
        RegExp(r'^\s*(X|x)\:?\s*([\-0-9\.]+)(\s*\,?\s*)(Y|y)\:?\s*([\-0-9\.]+)(\s*\,?\s*)(Z|z)\:?\s*([\-0-9\.]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.isNotEmpty) {
      var match = matches.elementAt(0);
      xString = match.group(2);
      yString = match.group(5);
      zString = match.group(8);
    }
  }

  if (matches.isEmpty) return null;
  if (xString == null || yString == null || zString == null) {
    return null;
  }

  var x = double.tryParse(xString);
  var y = double.tryParse(yString);
  var z = double.tryParse(zString);

  if (x == null || y == null || z == null) return null;

  return XYZCoordinate(x, y, z);
}
