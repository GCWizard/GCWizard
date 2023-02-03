import 'package:gc_wizard/tools/coords/coordinate_format_parser/logic/latlon.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

LatLng dmsToLatLon(DMS dms) {
  return decToLatLon(_DMSToDEC(dms));
}

DEC _DMSToDEC(DMS coord) {
  var lat = _DMSPartToDouble(coord.latitude);
  var lon = _DMSPartToDouble(coord.longitude);

  return normalizeDEC(DEC(lat, lon));
}

double _DMSPartToDouble(DMSPart dmsPart) {
  return dmsPart.sign * (dmsPart.degrees.abs() + dmsPart.minutes / 60.0 + dmsPart.seconds / 60.0 / 60.0);
}

DMS latLonToDMS(LatLng coord) {
  return _DECToDMS(DEC.fromLatLon(coord));
}

DMS _DECToDMS(DEC coord) {
  var normalizedCoord = normalizeDEC(coord);

  var lat = DMSLatitude.from(doubleToDMSPart(normalizedCoord.latitude));
  var lon = DMSLongitude.from(doubleToDMSPart(normalizedCoord.longitude));

  return DMS(lat, lon);
}

DMSPart doubleToDMSPart(double value) {
  var _sign = coordinateSign(value);

  int _degrees = value.abs().floor();
  double _minutesD = (value.abs() - _degrees) * 60.0;

  int _minutes = _minutesD.floor();
  double _seconds = (_minutesD - _minutes) * 60.0;

  return DMSPart(_sign, _degrees, _minutes, _seconds);
}

DMS normalize(DMS coord) {
  return _DECToDMS(_DMSToDEC(coord));
}

DMS parseDMS(String input, {wholeString = false}) {
  input = prepareInput(input, wholeString: wholeString);
  if (input == null) return null;

  var parsedTrailingSigns = _parseDMSTrailingSigns(input);
  if (parsedTrailingSigns != null) return parsedTrailingSigns;

  RegExp regex = RegExp(PATTERN_DMS + regexEnd, caseSensitive: false);
  if (regex.hasMatch(input)) {
    var matches = regex.firstMatch(input);

    var latSign = sign(matches.group(1));
    var latDegrees = int.tryParse(matches.group(2));
    var latMinutes = int.tryParse(matches.group(3));
    var latSeconds = 0.0;
    if (matches.group(5) != null) {
      latSeconds = double.parse('${matches.group(4)}.${matches.group(5)}');
    } else {
      latSeconds = double.parse('${matches.group(4)}.0');
    }
    var lat = DMSLatitude(latSign, latDegrees, latMinutes, latSeconds);

    var lonSign = sign(matches.group(6));
    var lonDegrees = int.tryParse(matches.group(7));
    var lonMinutes = int.tryParse(matches.group(8));
    var lonSeconds = 0.0;
    if (matches.group(10) != null) {
      lonSeconds = double.parse('${matches.group(9)}.${matches.group(10)}');
    } else {
      lonSeconds = double.parse('${matches.group(9)}.0');
    }
    var lon = DMSLongitude(lonSign, lonDegrees, lonMinutes, lonSeconds);

    return DMS(lat, lon);
  }

  return null;
}

DMS _parseDMSTrailingSigns(String text) {
  RegExp regex = RegExp(PATTERN_DMS_TRAILINGSIGN + regexEnd, caseSensitive: false);
  if (regex.hasMatch(text)) {
    var matches = regex.firstMatch(text);

    var latSign = sign(matches.group(5));
    var latDegrees = int.tryParse(matches.group(1));
    var latMinutes = int.tryParse(matches.group(2));
    var latSeconds = 0.0;
    if (matches.group(4) != null) {
      latSeconds = double.parse('${matches.group(3)}.${matches.group(4)}');
    } else {
      latSeconds = double.parse('${matches.group(3)}.0');
    }
    var lat = DMSLatitude(latSign, latDegrees, latMinutes, latSeconds);

    var lonSign = sign(matches.group(10));
    var lonDegrees = int.tryParse(matches.group(6));
    var lonMinutes = int.tryParse(matches.group(7));
    var lonSeconds = 0.0;
    if (matches.group(9) != null) {
      lonSeconds = double.parse('${matches.group(8)}.${matches.group(9)}');
    } else {
      lonSeconds = double.parse('${matches.group(8)}.0');
    }
    var lon = DMSLongitude(lonSign, lonDegrees, lonMinutes, lonSeconds);

    return DMS(lat, lon);
  }

  return null;
}

final PATTERN_DMS_TRAILINGSIGN = '^\\s*?'
    '(\\d{1,3})\\s*?[\\s°]\\s*?' //lat degrees + symbol
    '([0-5]?\\d)\\s*?[\\s\'´′`‘’]\\s*?' //lat minutes + symbol
    '([0-5]?\\d)\\s*?' //lat seconds
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lat milliseconds
    '[\\s"″“”]?\\s*?' //lat seconds symbol
    '([NS]$LETTER*?|[\\+\\-])\\s*?' //lat sign

    '[,\\s]\\s*?' //delimiter lat lon

    '(\\d{1,3})\\s*?[\\s°]\\s*?' //lon degrees + symbol
    '([0-5]?\\d)\\s*?[\\s\'´′`’‘]\\s*?' //lon minutes + symbol
    '([0-5]?\\d)\\s*?' //lon seconds
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lon milliseconds
    '[\\s"″“”]?\\s*?' //lon seconds symbol
    '([EWO]$LETTER*?|[\\+\\-])' //lon sign;
    '\\s*?';

final PATTERN_DMS = '^\\s*?'
    '([NS]$LETTER*?|[\\+\\-])?\\s*?' //lat sign
    '(\\d{1,3})\\s*?[\\s°]\\s*?' //lat degrees + symbol
    '([0-5]?\\d)\\s*?[\\s\'´′`’‘]\\s*?' //lat minutes + symbol
    '([0-5]?\\d)\\s*?' //lat seconds
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lat milliseconds
    '[\\s"″“”]?\\s*?' //lat seconds symbol

    '\\s*?[,\\s]\\s*?' //delimiter lat lon

    '([EWO]$LETTER*?|[\\+\\-])?\\s*?' //lon sign
    '(\\d{1,3})\\s*?[\\s°]\\s*?' //lon degrees + symbol
    '([0-5]?\\d)\\s*?[\\s\'´′`‘’]\\s*?' //lon minutes + symbol
    '([0-5]?\\d)\\s*?' //lon seconds
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lon milliseconds
    '[\\s"″“”]?' //lon seconds symbol
    '\\s*?';
