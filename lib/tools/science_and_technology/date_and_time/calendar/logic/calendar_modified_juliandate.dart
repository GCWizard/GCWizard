part of 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

double JulianDateToModifedJulianDate(double jd) {
  return jd - 2400000.5;
}

double ModifedJulianDateToJulianDate(double mjd) {
  return mjd + 2400000.5;
}
