part of 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

class PotrzebieCalendarOutput {
  DateTime date;
  String suffix;

  PotrzebieCalendarOutput(this.date, this.suffix);
}

PotrzebieCalendarOutput? JulianDateToPotrzebieCalendar(double jd) {

  if (jd < MIN_JD || jd > MAX_JD) return null;

// Day 0 in the Potrzebie-System is 01.10.1952
// Before MAD - B.M.   -   zero   -   Cowzofski Madi C.M
  double jd_p_zero = gregorianCalendarToJulianDate(DateTime(1952, 10, 1));
  int diff = (jd - jd_p_zero).round();
  bool bm = (diff < 0);
  if (diff < 0) diff = diff * -1;
  int cow = diff ~/ 100;
  int mingo = 1 + (diff % 100) ~/ 10;
  int clarke = 1 + (diff % 100) % 10;

  var suffix = bm ? 'B.M.' : 'C.M.';
  if (!validDateTime(cow, mingo, clarke)) {
    var newDate = (cow < minDateTime().year) ? minDateTime() : maxDateTime();
    cow = newDate.year;
    mingo = newDate.month;
    clarke = newDate.day;
  }

  return PotrzebieCalendarOutput(DateTime(cow, mingo, clarke), suffix);
}

double PotrzebieCalendarToJulianDate(DateTime date) {
  int p_d = date.day;
  int p_m = date.month;
  int p_y = date.year;

  int days = p_y * 100 + p_m * 10 + p_d;

  double jd_p_zero = gregorianCalendarToJulianDate(DateTime(1952, 10, 1)).floorToDouble() - 1;

  return jd_p_zero + days;
}
