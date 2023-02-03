import 'package:gc_wizard/tools/coords/coordinate_format_parser/logic/latlon.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

LatLng decToLatLon(DEC dec) {
  var normalized = normalizeDEC(dec);
  return LatLng(normalized.latitude, normalized.longitude);
}

DEC latLonToDEC(LatLng coord) {
  return DEC(coord.latitude, coord.longitude);
}

int sign(String match) {
  if (match == null) return 1;

  if (match[0].contains(RegExp(r'[SW-]', caseSensitive: false))) {
    return -1;
  }

  return 1;
}

String prepareInput(String text, {wholeString = false}) {
  if (text == null) return null;

  if (wholeString) {
    text = text.trim();
    regexEnd = wholeString ? '\$' : '';
  }

  if (text.length == 0) return null;

  return text;
}

double _normalizeLat(double lat) {
  if (lat > 90.0) return _normalizeLat(180.0 - lat);
  if (lat < -90.0) return _normalizeLat(-180.0 + -lat);

  return lat;
}

double _normalizeLon(double lon) {
  if (lon > 180.0) return _normalizeLon(lon - 360.0);
  if (lon < -180.0) return _normalizeLon(360.0 + lon);

  return lon;
}

DEC normalizeDEC(DEC coord) {
  var normalizedLat = coord.latitude;
  var normalizedLon = coord.longitude;

  while (normalizedLat > 90.0 || normalizedLat < -90) {
    if (normalizedLat > 90.0) {
      normalizedLat = 180.0 - normalizedLat;
    } else {
      normalizedLat = -180.0 + -normalizedLat;
    }

    normalizedLon += 180.0;
  }

  normalizedLon = _normalizeLon(normalizedLon);

  return DEC(normalizedLat, normalizedLon);
}

DEC parseDEC(String input, {wholeString = false}) {
  input = prepareInput(input, wholeString: wholeString);
  if (input == null) return null;

  var parsedTrailingSigns = _parseDECTrailingSigns(input);
  if (parsedTrailingSigns != null) return parsedTrailingSigns;

  RegExp regex = RegExp(PATTERN_DEC + regexEnd, caseSensitive: false);

  if (regex.hasMatch(input)) {
    var matches = regex.firstMatch(input);

    var latSign = sign(matches.group(1));
    var latDegrees = 0.0;
    if (matches.group(3) != null) {
      latDegrees = latSign * double.parse('${matches.group(2)}.${matches.group(3)}');
    } else {
      latDegrees = latSign * double.parse('${matches.group(2)}.0');
    }

    var lonSign = sign(matches.group(4));
    var lonDegrees = 0.0;
    if (matches.group(6) != null) {
      lonDegrees = lonSign * double.parse('${matches.group(5)}.${matches.group(6)}');
    } else {
      lonDegrees = lonSign * double.parse('${matches.group(5)}.0');
    }

    return DEC(latDegrees, lonDegrees);
  }

  return null;
}

DEC _parseDECTrailingSigns(String text) {
  RegExp regex = RegExp(PATTERN_DEC_TRAILINGSIGN + regexEnd, caseSensitive: false);
  if (regex.hasMatch(text)) {
    var matches = regex.firstMatch(text);

    var latSign = sign(matches.group(3));
    var latDegrees = 0.0;
    if (matches.group(2) != null) {
      latDegrees = latSign * double.parse('${matches.group(1)}.${matches.group(2)}');
    } else {
      latDegrees = latSign * double.parse('${matches.group(1)}.0');
    }

    var lonSign = sign(matches.group(6));
    var lonDegrees = 0.0;
    if (matches.group(5) != null) {
      lonDegrees = lonSign * double.parse('${matches.group(4)}.${matches.group(5)}');
    } else {
      lonDegrees = lonSign * double.parse('${matches.group(4)}.0');
    }

    return DEC(latDegrees, lonDegrees);
  }

  return null;
}

final PATTERN_DEC_TRAILINGSIGN = '^\\s*?'
    '(\\d{1,3})\\s*?' //lat degrees
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lat millidegrees
    '[\\s°]?\\s*?' //lat degrees symbol
    '([NS]$LETTER*?|[\\+\\-])\\s*?' //lat sign

    '[,\\s]\\s*?' //delimiter lat lon

    '(\\d{1,3})\\s*?' //lon degrees
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lon millidegrees
    '[\\s°]?\\s*?' //lon degree symbol
    '([EWO]$LETTER*?|[\\+\\-])' //lon sign;
    '\\s*?';

final PATTERN_DEC = '^\\s*?'
    '([NS]$LETTER*?|[\\+\\-])?\\s*?' //lat sign
    '(\\d{1,3})\\s*?' //lat degrees
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lat millidegrees
    '[\\s°]?\\s*?' //lat degree symbol

    '\\s*?[,\\s]\\s*?' //delimiter lat lon

    '([EWO]$LETTER*?|[\\+\\-])?\\s*?' //lon sign
    '(\\d{1,3})\\s*?' //lon degrees
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lon millidegrees
    '[\\s°]?' //lon degree symbol
    '\\s*?';
