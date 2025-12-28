// https://www.aoi.uzh.ch/de/islamwissenschaft/hilfsmittel/tools/kalenderumrechnung/yazdigird.html
// http://www.nabkal.de/kalrech.html
// jüdisch   http://www.nabkal.de/kalrechyud.html
// koptisch  http://www.nabkal.de/kalrech8.html
// iranisch  http://www.nabkal.de/kalrechiran.html
// https://web.archive.org/web/20071012175539/http://ortelius.de/kalender/basic_de.php

import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_constants.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

part 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_coptic.dart';
part 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_excel.dart';
part 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_hebrew.dart';
part 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_islamic.dart';
part 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_modified_juliandate.dart';
part 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_persian_yazdegard.dart';
part 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_potrzebie.dart';
part 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_unix.dart';

class CustomCalendarDate {
  int day;
  int month;
  int year;

  CustomCalendarDate({required this.year, required this.month, required this.day});
}

int intPart(double floatNum) {
  if (floatNum < -0.0000001) {
    return (floatNum - 0.0000001).ceil();
  } else {
    return (floatNum + 0.0000001).floor();
  }
}

int JulianDateToJulianDayNumber(double jd) {
  return jd.floor();
}

int Weekday(double JD) {
  return 1 + (JD + 0.5).floor() % 7;
}

int JulianDay(DateTime date) {
  return 1 + (gregorianCalendarToJulianDate(DateTime(date.year, date.month, date.day)) - gregorianCalendarToJulianDate(DateTime(date.year, 1, 1))).toInt();
}
