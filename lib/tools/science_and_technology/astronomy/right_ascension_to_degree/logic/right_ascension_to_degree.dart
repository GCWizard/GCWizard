// https://github.com/maxogden/equatorial

import 'dart:math';

import 'package:gc_wizard/tools/coords/coordinate_format_parser/logic/latlon.dart';
import 'package:gc_wizard/tools/coords/format_converter/logic/dec.dart' as dec;
import 'package:gc_wizard/utils/datetime_utils.dart';
import 'package:intl/intl.dart';

/// degree to Right ascension
RightAscension raDegree2RightAscension(RaDeg ra) {
  if ((ra == null) || (ra.degrees == null)) return null;
  var deg = ra.degrees.abs();

  var hour = (deg / 15.0).floor();
  var min = (((deg / 15.0) - hour) * 60).floor();
  var sec = ((((deg / 15.0) - hour) * 60) - min) * 60;

  return RightAscension(_sign(ra.degrees), hour, min, sec);
}

/// Right ascension hms to degree
RaDeg raRightAscension2Degree(RightAscension equatorial) {
  if (equatorial == null) return null;

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
  int hours;
  int minutes;
  double seconds;

  RightAscension(int sign, int hours, int min, double sec) {
    this.sign = sign;
    this.hours = hours.abs();
    this.minutes = min.abs();
    this.seconds = sec.abs();
  }

  int get milliseconds {
    return ((this.seconds - this.seconds.truncate()) * 1000).round();
  }

  static RightAscension fromDuration(Duration duration) {
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
        hours: this.hours, minutes: this.minutes, seconds: this.seconds.truncate(), milliseconds: this.milliseconds);

    if (sign < 0) duration = -duration;

    return duration;
  }

  static RightAscension parse(String input) {
    var regex = new RegExp(r"([+|-]?)([\d]*):([\d]*):([\d]*)(\.\d*)*");
    if (input == null) return null;

    var matches = regex.allMatches(input);

    if (matches.length > 0) {
      return new RightAscension(
          (matches.first.group(1) == "-") ? -1 : 1,
          int.parse(matches.first.group(2)),
          int.parse(matches.first.group(3)),
          ((matches.first.group(5) == null) || matches.first.group(5).isEmpty)
              ? double.parse(matches.first.group(4))
              : double.parse(matches.first.group(4) + matches.first.group(5)));
    } else
      return null;
  }

  @override
  String toString() {
    var hourFormat = hours + (minutes / 60) + (seconds / 3600);

    return (sign < 0 ? '-' : '') + formatHoursToHHmmss(hourFormat, limitHours: false);
  }
}

class RaDeg {
  double degrees;

  RaDeg(double degrees) {
    this.degrees = degrees;
  }

  static RaDeg fromDMM(int sign, int degrees, double minutes) {
    if (sign == null) sign = 1;
    if (degrees == null) degrees = 0;
    if (minutes == null) minutes = 0.0;
    return RaDeg(sign * (degrees.abs() + minutes / 60.0));
  }

  static RaDeg fromDMS(int sign, int degrees, int minutes, double seconds) {
    if (sign == null) sign = 1;
    if (degrees == null) degrees = 0;
    if (minutes == null) minutes = 0;
    if (seconds == null) seconds = 0.0;
    return RaDeg(sign * (degrees.abs() + minutes / 60.0 + seconds / 60.0 / 60.0));
  }

  static RaDeg fromDEC(int sign, double degrees) {
    if (sign == null) sign = 1;
    if (degrees == null) degrees = 0.0;
    return RaDeg(sign * degrees);
  }

  static RaDeg parse(String input, {wholeString = false}) {
    input = dec.prepareInput(input, wholeString: wholeString);
    if (input == null) return null;

    RegExp regex = RegExp(_PATTERN_RADEG + regexEnd, caseSensitive: false);

    if (regex.hasMatch(input)) {
      var matches = regex.firstMatch(input);

      var sign = dec.sign(matches.group(1));
      var degree = 0.0;
      if (matches.group(3) != null)
        degree = sign * double.parse('${matches.group(2)}.${matches.group(3)}');
      else
        degree = sign * double.parse('${matches.group(2)}.0');

      return RaDeg(degree);
    }
    return null;
  }

  @override
  String toString([int precision = 10]) {
    if (precision < 1) precision = 1;

    String fixedDigits = '0' * min(precision, 3);
    String variableDigits = precision > 3 ? '#' * (precision - 3) : '';

    return '${NumberFormat('0.' + fixedDigits + variableDigits).format(degrees)}';
  }

  static final _PATTERN_RADEG = '^\\s*?'
      '([\\+\\-])?\\s*?' //sign
      '(\\d{1,3})\\s*?' //degrees
      '(?:\\s*?[.,]\\s*?(\\d+))?\\s*?' //millidegrees
      '[\\s°]?\\s*?'; //degree symbol
}
