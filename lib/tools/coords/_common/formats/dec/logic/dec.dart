import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

const LETTER = '[A-ZÄÖÜ]';
const decKey = 'coords_dec';
var regexEnd = '';

class CoordinateFormatDefinitionDEC extends CoordinateFormatDefinition {
  CoordinateFormatDefinitionDEC(
      super.type, super.persistenceKey, super.apiKey, super.parseCoordinate, super.defaultCoordinate);

  @override
  BaseCoordinate? parseCoordinateWholeString(String input) {
    return DECCoordinate.parseWholeString(input);
  }
}

final DECFormatDefinition = CoordinateFormatDefinitionDEC(
    CoordinateFormatKey.DEC, decKey, decKey, DECCoordinate.parse, DECCoordinate(0.0, 0.0));

class DECCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.DEC);

  DECCoordinate([double? latitude, double? longitude]) : super(latitude, longitude) {
    this.latitude = latitude ?? DECFormatDefinition.defaultCoordinate.latitude;
    this.longitude = longitude ?? DECFormatDefinition.defaultCoordinate.longitude;
  }

  @override
  LatLng? toLatLng() {
    return decToLatLon(this);
  }

  static DECCoordinate fromLatLon(LatLng coord) {
    return _latLonToDEC(coord);
  }

  static DECCoordinate? parse(String input) {
    return _parseDEC(input, wholeString: false);
  }

  static DECCoordinate? parseWholeString(String input) {
    return _parseDEC(input, wholeString: true);
  }

  @override
  String toString([int? precision]) {
    precision = precision ?? 10;
    var latFormatStr = formatStringForDecimals(decimalPrecision: precision);
    var lonFormatStr = formatStringForDecimals(integerPrecision: 3, decimalPrecision: precision);
    return '${NumberFormat(latFormatStr).format(latitude)}\n${NumberFormat(lonFormatStr).format(longitude)}';
  }
}

LatLng decToLatLon(DECCoordinate dec) {
  return normalizeLatLon(dec.latitude, dec.longitude);
}

DECCoordinate _latLonToDEC(LatLng coord) {
  return DECCoordinate(coord.latitude, coord.longitude);
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

DECCoordinate? _parseDEC(String input, {bool wholeString = false}) {
  var _input = prepareInput(input, wholeString: wholeString);
  if (_input == null) return null;

  var parsedTrailingSigns = _parseDECTrailingSigns(_input);
  if (parsedTrailingSigns != null) return parsedTrailingSigns;

  RegExp regex = RegExp(_PATTERN_DEC + regexEnd, caseSensitive: false);

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

    return DECCoordinate(latDegrees, lonDegrees);
  }

  return null;
}

DECCoordinate? _parseDECTrailingSigns(String text) {
  RegExp regex = RegExp(_PATTERN_DEC_TRAILINGSIGN + regexEnd, caseSensitive: false);
  if (regex.hasMatch(text)) {
    RegExpMatch matches = regex.firstMatch(text)!;

    if (matches.group(1) == null) {
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

    if (matches.group(4) == null) {
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

    return DECCoordinate(latDegrees, lonDegrees);
  }

  return null;
}

const _PATTERN_DEC_TRAILINGSIGN = '^\\s*?'
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

const _PATTERN_DEC = '^\\s*?'
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
