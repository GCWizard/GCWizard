part of 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

double ExcelTimestampToJulianDate(int timestamp) {
  Duration days = Duration(days: timestamp);
  if (timestamp > 60) days = days - const Duration(days: 1); // correct Excel Bug - 1900 is a leap year
  DateTime date = DateTime(
    1900,
    1,
    0,
  ).add(days);
  return gregorianCalendarToJulianDate(date);
}

String JulianDateToExcelTimestamp(double jd) {
  return (jd - JD_EXCEL_START + 1).toStringAsFixed(0);
}
