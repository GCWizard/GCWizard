import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

const int _DEFAULT_PRECISION = 8;

const _BASE30 = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'B',
  'C',
  'D',
  'F',
  'G',
  'H',
  'J',
  'K',
  'L',
  'M',
  'N',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'V',
  'W',
  'X',
  'Z'
];

// source: http://www.nacgeo.com/nacsite/documents/nac.asp

String _latlonComponentToNACComponent(double component, int precision) {
  var a = <int>[];
  var an = component;
  while (a.length < precision) {
    an = an * 30;
    var ai = an.floor();

    a.add(ai);
    an = an - ai;
  }

  return a.map((e) {
    return _BASE30[e];
  }).join();
}

NaturalAreaCode latLonToNaturalAreaCode(LatLng coords, {int precision = _DEFAULT_PRECISION}) {
  var lon = (coords.longitude + 180.0) / 360.0;
  var lat = (coords.latitude + 90.0) / 180.0;

  return NaturalAreaCode(
      _latlonComponentToNACComponent(lon, precision), _latlonComponentToNACComponent(lat, precision));
}

double _nacComponentToLatLonComponent(String component) {
  component = component.toUpperCase();

  var a = 0.0;
  for (int i = 0; i < component.length; i++) {
    var value = _BASE30.indexOf(component[i]);
    if (value == -1) continue;

    a += value / pow(30, i + 1);
  }

  return a;
}

LatLng naturalAreaCodeToLatLon(NaturalAreaCode nac) {
  return LatLng(
    _nacComponentToLatLonComponent(nac.y) * 180.0 - 90.0,
    _nacComponentToLatLonComponent(nac.x) * 360.0 - 180.0,
  );
}

NaturalAreaCode? parseNaturalAreaCode(String input) {
  RegExp regExp = RegExp(r'^\s*([\dA-Z]+)(\s*,\s*|\s+)([\dA-Z]+)\s*$');
  var matches = regExp.allMatches(input);

  String? xString = '';
  String? yString = '';

  if (matches.isNotEmpty) {
    var match = matches.elementAt(0);
    xString = match.group(1);
    yString = match.group(3);
  }
  if (matches.isEmpty) {
    regExp = RegExp(r'^\s*([Xx]):?\s*([\dA-Z]+)(\s*,\s*|\s+)([Yy]):?\s*([\dA-Z]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.isNotEmpty) {
      var match = matches.elementAt(0);
      xString = match.group(2);
      yString = match.group(5);
    }
  }

  if (matches.isEmpty) return null;

  if (xString == null || yString == null) {
    return null;
  }

  return NaturalAreaCode(xString, yString);
}
