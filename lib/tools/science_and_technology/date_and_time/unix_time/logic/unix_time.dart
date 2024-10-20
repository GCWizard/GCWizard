//https://de.wikipedia.org/wiki/Unixzeit

import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_constants.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

class UnixTimeOutput {
  final int UnixTimeStamp;
  final DateTime GregorianDateTimeUTC;
  final String Error;

  UnixTimeOutput({
    required this.UnixTimeStamp,
    required this.GregorianDateTimeUTC,
    required this.Error,
  });
}

UnixTimeOutput DateTimeUTCToUnixTime(DateTime currentDateTimeUTC) {
  if (_invalidUnixDate(gregorianCalendarToJulianDate(currentDateTimeUTC))) {
    return UnixTimeOutput(Error: 'dates_calendar_unix_error', UnixTimeStamp: 0, GregorianDateTimeUTC: currentDateTimeUTC);
  }

  int jahr = currentDateTimeUTC.year;
  int monat = currentDateTimeUTC.month;
  int tag = currentDateTimeUTC.day;
  int stunde = currentDateTimeUTC.hour;
  int minute = currentDateTimeUTC.minute;
  int sekunde = currentDateTimeUTC.second;

  const tage_seit_jahresanfang = /* Anzahl der Tage seit Jahresanfang ohne Tage des aktuellen Monats und ohne Schalttag */
      [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];

  int schaltjahre = ((jahr - 1) - 1968) ~/ 4 /* Anzahl der Schaltjahre seit 1970 (ohne das evtl. laufende Schaltjahr) */
      -
      ((jahr - 1) - 1900) ~/ 100 +
      ((jahr - 1) - 1600) ~/ 400;

  int tage_seit_1970 = (jahr - 1970) * 365 + schaltjahre + tage_seit_jahresanfang[monat - 1] + tag - 1;

  if ((monat > 2) && (jahr % 4 == 0 && (jahr % 100 != 0 || jahr % 400 == 0))) {
    tage_seit_1970 += 1;
  } /* +Schalttag, wenn jahr Schaltjahr ist */
  return UnixTimeOutput(
      UnixTimeStamp: sekunde + 60 * (minute + 60 * (stunde + 24 * tage_seit_1970)),
      GregorianDateTimeUTC: currentDateTimeUTC,
      Error: '');
}

UnixTimeOutput UnixTimeToDateTimeUTC(int unixtime) {
  return UnixTimeOutput(
      GregorianDateTimeUTC: DateTime.utc(1970, 1, 1, 0, 0, 0).add(Duration(seconds: unixtime)),
      UnixTimeStamp: unixtime,
      Error: '');
}

bool _invalidUnixDate(double jd) {
  if (jd < JD_UNIX_START) return true;
  return false;
}
