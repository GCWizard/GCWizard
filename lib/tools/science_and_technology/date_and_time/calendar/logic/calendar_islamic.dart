part of 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

DateTime? JulianDateToIslamicCalendar(double jd) {

  if (jd < MIN_JD || jd > MAX_JD) return null;

  int l = (jd + 0.5).floor() - 1948440 + 10632;
  int n = intPart((l - 1) / 10631);
  l = l - 10631 * n + 354;
  int j =
      (intPart((10985 - l) / 5316)) * (intPart((50 * l) / 17719)) + (intPart(l / 5670)) * (intPart((43 * l) / 15238));
  l = l - (intPart((30 - j) / 15)) * (intPart((17719 * j) / 50)) - (intPart(j / 16)) * (intPart((15238 * j) / 43)) + 29;
  int m = intPart((24 * l) / 709);
  int d = l - intPart((709 * m) / 24);
  int y = 30 * n + j - 30;

  if (validDateTime(y, m, d)) {
    return DateTime(y, m, d);
  } else {
    return null;
  }
}

double IslamicCalendarToJulianDate(CustomCalendarDate date) {
  int d = date.day;
  int m = date.month;
  int y = date.year;
  return (intPart((11 * y + 3) / 30) + 354 * y + 30 * m - intPart((m - 1) / 2) + d + 1948440 - 385).toDouble();
}
