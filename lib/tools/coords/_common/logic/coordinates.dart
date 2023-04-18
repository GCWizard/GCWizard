import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/dec.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/dms.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/dutchgrid.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/gauss_krueger.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/geo3x3.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/geohash.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/geohex.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/lambert.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/maidenhead.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/makaney.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/mercator.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/mgrs.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/natural_area_code.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/open_location_code.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/quadtree.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/reverse_wherigo_day1976.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/reverse_wherigo_waldmeister.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/slippy_map.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/swissgrid.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/utm.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/xyz.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

abstract class BaseCoordFormatKey{}

String _dmmAndDMSNumberFormat([int precision = 6]) {
  var formatString = '00.';
  if (precision < 0) precision = 0;

  if (precision <= 3) formatString += '0' * precision;
  if (precision > 3) formatString += '000' + '#' * (precision - 3);

  return formatString;
}

String _getCoordinateSignString(int sign, bool isLatitude) {
  var _sign = '';

  if (isLatitude) {
    _sign = (sign >= 0) ? 'N' : 'S';
  } else {
    _sign = (sign >= 0) ? 'E' : 'W';
  }

  return _sign;
}

int getCoordinateSignFromString(String text, bool isLatitude) {
  int _sign = 0;

  if (isLatitude) {
    _sign = (text == 'N') ? 1 : -1;
  } else {
    _sign = (text == 'E') ? 1 : -1;
  }

  return _sign;
}

abstract class BaseCoordinate {
  late double _latitude;
  late double _longitude;
  late CoordinateFormat _format;

  CoordinateFormat get format => _format;

  BaseCoordinate ([double? latitude, double? longitude]) {
    _latitude = latitude ?? defaultCoordinate.latitude;
    _longitude = longitude ?? defaultCoordinate.longitude;
  }

  // TODO: Make this null-safe. Some inheriting CoordFormats may return null here. This shall be avoided.
  LatLng? toLatLng() {
    return LatLng(_latitude, _longitude);
  }

  @override
  String toString() {
    return LatLng(_latitude, _longitude).toString();
  }
}

abstract class BaseCoordinateWithSubtypes extends BaseCoordinate {}

class DEC extends BaseCoordinate {
  double latitude;
  double longitude;

  DEC(this.latitude, this.longitude) {
    _format = CoordinateFormat(CoordinateFormatKey.DEC);
  }

  @override
  LatLng toLatLng() {
    return decToLatLon(this);
  }

  static DEC fromLatLon(LatLng coord) {
    return latLonToDEC(coord);
  }

  static DEC? parse(String input, {bool wholeString = false}) {
    return parseDEC(input, wholeString: wholeString);
  }

  @override
  String toString([int precision = 10]) {
    if (precision < 1) precision = 1;

    String fixedDigits = '0' * min(precision, 3);
    String variableDigits = precision > 3 ? '#' * (precision - 3) : '';

    return '${NumberFormat('00.' + fixedDigits + variableDigits).format(latitude)}\n${NumberFormat('000.' + fixedDigits + variableDigits).format(longitude)}';
  }
}

class FormattedDMMPart {
  IntegerText sign;
  String degrees, minutes;

  FormattedDMMPart(this.sign, this.degrees, this.minutes);

  @override
  String toString() {
    return sign.text + ' ' +  degrees +  '° ' +  minutes + '\'';
  }
}

class DMMPart {
  int sign;
  int degrees;
  double minutes;

  DMMPart(this.sign, this.degrees, this.minutes);

  FormattedDMMPart _formatParts(bool isLatitude, [int precision = 10]) {
    var _minutesStr = NumberFormat(_dmmAndDMSNumberFormat(precision)).format(minutes);
    var _degrees = degrees;
    var _sign = _getCoordinateSignString(sign, isLatitude);

    //Values like 59.999999999' may be rounded to 60.0. So in that case,
    //the degree has to be increased while minutes should be set to 0.0
    if (_minutesStr.startsWith('60')) {
      _minutesStr = '00.000';
      _degrees += 1;
    }

    String _degreesStr = _degrees.toString().padLeft(isLatitude ? 2 : 3, '0');

    return FormattedDMMPart(IntegerText(_sign, sign), _degreesStr, _minutesStr);
  }

  String _format(bool isLatitude, [int precision = 10]) {
    var formattedParts = _formatParts(isLatitude, precision);

    return formattedParts.toString();
  }

  @override
  String toString() {
    return 'sign: $sign, degrees: $degrees, minutes: $minutes';
  }
}

class DMMLatitude extends DMMPart {
  DMMLatitude(int sign, int degrees, double minutes) : super(sign, degrees, minutes);

  static DMMLatitude from(DMMPart dmmPart) {
    return DMMLatitude(dmmPart.sign, dmmPart.degrees, dmmPart.minutes);
  }

  FormattedDMMPart formatParts([int precision = 10]) {
    return super._formatParts(true, precision);
  }

  String format([int precision = 10]) {
    return super._format(true, precision);
  }
}

class DMMLongitude extends DMMPart {
  DMMLongitude(int sign, int degrees, double minutes) : super(sign, degrees, minutes);

  static DMMLongitude from(DMMPart dmmPart) {
    return DMMLongitude(dmmPart.sign, dmmPart.degrees, dmmPart.minutes);
  }

  FormattedDMMPart formatParts([int precision = 10]) {
    return super._formatParts(false, precision);
  }

  String format([int precision = 10]) {
    return super._format(false, precision);
  }
}

class DMM extends BaseCoordinate {
  late DMMLatitude latitude;
  late DMMLongitude longitude;

  DMM(this.latitude, this. longitude) {
    _format = CoordinateFormat(CoordinateFormatKey.DMM);
  }

  @override
  LatLng toLatLng() {
    return dmmToLatLon(this);
  }

  static DMM fromLatLon(LatLng coord) {
    return latLonToDMM(coord);
  }

  static DMM? parse(String text, {bool leftPadMilliMinutes = false, bool wholeString = false}) {
    return parseDMM(text, leftPadMilliMinutes: leftPadMilliMinutes, wholeString: wholeString);
  }

  @override
  String toString([int precision = 10]) {
    return '${latitude.format(precision)}\n${longitude.format(precision)}';
  }
}

class FormattedDMSPart {
  IntegerText sign;
  String degrees, minutes, seconds;

  FormattedDMSPart(this.sign, this.degrees, this.minutes, this.seconds);

  @override
  String toString() {
    return sign.text + ' ' +  degrees +  '° ' +  minutes + '\' ' + seconds + '"';
  }
}

class DMSPart {
  int sign;
  int degrees;
  int minutes;
  double seconds;

  DMSPart(this.sign, this.degrees, this.minutes, this.seconds);

  FormattedDMSPart _formatParts(bool isLatitude, [int precision = 10]) {
    var _sign = _getCoordinateSignString(sign, isLatitude);
    var _secondsStr = NumberFormat(_dmmAndDMSNumberFormat(precision)).format(seconds);
    var _minutes = minutes;

    //Values like 59.999999999 may be rounded to 60.0. So in that case,
    //the greater unit (minutes or degrees) has to be increased instead
    if (_secondsStr.startsWith('60')) {
      _secondsStr = '00.000';
      _minutes += 1;
    }

    var _degrees = degrees;

    var _minutesStr = _minutes.toString().padLeft(2, '0');
    if (_minutesStr.startsWith('60')) {
      _minutesStr = '00';
      _degrees += 1;
    }

    var _degreesStr = _degrees.toString().padLeft(isLatitude ? 2 : 3, '0');

    return FormattedDMSPart(IntegerText(_sign, sign), _degreesStr, _minutesStr, _secondsStr);
  }

  String _format(bool isLatitude, [int precision = 10]) {
    var formattedParts = _formatParts(isLatitude, precision);

    return formattedParts.toString();
  }

  @override
  String toString() {
    return 'sign: $sign, degrees: $degrees, minutes: $minutes, seconds: $seconds';
  }
}

class DMSLatitude extends DMSPart {
  DMSLatitude(int sign, int degrees, int minutes, double seconds) : super(sign, degrees, minutes, seconds);

  static DMSLatitude from(DMSPart dmsPart) {
    return DMSLatitude(dmsPart.sign, dmsPart.degrees, dmsPart.minutes, dmsPart.seconds);
  }

  FormattedDMSPart formatParts([int precision = 10]) {
    return super._formatParts(true, precision);
  }

  String format([int precision = 10]) {
    return super._format(true, precision);
  }
}

class DMSLongitude extends DMSPart {
  DMSLongitude(int sign, int degrees, int minutes, double seconds) : super(sign, degrees, minutes, seconds);

  static DMSLongitude from(DMSPart dmsPart) {
    return DMSLongitude(dmsPart.sign, dmsPart.degrees, dmsPart.minutes, dmsPart.seconds);
  }

  FormattedDMSPart formatParts([int precision = 10]) {
    return super._formatParts(false, precision);
  }

  String format([int precision = 10]) {
    return super._format(false, precision);
  }
}

class DMS extends BaseCoordinate {
  DMSLatitude latitude;
  DMSLongitude longitude;

  DMS(this.latitude, this.longitude) {
    _format = CoordinateFormat(CoordinateFormatKey.DMS);
  }

  @override
  LatLng toLatLng() {
    return dmsToLatLon(this);
  }

  static DMS fromLatLon(LatLng coord) {
    return latLonToDMS(coord);
  }

  static DMS? parse(String input, {bool wholeString = false}) {
    return parseDMS(input, wholeString: wholeString);
  }

  @override
  String toString([int precision = 10]) {
    return '${latitude.format(precision)}\n${longitude.format(precision)}';
  }
}

enum HemisphereLatitude { North, South }

enum HemisphereLongitude { East, West }

// UTM with latitude Zones; Normal UTM is only separated into Hemispheres N and S
class UTMREF extends BaseCoordinate {

  UTMZone zone;
  double easting;
  double northing;

  UTMREF(this.zone, this.easting, this.northing) {
    _format = CoordinateFormat(CoordinateFormatKey.UTM);
  }

  HemisphereLatitude get hemisphere {
    return 'NPQRSTUVWXYZ'.contains(zone.latZone) ? HemisphereLatitude.North : HemisphereLatitude.South;
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return UTMREFtoLatLon(this, ells);
  }

  static UTMREF fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToUTM(coord, ells);
  }

  static UTMREF? parse(String input) {
    return parseUTM(input);
  }

  @override
  String toString() {
    return '${zone.lonZone} ${zone.latZone} ${doubleFormat.format(easting)} ${doubleFormat.format(northing)}';
  }
}

class UTMZone {
  int lonZone;
  int lonZoneRegular; //the real lonZone differs from mathematical because of two special zones around norway
  String latZone;

  UTMZone(this.lonZoneRegular, this.lonZone, this.latZone);
}

class MGRS extends BaseCoordinate {

  UTMZone utmZone;
  String digraph;
  double easting;
  double northing;

  MGRS(this.utmZone, this.digraph, this.easting, this.northing) {
    _format = CoordinateFormat(CoordinateFormatKey.MGRS);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return mgrsToLatLon(this, ells);
  }

  static MGRS fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToMGRS(coord, ells);
  }

  static MGRS? parse(String text) {
    return parseMGRS(text);
  }

  @override
  String toString() {
    return '${utmZone.lonZone}${utmZone.latZone} $digraph ${doubleFormat.format(easting)} ${doubleFormat.format(northing)}';
  }
}

class SwissGrid extends BaseCoordinate {
  double easting;
  double northing;

  SwissGrid(this.easting, this.northing) {
    _format = CoordinateFormat(CoordinateFormatKey.SWISS_GRID);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return swissGridToLatLon(this, ells);
  }

  static SwissGrid fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToSwissGrid(coord, ells);
  }

  static SwissGrid? parse(String input) {
    return parseSwissGrid(input);
  }

  @override
  String toString() {
    return 'Y: $easting\nX: $northing';
  }
}

class SwissGridPlus extends SwissGrid {

  SwissGridPlus(double easting, double northing) : super(easting, northing) {
    _format = CoordinateFormat(CoordinateFormatKey.SWISS_GRID_PLUS);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return swissGridPlusToLatLon(this, ells);
  }

  static SwissGridPlus fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToSwissGridPlus(coord, ells);
  }

  static SwissGridPlus? parse(String input) {
    return parseSwissGridPlus(input);
  }
}

class DutchGrid extends BaseCoordinate {
  double x;
  double y;

  DutchGrid(this.x, this.y) {
    _format = CoordinateFormat(CoordinateFormatKey.DUTCH_GRID);
  }

  @override
  LatLng toLatLng() {
    return dutchGridToLatLon(this);
  }

  static DutchGrid fromLatLon(LatLng coord) {
    return latLonToDutchGrid(coord);
  }

  static DutchGrid? parse(String input) {
    return parseDutchGrid(input);
  }

  @override
  String toString() {
    return 'X: $x\nY: $y';
  }
}

class GaussKrueger extends BaseCoordinateWithSubtypes {
  double easting;
  double northing;

  static const String _ERROR_INVALID_SUBTYPE = 'No valid GaussKrueger subtype given.';

  GaussKrueger(CoordinateFormatKey subtypeKey, this.easting, this.northing) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtypeKey)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    _format = CoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtypeKey);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return gaussKruegerToLatLon(this, ells);
  }

  static GaussKrueger fromLatLon(LatLng coord, CoordinateFormatKey subtype, Ellipsoid ells) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return latLonToGaussKrueger(coord, subtype, ells);
  }

  static GaussKrueger? parse(String input, {CoordinateFormatKey subtype = defaultGaussKruegerType}) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.GAUSS_KRUEGER, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return parseGaussKrueger(input, gaussKruegerCode: subtype);
  }

  @override
  String toString() {
    return 'R: $easting\nH: $northing';
  }
}

class Lambert extends BaseCoordinateWithSubtypes {
  double easting;
  double northing;

  static const String _ERROR_INVALID_SUBTYPE = 'No valid Lambert subtype given.';

  Lambert(CoordinateFormatKey subtypeKey, this.easting, this.northing) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.LAMBERT, subtypeKey)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    _format = CoordinateFormat(CoordinateFormatKey.LAMBERT, subtypeKey);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return lambertToLatLon(this, ells);
  }

  static Lambert fromLatLon(LatLng coord, CoordinateFormatKey subtype, Ellipsoid ells) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.LAMBERT, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return latLonToLambert(coord, subtype, ells);
  }

  static Lambert? parse(String input, {CoordinateFormatKey subtype = defaultLambertType}) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.LAMBERT, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return parseLambert(input, subtype: subtype);
  }

  @override
  String toString() {
    return 'X: $easting\nY: $northing';
  }
}

class Mercator extends BaseCoordinate {
  double easting;
  double northing;

  Mercator(this.easting, this.northing) {
    _format = CoordinateFormat(CoordinateFormatKey.MERCATOR);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return mercatorToLatLon(this, ells);
  }

  static Mercator fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToMercator(coord, ells);
  }

  static Mercator? parse(String input) {
    return parseMercator(input);
  }

  @override
  String toString() {
    return 'Y: $easting\nX: $northing';
  }
}

class NaturalAreaCode extends BaseCoordinate {
  String x; //east
  String y; //north

  NaturalAreaCode(this.x, this.y) {
    _format = CoordinateFormat(CoordinateFormatKey.NATURAL_AREA_CODE);
  }

  @override
  LatLng toLatLng() {
    return naturalAreaCodeToLatLon(this);
  }

  static NaturalAreaCode fromLatLon(LatLng coord, [int precision = 8]) {
    return latLonToNaturalAreaCode(coord, precision: precision);
  }

  static NaturalAreaCode? parse(String input) {
    return parseNaturalAreaCode(input);
  }

  @override
  String toString() {
    return 'X: $x\nY: $y';
  }
}

class SlippyMap extends BaseCoordinateWithSubtypes {
  double x;
  double y;

  static const String _ERROR_INVALID_SUBTYPE = 'No valid SlippyMap subtype given.';

  SlippyMap(this.x, this.y, CoordinateFormatKey subtypeKey) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtypeKey)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    _format = CoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtypeKey);
  }

  @override
  LatLng toLatLng() {
    return slippyMapToLatLon(this);
  }

  static SlippyMap fromLatLon(LatLng coord, CoordinateFormatKey subtype) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return latLonToSlippyMap(coord, subtype);
  }

  static SlippyMap? parse(String input, {CoordinateFormatKey subtype = defaultSlippyMapType}) {
    if (!isSubtypeOfCoordinateFormat(CoordinateFormatKey.SLIPPY_MAP, subtype)) {
      throw Exception(_ERROR_INVALID_SUBTYPE);
    }

    return parseSlippyMap(input, subtype: subtype);
  }

  @override
  String toString() {
    return 'X: $x\nY: $y\nZoom: ${_format.subtype}';
  }
}

class ReverseWherigoWaldmeister extends BaseCoordinate {
  int a, b, c;

  ReverseWherigoWaldmeister(this.a, this.b, this.c) {
    _format = CoordinateFormat(CoordinateFormatKey.REVERSE_WIG_WALDMEISTER);
  }

  @override
  LatLng toLatLng() {
    return reverseWIGWaldmeisterToLatLon(this);
  }

  static ReverseWherigoWaldmeister fromLatLon(LatLng coord) {
    return latLonToReverseWIGWaldmeister(coord);
  }

  static ReverseWherigoWaldmeister? parse(String input) {
    return parseReverseWherigoWaldmeister(input);
  }

  String _leftPadComponent(int x) {
    return x.toString().padLeft(6, '0');
  }

  @override
  String toString() {
    return [a, b, c].map((e) => _leftPadComponent(e)).join('\n');
  }
}

class ReverseWherigoDay1976 extends BaseCoordinate {
  String s, t;

  ReverseWherigoDay1976(this.s, this.t) {
    _format = CoordinateFormat(CoordinateFormatKey.REVERSE_WIG_DAY1976);
  }

  @override
  LatLng toLatLng() {
    return reverseWIGDay1976ToLatLon(this);
  }

  static ReverseWherigoDay1976 fromLatLon(LatLng coord) {
    return latLonToReverseWIGDay1976(coord);
  }

  static ReverseWherigoDay1976? parse(String input) {
    return parseReverseWherigoDay1976(input);
  }

  @override
  String toString() {
    return '$s\n$t';
  }
}

class XYZ extends BaseCoordinate {
  double x, y, z;

  XYZ(this.x, this.y, this.z) {
    _format = CoordinateFormat(CoordinateFormatKey.XYZ);
  }

  @override
  LatLng toLatLng({Ellipsoid? ells}) {
    ells ??= defaultEllipsoid;
    return xyzToLatLon(this, ells);
  }

  static XYZ fromLatLon(LatLng coord, Ellipsoid ells, {double h = 0.0}) {
    return latLonToXYZ(coord, ells, h: h);
  }

  static XYZ? parse(String input) {
    return parseXYZ(input);
  }

  @override
  String toString() {
    var numberFormat = NumberFormat('0.######');
    return 'X: ${numberFormat.format(x)}\nY: ${numberFormat.format(y)}\nZ: ${numberFormat.format(z)}';
  }
}

class Maidenhead extends BaseCoordinate {
  String text;

  Maidenhead(this.text) {
    _format = CoordinateFormat(CoordinateFormatKey.MAIDENHEAD);
  }

  @override
  LatLng? toLatLng() {
    return maidenheadToLatLon(this);
  }

  static Maidenhead fromLatLon(LatLng coord) {
    return latLonToMaidenhead(coord);
  }

  static Maidenhead? parse(String input) {
    return parseMaidenhead(input);
  }

  @override
  String toString() {
    return text;
  }
}

class Makaney extends BaseCoordinate {
  String text;

  Makaney(this.text) {
    _format = CoordinateFormat(CoordinateFormatKey.MAKANEY);
  }

  @override
  LatLng? toLatLng() {
    return makaneyToLatLon(this);
  }

  static Makaney fromLatLon(LatLng coord) {
    return latLonToMakaney(coord);
  }

  static Makaney? parse(String input) {
    return parseMakaney(input);
  }

  @override
  String toString() {
    return text;
  }
}

class Geohash extends BaseCoordinate {
  String text;

  Geohash(this.text) {
    _format = CoordinateFormat(CoordinateFormatKey.GEOHASH);
  }

  @override
  LatLng? toLatLng() {
    return geohashToLatLon(this);
  }

  static Geohash fromLatLon(LatLng coord, [int geohashLength = 14]) {
    return latLonToGeohash(coord, geohashLength);
  }

  static Geohash? parse(String input) {
    return parseGeohash(input);
  }

  @override
  String toString() {
    return text;
  }
}

class GeoHex extends BaseCoordinate {
  String text;

  GeoHex(this.text) {
    _format = CoordinateFormat(CoordinateFormatKey.GEOHEX);
  }

  @override
  LatLng? toLatLng() {
    return geoHexToLatLon(this);
  }

  static GeoHex fromLatLon(LatLng coord, [int precision = 20]) {
    return latLonToGeoHex(coord, precision);
  }

  static GeoHex? parse(String input) {
    return parseGeoHex(input);
  }

  @override
  String toString() {
    return text;
  }
}

class Geo3x3 extends BaseCoordinate {
  String text;

  Geo3x3(this.text) {
    _format = CoordinateFormat(CoordinateFormatKey.GEO3X3);
  }

  @override
  LatLng? toLatLng() {
    return geo3x3ToLatLon(this);
  }

  static Geo3x3 fromLatLon(LatLng coord, [int level = 20]) {
    return latLonToGeo3x3(coord, level);
  }

  static Geo3x3? parse(String input) {
    return parseGeo3x3(input);
  }

  @override
  String toString() {
    return text.toUpperCase();
  }
}

class OpenLocationCode extends BaseCoordinate {
  String text;

  OpenLocationCode(this.text) {
    _format = CoordinateFormat(CoordinateFormatKey.OPEN_LOCATION_CODE);
  }

  @override
  LatLng? toLatLng() {
    return openLocationCodeToLatLon(this);
  }

  static OpenLocationCode fromLatLon(LatLng coord, [int codeLength = 14]) {
    return latLonToOpenLocationCode(coord, codeLength: codeLength);
  }

  static OpenLocationCode? parse(String input) {
    return parseOpenLocationCode(input);
  }

  @override
  String toString() {
    return text;
  }
}

class Quadtree extends BaseCoordinate {
  List<int> coords;

  Quadtree(this.coords) {
    _format = CoordinateFormat(CoordinateFormatKey.QUADTREE);
  }

  @override
  LatLng toLatLng() {
    return quadtreeToLatLon(this);
  }

  static Quadtree? parse(String input) {
    return parseQuadtree(input);
  }

  static Quadtree fromLatLon(LatLng coord, [int precision = 40]) {
    return latLonToQuadtree(coord, precision: precision);
  }

  @override
  String toString() {
    return coords.join();
  }
}

BaseCoordinate buildUninitializedCoordinateByFormat(CoordinateFormat format) {
  if (isCoordinateFormatWithSubtype(format.type)) {
    if (format.subtype == null || !isSubtypeOfCoordinateFormat(format.type, format.subtype!)) {
      format.subtype = defaultCoordinateFormatSubtypeForFormat(format.type);
    }
  }

  switch (format.type) {
    case CoordinateFormatKey.DEC:
      return DEC(0.0, 0.0);
    case CoordinateFormatKey.DMM:
      return DMM(DMMLatitude(0,0,0), DMMLongitude(0,0,0));
    case CoordinateFormatKey.DMS:
      return DMS(DMSLatitude(0,0,0,0), DMSLongitude(0,0,0,0));
    case CoordinateFormatKey.UTM:
      return UTMREF(UTMZone(0,0,'U'), 0,0);
    case CoordinateFormatKey.MGRS:
      return MGRS(UTMZone(0,0,'A'), 'AA', 0,0);
    case CoordinateFormatKey.XYZ:
      return XYZ(0,0,0);
    case CoordinateFormatKey.SWISS_GRID:
      return SwissGrid(0,0);
    case CoordinateFormatKey.SWISS_GRID_PLUS:
      return SwissGridPlus(0,0);
    case CoordinateFormatKey.DUTCH_GRID:
      return DutchGrid(0,0);
    case CoordinateFormatKey.GAUSS_KRUEGER:
      return GaussKrueger(defaultGaussKruegerType, 0,0);
    case CoordinateFormatKey.LAMBERT:
      return Lambert(defaultLambertType, 0,0);
    case CoordinateFormatKey.MAIDENHEAD:
      return Maidenhead('');
    case CoordinateFormatKey.MERCATOR:
      return Mercator(0,0);
    case CoordinateFormatKey.NATURAL_AREA_CODE:
      return NaturalAreaCode('','');
    case CoordinateFormatKey.SLIPPY_MAP:
      return SlippyMap(0,0,defaultSlippyMapType);
    case CoordinateFormatKey.GEOHASH:
      return Geohash('');
    case CoordinateFormatKey.GEO3X3:
      return Geo3x3('');
    case CoordinateFormatKey.GEOHEX:
      return GeoHex('');
    case CoordinateFormatKey.OPEN_LOCATION_CODE:
      return OpenLocationCode('');
    case CoordinateFormatKey.MAKANEY:
      return Makaney('');
    case CoordinateFormatKey.QUADTREE:
      return Quadtree([]);
    case CoordinateFormatKey.REVERSE_WIG_WALDMEISTER:
      return ReverseWherigoWaldmeister(0,0,0);
    case CoordinateFormatKey.REVERSE_WIG_DAY1976:
      return ReverseWherigoDay1976('00000','00000');
    default:
      return buildDefaultCoordinateByCoordinates(defaultCoordinate);
  }
}

BaseCoordinate buildDefaultCoordinateByCoordinates(LatLng coords) {
  return buildCoordinate(defaultCoordinateFormat, coords, defaultEllipsoid);
}

BaseCoordinate buildCoordinate(CoordinateFormat format, LatLng coords, [Ellipsoid? ellipsoid]) {
  if (isCoordinateFormatWithSubtype(format.type)) {
    if (format.subtype == null || !isSubtypeOfCoordinateFormat(format.type, format.subtype!)) {
      format.subtype = defaultCoordinateFormatSubtypeForFormat(format.type);
    }
  }
  
  ellipsoid ??= defaultEllipsoid;

  switch (format.type) {
    case CoordinateFormatKey.DEC:
      return DEC.fromLatLon(coords);
    case CoordinateFormatKey.DMM:
      return DMM.fromLatLon(coords);
    case CoordinateFormatKey.DMS:
      return DMS.fromLatLon(coords);
    case CoordinateFormatKey.UTM:
      return UTMREF.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.MGRS:
      return MGRS.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.XYZ:
      return XYZ.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.SWISS_GRID:
      return SwissGrid.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.SWISS_GRID_PLUS:
      return SwissGridPlus.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.DUTCH_GRID:
      return DutchGrid.fromLatLon(coords);
    case CoordinateFormatKey.GAUSS_KRUEGER:
      return GaussKrueger.fromLatLon(coords, format.subtype!, ellipsoid);
    case CoordinateFormatKey.LAMBERT:
      return Lambert.fromLatLon(coords, format.subtype!, ellipsoid);
    case CoordinateFormatKey.MAIDENHEAD:
      return Maidenhead.fromLatLon(coords);
    case CoordinateFormatKey.MERCATOR:
      return Mercator.fromLatLon(coords, ellipsoid);
    case CoordinateFormatKey.NATURAL_AREA_CODE:
      return NaturalAreaCode.fromLatLon(coords);
    case CoordinateFormatKey.SLIPPY_MAP:
      return SlippyMap.fromLatLon(coords, format.subtype!);
    case CoordinateFormatKey.GEOHASH:
      return Geohash.fromLatLon(coords);
    case CoordinateFormatKey.GEO3X3:
      return Geo3x3.fromLatLon(coords);
    case CoordinateFormatKey.GEOHEX:
      return GeoHex.fromLatLon(coords);
    case CoordinateFormatKey.OPEN_LOCATION_CODE:
      return OpenLocationCode.fromLatLon(coords);
    case CoordinateFormatKey.MAKANEY:
      return Makaney.fromLatLon(coords);
    case CoordinateFormatKey.QUADTREE:
      return Quadtree.fromLatLon(coords);
    case CoordinateFormatKey.REVERSE_WIG_WALDMEISTER:
      return ReverseWherigoWaldmeister.fromLatLon(coords);
    case CoordinateFormatKey.REVERSE_WIG_DAY1976:
      return ReverseWherigoDay1976.fromLatLon(coords);
    default:
      return buildDefaultCoordinateByCoordinates(coords);
  }
}
