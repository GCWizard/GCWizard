part of 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

double UnixTimestampToJulianDate(int timestamp) {
  DateTime date = DateTime(1970, 1, 1, 0, 0, 0).add(Duration(seconds: timestamp));

  return gregorianCalendarToJulianDate(date);
}

String JulianDateToUnixTimestamp(double jd) {
  return ((jd - JD_UNIX_START) * 86400).toStringAsFixed(0);
}
