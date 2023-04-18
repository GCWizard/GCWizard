import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

LatLng decToLatLon(DEC dec) {
  return normalizeLatLon(dec.latitude, dec.longitude);
}

DEC latLonToDEC(LatLng coord) {
  return DEC(coord.latitude, coord.longitude);
}

int latLngPartSign(String? text) {
  if (text == null) return 1;

  if (text[0].contains(RegExp(r'[SW-]', caseSensitive: false))) {
    return -1;
  }

  return 1;
}

String? prepareInput(String text, {bool wholeString = false}) {
  if (wholeString) {
    text = text.trim();
    regexEnd = wholeString ? '\$' : '';
  }

  if (text.isEmpty) return null;

  return text;
}

DEC? parseDEC(String input, {bool wholeString = false}) {
  var _input = prepareInput(input, wholeString: wholeString);
  if (_input == null) return null;

  var parsedTrailingSigns = _parseDECTrailingSigns(_input);
  if (parsedTrailingSigns != null) return parsedTrailingSigns;

  RegExp regex = RegExp(PATTERN_DEC + regexEnd, caseSensitive: false);

  if (regex.hasMatch(_input)) {
    RegExpMatch matches = regex.firstMatch(_input)!;

    if (matches.group(2) == null) {
      return null;
    }

    var latSign = latLngPartSign(matches.group(1));
    double? _latDegrees = 0.0;
    if (matches.group(3) != null) {
      _latDegrees = double.tryParse('${matches.group(2)}.${matches.group(3)}');
    } else {
      _latDegrees = double.tryParse('${matches.group(2)}.0');
    }
    if (_latDegrees == null) {
      return null;
    }

    var latDegrees = latSign * _latDegrees;

    if (matches.group(5) == null) {
      return null;
    }

    var lonSign = latLngPartSign(matches.group(4));
    double? _lonDegrees = 0.0;
    if (matches.group(6) != null) {
      _lonDegrees = double.tryParse('${matches.group(5)}.${matches.group(6)}');
    } else {
      _lonDegrees = double.tryParse('${matches.group(5)}.0');
    }
    if (_lonDegrees == null) {
      return null;
    }

    var lonDegrees = lonSign * _lonDegrees;

    return DEC(latDegrees, lonDegrees);
  }

  return null;
}

DEC? _parseDECTrailingSigns(String text) {
  RegExp regex = RegExp(PATTERN_DEC_TRAILINGSIGN + regexEnd, caseSensitive: false);
  if (regex.hasMatch(text)) {
    RegExpMatch matches = regex.firstMatch(text)!;

    if (matches.group(1) == null
    ) {
      return null;
    }

    var latSign = latLngPartSign(matches.group(3));
    double? _latDegrees = 0.0;
    if (matches.group(2) != null) {
      _latDegrees = double.tryParse('${matches.group(1)}.${matches.group(2)}');
    } else {
      _latDegrees = double.tryParse('${matches.group(1)}.0');
    }
    if (_latDegrees == null) {
      return null;
    }

    var latDegrees = latSign * _latDegrees;

    if (matches.group(4) == null
    ) {
      return null;
    }

    var lonSign = latLngPartSign(matches.group(6));
    double? _lonDegrees = 0.0;
    if (matches.group(5) != null) {
      _lonDegrees = double.tryParse('${matches.group(4)}.${matches.group(5)}');
    } else {
      _lonDegrees = double.tryParse('${matches.group(4)}.0');
    }
    if (_lonDegrees == null) {
      return null;
    }

    var lonDegrees = lonSign * _lonDegrees;

    return DEC(latDegrees, lonDegrees);
  }

  return null;
}

const PATTERN_DEC_TRAILINGSIGN = '^\\s*?'
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

const PATTERN_DEC = '^\\s*?'
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
