part of 'package:gc_wizard/tools/science_and_technology/date_and_time/calendar/logic/calendar.dart';

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
  while (newSum > 0 && i < 12) {
    oldSum = newSum;
    newSum = oldSum - mschema[i];
    i += 1;
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
    i += 1;
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

  if (jd < MIN_JD || jd > MAX_JD) return null;

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
  if (!validDateTime(cy, pm, pd)) {
    return null;
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
    if (!validDateTime(cy - 1, pmprev, pdprev)) return null;
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
    if (!validDateTime(cy + 1, pmnext, pdnext)) return null;
    int pjnext = (gregorianCalendarToJulianDate(DateTime(cy + 1, pmnext, pdnext)) + 0.5).floor();

    int jyearlength = pjnext - pjd;
    int days = (jd + 0.5).floor() - pjd - 163;
    List<int> dateArr = jewDayAndMonthInYear(days, jyearlength);
    jmonth = dateArr[1];
    jday = dateArr[0];
  }

  if (validDateTime(jy, jmonth, jday)) {
    return DateTime(jy, jmonth, jday);
  } else {
    return null;
  }
}

double HebrewCalendarToJulianDate(CustomCalendarDate date) {
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
