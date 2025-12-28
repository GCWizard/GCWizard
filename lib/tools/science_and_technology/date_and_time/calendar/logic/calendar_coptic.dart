part of 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

DateTime? JulianDateToCopticCalendar(double jd) {

  if (jd < MIN_JD || jd > MAX_JD) return null;

  int cop_j_bar = (jd + 0.5).floor() + 124;

  int cop_y_bar = intPart((4 * cop_j_bar + 3) / 1461);
  int cop_t_bar = intPart(((4 * cop_j_bar + 3) % 1461) / 4);
  int cop_m_bar = intPart((1 * cop_t_bar + 0) / 30);
  int cop_d_bar = intPart(((1 * cop_t_bar + 0) % 30) / 1);
  int cop_d = cop_d_bar + 1;
  int cop_m = (cop_m_bar + 1 - 1) % 13 + 1;
  int cop_y = cop_y_bar - 4996 + intPart((13 + 1 - 1 - cop_m) / 13);

  if (validDateTime(cop_y, cop_m, cop_d)) {
    return DateTime(cop_y, cop_m, cop_d);
  } else {
    return null;
  }
}

double CopticCalendarToJulianDate(CustomCalendarDate date) {
  int cop_d = date.day;
  int cop_m = date.month;
  int cop_y = date.year;

  int cop_y_bar = cop_y + 4996 - intPart((13 + 1 - 1 - cop_m) / 13);
  int cop_m_bar = (cop_m - 1 + 13) % 13;
  int cop_d_bar = cop_d - 1;

  int c = intPart((1461 * cop_y_bar + 0) / 4);
  int d = intPart((30 * cop_m_bar + 0) / 1);
  return (c + d + cop_d_bar - 124).toDouble();
}
