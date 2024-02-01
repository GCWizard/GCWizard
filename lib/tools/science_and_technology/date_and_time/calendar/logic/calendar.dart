// https://www.aoi.uzh.ch/de/islamwissenschaft/hilfsmittel/tools/kalenderumrechnung/yazdigird.html
// http://www.nabkal.de/kalrech.html
// jüdisch   http://www.nabkal.de/kalrechyud.html
// koptisch  http://www.nabkal.de/kalrech8.html
// iranisch  http://www.nabkal.de/kalrechiran.html
// https://web.archive.org/web/20071012175539/http://ortelius.de/kalender/basic_de.php

import 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar_constants.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

bool _validDateTime(int year, int month, int day) {
  // https://stackoverflow.com/questions/67144785/flutter-dart-datetime-max-min-value
  const _DATETIME_MAX_YEAR = 275760;
  const _DATETIME_MAX_MONTH = 9;
  const _DATETIME_MAX_DAY = 13;
  const _DATETIME_MIN_YEAR = -271821;
  const _DATETIME_MIN_MONTH = 4;
  const _DATETIME_MIN_DAY = 20;

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

double UnixTimestampToJulianDate(int timestamp) {
  DateTime date = DateTime(1970, 1, 1, 0, 0, 0).add(Duration(seconds: timestamp));

  return gregorianCalendarToJulianDate(date);
}

String JulianDateToUnixTimestamp(double jd) {
  return ((jd - JD_UNIX_START) * 86400).toStringAsFixed(0);
}

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

int intPart(double floatNum) {
  if (floatNum < -0.0000001) {
    return (floatNum - 0.0000001).ceil();
  } else {
    return (floatNum + 0.0000001).floor();
  }
}

double JulianDateToModifedJulianDate(double jd) {
  return jd - 2400000.5;
}

double ModifedJulianDateToJulianDate(double mjd) {
  return mjd + 2400000.5;
}

int JulianDateToJulianDayNumber(double jd) {
  return jd.floor();
}

int Weekday(double JD) {
  return 1 + (JD + 0.5).floor() % 7;
}

int JulianDay(DateTime date) {
  return 1 + (gregorianCalendarToJulianDate(date) - gregorianCalendarToJulianDate(DateTime(date.year, 1, 1))).toInt();
}

DateTime? JulianDateToIslamicCalendar(double jd) {
  int l = (jd + 0.5).floor() - 1948440 + 10632;
  int n = intPart((l - 1) / 10631);
  l = l - 10631 * n + 354;
  int j =
      (intPart((10985 - l) / 5316)) * (intPart((50 * l) / 17719)) + (intPart(l / 5670)) * (intPart((43 * l) / 15238));
  l = l - (intPart((30 - j) / 15)) * (intPart((17719 * j) / 50)) - (intPart(j / 16)) * (intPart((15238 * j) / 43)) + 29;
  int m = intPart((24 * l) / 709);
  int d = l - intPart((709 * m) / 24);
  int y = 30 * n + j - 30;

  if (_validDateTime(y, m, d)) {
    return DateTime(y, m, d);
  } else {
    return null;
  }
}

double IslamicCalendarToJulianDate(DateTime date) {
  int d = date.day;
  int m = date.month;
  int y = date.year;
  return (intPart((11 * y + 3) / 30) + 354 * y + 30 * m - intPart((m - 1) / 2) + d + 1948440 - 385).toDouble();
}

DateTime? JulianDateToPersianYazdegardCalendar(double jd) {
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

  if (_validDateTime(y, m, d)) {
    return DateTime(y, m, d);
  } else {
    return null;
  }
}

double PersianYazdegardCalendarToJulianDate(DateTime date) {
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

const List<int> _jregyeardef = [30, 29, 29, 29, 30, 29, 30, 29, 30, 29, 30, 29];
const List<int> _jregyearreg = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
const List<int> _jregyearcom = [30, 30, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];

const List<int> _jembyeardef = [30, 29, 29, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29];
const List<int> _jembyearreg = [30, 29, 30, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29];
const List<int> _jembyearcom = [30, 30, 30, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29];

String typeOfJewYear(int yearlength) {
  if (yearlength == 353) {
    return "common, deficient";
  } else if (yearlength == 354) {
    return "common, regular";
  } else if (yearlength == 355) {
    return "common, complete";
  } else if (yearlength == 383) {
    return "embolistic, deficient";
  } else if (yearlength == 384) {
    return "embolistic, regular";
  } else if (yearlength == 385) {
    return "embolistic, complete";
  } else {
    return ("common");
  }
}

List<int> jewDayAndMonthInYear(int days, int yearlength) {
  List<int> mschema = _jregyeardef;
  if (yearlength == 353) {
    mschema = _jregyeardef;
  } else if (yearlength == 354) {
    mschema = _jregyearreg;
  } else if (yearlength == 355) {
    mschema = _jregyearcom;
  } else if (yearlength == 383) {
    mschema = _jembyeardef;
  } else if (yearlength == 384) {
    mschema = _jembyearreg;
  } else if (yearlength == 385) {
    mschema = _jembyearcom;
  }

  var oldSum = days;
  var newSum = days;
  var i = 0;
  while (newSum > 0) {
    oldSum = newSum;
    newSum = oldSum - mschema[i];
    i = i + 1;
  }
  List<int> resArr = [1, 1];
  resArr[0] = oldSum + 1;
  if (i == 0) i = 1;

  resArr[1] = i;
  return resArr;
}

int daysInJewYear(int d, int m, int yearlength) {
  List<int> mschema = _jregyeardef;
  if (yearlength == 353) {
    mschema = _jregyeardef;
  } else if (yearlength == 354) {
    mschema = _jregyearreg;
  } else if (yearlength == 355) {
    mschema = _jregyearcom;
  } else if (yearlength == 383) {
    mschema = _jembyeardef;
  } else if (yearlength == 384) {
    mschema = _jembyearreg;
  } else if (yearlength == 385) {
    mschema = _jembyearcom;
  }
  int i = 0;
  int days = 0;
  while (i < m - 1) {
    days = days + mschema[i];
    i = i + 1;
  }
  return days + d;
}

int cyear2pesach(int xx) {
  int cc = (0.01 * xx).floor();
  int ss = (0.25 * (3 * cc - 5)).floor();
  if (xx < 1583) {
    ss = 0;
  }
  int a = (12 * xx + 12) % 19;
  int b = xx % 4;
  double qq = -1.904412361576 + 1.554241796621 * a + 0.25 * b - 0.003177794022 * xx + ss;
  int j = ((qq).floor() + 3 * xx + 5 * b + 2 - ss) % 7;
  double r = qq - (qq).floor();
  int dd = (qq).floor() + 22;
  if (j == 2 || j == 4 || j == 6) {
    dd = (qq).floor() + 23;
  } else if (j == 1 && a > 6 && r >= 0.632870370) {
    dd = (qq).floor() + 24;
  } else if (j == 0 && a > 11 && r >= 0.897723765) {
    dd = (qq).floor() + 23;
  }
  return dd;
}

int JewishYearLength(double jd) {
  DateTime GregorianDate = julianDateToGregorianCalendar(jd);
  int jyearlength = 0;
  int cy = GregorianDate.year;
  int pd = cyear2pesach(cy);
  int pm = 3;
  if (pd > 31) {
    pd = pd - 31;
    pm = 4;
  }
  int pjd = (gregorianCalendarToJulianDate(DateTime(cy, pm, pd)) + 0.5).floor();
  int jnyjd = pjd + 163;
  int jy = cy + 3761;
  if (jd < jnyjd) {
    jy = jy - 1;
    int pdprev = cyear2pesach(cy - 1);
    int pmprev = 3;
    if (pdprev > 31) {
      pdprev = pdprev - 31;
      pmprev = 4;
    }
    int pjdprev = (gregorianCalendarToJulianDate(DateTime(cy - 1, pmprev, pdprev)) + 0.5).floor();

    jyearlength = pjd - pjdprev;
  } else {
    int pdnext = cyear2pesach(cy + 1);
    int pmnext = 3;
    if (pdnext > 31) {
      pdnext = pdnext - 31;
      pmnext = 4;
    }
    int pjnext = (gregorianCalendarToJulianDate(DateTime(cy + 1, pmnext, pdnext)) + 0.5).floor();

    jyearlength = pjnext - pjd;
  }

  return jyearlength;
}

DateTime? JulianDateToHebrewCalendar(double jd) {
  int jday = 1;
  int jmonth = 1;
  DateTime GregorianDate = julianDateToGregorianCalendar(jd);
  int cy = GregorianDate.year;
  int pd = cyear2pesach(cy);
  int pm = 3;
  if (pd > 31) {
    pd = pd - 31;
    pm = 4;
  }
  int pjd = (gregorianCalendarToJulianDate(DateTime(cy, pm, pd)) + 0.5).floor();
  int jnyjd = pjd + 163;

  int jy = cy + 3761;

  if (jd < jnyjd) {
    jy = jy - 1;
    int pdprev = cyear2pesach(cy - 1);
    int pmprev = 3;
    if (pdprev > 31) {
      pdprev = pdprev - 31;
      pmprev = 4;
    }
    int pjdprev = (gregorianCalendarToJulianDate(DateTime(cy - 1, pmprev, pdprev)) + 0.5).floor();

    int jyearlength = pjd - pjdprev;
    int days = (jd + 0.5).floor() - pjdprev - 163;
    List<int> dateArr = jewDayAndMonthInYear(days, jyearlength);
    jmonth = dateArr[1];
    jday = dateArr[0];
  } else {
    int pdnext = cyear2pesach(cy + 1);
    int pmnext = 3;
    if (pdnext > 31) {
      pdnext = pdnext - 31;
      pmnext = 4;
    }
    int pjnext = (gregorianCalendarToJulianDate(DateTime(cy + 1, pmnext, pdnext)) + 0.5).floor();

    int jyearlength = pjnext - pjd;
    int days = (jd + 0.5).floor() - pjd - 163;
    List<int> dateArr = jewDayAndMonthInYear(days, jyearlength);
    jmonth = dateArr[1];
    jday = dateArr[0];
  }

  if (_validDateTime(jy, jmonth, jday)) {
    return DateTime(jy, jmonth, jday);
  } else {
    return null;
  }
}

double HebrewCalendarToJulianDate(DateTime date) {
  int jy = date.year;
  int m = date.month;
  int d = date.day;
  int cy = jy - 3761;
  int pd = cyear2pesach(cy);
  int pm = 3;
  if (pd > 31) {
    pd = pd - 31;
    pm = 4;
  }
  int pjd = (gregorianCalendarToJulianDate(DateTime(cy, pm, pd)) + 0.5).floor();
  int jnyjd = pjd + 163;
  int pdnext = cyear2pesach(cy + 1);
  int pmnext = 3;
  if (pdnext > 31) {
    pdnext = pdnext - 31;
    pmnext = 4;
  }
  int pjnext = (gregorianCalendarToJulianDate(DateTime(cy + 1, pmnext, pdnext)) + 0.5).floor();
  int jyearlength = pjnext - pjd;

  int days = daysInJewYear(d, m, jyearlength);
  int cjd = jnyjd + days - 1;
  return (cjd).toDouble();
}

DateTime? JulianDateToCopticCalendar(double jd) {
  int cop_j_bar = (jd + 0.5).floor() + 124;

  int cop_y_bar = intPart((4 * cop_j_bar + 3) / 1461);
  int cop_t_bar = intPart(((4 * cop_j_bar + 3) % 1461) / 4);
  int cop_m_bar = intPart((1 * cop_t_bar + 0) / 30);
  int cop_d_bar = intPart(((1 * cop_t_bar + 0) % 30) / 1);
  int cop_d = cop_d_bar + 1;
  int cop_m = (cop_m_bar + 1 - 1) % 13 + 1;
  int cop_y = cop_y_bar - 4996 + intPart((13 + 1 - 1 - cop_m) / 13);

  if (_validDateTime(cop_y, cop_m, cop_d)) {
    return DateTime(cop_y, cop_m, cop_d);
  } else {
    return null;
  }
}

double CopticCalendarToJulianDate(DateTime date) {
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

class PotrzebieCalendarOutput {
  DateTime date;
  String suffix;

  PotrzebieCalendarOutput(this.date, this.suffix);
}

PotrzebieCalendarOutput JulianDateToPotrzebieCalendar(double jd) {
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
