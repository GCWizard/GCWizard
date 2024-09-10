import 'package:intl/intl.dart';

const Map<int, String> WEEKDAY = {
  1: 'dates_weekday_monday',
  2: 'dates_weekday_tuesday',
  3: 'dates_weekday_wednesday',
  4: 'dates_weekday_thursday',
  5: 'dates_weekday_friday',
  6: 'dates_weekday_saturday',
  7: 'dates_weekday_sunday'
};

const Map<int, String> MONTH = {
  1: 'common_month_january',
  2: 'common_month_february',
  3: 'common_month_march',
  4: 'common_month_april',
  5: 'common_month_may',
  6: 'common_month_june',
  7: 'common_month_july',
  8: 'common_month_august',
  9: 'common_month_september',
  10: 'common_month_october',
  11: 'common_month_november',
  12: 'common_month_december',
};

enum _CalendarType { JULIAN, GREGORIAN }

DateTime julianDateToGregorianCalendar(double jd) {
  return _JDToCal(jd, _CalendarType.GREGORIAN);
}

DateTime julianDateToJulianCalendar(double jd) {
  return _JDToCal(jd, _CalendarType.JULIAN);
}

double gregorianCalendarToJulianDate(DateTime date) {
  return _calToJD(date, _CalendarType.GREGORIAN);
}

double julianCalendarToJulianDate(DateTime date) {
  return _calToJD(date, _CalendarType.JULIAN);
}

double _calToJD(DateTime date, _CalendarType type) {
  int day = date.day;
  int month = date.month;
  int year = date.year;

  if (month <= 2) {
    year = year - 1;
    month = month + 12;
  }

  int b = 0;
  if (type == _CalendarType.GREGORIAN) b = 2 - (year / 100).floor() + (year / 400).floor();

  return (365.25 * (year + 4716)).floor() + (30.6001 * (month + 1)).floor() + day + b - 1524.5;
}

DateTime _JDToCal(double jd, _CalendarType type) {
  int z = (jd + 0.5).floor();
  double f = jd + 0.5 - z;
  int a = z;
  int alpha = 0;
  if (type == _CalendarType.GREGORIAN) {
    alpha = ((z - 1867216.25) / 36524.25).floor();
    a = z + 1 + alpha - (alpha / 4).floor();
  }
  int b = a + 1524;
  int c = ((b - 122.1) / 365.25).floor();
  int d = (365.25 * c).floor();
  int e = ((b - d) / 30.6001).floor();
  double day = b - d - (30.6001 * e).floor() + f;
  int month = 0;
  int year = 0;
  if (e <= 13) {
    month = e - 1;
    year = c - 4716;
  } else {
    month = e - 13;
    year = c - 4715;
  }

  if (!validDateTime(year, month, day.truncate())) {
    return (year < minDateTime().year) ? minDateTime() :maxDateTime();
  }

  return DateTime(year, month, day.truncate());
}

const _DATETIME_MAX_YEAR = 275760;
const _DATETIME_MAX_MONTH = 9;
const _DATETIME_MAX_DAY = 13;
const _DATETIME_MIN_YEAR = -271821;
const _DATETIME_MIN_MONTH = 4;
const _DATETIME_MIN_DAY = 20;

DateTime minDateTime() {
  return DateTime.utc(_DATETIME_MIN_YEAR,_DATETIME_MIN_MONTH,_DATETIME_MIN_DAY);
}

DateTime maxDateTime() {
  return DateTime.utc(_DATETIME_MAX_YEAR,_DATETIME_MAX_MONTH,_DATETIME_MAX_DAY);
}

bool validDateTime(int year, int month, int day) {
  // https://stackoverflow.com/questions/67144785/flutter-dart-datetime-max-min-value
  if (year > _DATETIME_MAX_YEAR ||
      (year == _DATETIME_MAX_YEAR && month > _DATETIME_MAX_MONTH) ||
      (year == _DATETIME_MAX_YEAR && month == _DATETIME_MAX_MONTH && day > _DATETIME_MAX_DAY)) {
    return false;
  }

  if (year < _DATETIME_MIN_YEAR ||
      (year == _DATETIME_MIN_YEAR && month > _DATETIME_MIN_MONTH) ||
      (year == _DATETIME_MIN_YEAR && month == _DATETIME_MIN_MONTH && day > _DATETIME_MIN_DAY)) {
    return false;
  }

  return true;
}

String replaceMonthNameWithCustomString(DateTime date, String datePattern, String locale, String? customMonth) {
  var dateStr = DateFormat(datePattern, locale).format(date);
  if (!datePattern.contains('MMMM')) {
    return dateStr;
  }

  var monthName = DateFormat('MMMM', locale).format(date);

  return dateStr.replaceFirst(monthName, customMonth ?? '');
}

String formatDaysToNearestUnit(double days) {
  var format = NumberFormat('0.00');

  if (days >= 365 * 1000000) return format.format(days / (365 * 1000000)) + ' Mio. a';
  if (days >= 365) return format.format(days / 365) + ' a';
  if (days >= 1) return format.format(days) + ' d';
  if (days >= 1 / 24) return format.format(days / (1 / 24)) + ' h';
  if (days >= 1 / 24 / 60) return format.format(days / (1 / 24 / 60)) + ' min';
  if (days >= 1 / 24 / 60 / 60) return format.format(days / (1 / 24 / 60 / 60)) + ' s';

  return format.format(days / (1 / 24 / 60 / 60 / 1000)) + ' ms';
}

DateTime hoursToHHmmss(double hours) {
  var h = hours.floor();
  var minF = (hours - h) * 60;
  var min = minF.floor();
  var secF = (minF - min) * 60;
  var sec = secF.floor();
  var milliSec = ((secF - sec) * 1000).round();

  return DateTime(0, 1, 1, h, min, sec, milliSec);
}

String formatHoursToHHmmss(double hours, {bool milliseconds = true, bool limitHours = true}) {
  var time = hoursToHHmmss(hours);

  var h = time.hour;
  var min = time.minute;
  var sec = time.second + time.millisecond / 1000.0;
  if (!limitHours) h += (time.day - 1) * 24 + (time.month - 1) * 31;

  var secondsStr = milliseconds ? NumberFormat('00.000').format(sec) : NumberFormat('00').format(sec.truncate());
  //Values like 59.999999999 may be rounded to 60.0. So in that case,
  //the greater unit (minutes or degrees) has to be increased instead
  if (secondsStr.startsWith('60')) {
    secondsStr = milliseconds ? '00.000' : '00';
    min += 1;
  }

  var minutesStr = min.toString().padLeft(2, '0');
  if (minutesStr.startsWith('60')) {
    minutesStr = '00';
    h += 1;
  }

  var hourStr = h.toString().padLeft(2, '0');

  return '$hourStr:$minutesStr:$secondsStr';
}

String formatDurationToHHmmss(Duration duration, {bool days = true, bool milliseconds = true, bool limitHours = true}) {
  var sign = duration.isNegative ? '-' : '';
  var _duration = duration.abs();
  var hours = days ? _duration.inHours.remainder(24) : _duration.inHours;
  var minutes = _duration.inMinutes.remainder(60);
  var seconds = _duration.inSeconds.remainder(60);
  var dayValue = limitHours ? _duration.inDays : _duration.inDays;

  var hourFormat = hours + (minutes / 60) + (seconds / 3600);

  return sign +
      (days ? dayValue.toString() + ':' : '') +
      formatHoursToHHmmss(hourFormat, milliseconds: milliseconds, limitHours: limitHours);
}
