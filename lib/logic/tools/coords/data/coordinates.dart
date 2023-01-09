import 'dart:math';

import 'package:gc_wizard/logic/tools/coords/converter/dec.dart';
import 'package:gc_wizard/logic/tools/coords/converter/dmm.dart';
import 'package:gc_wizard/logic/tools/coords/converter/dms.dart';
import 'package:gc_wizard/logic/tools/coords/converter/dutchgrid.dart';
import 'package:gc_wizard/logic/tools/coords/converter/gauss_krueger.dart';
import 'package:gc_wizard/logic/tools/coords/converter/geo3x3.dart';
import 'package:gc_wizard/logic/tools/coords/converter/geohash.dart';
import 'package:gc_wizard/logic/tools/coords/converter/geohex.dart';
import 'package:gc_wizard/logic/tools/coords/converter/lambert.dart';
import 'package:gc_wizard/logic/tools/coords/converter/maidenhead.dart';
import 'package:gc_wizard/logic/tools/coords/converter/makaney.dart';
import 'package:gc_wizard/logic/tools/coords/converter/mercator.dart';
import 'package:gc_wizard/logic/tools/coords/converter/mgrs.dart';
import 'package:gc_wizard/logic/tools/coords/converter/natural_area_code.dart';
import 'package:gc_wizard/logic/tools/coords/converter/open_location_code.dart';
import 'package:gc_wizard/logic/tools/coords/converter/quadtree.dart';
import 'package:gc_wizard/logic/tools/coords/converter/reverse_wherigo_day1976.dart';
import 'package:gc_wizard/logic/tools/coords/converter/reverse_wherigo_waldmeister.dart';
import 'package:gc_wizard/logic/tools/coords/converter/slippy_map.dart';
import 'package:gc_wizard/logic/tools/coords/converter/swissgrid.dart';
import 'package:gc_wizard/logic/tools/coords/converter/utm.dart';
import 'package:gc_wizard/logic/tools/coords/converter/xyz.dart';
import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:gc_wizard/logic/tools/coords/utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/widgets/tools/coords/base/utils.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

const keyCoordsALL = 'coords_all';
const keyCoordsDEC = 'coords_dec';
const keyCoordsDMM = 'coords_dmm';
const keyCoordsDMS = 'coords_dms';
const keyCoordsUTM = 'coords_utm';
const keyCoordsMGRS = 'coords_mgrs';
const keyCoordsXYZ = 'coords_xyz';
const keyCoordsSwissGrid = 'coords_swissgrid';
const keyCoordsSwissGridPlus = 'coords_swissgridplus';
const keyCoordsDutchGrid = 'coords_dutchgrid';
const keyCoordsGaussKrueger = 'coords_gausskrueger';
const keyCoordsGaussKruegerGK1 = 'coords_gausskrueger_gk1';
const keyCoordsGaussKruegerGK2 = 'coords_gausskrueger_gk2';
const keyCoordsGaussKruegerGK3 = 'coords_gausskrueger_gk3';
const keyCoordsGaussKruegerGK4 = 'coords_gausskrueger_gk4';
const keyCoordsGaussKruegerGK5 = 'coords_gausskrueger_gk5';
const keyCoordsLambert = 'coords_lambert';
const keyCoordsLambert93 = 'coords_lambert_93';
const keyCoordsLambert2008 = 'coords_lambert_2008';
const keyCoordsLambertETRS89LCC = 'coords_lambert_etrs89lcc';
const keyCoordsLambert72 = 'coords_lambert_72';
const keyCoordsLambert93CC42 = 'coords_lambert_93_cc42';
const keyCoordsLambert93CC43 = 'coords_lambert_93_cc43';
const keyCoordsLambert93CC44 = 'coords_lambert_93_cc44';
const keyCoordsLambert93CC45 = 'coords_lambert_93_cc45';
const keyCoordsLambert93CC46 = 'coords_lambert_93_cc46';
const keyCoordsLambert93CC47 = 'coords_lambert_93_cc47';
const keyCoordsLambert93CC48 = 'coords_lambert_93_cc48';
const keyCoordsLambert93CC49 = 'coords_lambert_93_cc49';
const keyCoordsLambert93CC50 = 'coords_lambert_93_cc50';
const keyCoordsMaidenhead = 'coords_maidenhead';
const keyCoordsMercator = 'coords_mercator';
const keyCoordsNaturalAreaCode = 'coords_naturalareacode';
const keyCoordsSlippyMap = 'coords_slippymap';
const keyCoordsGeohash = 'coords_geohash';
const keyCoordsGeoHex = 'coords_geohex';
const keyCoordsGeo3x3 = 'coords_geo3x3';
const keyCoordsOpenLocationCode = 'coords_openlocationcode';
const keyCoordsMakaney = 'coords_makaney';
const keyCoordsQuadtree = 'coords_quadtree';
const keyCoordsReverseWherigoWaldmeister = 'coords_reversewhereigo_waldmeister'; // typo known. DO NOT change!
const keyCoordsReverseWherigoDay1976 = 'coords_reversewhereigo_day1976';

class CoordinateFormat {
  final key;
  String name;
  List<CoordinateFormat> subtypes;
  String example;

  CoordinateFormat(this.key, this.name, this.example, {this.subtypes});
}

List<CoordinateFormat> allCoordFormats = [
  CoordinateFormat(keyCoordsDEC, 'DEC: DD.DDD°', '45.29100, -122.41333'),
  CoordinateFormat(keyCoordsDMM, 'DMM: DD° MM.MMM\'', 'N 45° 17.460\' W 122° 24.800\''),
  CoordinateFormat(keyCoordsDMS, 'DMS: DD° MM\' SS.SSS"', 'N 45° 17\' 27.60" W 122° 24\' 48.00"'),
  CoordinateFormat(keyCoordsUTM, 'UTM', '10 N 546003.6 5015445.0'),
  CoordinateFormat(keyCoordsMGRS, 'MGRS', '10T ER 46003.6 15445.0'),
  CoordinateFormat(keyCoordsXYZ, 'XYZ (ECEF)', 'X: -2409244, Y: -3794410, Z: 4510158'),
  CoordinateFormat(keyCoordsSwissGrid, 'SwissGrid (CH1903/LV03)', 'Y: 720660.2, X: 167765.3'),
  CoordinateFormat(keyCoordsSwissGridPlus, 'SwissGrid (CH1903+/LV95)', 'Y: 2720660.2, X: 1167765.3'),
  CoordinateFormat(keyCoordsGaussKrueger, 'coords_formatconverter_gausskrueger', 'R: 8837763.4, H: 5978799.1',
      subtypes: [
        CoordinateFormat(
            keyCoordsGaussKruegerGK1, 'coords_formatconverter_gausskrueger_gk1', 'R: 8837763.4, H: 5978799.1'),
        CoordinateFormat(
            keyCoordsGaussKruegerGK2, 'coords_formatconverter_gausskrueger_gk2', 'R: 8837739.4, H: 5978774.5'),
        CoordinateFormat(
            keyCoordsGaussKruegerGK3, 'coords_formatconverter_gausskrueger_gk3', 'R: 8837734.7, H: 5978798.2'),
        CoordinateFormat(
            keyCoordsGaussKruegerGK4, 'coords_formatconverter_gausskrueger_gk4', 'R: 8837790.8, H: 5978787.4'),
        CoordinateFormat(
            keyCoordsGaussKruegerGK5, 'coords_formatconverter_gausskrueger_gk5', 'R: 8837696.4, H: 5978779.5'),
      ]),
  CoordinateFormat(keyCoordsLambert, 'coords_formatconverter_lambert', 'X: 8837763.4, Y: 5978799.1', subtypes: [
    CoordinateFormat(keyCoordsLambert93, 'coords_formatconverter_lambert_93', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert2008, 'coords_formatconverter_lambert_2008', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(
        keyCoordsLambertETRS89LCC, 'coords_formatconverter_lambert_etrs89lcc', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert72, 'coords_formatconverter_lambert_72', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC42, 'coords_formatconverter_lambert_l93cc42', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC43, 'coords_formatconverter_lambert_l93cc43', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC44, 'coords_formatconverter_lambert_l93cc44', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC45, 'coords_formatconverter_lambert_l93cc45', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC46, 'coords_formatconverter_lambert_l93cc46', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC47, 'coords_formatconverter_lambert_l93cc47', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC48, 'coords_formatconverter_lambert_l93cc48', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC49, 'coords_formatconverter_lambert_l93cc49', 'X: 8837763.4, Y: 5978799.1'),
    CoordinateFormat(keyCoordsLambert93CC50, 'coords_formatconverter_lambert_l93cc50', 'X: 8837763.4, Y: 5978799.1'),
  ]),
  CoordinateFormat(keyCoordsDutchGrid, 'RD (Rijksdriehoeks, DutchGrid)', 'X: 221216.7, Y: 550826.2'),
  CoordinateFormat(keyCoordsMaidenhead, 'Maidenhead Locator (QTH)', 'CN85TG09JU'),
  CoordinateFormat(keyCoordsMercator, 'Mercator', 'Y: 5667450.4, X: -13626989.9'),
  CoordinateFormat(keyCoordsNaturalAreaCode, 'Natural Area Code (NAC)', 'X: 4RZ000, Y: QJFMGZ'),
  CoordinateFormat(keyCoordsOpenLocationCode, 'OpenLocationCode (OLC, PlusCode)', '84QV7HRP+CM3'),
  CoordinateFormat(keyCoordsSlippyMap, 'Slippy Map Tiles', 'Z: 15, X: 5241, Y: 11749'),
  CoordinateFormat(keyCoordsReverseWherigoWaldmeister, 'Reverse Wherigo (Waldmeister)', '042325, 436113, 935102'),
  CoordinateFormat(keyCoordsReverseWherigoDay1976, 'Reverse Wherigo (Day1976)', '3f8f1, z4ee4'),
  CoordinateFormat(keyCoordsGeohash, 'Geohash', 'c20cwkvr4'),
  CoordinateFormat(keyCoordsQuadtree, 'Quadtree', '021230223311203323'),
  CoordinateFormat(keyCoordsMakaney, 'Makaney (MKC)', 'M97F-BBOOI'),
  CoordinateFormat(keyCoordsGeoHex, 'GeoHex', 'RU568425483853568'),
  CoordinateFormat(keyCoordsGeo3x3, 'Geo3x3', 'W7392967941169'),
];

CoordinateFormat getCoordinateFormatByKey(String key) {
  return allCoordFormats.firstWhere((format) => format.key == key);
}

final defaultCoordinate = LatLng(0.0, 0.0);

abstract class BaseCoordinates {
  String get key;

  LatLng toLatLng();

  bool isDefault() {
    var latlon = toLatLng();
    return latlon.latitude == 0.0 && latlon.longitude == 0.0;
  }
}

String _dmmAndDMSNumberFormat([int precision = 6]) {
  var formatString = '00.';
  if (precision == null) precision = 6;
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

class DEC extends BaseCoordinates {
  String get key => keyCoordsDEC;
  double latitude;
  double longitude;

  DEC(this.latitude, this.longitude);

  LatLng toLatLng() {
    return decToLatLon(this);
  }

  static DEC fromLatLon(LatLng coord) {
    return latLonToDEC(coord);
  }

  static DEC parse(String input, {wholeString = false}) {
    return parseDEC(input, wholeString: wholeString);
  }

  @override
  String toString([int precision]) {
    if (precision == null) precision = 10;
    if (precision < 1) precision = 1;

    String fixedDigits = '0' * min(precision, 3);
    String variableDigits = precision > 3 ? '#' * (precision - 3) : '';

    return '${NumberFormat('00.' + fixedDigits + variableDigits).format(latitude)}\n${NumberFormat('000.' + fixedDigits + variableDigits).format(longitude)}';
  }
}

class DMMPart {
  String get key => keyCoordsDMM;
  int sign;
  int degrees;
  double minutes;

  DMMPart(this.sign, this.degrees, this.minutes);

  Map<String, dynamic> _formatParts(bool isLatitude, [int precision]) {
    var _minutesStr = NumberFormat(_dmmAndDMSNumberFormat(precision)).format(minutes);
    var _degrees = degrees;
    var _sign = _getCoordinateSignString(sign, isLatitude);

    //Values like 59.999999999' may be rounded to 60.0. So in that case,
    //the degree has to be increased while minutes should be set to 0.0
    if (_minutesStr.startsWith('60')) {
      _minutesStr = '00.000';
      _degrees += 1;
    }

    var _degreesStr = _degrees.toString().padLeft(isLatitude ? 2 : 3, '0');

    return {
      'sign': {'value': sign, 'formatted': _sign},
      'degrees': _degreesStr,
      'minutes': _minutesStr
    };
  }

  String _format(bool isLatitude, [int precision]) {
    var formattedParts = _formatParts(isLatitude, precision);

    return formattedParts['sign']['formatted'] +
        ' ' +
        formattedParts['degrees'] +
        '° ' +
        formattedParts['minutes'] +
        '\'';
  }

  @override
  String toString() {
    return 'sign: $sign, degrees: $degrees, minutes: $minutes';
  }
}

class DMMLatitude extends DMMPart {
  DMMLatitude(sign, degrees, minutes) : super(sign, degrees, minutes);

  static DMMLatitude from(DMMPart dmmPart) {
    return DMMLatitude(dmmPart.sign, dmmPart.degrees, dmmPart.minutes);
  }

  Map<String, dynamic> formatParts([int precision]) {
    return super._formatParts(true, precision);
  }

  String format([int precision]) {
    return super._format(true, precision);
  }
}

class DMMLongitude extends DMMPart {
  DMMLongitude(sign, degrees, minutes) : super(sign, degrees, minutes);

  static DMMLongitude from(DMMPart dmmPart) {
    return DMMLongitude(dmmPart.sign, dmmPart.degrees, dmmPart.minutes);
  }

  Map<String, dynamic> formatParts([int precision]) {
    return super._formatParts(false, precision);
  }

  String format([int precision]) {
    return super._format(false, precision);
  }
}

class DMM extends BaseCoordinates {
  String get key => keyCoordsDMM;
  DMMLatitude latitude;
  DMMLongitude longitude;

  DMM(this.latitude, this.longitude);

  LatLng toLatLng() {
    return dmmToLatLon(this);
  }

  static DMM fromLatLon(LatLng coord) {
    return latLonToDMM(coord);
  }

  static DMM parse(String text, {leftPadMilliMinutes: false, wholeString: false}) {
    return parseDMM(text, leftPadMilliMinutes: leftPadMilliMinutes, wholeString: wholeString);
  }

  @override
  String toString([int precision]) {
    return '${latitude.format(precision)}\n${longitude.format(precision)}';
  }
}

class DMSPart {
  int sign;
  int degrees;
  int minutes;
  double seconds;

  DMSPart(this.sign, this.degrees, this.minutes, this.seconds);

  Map<String, dynamic> _formatParts(bool isLatitude, [int precision]) {
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

    return {
      'sign': {'value': sign, 'formatted': _sign},
      'degrees': _degreesStr,
      'minutes': _minutesStr,
      'seconds': _secondsStr
    };
  }

  String _format(bool isLatitude, [int precision]) {
    var formattedParts = _formatParts(isLatitude, precision);

    return formattedParts['sign']['formatted'] +
        ' ' +
        formattedParts['degrees'] +
        '° ' +
        formattedParts['minutes'] +
        '\' ' +
        formattedParts['seconds'] +
        '"';
  }

  @override
  String toString() {
    return 'sign: $sign, degrees: $degrees, minutes: $minutes, seconds: $seconds';
  }
}

class DMSLatitude extends DMSPart {
  DMSLatitude(sign, degrees, minutes, seconds) : super(sign, degrees, minutes, seconds);

  static DMSLatitude from(DMSPart dmsPart) {
    return DMSLatitude(dmsPart.sign, dmsPart.degrees, dmsPart.minutes, dmsPart.seconds);
  }

  Map<String, dynamic> formatParts([int precision]) {
    return super._formatParts(true, precision);
  }

  String format([int precision]) {
    return super._format(true, precision);
  }
}

class DMSLongitude extends DMSPart {
  DMSLongitude(sign, degrees, minutes, seconds) : super(sign, degrees, minutes, seconds);

  static DMSLongitude from(DMSPart dmsPart) {
    return DMSLongitude(dmsPart.sign, dmsPart.degrees, dmsPart.minutes, dmsPart.seconds);
  }

  Map<String, dynamic> formatParts([int precision]) {
    return super._formatParts(false, precision);
  }

  String format([int precision]) {
    return super._format(false, precision);
  }
}

class DMS extends BaseCoordinates {
  String get key => keyCoordsDMS;
  DMSLatitude latitude;
  DMSLongitude longitude;

  DMS(this.latitude, this.longitude);

  LatLng toLatLng() {
    return dmsToLatLon(this);
  }

  static DMS fromLatLon(LatLng coord) {
    return latLonToDMS(coord);
  }

  static DMS parse(String input, {wholeString = false}) {
    return parseDMS(input, wholeString: wholeString);
  }

  @override
  String toString([int precision]) {
    return '${latitude.format(precision)}\n${longitude.format(precision)}';
  }
}

enum HemisphereLatitude { North, South }

enum HemisphereLongitude { East, West }

// UTM with latitude Zones; Normal UTM is only separated into Hemispheres N and S
class UTMREF extends BaseCoordinates {
  String get key => keyCoordsUTM;
  UTMZone zone;
  double easting;
  double northing;

  UTMREF(this.zone, this.easting, this.northing);

  get hemisphere {
    return 'NPQRSTUVWXYZ'.contains(zone.latZone) ? HemisphereLatitude.North : HemisphereLatitude.South;
  }

  LatLng toLatLng({Ellipsoid ells}) {
    if (ells == null) ells = defaultEllipsoid();
    return UTMREFtoLatLon(this, ells);
  }

  static UTMREF fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToUTM(coord, ells);
  }

  static UTMREF parse(String input) {
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

class MGRS extends BaseCoordinates {
  String get key => keyCoordsMGRS;
  UTMZone utmZone;
  String digraph;
  double easting;
  double northing;

  MGRS(this.utmZone, this.digraph, this.easting, this.northing);

  LatLng toLatLng({Ellipsoid ells}) {
    if (ells == null) ells = defaultEllipsoid();
    return mgrsToLatLon(this, ells);
  }

  static MGRS fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToMGRS(coord, ells);
  }

  static MGRS parse(String text) {
    return parseMGRS(text);
  }

  @override
  String toString() {
    return '${utmZone.lonZone}${utmZone.latZone} $digraph ${doubleFormat.format(easting)} ${doubleFormat.format(northing)}';
  }
}

class SwissGrid extends BaseCoordinates {
  String get key => keyCoordsSwissGrid;
  double easting;
  double northing;

  SwissGrid(this.easting, this.northing);

  LatLng toLatLng({Ellipsoid ells}) {
    if (ells == null) ells = defaultEllipsoid();
    return swissGridToLatLon(this, ells);
  }

  static SwissGrid fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToSwissGrid(coord, ells);
  }

  static SwissGrid parse(String input) {
    return parseSwissGrid(input);
  }

  @override
  String toString() {
    return 'Y: $easting\nX: $northing';
  }
}

class SwissGridPlus extends SwissGrid {
  String get key => keyCoordsSwissGridPlus;

  SwissGridPlus(easting, northing) : super(easting, northing);

  LatLng toLatLng({Ellipsoid ells}) {
    if (ells == null) ells = defaultEllipsoid();
    return swissGridPlusToLatLon(this, ells);
  }

  @override
  static SwissGridPlus fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToSwissGridPlus(coord, ells);
  }

  @override
  static SwissGridPlus parse(String input) {
    return parseSwissGridPlus(input);
  }
}

class DutchGrid extends BaseCoordinates {
  String get key => keyCoordsDutchGrid;
  double x;
  double y;

  DutchGrid(this.x, this.y);

  LatLng toLatLng() {
    return dutchGridToLatLon(this);
  }

  static DutchGrid fromLatLon(LatLng coord) {
    return latLonToDutchGrid(coord);
  }

  static DutchGrid parse(String input) {
    return parseDutchGrid(input);
  }

  @override
  String toString() {
    return 'X: $x\nY: $y';
  }
}

class GaussKrueger extends BaseCoordinates {
  String get key => keyCoordsGaussKrueger;
  int code;
  double easting;
  double northing;

  GaussKrueger(this.code, this.easting, this.northing);

  LatLng toLatLng({Ellipsoid ells}) {
    if (ells == null) ells = defaultEllipsoid();
    return gaussKruegerToLatLon(this, ells);
  }

  static GaussKrueger fromLatLon(LatLng coord, int gkno, Ellipsoid ells) {
    return latLonToGaussKrueger(coord, gkno, ells);
  }

  static GaussKrueger parse(String input, {gaussKruegerCode: DefaultGaussKruegerType}) {
    return parseGaussKrueger(input, gaussKruegerCode: gaussKruegerCode);
  }

  @override
  String toString() {
    return 'R: $easting\nH: $northing';
  }
}

class Lambert extends BaseCoordinates {
  String get key => keyCoordsLambert;
  LambertType type;
  double easting;
  double northing;

  Lambert(this.type, this.easting, this.northing);

  LatLng toLatLng({Ellipsoid ells}) {
    if (ells == null) ells = defaultEllipsoid();
    return lambertToLatLon(this, ells);
  }

  static Lambert fromLatLon(LatLng coord, LambertType type, Ellipsoid ells) {
    return latLonToLambert(coord, type, ells);
  }

  static Lambert parse(String input, {type: DefaultLambertType}) {
    return parseLambert(input, type: type);
  }

  @override
  String toString() {
    return 'X: $easting\nY: $northing';
  }
}

class Mercator extends BaseCoordinates {
  String get key => keyCoordsMercator;
  double easting;
  double northing;

  Mercator(this.easting, this.northing);

  LatLng toLatLng({Ellipsoid ells}) {
    if (ells == null) ells = defaultEllipsoid();
    return mercatorToLatLon(this, ells);
  }

  static Mercator fromLatLon(LatLng coord, Ellipsoid ells) {
    return latLonToMercator(coord, ells);
  }

  static Mercator parse(String input) {
    return parseMercator(input);
  }

  @override
  String toString() {
    return 'Y: $easting\nX: $northing';
  }
}

class NaturalAreaCode extends BaseCoordinates {
  String get key => keyCoordsNaturalAreaCode;
  String x; //east
  String y; //north

  NaturalAreaCode(this.x, this.y);

  LatLng toLatLng() {
    return naturalAreaCodeToLatLon(this);
  }

  static NaturalAreaCode fromLatLon(LatLng coord, {int precision}) {
    return latLonToNaturalAreaCode(coord, precision: precision);
  }

  static NaturalAreaCode parse(String input) {
    return parseNaturalAreaCode(input);
  }

  @override
  String toString() {
    return 'X: $x\nY: $y';
  }
}

class SlippyMap extends BaseCoordinates {
  String get key => keyCoordsSlippyMap;
  double x;
  double y;
  double zoom;

  SlippyMap(this.x, this.y, this.zoom);

  LatLng toLatLng() {
    return slippyMapToLatLon(this);
  }

  static SlippyMap fromLatLon(LatLng coord, double zoom) {
    return latLonToSlippyMap(coord, zoom);
  }

  static SlippyMap parse(String input, {zoom: DefaultSlippyZoom}) {
    return parseSlippyMap(input, zoom: zoom);
  }

  @override
  String toString() {
    return 'X: $x\nY: $y\nZoom: $zoom';
  }
}

class ReverseWherigoWaldmeister extends BaseCoordinates {
  String get key => keyCoordsReverseWherigoWaldmeister;
  String a, b, c;

  ReverseWherigoWaldmeister(this.a, this.b, this.c);

  LatLng toLatLng() {
    return reverseWIGWaldmeisterToLatLon(this);
  }

  static ReverseWherigoWaldmeister fromLatLon(LatLng coord) {
    return latLonToReverseWIGWaldmeister(coord);
  }

  static ReverseWherigoWaldmeister parse(String input) {
    return parseReverseWherigoWaldmeister(input);
  }

  @override
  String toString() {
    return '$a\n$b\n$c';
  }
}

class ReverseWherigoDay1976 extends BaseCoordinates {
  String get key => keyCoordsReverseWherigoDay1976;
  String s, t;

  ReverseWherigoDay1976(this.s, this.t);

  LatLng toLatLng() {
    return reverseWIGDay1976ToLatLon(this);
  }

  static ReverseWherigoDay1976 fromLatLon(LatLng coord) {
    return latLonToReverseWIGDay1976(coord);
  }

  static ReverseWherigoDay1976 parse(String input) {
    return parseReverseWherigoDay1976(input);
  }

  @override
  String toString() {
    return '$s\n$t';
  }
}

class XYZ extends BaseCoordinates {
  String get key => keyCoordsXYZ;
  double x, y, z;

  XYZ(this.x, this.y, this.z);

  LatLng toLatLng({Ellipsoid ells}) {
    if (ells == null) ells = defaultEllipsoid();
    return xyzToLatLon(this, ells);
  }

  static XYZ fromLatLon(LatLng coord, Ellipsoid ells, {double h: 0.0}) {
    return latLonToXYZ(coord, ells, h: h);
  }

  static XYZ parse(String input) {
    return parseXYZ(input);
  }

  @override
  String toString() {
    var numberFormat = NumberFormat('0.######');
    return 'X: ${numberFormat.format(x)}\nY: ${numberFormat.format(y)}\nZ: ${numberFormat.format(z)}';
  }
}

class Maidenhead extends BaseCoordinates {
  String get key => keyCoordsMaidenhead;
  String text;

  Maidenhead(this.text);

  LatLng toLatLng() {
    return maidenheadToLatLon(this);
  }

  static Maidenhead fromLatLon(LatLng coord) {
    return latLonToMaidenhead(coord);
  }

  static Maidenhead parse(String input) {
    return parseMaidenhead(input);
  }

  @override
  String toString() {
    return text;
  }
}

class Makaney extends BaseCoordinates {
  String get key => keyCoordsMakaney;
  String text;

  Makaney(this.text);

  LatLng toLatLng() {
    return makaneyToLatLon(this);
  }

  static Makaney fromLatLon(LatLng coord) {
    return latLonToMakaney(coord);
  }

  static Makaney parse(String input) {
    return parseMakaney(input);
  }

  @override
  String toString() {
    return text;
  }
}

class Geohash extends BaseCoordinates {
  String get key => keyCoordsGeohash;
  String text;

  Geohash(this.text);

  LatLng toLatLng() {
    return geohashToLatLon(this);
  }

  static Geohash fromLatLon(LatLng coord, int geohashLength) {
    return latLonToGeohash(coord, geohashLength);
  }

  static Geohash parse(String input) {
    return parseGeohash(input);
  }

  @override
  String toString() {
    return text;
  }
}

class GeoHex extends BaseCoordinates {
  String get key => keyCoordsGeoHex;
  String text;

  GeoHex(this.text);

  LatLng toLatLng() {
    return geoHexToLatLon(this);
  }

  static GeoHex fromLatLon(LatLng coord, int precision) {
    return latLonToGeoHex(coord, precision);
  }

  static GeoHex parse(String input) {
    return parseGeoHex(input);
  }

  @override
  String toString() {
    return text;
  }
}

class Geo3x3 extends BaseCoordinates {
  String get key => keyCoordsGeo3x3;
  String text;

  Geo3x3(this.text);

  LatLng toLatLng() {
    return geo3x3ToLatLon(this);
  }

  static Geo3x3 fromLatLon(LatLng coord, int level) {
    return latLonToGeo3x3(coord, level);
  }

  static Geo3x3 parse(String input) {
    return parseGeo3x3(input);
  }

  @override
  String toString() {
    return text.toUpperCase();
  }
}

class OpenLocationCode extends BaseCoordinates {
  String get key => keyCoordsOpenLocationCode;
  String text;

  OpenLocationCode(this.text);

  LatLng toLatLng() {
    return openLocationCodeToLatLon(this);
  }

  static OpenLocationCode fromLatLon(LatLng coord, {int codeLength}) {
    return latLonToOpenLocationCode(coord, codeLength: codeLength);
  }

  static OpenLocationCode parse(String input) {
    return parseOpenLocationCode(input);
  }

  @override
  String toString() {
    return text;
  }
}

class Quadtree extends BaseCoordinates {
  String get key => keyCoordsQuadtree;
  List<int> coords;

  Quadtree(this.coords);

  LatLng toLatLng() {
    return quadtreeToLatLon(this);
  }

  static Quadtree parse(String input) {
    return parseQuadtree(input);
  }

  static Quadtree fromLatLon(LatLng coord, {int precision}) {
    return latLonToQuadtree(coord, precision: precision);
  }

  @override
  String toString() {
    return coords.join();
  }
}
