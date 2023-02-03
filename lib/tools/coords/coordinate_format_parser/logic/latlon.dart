import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

final PATTERN_NO_NUMBERS = r'\s+?';
final PATTERN_NOTHING_OR_NO_NUMBERS = r'\s*?';
final PATTERN_LAT_SIGN = r'([NS][A-Za-zÄÖÜäöü]*?|[\+\-])';
final PATTERN_LON_SIGN = r'([EWO][A-Za-zÄÖÜäöü]*?|[\+\-])';
final PATTERN_LON_SIGN_WITH_SPACE = '(?:\\s+?$PATTERN_LON_SIGN)?';
final PATTERN_LAT_DEGREE_INT = r'(\d{1,2})[\s°]+?';
final PATTERN_LON_DEGREE_INT = r'(\d{1,3})[\s°]+?';
final PATTERN_SECONDS_MINUTES = '([0-5]?[0-9])[\\s\']+?';
final PATTERN_DECIMAL = r'(?:\s*?[\.,]\s*?(\d+))?' + '[\\s\'°"]+?';
final LETTER = '[A-ZÄÖÜ]';

var regexEnd = '';

//wholeString == false: The first match at the text begin is taken - for copy
//wholeString == true: The whole text must be a valid coord - for var coords
List<BaseCoordinates> parseCoordinates(String text, {wholeString = false}) {
  var coords = <BaseCoordinates>[];

  try {
    BaseCoordinates coord = DMS.parse(text, wholeString: wholeString);
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
      if (coord != null) coords.add(swissGripPlus);
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
Map<String, dynamic> parseStandardFormats(String text, {wholeString = false}) {
  LatLng coord = DMS.parse(text, wholeString: wholeString)?.toLatLng();
  if (coord != null) return {'format': keyCoordsDMS, 'coordinate': coord};

  coord = DMM.parse(text, wholeString: wholeString)?.toLatLng();
  if (coord != null) return {'format': keyCoordsDMM, 'coordinate': coord};

  coord = DEC.parse(text, wholeString: wholeString)?.toLatLng();
  if (coord != null) return {'format': keyCoordsDEC, 'coordinate': coord};

  return null;
}
