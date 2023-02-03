import 'dart:math';

import 'package:gc_wizard/tools/coords/ellipsoid_transform/logic/ellipsoid_transform.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

SwissGridPlus latLonToSwissGridPlus(LatLng coord, Ellipsoid ells) {
  SwissGrid swissGrid = SwissGrid.fromLatLon(coord, ells);

  return SwissGridPlus(swissGrid.easting + 2000000, swissGrid.northing + 1000000);
}

SwissGrid latLonToSwissGrid(LatLng coord, Ellipsoid ells) {
  int x = -1;

  switch (ells.name) {
    case ELLIPSOID_NAME_AIRY1830:
      x = 6;
      break;
    case ELLIPSOID_NAME_AIRYMODIFIED:
      x = 7;
      break;
    case ELLIPSOID_NAME_BESSEL1841:
      x = 0;
      break;
    case ELLIPSOID_NAME_CLARKE1866:
      x = 9;
      break;
    case ELLIPSOID_NAME_HAYFORD1924:
      x = 8;
      break;
    case ELLIPSOID_NAME_KRASOVSKY1940:
      x = 2;
      break;
  }

  LatLng newCoord = coord;
  if (x >= 0) {
    newCoord = ellipsoidTransformLatLng(coord, x, false, false);
  }
  newCoord = ellipsoidTransformLatLng(newCoord, 5, true, false);

  double lat0 = degToRadian(46.952405555555556); //Bern
  double lon0 = degToRadian(7.439583333333333);

  var ellsBessel = getEllipsoidByName(ELLIPSOID_NAME_BESSEL1841);
  double a = ellsBessel.a;
  double E = ellsBessel.e;
  double E2 = ellsBessel.e2;
  double alpha = sqrt(1 + (E2 / (1 - E2)) * pow(cos(lat0), 4));
  double b0 = asin(sin(lat0) / alpha);
  double K = log(tan(pi / 4.0 + b0 / 2.0)) -
      alpha * log(tan(pi / 4.0 + lat0 / 2.0)) +
      (alpha * E) / 2.0 * log((1 + E * sin(lat0)) / (1 - E * sin(lat0)));
  double R = (a * sqrt(1 - E2)) / (1 - E2 * pow(sin(lat0), 2));

  var lat = newCoord.latitudeInRad;
  var lon = newCoord.longitudeInRad;

  double S =
      alpha * log(tan(pi / 4.0 + lat / 2.0)) - (alpha * E) / 2.0 * log((1 + E * sin(lat)) / (1 - E * sin(lat))) + K;
  double b = 2 * (atan(exp(S)) - pi / 4.0);
  double l = alpha * (lon - lon0);

  double l_ = atan(sin(l) / (sin(b0) * tan(b) + cos(b0) * cos(l)));
  double b_ = asin(cos(b0) * sin(b) - sin(b0) * cos(b) * cos(l));

  double Y = R * l_;
  double X = R / 2.0 * log((1 + sin(b_)) / (1 - sin(b_)));

  Y += 600000;
  X += 200000;

  return SwissGrid(Y, X);
}

LatLng swissGridPlusToLatLon(SwissGridPlus coord, Ellipsoid ells) {
  var swissGripPlus = SwissGrid(coord.easting - 2000000, coord.northing - 1000000);

  return swissGridToLatLon(swissGripPlus, ells);
}

LatLng swissGridToLatLon(SwissGrid coord, Ellipsoid ells) {
  var y = coord.easting - 600000;
  var x = coord.northing - 200000;

  double lat0 = degToRadian(46.952405555555556); //Bern
  double lon0 = degToRadian(7.439583333333333);

  var ellsBessel = getEllipsoidByName(ELLIPSOID_NAME_BESSEL1841);
  double a = ellsBessel.a;
  double E = ellsBessel.e;
  double E2 = ellsBessel.e2;
  double alpha = sqrt(1 + (E2 / (1 - E2)) * pow(cos(lat0), 4));
  double b0 = asin(sin(lat0) / alpha);
  double K = log(tan(pi / 4.0 + b0 / 2.0)) -
      alpha * log(tan(pi / 4.0 + lat0 / 2.0)) +
      (alpha * E) / 2.0 * log((1 + E * sin(lat0)) / (1 - E * sin(lat0)));
  double R = (a * sqrt(1 - E2)) / (1 - E2 * pow(sin(lat0), 2));

  double l_ = y / R;
  double b_ = 2 * (atan(exp(x / R)) - pi / 4.0);

  double b = asin(cos(b0) * sin(b_) + sin(b0) * cos(b_) * cos(l_));
  double l = atan(sin(l_) / (cos(b0) * cos(l_) - sin(b0) * tan(b_)));

  double lon = lon0 + l / alpha;

  double lat = b;
  double phi = 1000;

  while ((phi - lat).abs() > practical_epsilon) {
    phi = lat;
    double S = 1 / alpha * (log(tan(pi / 4.0 + b / 2.0)) - K) + E * log(tan(pi / 4.0 + (asin(E * sin(lat)) / 2.0)));
    lat = 2 * atan(exp(S)) - pi / 2.0;
  }

  int X = -1;
  switch (ells.name) {
    case ELLIPSOID_NAME_AIRY1830:
      X = 6;
      break;
    case ELLIPSOID_NAME_AIRYMODIFIED:
      X = 7;
      break;
    case ELLIPSOID_NAME_BESSEL1841:
      X = 0;
      break;
    case ELLIPSOID_NAME_CLARKE1866:
      X = 9;
      break;
    case ELLIPSOID_NAME_HAYFORD1924:
      X = 8;
      break;
    case ELLIPSOID_NAME_KRASOVSKY1940:
      X = 2;
      break;
  }

  LatLng newCoord = ellipsoidTransformLatLng(LatLng(radianToDeg(lat), radianToDeg(lon)), 5, false, false);
  if (X >= 0) newCoord = ellipsoidTransformLatLng(newCoord, X, true, false);

  return newCoord;
}

SwissGrid parseSwissGrid(String input) {
  RegExp regExp = RegExp(r'^\s*([\-0-9\.]+)(\s*\,\s*|\s+)([\-0-9\.]+)\s*$');
  var matches = regExp.allMatches(input);
  var _eastingString = '';
  var _northingString = '';

  if (matches.length > 0) {
    var match = matches.elementAt(0);
    _eastingString = match.group(1);
    _northingString = match.group(3);
  }
  if (matches.length == 0) {
    regExp = RegExp(r'^\s*(Y|y)\:?\s*([\-0-9\.]+)(\s*\,?\s*)(X|x)\:?\s*([\-0-9\.]+)\s*$');
    matches = regExp.allMatches(input);
    if (matches.length > 0) {
      var match = matches.elementAt(0);
      _eastingString = match.group(2);
      _northingString = match.group(5);
    }
  }

  if (matches.length == 0) return null;

  var _easting = double.tryParse(_eastingString);
  if (_easting == null) return null;

  var _northing = double.tryParse(_northingString);
  if (_northing == null) return null;

  return SwissGrid(_easting, _northing);
}

SwissGridPlus parseSwissGridPlus(String input) {
  var swissGrid = SwissGrid.parse(input);
  return swissGrid == null ? null : SwissGridPlus(swissGrid.easting, swissGrid.northing);
}
