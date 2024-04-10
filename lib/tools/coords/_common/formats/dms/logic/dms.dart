import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:gc_wizard/utils/data_type_utils/double_type_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

const dmsKey = 'coords_dms';

class CoordinateFormatDefinitionDMS extends CoordinateFormatDefinition {
  CoordinateFormatDefinitionDMS(super.type, super.persistenceKey, super.apiKey,
      super.parseCoordinate, super.defaultCoordinate);

  @override
  BaseCoordinate? parseCoordinateWholeString(String input) {
    return DMSCoordinate.parseWholeString(input);
  }
}

final DMSFormatDefinition = CoordinateFormatDefinitionDMS(
  CoordinateFormatKey.DMS, dmsKey, dmsKey, DMSCoordinate.parse,
  DMSCoordinate(DMSLatitude(0, 0, 0, 0), DMSLongitude(0, 0, 0, 0)));

class _FormattedDMSPart {
  IntegerText sign;
  String degrees, minutes, seconds;

  _FormattedDMSPart(this.sign, this.degrees, this.minutes, this.seconds);

  @override
  String toString() {
    return sign.text + ' ' + degrees + '° ' + minutes + '\' ' + seconds + '"';
  }
}

class _DMSPart {
  int sign;
  int degrees;
  int minutes;
  double seconds;

  _DMSPart(this.sign, this.degrees, this.minutes, this.seconds);

  _FormattedDMSPart _formatParts(bool isLatitude, [int precision = 10]) {
    var _sign = getCoordinateSignString(sign, isLatitude);
    var _secondsStr =
    NumberFormat(formatStringForDecimals(decimalPrecision: precision, minDecimalPrecision: 2)).format(seconds);
    var _minutes = minutes;

    //Values like 59.999999999 may be rounded to 60.0. So in that case,
    //the greater unit (minutes or degrees) has to be increased instead
    if (_secondsStr.startsWith('60')) {
      _secondsStr = '00.00';
      _minutes += 1;
    }

    var _degrees = degrees;

    var _minutesStr = _minutes.toString().padLeft(2, '0');
    if (_minutesStr.startsWith('60')) {
      _minutesStr = '00';
      _degrees += 1;
    }

    var _degreesStr = _degrees.toString().padLeft(isLatitude ? 2 : 3, '0');

    return _FormattedDMSPart(IntegerText(_sign, sign), _degreesStr, _minutesStr, _secondsStr);
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

class DMSLatitude extends _DMSPart {
  DMSLatitude(super.sign, super.degrees, super.minutes, super.seconds);

  static DMSLatitude from(_DMSPart dmsPart) {
    return DMSLatitude(dmsPart.sign, dmsPart.degrees, dmsPart.minutes, dmsPart.seconds);
  }

  _FormattedDMSPart formatParts([int precision = 10]) {
    return super._formatParts(true, precision);
  }

  String format([int precision = 10]) {
    return super._format(true, precision);
  }
}

class DMSLongitude extends _DMSPart {
  DMSLongitude(super.sign, super.degrees, super.minutes, super.seconds);

  static DMSLongitude from(_DMSPart dmsPart) {
    return DMSLongitude(dmsPart.sign, dmsPart.degrees, dmsPart.minutes, dmsPart.seconds);
  }

  _FormattedDMSPart formatParts([int precision = 10]) {
    return super._formatParts(false, precision);
  }

  String format([int precision = 10]) {
    return super._format(false, precision);
  }
}

class DMSCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.DMS);
  late final DMSLatitude dmsLatitude;
  late final DMSLongitude dmsLongitude;

  DMSCoordinate(this.dmsLatitude, this.dmsLongitude);

  @override
  LatLng? toLatLng() {
    return _dmsToLatLon(this);
  }

  static DMSCoordinate fromLatLon(LatLng coord) {
    return _latLonToDMS(coord);
  }

  static DMSCoordinate? parse(String input) {
    return parseDMS(input);
  }
  static DMSCoordinate? parseWholeString(String input) {
    return parseDMS(input, wholeString: true);
  }

  @override
  String toString([int? precision]) {
    precision = precision ?? 6;
    return '${dmsLatitude.format(precision)}\n${dmsLongitude.format(precision)}';
  }
}

LatLng _dmsToLatLon(DMSCoordinate dms) {
  return decToLatLon(_DMSToDEC(dms));
}

DECCoordinate _DMSToDEC(DMSCoordinate coord) {
  var lat = _DMSPartToDouble(coord.dmsLatitude);
  var lon = _DMSPartToDouble(coord.dmsLongitude);

  return DECCoordinate.fromLatLon(normalizeLatLon(lat, lon));
}

double _DMSPartToDouble(_DMSPart dmsPart) {
  return dmsPart.sign * (dmsPart.degrees.abs() + dmsPart.minutes / 60.0 + dmsPart.seconds / 60.0 / 60.0);
}

DMSCoordinate _latLonToDMS(LatLng coord) {
  return _DECToDMS(DECCoordinate.fromLatLon(coord));
}

DMSCoordinate _DECToDMS(DECCoordinate coord) {
  var normalizedCoord = normalizeLatLon(coord.latitude, coord.longitude);

  var lat = DMSLatitude.from(doubleToDMSPart(normalizedCoord.latitude));
  var lon = DMSLongitude.from(doubleToDMSPart(normalizedCoord.longitude));

  return DMSCoordinate(lat, lon);
}

_DMSPart doubleToDMSPart(double value) {
  var _sign = sign(value);

  int _degrees = value.abs().floor();
  double _minutesD = (value.abs() - _degrees) * 60.0;

  int _minutes = _minutesD.floor();
  double _seconds = (_minutesD - _minutes) * 60.0;

  return _DMSPart(_sign, _degrees, _minutes, _seconds);
}

DMSCoordinate normalize(DMSCoordinate coord) {
  return _DECToDMS(_DMSToDEC(coord));
}

DMSCoordinate? parseDMS(String input, {bool wholeString = false}) {
  var _input = prepareInput(input, wholeString: wholeString);
  if (_input == null) return null;

  var parsedTrailingSigns = _parseDMSTrailingSigns(_input);
  if (parsedTrailingSigns != null) return parsedTrailingSigns;

  RegExp regex = RegExp(_PATTERN_DMS + regexEnd, caseSensitive: false);
  if (regex.hasMatch(_input)) {
    RegExpMatch matches = regex.firstMatch(_input)!;

    if (matches.group(2) == null || matches.group(3) == null || matches.group(4) == null) {
      return null;
    }

    var latSign = latLngPartSign(matches.group(1));
    var latDegrees = int.tryParse(matches.group(2)!);
    var latMinutes = int.tryParse(matches.group(3)!);
    if (latDegrees == null || latMinutes == null) {
      return null;
    }

    double? latSeconds = 0.0;
    if (matches.group(5) != null) {
      latSeconds = double.tryParse('${matches.group(4)}.${matches.group(5)}');
    } else {
      latSeconds = double.tryParse('${matches.group(4)}.0');
    }
    if (latSeconds == null) {
      return null;
    }

    var lat = DMSLatitude(latSign, latDegrees, latMinutes, latSeconds);

    if (matches.group(7) == null || matches.group(8) == null || matches.group(9) == null) {
      return null;
    }

    var lonSign = latLngPartSign(matches.group(6));
    var lonDegrees = int.tryParse(matches.group(7)!);
    var lonMinutes = int.tryParse(matches.group(8)!);
    if (lonDegrees == null || lonMinutes == null) {
      return null;
    }

    double? lonSeconds = 0.0;
    if (matches.group(10) != null) {
      lonSeconds = double.tryParse('${matches.group(9)}.${matches.group(10)}');
    } else {
      lonSeconds = double.tryParse('${matches.group(9)}.0');
    }
    if (lonSeconds == null) {
      return null;
    }

    var lon = DMSLongitude(lonSign, lonDegrees, lonMinutes, lonSeconds);

    return DMSCoordinate(lat, lon);
  }

  return null;
}

DMSCoordinate? _parseDMSTrailingSigns(String text) {
  RegExp regex = RegExp(_PATTERN_DMS_TRAILINGSIGN + regexEnd, caseSensitive: false);
  if (regex.hasMatch(text)) {
    RegExpMatch matches = regex.firstMatch(text)!;

    if (matches.group(2) == null || matches.group(3) == null || matches.group(5) == null) {
      return null;
    }

    var latSign = latLngPartSign(matches.group(5));
    var latDegrees = int.tryParse(matches.group(1)!);
    var latMinutes = int.tryParse(matches.group(2)!);
    if (latDegrees == null || latMinutes == null) {
      return null;
    }

    double? latSeconds = 0.0;
    if (matches.group(4) != null) {
      latSeconds = double.tryParse('${matches.group(3)}.${matches.group(4)}');
    } else {
      latSeconds = double.tryParse('${matches.group(3)}.0');
    }
    if (latSeconds == null) {
      return null;
    }

    var lat = DMSLatitude(latSign, latDegrees, latMinutes, latSeconds);

    if (matches.group(7) == null || matches.group(8) == null || matches.group(10) == null) {
      return null;
    }

    var lonSign = latLngPartSign(matches.group(10));
    var lonDegrees = int.tryParse(matches.group(6)!);
    var lonMinutes = int.tryParse(matches.group(7)!);
    if (lonDegrees == null || lonMinutes == null) {
      return null;
    }

    double? lonSeconds = 0.0;
    if (matches.group(9) != null) {
      lonSeconds = double.tryParse('${matches.group(8)}.${matches.group(9)}');
    } else {
      lonSeconds = double.tryParse('${matches.group(8)}.0');
    }
    if (lonSeconds == null) {
      return null;
    }

    var lon = DMSLongitude(lonSign, lonDegrees, lonMinutes, lonSeconds);

    return DMSCoordinate(lat, lon);
  }

  return null;
}

const _PATTERN_DMS_TRAILINGSIGN = '^\\s*?'
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

const _PATTERN_DMS = '^\\s*?'
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
