import 'package:gc_wizard/tools/coords/format_converter/logic/utm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

String digraphLettersEast = "ABCDEFGHJKLMNPQRSTUVWXYZ"; //without I and O
String digraphLettersNorth = "ABCDEFGHJKLMNPQRSTUV";

String _constructDigraph(int zone, double easting, double northing) {
  var _letter = ((zone - 1) * 8 + easting).floor();
  _letter = _letter - 24 * (_letter / 24.0).floor() - 1;

  var _digraph = digraphLettersEast[_letter];
  _letter = northing.floor();

  if (zone / 2.0 == (zone / 2.0).floor()) {
    _letter = _letter + 5;
  }

  _letter = _letter - 20 * (_letter / 20.0).floor();

  return _digraph + digraphLettersNorth[_letter];
}

MGRS latLonToMGRS(LatLng coord, Ellipsoid ells) {
  UTMREF _utm = UTMREF.fromLatLon(coord, ells);

  var _digraph = _constructDigraph(_utm.zone.lonZone, _utm.easting / 100000.0, _utm.northing / 100000.0);

  var _easting = _utm.easting - 100000 * (_utm.easting / 100000.0).floor();
  var _northing = _utm.northing - 100000 * (_utm.northing / 100000.0).floor();

  return MGRS(_utm.zone, _digraph, _easting, _northing);
}

List<List<dynamic>> latitudeBandConstants = [
  [2, 1100000.0, -72.0, -80.5, 0.0],
  [3, 2000000.0, -64.0, -72.0, 2000000.0],
  [4, 2800000.0, -56.0, -64.0, 2000000.0],
  [5, 3700000.0, -48.0, -56.0, 2000000.0],
  [6, 4600000.0, -40.0, -48.0, 4000000.0],
  [7, 5500000.0, -32.0, -40.0, 4000000.0],
  [9, 6400000.0, -24.0, -32.0, 6000000.0],
  [10, 7300000.0, -16.0, -24.0, 6000000.0],
  [11, 8200000.0, -8.0, -16.0, 8000000.0],
  [12, 9100000.0, 0.0, -8.0, 8000000.0],
  [13, 0.0, 8.0, 0.0, 0.0],
  [14, 800000.0, 16.0, 8.0, 0.0],
  [16, 1700000.0, 24.0, 16.0, 0.0],
  [17, 2600000.0, 32.0, 24.0, 2000000.0],
  [18, 3500000.0, 40.0, 32.0, 2000000.0],
  [19, 4400000.0, 48.0, 40.0, 4000000.0],
  [20, 5300000.0, 56.0, 48.0, 4000000.0],
  [21, 6200000.0, 64.0, 56.0, 6000000.0],
  [22, 7000000.0, 72.0, 64.0, 6000000.0],
  [23, 7900000.0, 84.5, 72.0, 6000000.0]
];

// ported from NASA Worldwind
UTMREF convertMGRSToUTM(MGRS mgrs) {
  String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  double grid_easting; /* Easting for 100,000 meter grid square      */
  double grid_northing; /* Northing for 100,000 meter grid square     */

  double easting = 0;
  double northing = 0;

  int set_number; /* Set number (1-6) based on UTM zone number */

  set_number = mgrs.utmZone.lonZone % 6;

  if (set_number == 0) set_number = 6;

  var ltr2_low_value;
  if ((set_number == 1) || (set_number == 4)) {
    ltr2_low_value = alphabet.indexOf('A');
  } else if ((set_number == 2) || (set_number == 5)) {
    ltr2_low_value = alphabet.indexOf('J');
  } else if ((set_number == 3) || (set_number == 6)) {
    ltr2_low_value = alphabet.indexOf('S');
  }

  var false_northing;

  if ((set_number % 2) == 0)
    false_northing = 500000.0;
  else
    false_northing = 0.0;

  var squareLetter1 = alphabet.indexOf(mgrs.digraph[0]);
  var squareLetter2 = alphabet.indexOf(mgrs.digraph[1]);

  grid_northing = squareLetter2 * 100000.0;
  grid_easting = (squareLetter1 - ltr2_low_value + 1) * 100000.0;
  if ((ltr2_low_value == alphabet.indexOf('J')) && (squareLetter1 > alphabet.indexOf('O')))
    grid_easting = grid_easting - 100000;

  if (squareLetter2 > alphabet.indexOf('O')) grid_northing = grid_northing - 100000;

  if (squareLetter2 > alphabet.indexOf('I')) grid_northing = grid_northing - 100000;

  if (grid_northing >= 2000000) grid_northing = grid_northing - 2000000;

  var letter = alphabet.indexOf(mgrs.utmZone.latZone);
  var min_northing;
  var northing_offset;

  if ((letter >= alphabet.indexOf('C')) && (letter <= alphabet.indexOf('H'))) {
    min_northing = latitudeBandConstants[letter - 2][1];
    northing_offset = latitudeBandConstants[letter - 2][4];
  } else if ((letter >= alphabet.indexOf('J')) && (letter <= alphabet.indexOf('N'))) {
    min_northing = latitudeBandConstants[letter - 3][1];
    northing_offset = latitudeBandConstants[letter - 3][4];
  } else if ((letter >= alphabet.indexOf('P')) && (letter <= alphabet.indexOf('X'))) {
    min_northing = latitudeBandConstants[letter - 4][1];
    northing_offset = latitudeBandConstants[letter - 4][4];
  }

  grid_northing = grid_northing - false_northing;

  if (grid_northing < 0.0) grid_northing += 2000000;

  grid_northing += northing_offset;

  if (grid_northing < min_northing) grid_northing += 2000000;

  easting = grid_easting + mgrs.easting;
  northing = grid_northing + mgrs.northing;

  return UTMREF(mgrs.utmZone, easting, northing);
}

LatLng mgrsToLatLon(MGRS mgrs, Ellipsoid ells) {
  var utm = convertMGRSToUTM(mgrs);
  return UTMREFtoLatLon(utm, ells);
}

MGRS parseMGRS(String input) {
  RegExp regExp = RegExp(r'^\s*(\d+)\s?([A-Z])\s?([A-Z]{2})\s?([0-9\.]+)\s+([0-9\.]+)\s*$');
  var matches = regExp.allMatches(input);
  var _lonZoneString = '';
  var _latZone = '';
  var _digraph = '';
  var _eastingString = '';
  var _northingString = '';

  if (matches.length > 0) {
    var match = matches.elementAt(0);
    _lonZoneString = match.group(1);
    _latZone = match.group(2);
    _digraph = match.group(3);
    _eastingString = match.group(4);
    _northingString = match.group(5);
  }
  if (matches.length == 0) {
    regExp = RegExp(r'^\s*(\d+)\s?([A-Z])\s?([A-Z]{2})\s?([0-9]{10})\s*$');
    matches = regExp.allMatches(input);
    if (matches.length > 0) {
      var match = matches.elementAt(0);
      _lonZoneString = match.group(1);
      _latZone = match.group(2);
      _digraph = match.group(3);
      _eastingString = match.group(4).substring(0, 5);
      _northingString = match.group(4).substring(5);
    }
  }

  if (matches.length == 0) return null;

  var _lonZone = int.tryParse(_lonZoneString);
  if (_lonZone == null) return null;

  var _easting = double.tryParse(_eastingString);
  if (_easting == null) return null;
  _easting = fillUpNumber(_easting, _eastingString, 5);

  var _northing = double.tryParse(_northingString);
  if (_northing == null) return null;
  _northing = fillUpNumber(_northing, _northingString, 5);

  var zone = UTMZone(_lonZone, _lonZone, _latZone);
  var mgrs = MGRS(zone, _digraph, _easting, _northing);

  return mgrs;
}

// East values must be between 1 and 99 999. Missing digits are filled in at the back.
// North values must be between 1 and 99,999. Missing digits are filled in at the back.
// Values below 10,000 must be filled with zeros accordingly so that the two numbers each 5 digits long.
// Values with a point are not changed
// discussed with Mark on 3.2.2021
double fillUpNumber(double number, String text, int length) {
  if (text.contains('.'))
    return number;
  else {
    text = text.padRight(length, '0');
    return double.parse(text);
  }
}
