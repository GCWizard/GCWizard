import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:latlong2/latlong.dart';

// source: https://en.wikipedia.org/wiki/Global_Area_Reference_System
// source: https://web.archive.org/web/20061020155156/http://earth-info.nga.mil/GandG/coordsys/grids/gars.html

const garsKey = 'coords_gars';

final GARSFormatDefinition = CoordinateFormatDefinition(
    CoordinateFormatKey.GARS, garsKey, garsKey, GARSCoordinate.parse, GARSCoordinate('001AA11'));

class GARSCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.GARS);
  String text;

  GARSCoordinate(this.text);

  @override
  LatLng? toLatLng() {
    return _GARSToLatLon(this);
  }

  static GARSCoordinate? parse(String input) {
    return _parseGARS(input);
  }

  static GARSCoordinate fromLatLon(LatLng coord) {
    return _latLonToGARS(coord);
  }

  @override
  String toString([int? precision]) {
    return text;
  }
}

const _LAT_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ'; // omit I and O

GARSCoordinate _latLonToGARS(LatLng coord) {
  var lat = coord.latitude;
  var lon = coord.longitude;

  /// step 1: 30' x 30' cells ///

  var lonZone = min<int>(((lon + 180) * 2).toInt() + 1, 720); // min is for edge cases: exact 90° lat or 180° lon
  var out = lonZone.toString().padLeft(3, '0');

  var latZone = min<int>(((lat + 90) * 2).toInt(), 359);
  out += convertIntToBase(
      latZone.toString(),
      _LAT_ALPHABET.length, outputAlphabet: _LAT_ALPHABET
  ).padLeft(2, 'A');

  /// step 2: divide cells into 2x2 15' cells ///

  var lowerBoundX = latZone / 2.0 - 90;
  var lowerBoundY = (lonZone - 1) / 2.0 - 180;

  var quadrant = '';
  if (lat - lowerBoundX >= 0.25) {
    quadrant = '12';
    lowerBoundX += 0.25;
  } else {
    quadrant = '34';
  }

  if (lon - lowerBoundY >= 0.25) {
    out += quadrant[1];
    lowerBoundY += 0.25;
  } else {
    out += quadrant[0];
  }

  /// step 3: divide cells into 3x3 5' cells ///

  var keypad = '';
  if (lat - lowerBoundX < 1 / 12) {
    keypad = '789';
  } else if (lat - lowerBoundX >= 2 / 12) {
    keypad = '123';
  } else {
    keypad = '456';
  }

  if (lon - lowerBoundY < 1 / 12) {
    out += keypad[0];
  } else if (lon - lowerBoundY >= 2 / 12) {
    out += keypad[2];
  } else {
    out += keypad[1];
  }

  return GARSCoordinate(out);
}

LatLng? _GARSToLatLon(GARSCoordinate gars) {
  var text = gars.text.toUpperCase();

  var lonZone = int.parse(text.substring(0, 3));
  var latZone = text.substring(3, 5);
  var quadrant = int.parse(text[5]);
  var keypad = int.parse(text[6]);

  var lon = (lonZone - 1) / 2.0 - 180;
  var lat = int.parse(convertBaseToInt(latZone, 24, inputAlphabet: _LAT_ALPHABET)) / 2.0 - 90;

  if ([1, 2].contains(quadrant)) {
    lat += 0.25;
  }

  if ([2, 4].contains(quadrant)) {
    lon += 0.25;
  }

  if ([4, 5, 6].contains(keypad)) {
    lat += 1 / 12;
  } else if ([1, 2, 3].contains(keypad)) {
    lat += 2 / 12;
  }

  if ([2, 5, 8].contains(keypad)) {
    lon += 1 / 12;
  } else if ([3, 6, 9].contains(keypad)) {
    lon += 2 / 12;
  }

  return LatLng(lat, lon);
}

GARSCoordinate? _parseGARS(String input) {
  if (input.length != 7) return null;

  input = input.toUpperCase();
  if (input.length != input.replaceAll(RegExp(r'[^' + _LAT_ALPHABET + '0-9]'), '').length) return null;

  var part1 = input.substring(0, 3);
  var part1Int = int.tryParse(part1);
  if (part1Int == null || part1Int > 720 || part1Int < 1) return null;

  var part2 = input.substring(3, 5);
  if (!_LAT_ALPHABET.contains(part2[0]) || !_LAT_ALPHABET.contains(part2[1])) return null;
  if (int.parse(convertBaseToInt(part2, _LAT_ALPHABET.length, inputAlphabet: _LAT_ALPHABET)) > 359) return null;

  var part3 = input[5];
  var part3Int = int.tryParse(part3);
  if (part3Int == null || part3Int > 4 || part3Int < 1) return null;

  var part4 = input[6];
  var part4Int = int.tryParse(part4);
  if (part4Int == null || part4Int > 9 || part4Int < 1) return null;

  return GARSCoordinate(input);
}
