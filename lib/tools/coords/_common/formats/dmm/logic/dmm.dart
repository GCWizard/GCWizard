import 'package:gc_wizard/application/settings/logic/preferences.dart';
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
import 'package:prefs/prefs.dart';

const dmmKey = 'coords_dmm';

class CoordinateFormatDefinitionDMM extends CoordinateFormatDefinition {
  CoordinateFormatDefinitionDMM(super.type, super.persistenceKey, super.apiKey,
      super.parseCoordinate, super.defaultCoordinate);

  @override
  BaseCoordinate? parseCoordinateWholeString(String input) {
    return DMMCoordinate.parseWholeString(input);
  }
}

final DMMFormatDefinition = CoordinateFormatDefinitionDMM(
    CoordinateFormatKey.DMM, dmmKey, dmmKey, DMMCoordinate.parse,
    DMMCoordinate(DMMLatitude(0, 0, 0), DMMLongitude(0, 0, 0)));

class _FormattedDMMPart {
  IntegerText sign;
  String degrees, minutes;

  _FormattedDMMPart(this.sign, this.degrees, this.minutes);

  @override
  String toString() {
    return sign.text + ' ' + degrees + '° ' + minutes + '\'';
  }
}

class _DMMPart {
  int sign;
  int degrees;
  double minutes;

  _DMMPart(this.sign, this.degrees, this.minutes);

  _FormattedDMMPart _formatParts(bool isLatitude, [int precision = 10]) {
    var _minutesStr = NumberFormat(formatStringForDecimals(decimalPrecision: precision)).format(minutes);
    var _degrees = degrees;
    var _sign = getCoordinateSignString(sign, isLatitude);

    //Values like 59.999999999' may be rounded to 60.0. So in that case,
    //the degree has to be increased while minutes should be set to 0.0
    if (_minutesStr.startsWith('60')) {
      _minutesStr = '00.000';
      _degrees += 1;
    }

    String _degreesStr = _degrees.toString().padLeft(isLatitude ? 2 : 3, '0');

    return _FormattedDMMPart(IntegerText(_sign, sign), _degreesStr, _minutesStr);
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

class DMMLatitude extends _DMMPart {
  DMMLatitude(super.sign, super.degrees, super.minutes);

  static DMMLatitude from(_DMMPart dmmPart) {
    return DMMLatitude(dmmPart.sign, dmmPart.degrees, dmmPart.minutes);
  }

  _FormattedDMMPart formatParts([int precision = 10]) {
    return super._formatParts(true, precision);
  }

  String format([int precision = 10]) {
    return super._format(true, precision);
  }
}

class DMMLongitude extends _DMMPart {
  DMMLongitude(super.sign, super.degrees, super.minutes);

  static DMMLongitude from(_DMMPart dmmPart) {
    return DMMLongitude(dmmPart.sign, dmmPart.degrees, dmmPart.minutes);
  }

  _FormattedDMMPart formatParts([int precision = 10]) {
    return super._formatParts(false, precision);
  }

  String format([int precision = 10]) {
    return super._format(false, precision);
  }
}

class DMMCoordinate extends BaseCoordinate {
  @override
  CoordinateFormat get format => CoordinateFormat(CoordinateFormatKey.DMM);
  late final DMMLatitude dmmLatitude;
  late final DMMLongitude dmmLongitude;

  DMMCoordinate(this.dmmLatitude, this.dmmLongitude);

  @override
  LatLng toLatLng() {
    return _dmmToLatLon(this);
  }

  static DMMCoordinate fromLatLon(LatLng coord) {
    return _latLonToDMM(coord);
  }

  static DMMCoordinate? parse(String text, {bool leftPadMilliMinutes = false, bool wholeString = false}) {
    return _parseDMM(text, leftPadMilliMinutes: leftPadMilliMinutes, wholeString: wholeString);
  }
  static DMMCoordinate? parseWholeString(String input) {
    return _parseDMM(input, wholeString: true);
  }

  @override
  String toString([int? precision]) {
    precision = precision ?? Prefs.getInt(PREFERENCE_COORD_PRECISION_DMM);
    return '${dmmLatitude.format(precision)}\n${dmmLongitude.format(precision)}';
  }
}

String getCoordinateSignString(int sign, bool isLatitude) {
  var _sign = '';

  if (isLatitude) {
    _sign = (sign >= 0) ? 'N' : 'S';
  } else {
    _sign = (sign >= 0) ? 'E' : 'W';
  }

  return _sign;
}

LatLng _dmmToLatLon(DMMCoordinate dmm) {
  return decToLatLon(_DMMToDEC(dmm));
}

DECCoordinate _DMMToDEC(DMMCoordinate coord) {
  var lat = _DMMPartToDouble(coord.dmmLatitude);
  var lon = _DMMPartToDouble(coord.dmmLongitude);

  return DECCoordinate.fromLatLon(normalizeLatLon(lat, lon));
}

double _DMMPartToDouble(_DMMPart dmmPart) {
  return dmmPart.sign * (dmmPart.degrees.abs() + dmmPart.minutes / 60.0);
}

DMMCoordinate _latLonToDMM(LatLng coord) {
  return _DECToDMM(DECCoordinate.fromLatLon(coord));
}

DMMCoordinate _DECToDMM(DECCoordinate coord) {
  var normalizedCoord = normalizeLatLon(coord.latitude, coord.longitude);

  var lat = DMMLatitude.from(doubleToDMMPart(normalizedCoord.latitude));
  var lon = DMMLongitude.from(doubleToDMMPart(normalizedCoord.longitude));

  return DMMCoordinate(lat, lon);
}

_DMMPart doubleToDMMPart(double value) {
  var _sign = sign(value);

  int _degrees = value.abs().floor();
  double _minutes = (value.abs() - _degrees) * 60.0;

  return _DMMPart(_sign, _degrees, _minutes);
}

DMMCoordinate? _parseDMM(String input, {bool leftPadMilliMinutes = false, bool wholeString = false}) {
  var _input = prepareInput(input, wholeString: wholeString);
  if (_input == null) return null;

  var parsedTrailingSigns = _parseDMMTrailingSigns(_input, leftPadMilliMinutes);
  if (parsedTrailingSigns != null) return parsedTrailingSigns;

  RegExp regex = RegExp(_PATTERN_DMM + regexEnd, caseSensitive: false);
  if (regex.hasMatch(_input)) {
    RegExpMatch matches = regex.firstMatch(_input)!;

    if (matches.group(2) == null || matches.group(3) == null) {
      return null;
    }

    var latSign = latLngPartSign(matches.group(1));
    var latDegrees = int.tryParse(matches.group(2)!);
    if (latDegrees == null) {
      return null;
    }

    double? latMinutes = 0.0;
    if (matches.group(4) != null) {
      if (leftPadMilliMinutes && (matches.group(4)!.length) < 3) {
        latMinutes = _leftPadDMMMilliMinutes(matches.group(3)!, matches.group(4)!);
      } else {
        latMinutes = double.tryParse('${matches.group(3)}.${matches.group(4)}');
      }
    } else {
      latMinutes = double.tryParse('${matches.group(3)}.0');
    }
    if (latMinutes == null) {
      return null;
    }

    var lat = DMMLatitude(latSign, latDegrees, latMinutes);

    if (matches.group(6) == null || matches.group(7) == null) {
      return null;
    }

    var lonSign = latLngPartSign(matches.group(5));
    var lonDegrees = int.tryParse(matches.group(6)!);
    if (lonDegrees == null) {
      return null;
    }

    double? lonMinutes = 0.0;
    if (matches.group(8) != null) {
      if (leftPadMilliMinutes && matches.group(8)!.length < 3) {
        lonMinutes = _leftPadDMMMilliMinutes(matches.group(7)!, matches.group(8)!);
      } else {
        lonMinutes = double.tryParse('${matches.group(7)}.${matches.group(8)}');
      }
    } else {
      lonMinutes = double.tryParse('${matches.group(7)}.0');
    }
    if (lonMinutes == null) {
      return null;
    }

    var lon = DMMLongitude(lonSign, lonDegrees, lonMinutes);

    return DMMCoordinate(lat, lon);
  }

  return null;
}

double _leftPadDMMMilliMinutes(String minutes, String milliMinutes) {
  if (milliMinutes.length <= 3) return double.parse('$minutes.${milliMinutes.padLeft(3, '0')}');

  int milliMinuteValue = int.parse(milliMinutes);
  int minuteValue = int.parse(minutes) + (milliMinuteValue / 1000).floor();

  return double.parse('$minuteValue.${milliMinuteValue % 1000}');
}

DMMCoordinate? _parseDMMTrailingSigns(String text, bool leftPadMilliMinutes) {
  RegExp regex = RegExp(_PATTERN_DMM_TRAILINGSIGN + regexEnd, caseSensitive: false);

  if (regex.hasMatch(text)) {
    RegExpMatch matches = regex.firstMatch(text)!;

    if (matches.group(2) == null || matches.group(4) == null) {
      return null;
    }

    var latSign = latLngPartSign(matches.group(4));
    var latDegrees = int.tryParse(matches.group(1)!);
    if (latDegrees == null) {
      return null;
    }

    double? latMinutes = 0.0;
    if (matches.group(3) != null) {
      if (leftPadMilliMinutes) {
        latMinutes = _leftPadDMMMilliMinutes(matches.group(2)!, matches.group(3)!);
      } else {
        latMinutes = double.tryParse('${matches.group(2)}.${matches.group(3)}');
      }
    } else {
      latMinutes = double.tryParse('${matches.group(2)}.0');
    }
    if (latMinutes == null) {
      return null;
    }

    var lat = DMMLatitude(latSign, latDegrees, latMinutes);

    if (matches.group(6) == null || matches.group(8) == null) {
      return null;
    }

    var lonSign = latLngPartSign(matches.group(8));
    var _lonDegrees = int.tryParse(matches.group(5)!);
    if (_lonDegrees == null) {
      return null;
    }
    var lonDegrees = lonSign * _lonDegrees;

    double? lonMinutes = 0.0;
    if (matches.group(7) != null) {
      if (leftPadMilliMinutes) {
        lonMinutes = _leftPadDMMMilliMinutes(matches.group(6)!, matches.group(7)!);
      } else {
        lonMinutes = double.tryParse('${matches.group(6)}.${matches.group(7)}');
      }
    } else {
      lonMinutes = double.tryParse('${matches.group(6)}.0');
    }
    if (lonMinutes == null) {
      return null;
    }

    var lon = DMMLongitude(lonSign, lonDegrees, lonMinutes);

    return DMMCoordinate(lat, lon);
  }

  return null;
}

const _PATTERN_DMM_TRAILINGSIGN = '^\\s*?'
    '(\\d{1,3})\\s*?[\\s°]\\s*?' //lat degrees + symbol
    '([0-5]?\\d)\\s*?' //lat minutes
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lat milliminutes
    '[\\s\'´′`’‘]?\\s*?' //lat minute symbol
    '([NS]$LETTER*?|[\\+\\-])\\s*?' //lat sign

    '[,\\s]\\s*?' //delimiter lat lon

    '(\\d{1,3})\\s*?[\\s°]\\s*?' //lon degrees + symbol
    '([0-5]?\\d)\\s*?' //lon minutes
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lon milliminutes
    '[\\s\'´′`’‘]?\\s*?' //lon minutes symbol
    '([EWO]$LETTER*?|[\\+\\-])' //lon sign;
    '\\s*?';

const _PATTERN_DMM = '^\\s*?'
    '([NS]$LETTER*?|[\\+\\-])?\\s*?' //lat sign
    '(\\d{1,3})\\s*?[\\s°]\\s*?' //lat degrees + symbol
    '([0-5]?\\d)\\s*?' //lat minutes
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lat milliminutes
    '[\\s\'´′`’‘]?\\s*?' //lat minute symbol

    '\\s*?[,\\s]\\s*?' //delimiter lat lon

    '([EWO]$LETTER*?|[\\+\\-])?\\s*?' //lon sign
    '(\\d{1,3})\\s*?[\\s°]\\s*?' //lon degrees + symbol
    '([0-5]?\\d)\\s*?' //lon minutes
    '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //lon milliminutes
    '[\\s\'´′`’‘]?' //lon minutes symbol
    '\\s*?';
