import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

const PATTERN_NO_NUMBERS = r'\s+?';
const PATTERN_NOTHING_OR_NO_NUMBERS = r'\s*?';
const PATTERN_LAT_SIGN = r'([NS][A-Za-zÄÖÜäöü]*?|[\+\-])';
const PATTERN_LON_SIGN = r'([EWO][A-Za-zÄÖÜäöü]*?|[\+\-])';
const PATTERN_LON_SIGN_WITH_SPACE = '(?:\\s+?$PATTERN_LON_SIGN)?';
const PATTERN_LAT_DEGREE_INT = r'(\d{1,2})[\s°]+?';
const PATTERN_LON_DEGREE_INT = r'(\d{1,3})[\s°]+?';
const PATTERN_SECONDS_MINUTES = '([0-5]?\\d)[\\s\']+?';
const PATTERN_DECIMAL = r'(?:\s*?[\.,]\s*?(\d+))?' '[\\s\'°"]+?';
const LETTER = '[A-ZÄÖÜ]';

var regexEnd = '';

//wholeString == false: The first match at the text begin is taken - for copy
//wholeString == true: The whole text must be a valid coord - for var coords
List<BaseCoordinate> parseCoordinates(String text, {bool wholeString = false}) {
  var coords = <BaseCoordinate>[];

  try {
    BaseCoordinate? coord = DMS.parse(text, wholeString: wholeString);
    if (coord != null) coords.add(coord);

    coord = DMM.parse(text, wholeString: wholeString);
    if (coord != null) coords.add(coord);

    coord = DEC.parse(text, wholeString: wholeString);
    if (coord != null) coords.add(coord);

    coord = UTMREF.parse(text);
    if (coord != null) coords.add(coord);

    coord = MGRS.parse(text);
    if (coord != null) coords.add(coord);

    coord = ReverseWherigoWaldmeister.parse(text);
    if (coord != null) coords.add(coord);

    coord = ReverseWherigoDay1976.parse(text);
    if (coord != null) coords.add(coord);

    coord = XYZ.parse(text);
    if (coord != null) coords.add(coord);

    coord = SwissGrid.parse(text);
    var swissGripPlus = SwissGridPlus.parse(text);
    if (swissGripPlus != null &&
        (swissGripPlus.easting.toInt().toString().length == 7 ||
            swissGripPlus.northing.toInt().toString().length == 7)) {
      if (coord != null) coords.add(swissGripPlus);
      if (coord != null) coords.add(coord);
    } else {
      if (coord != null) coords.add(coord);
    }

    coord = GaussKrueger.parse(text);
    if (coord != null) coords.add(coord);

    coord = Lambert.parse(text);
    if (coord != null) coords.add(coord);

    coord = DutchGrid.parse(text);
    if (coord != null) coords.add(coord);

    coord = Maidenhead.parse(text);
    if (coord != null) coords.add(coord);

    coord = Mercator.parse(text);
    if (coord != null) coords.add(coord);

    coord = NaturalAreaCode.parse(text);
    if (coord != null) coords.add(coord);

    coord = Geohash.parse(text);
    if (coord != null) coords.add(coord);

    coord = GeoHex.parse(text);
    if (coord != null) coords.add(coord);

    coord = Geo3x3.parse(text);
    if (coord != null) coords.add(coord);

    coord = OpenLocationCode.parse(text);
    if (coord != null) coords.add(coord);

    coord = Makaney.parse(text);
    if (coord != null) coords.add(coord);

    coord = Quadtree.parse(text);
    if (coord != null) coords.add(coord);

    coord = SlippyMap.parse(text);
    if (coord != null) coords.add(coord);
  } catch (e) {}

  return coords;
}

//wholeString == false: The first match at the text begin is taken - for copy
//wholeString == true: The whole text must be a valid coord - for var coords
BaseCoordinate? parseStandardFormats(String text, {bool wholeString = false}) {
  LatLng? coord = DMS.parse(text, wholeString: wholeString)?.toLatLng();
  if (coord != null) return DMS.fromLatLon(coord);

  coord = DMM.parse(text, wholeString: wholeString)?.toLatLng();
  if (coord != null) return DMM.fromLatLon(coord);

  coord = DEC.parse(text, wholeString: wholeString)?.toLatLng();
  if (coord != null) return DEC.fromLatLon(coord);

  return null;
}
