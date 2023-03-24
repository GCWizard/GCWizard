// https://github.com/maxogden/equatorial

import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/dec.dart' as dec;
import 'package:gc_wizard/utils/datetime_utils.dart';
import 'package:intl/intl.dart';

/// degree to Right ascension
RightAscension? raDegree2RightAscension(RaDeg ra) {
  var deg = ra.degrees.abs();

  var hour = (deg / 15.0).floor();
  var min = (((deg / 15.0) - hour) * 60).floor();
  var sec = ((((deg / 15.0) - hour) * 60) - min) * 60;

  return RightAscension(_sign(ra.degrees), hour, min, sec);
}

/// Right ascension hms to degree
RaDeg? raRightAscension2Degree(RightAscension equatorial) {
  var h = equatorial.hours;
  var m = equatorial.minutes;
  var s = equatorial.seconds;

  var sDeg = (s / 240.0);
  var deg = (h * 15.0) + (m / 4.0) + sDeg;
  var _sign = equatorial.sign == 0 ? 1 : equatorial.sign;

  return RaDeg(_sign * deg);
}

int _sign(double num) {
  return num < 0 ? -1 : 1;
}

/// equatorial coordinate system
class RightAscension {
  int sign = 1;
  late int hours;
  late int minutes;
  late double seconds;

  RightAscension(this.sign, int hours, int min, double sec) {
    this.hours = hours.abs();
    minutes = min.abs();
    seconds = sec.abs();
  }

  int get milliseconds {
    return ((seconds - seconds.truncate()) * 1000).round();
  }

  static RightAscension? fromDuration(Duration? duration) {
    if (duration == null) return null;
    var _hours = duration.inHours;
    var _minutes = duration.inMinutes.abs().remainder(60);
    var _seconds = duration.inSeconds.abs().remainder(60);
    var _mseconds = (duration.abs().inMilliseconds - duration.abs().inSeconds * 1000).round();
    var _msStr = _mseconds.toString().padLeft(3, '0');
    var _secondsD = double.parse('$_seconds.$_msStr');
    return RightAscension(duration.isNegative ? -1 : 1, _hours, _minutes, _secondsD);
  }

  Duration toDuration() {
    var duration = Duration(
        hours: hours, minutes: minutes, seconds: seconds.truncate(), milliseconds: milliseconds);

    if (sign < 0) duration = -duration;

    return duration;
  }

  static RightAscension? parse(String input) {
    var regex = RegExp(r"([+|-]?)([\d]*):([\d]*):([\d]*)(\.\d*)*");
    var matches = regex.allMatches(input);

    if (matches.isNotEmpty) {
      var match =matches.first;
      return RightAscension(
          (matches.first.group(1) == "-") ? -1 : 1,
          int.parse(match.group(2) ?? ''),
          int.parse(match.group(3) ?? ''),
          ((match.group(5) == null) || match.group(5)!.isEmpty)
              ? double.parse(match.group(4) ?? '')
              : double.parse((match.group(4) ?? '') + match.group(5)!));
    } else {
      return null;
    }
  }

  @override
  String toString() {
    var hourFormat = hours + (minutes / 60) + (seconds / 3600);

    return (sign < 0 ? '-' : '') + formatHoursToHHmmss(hourFormat, limitHours: false);
  }
}

class RaDeg {
  late double degrees;

  RaDeg(this.degrees);

  static RaDeg fromDMM(int? sign, int? degrees, double? minutes) {
    sign ??= 1;
    degrees ??= 0;
    minutes ??= 0.0;
    return RaDeg(sign * (degrees.abs() + minutes / 60.0));
  }

  static RaDeg fromDMS(int? sign, int? degrees, int? minutes, double? seconds) {
    sign ??= 1;
    degrees ??= 0;
    minutes ??= 0;
    seconds ??= 0.0;
    return RaDeg(sign * (degrees.abs() + minutes / 60.0 + seconds / 60.0 / 60.0));
  }

  static RaDeg fromDEC(int? sign, double? degrees) {
    sign ??= 1;
    degrees ??= 0.0;
    return RaDeg(sign * degrees);
  }

  static RaDeg? parse(String input, {bool wholeString = false}) {
    var _input = dec.prepareInput(input, wholeString: wholeString);
    if (_input == null) return null;

    RegExp regex = RegExp(_PATTERN_RADEG + regexEnd, caseSensitive: false);

    if (regex.hasMatch(_input)) {
      var matches = regex.firstMatch(_input);
      if (matches == null) return null;

      var sign = dec.latLngPartSign(matches.group(1));
      var degree = 0.0;
      if (matches.group(3) != null) {
        degree = sign * double.parse('${matches.group(2)}.${matches.group(3)}');
      } else {
        degree = sign * double.parse('${matches.group(2)}.0');
      }

      return RaDeg(degree);
    }
    return null;
  }

  @override
  String toString([int precision = 10]) {
    if (precision < 1) precision = 1;

    String fixedDigits = '0' * min(precision, 3);
    String variableDigits = precision > 3 ? '#' * (precision - 3) : '';

    return NumberFormat('0.' + fixedDigits + variableDigits).format(degrees);
  }

  static const _PATTERN_RADEG = '^\\s*?'
      '([\\+\\-])?\\s*?' //sign
      '(\\d{1,3})\\s*?' //degrees
      '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //millidegrees
      '[\\s°]?\\s*?'; //degree symbol
}
