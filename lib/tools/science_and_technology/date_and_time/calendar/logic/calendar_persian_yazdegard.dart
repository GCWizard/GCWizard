part of 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

DateTime? JulianDateToPersianYazdegardCalendar(double jd) {

  if (jd < MIN_JD || jd > MAX_JD) return null;

  int epagflg = 0; // Epagomenai: Change at 1007 Jul./376 Yaz.
  int epag_change = 2088938;
  int d_diff = intPart(jd + 0.5) - 1952063;
  int y = intPart(d_diff / 365) + 1;
  int y_diff = d_diff - (y - 1) * 365;
  int epalim = 240;
  if ((jd > epag_change && epagflg == 0) || (epagflg == 2)) {
    epalim = 360;
  }
  int m = intPart((y_diff - intPart(y_diff / epalim) * 5) / 30) + 1;
  int d = y_diff - (m - 1) * 30 - intPart(y_diff / (epalim + 5)) * 5 + 1;

  if (validDateTime(y, m, d)) {
    return DateTime(y, m, d);
  } else {
    return null;
  }
}

double PersianYazdegardCalendarToJulianDate(CustomCalendarDate date) {
  int epagflg = 0; // Epagomenai: Change at 1007 Jul./376 Yaz.
  int yaz_ep = 1951668;
  int m = date.month;
  int d = date.day;
  int y = date.year;
  if (m > 8 && ((y < 376 && epagflg == 0) || (epagflg == 1))) {
    yaz_ep = yaz_ep + 5; // days increased by Epagomenai
  }
  return (yaz_ep + d - 1 + m * 30 + y * 365).toDouble();
}