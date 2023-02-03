import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

// Source: https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames

LatLng slippyMapToLatLon(SlippyMap slippyMap) {
  var lon = slippyMap.x / pow(2.0, slippyMap.zoom) * 360.0 - 180.0;

  var n = pi - 2.0 * pi * slippyMap.y / pow(2.0, slippyMap.zoom);
  var lat = 180.0 / pi * atan(0.5 * (exp(n) - exp(-n)));

  return LatLng(lat, lon);
}

SlippyMap latLonToSlippyMap(LatLng coords, double zoom) {
  var x = (coords.longitude + 180.0) / 360.0 * pow(2.0, zoom);
  var y = (1 - log(tan(coords.latitude * pi / 180.0) + 1.0 / cos(coords.latitude * pi / 180.0)) / pi) /
      2.0 *
      pow(2.0, zoom);

  return SlippyMap(x, y, zoom);
}

SlippyMap parseSlippyMap(String input, {zoom: 10.0}) {
  RegExp regExp = RegExp(r'^\s*([\0-9\.]+)(\s*,\s*|\s+)([\0-9\.]+)\s*$');
  var matches = regExp.allMatches(input);
  var xString = '';
  var yString = '';

  if (matches.length > 0) {
    var match = matches.elementAt(0);
    xString = match.group(1);
    yString = match.group(3);
  }
  if (matches.length == 0) {
    regExp = RegExp(r'^\s*(X|x)\:?\s*([\0-9\.]+)(\s*\,?\s*)(Y|y)\:?\s*([\0-9\.]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.length > 0) {
      var match = matches.elementAt(0);
      xString = match.group(2);
      yString = match.group(5);
    }
  }

  if (matches.length == 0) return null;

  var x = double.tryParse(xString);
  if (x == null) return null;

  var y = double.tryParse(yString);
  if (y == null) return null;

  return SlippyMap(x, y, zoom);
}
