import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

part 'package:gc_wizard/tools/coords/format_converter/logic/external_libs/djvanderlaan.rijksdriehoek/rijksdriehoek_js.dart';

DutchGrid latLonToDutchGrid(LatLng coord) {
  var dutchGrid = _rijksdriehoek(coord.longitude, coord.latitude);
  return DutchGrid(dutchGrid[0], dutchGrid[1]);
}

LatLng dutchGridToLatLon(DutchGrid dutchGrid) {
  var latLon = _rijksdriehoekInverse(dutchGrid.x, dutchGrid.y);
  return LatLng(latLon[1], latLon[0]);
}

DutchGrid? parseDutchGrid(String input) {
  RegExp regExp = RegExp(r'^\s*([\-\d.]+)(\s*,\s*|\s+)([\-\d.]+)\s*$');
  var matches = regExp.allMatches(input);
  String? _xString = '';
  String? _yString = '';

  if (matches.isNotEmpty) {
    var match = matches.elementAt(0);
    _xString = match.group(1);
    _yString = match.group(3);
  }
  if (matches.isEmpty) {
    regExp = RegExp(r'^\s*([Xx]):?\s*([\-\d.]+)(\s*,?\s*)([Yy]):?\s*([\-\d.]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.isNotEmpty) {
      var match = matches.elementAt(0);
      _xString = match.group(2);
      _yString = match.group(5);
    }
  }

  if (matches.isEmpty) return null;
  if (_xString == null || _yString == null) return null;

  var x = double.tryParse(_xString);
  if (x == null) return null;

  var y = double.tryParse(_yString);
  if (y == null) return null;

  return DutchGrid(x, y);
}
