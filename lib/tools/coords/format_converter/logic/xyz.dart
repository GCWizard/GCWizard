import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

LatLng xyzToLatLon(XYZ xyz, Ellipsoid ells) {
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

XYZ latLonToXYZ(LatLng coord, Ellipsoid ells, {double h: 0.0}) {
  var lat = coord.latitudeInRad;
  var lon = coord.longitudeInRad;
  var v = ells.a / sqrt(1 - ells.e2 * sin(lat) * sin(lat));

  var x = (v + h) * cos(lat) * cos(lon);
  var y = (v + h) * cos(lat) * sin(lon);
  var z = ((1 - ells.e2) * v + h) * sin(lat);

  return XYZ(x, y, z);
}

XYZ parseXYZ(String input) {
  RegExp regExp = RegExp(r'^\s*([\-0-9\.]+)(\s*,\s*|\s+)([\-0-9\.]+)(\s*,\s*|\s+)([\-0-9\.]+)\s*$');
  var matches = regExp.allMatches(input);

  var xString = '';
  var yString = '';
  var zString = '';

  if (matches.length > 0) {
    var match = matches.elementAt(0);
    xString = match.group(1);
    yString = match.group(3);
    zString = match.group(5);
  }
  if (matches.length == 0) {
    regExp =
        RegExp(r'^\s*(X|x)\:?\s*([\-0-9\.]+)(\s*\,?\s*)(Y|y)\:?\s*([\-0-9\.]+)(\s*\,?\s*)(Z|z)\:?\s*([\-0-9\.]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.length > 0) {
      var match = matches.elementAt(0);
      xString = match.group(2);
      yString = match.group(5);
      zString = match.group(8);
    }
  }

  if (matches.length == 0) return null;

  var x = double.tryParse(xString);
  var y = double.tryParse(yString);
  var z = double.tryParse(zString);

  if (x == null || y == null || z == null) return null;

  return XYZ(x, y, z);
}
