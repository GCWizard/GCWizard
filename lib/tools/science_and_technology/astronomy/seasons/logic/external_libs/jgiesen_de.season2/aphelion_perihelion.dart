// ported from http://www.jgiesen.de/astro/astroJS/seasons2/seasons.js
// with permission of the owner via email (2020-06-26, forwarded to geocache.wizard@gmail.com on 2020-06-29)
part of 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/seasons.dart';

double _r0(double t) {
  var LArray = [
    [100013989, 0, 0],
    [1670700, 3.0984635, 6283.0758500],
    [13956, 3.05525, 12566.15170],
    [3084, 5.1985, 77713.7715],
    [1628, 1.1739, 5753.3849],
    [1576, 2.8469, 7860.4194],
    [925, 5.453, 11506.770],
    [542, 4.564, 3930.210],
    [472, 3.661, 5884.927],
    [346, 0.964, 5507.553],
    [329, 5.900, 5223.694],
    [307, 0.299, 5573.143],
    [243, 4.273, 11790.629],
    [212, 5.847, 1577.344],
    [186, 5.022, 10977.079],
    [175, 3.012, 18849.228],
    [110, 5.055, 5486.778],
    [98, 0.89, 6069.78],
    [86, 5.69, 15720.84],
    [86, 1.27, 161000.69],
    [65, 0.27, 17260.15],
    [63, 0.92, 529.69],
    [57, 2.01, 83996.85],
    [56, 5.24, 71430.70],
    [49, 3.25, 2544.31],
    [47, 2.58, 775.52],
    [45, 5.54, 9437.76],
    [43, 6.01, 6275.96],
    [39, 5.36, 4694.00],
    [38, 2.39, 8827.39],
    [37, 0.83, 19651.05],
    [37, 4.90, 12139.55],
    [36, 1.67, 12036.46],
    [35, 1.84, 2942.46],
    [33, 0.24, 7084.90],
    [32, 0.18, 5088.63],
    [32, 1.78, 398.15],
    [28, 1.21, 6286.60],
    [28, 1.90, 6279.55],
    [26, 4.59, 10447.39]
  ];

  double r0 = 0;
  for (int i = 0; i < LArray.length; ++i) {
    r0 = r0 + LArray[i][0] * cos(LArray[i][1] + LArray[i][2] * t);
  }

  return r0;
}

double _r1(double t) {
  var LArray = [
    [103019, 1.107490, 6283.075850],
    [1721, 1.0644, 12566.1517],
    [702, 3.142, 0],
    [32, 1.02, 18849.23],
    [31, 2.84, 5507.55],
    [25, 1.32, 5223.69],
    [18, 1.42, 1577.34],
    [10, 5.91, 10977.08],
    [9, 1.42, 6275.96],
    [9, 0.27, 5486.78]
  ];

  double r1 = 0;
  for (int i = 0; i < LArray.length; ++i) {
    r1 = r1 + LArray[i][0] * cos(LArray[i][1] + LArray[i][2] * t);
  }

  return r1;
}

double _r2(double t) {
  var LArray = [
    [4359, 5.7846, 6283.0758],
    [124, 5.579, 12566.152],
    [12, 3.14, 0],
    [9, 3.63, 77713.77],
    [6, 1.87, 5573.14],
    [3, 5.47, 18849.23],
  ];

  double r2 = 0;
  for (int i = 0; i < LArray.length; ++i) {
    r2 = r2 + LArray[i][0] * cos(LArray[i][1] + LArray[i][2] * t);
  }

  return r2;
}

double _r3(double t) {
  var LArray = [
    [145, 4.273, 6283.076],
    [7, 3.92, 12566.15]
  ];

  double r3 = 0;
  for (int i = 0; i < LArray.length; ++i) {
    r3 = r3 + LArray[i][0] * cos(LArray[i][1] + LArray[i][2] * t);
  }

  return r3;
}

double _r4(double t) {
  var LArray = [4, 2.56, 6283.08];
  double r4 = LArray[0] * cos(LArray[1] + LArray[2] * t);

  return r4;
}

double _quad(double y0, double yM, double yP, double dX) {
  double x1 = -dX;
  double x2 = dX;
  double a = (yM * x2 - yP * x1 - y0 * (x2 - x1)) / (x1 * x1 * x2 - x2 * x2 * x1);
  double b = (yM - y0 - a * x1 * x1) / x1;

  return -b / (2 * a);
}

double _JD(int date, int month, int year, double STD) {
  double A;
  int B;
  double MJD;
  A = 10000.0 * year + 100.0 * month + date;

  if (month <= 2) {
    month = month + 12;
    year = year - 1;
  }

  if (A <= 15821004.1) {
    B = -2 + ((year + 4716) / 4).floor() - 1179;
  } else {
    B = (year / 400).floor() - (year / 100).floor() + (year / 4).floor();
  }

  A = 365.0 * year - 679004.0;
  MJD = A + B + (30.6001 * (month + 1)).floor() + date + STD / 24.0;
  return MJD + 2400000.5;
}

double _earthR(int date, int month, int year, double UT) {
  double JDE = _JD(date, month, year, UT);
  double T = (JDE - 2451545.0) / 365250.0;
  return (_r0(T) + _r1(T) * T + _r2(T) * T * T + _r3(T) * T * T * T + _r4(T) * T * T * T * T) / (1.0E8);
}

DateTimeDouble _perihelion(int year) {
  double minR = 10;
  var d = 0;
  var h = 100.0;

  double R;
  for (int i = 1; i < 6; ++i) {
    R = _earthR(i, 1, year, 12);
    if (R < minR) {
      minR = R;
      d = i;
    }
  }

  minR = 10;
  d = d - 1;
  for (int i = 0; i < 49; ++i) {
    R = _earthR(d, 1, year, i.toDouble());
    if (R < minR) {
      minR = R;
      h = i.toDouble();
    }
  }

  if (h >= 24) {
    d = d + 1;
    h = h - 24;
  }

  h = h - 1;
  R = 10;
  var min = 0;
  for (int i = 0; i < 121; ++i) {
    R = _earthR(d, 1, year, h + i / 60.0);
    if (R < minR) {
      minR = R;
      min = i;
    }
  }

  h = h + min / 60.0;
  if (h >= 24) {
    h = h - 24;
    d = d + 1;
  }

  double r0 = _earthR(d, 1, year, h);
  double rM = _earthR(d, 1, year, h - 1);
  double rP = _earthR(d, 1, year, h + 1);

  double minFrac = _quad(r0, rM, rP, 1);
  h = h + minFrac;

  double rp = _earthR(d, 1, year, h);

  var time = hoursToHHmmss(h);

  return DateTimeDouble(
      datetime: DateTime(year, 1, d, time.hour, time.minute, time.second, time.millisecond), value: rp);
}

DateTimeDouble _aphelion(int year) {
  var minR = 0.0;
  var d = 0;
  var h = 100.0;
  double R;

  for (int i = 3; i < 7; ++i) {
    R = _earthR(i, 7, year, 12);
    if (R > minR) {
      minR = R;
      d = i;
    }
  }

  minR = 0;
  --d;
  for (int i = 0; i < 49; ++i) {
    R = _earthR(d, 7, year, i.toDouble());
    if (R > minR) {
      minR = R;
      h = i.toDouble();
    }
  }

  if (h >= 24) {
    ++d;
    h -= 24;
  }

  h = h - 1;
  R = 0;
  var min = 0;

  for (int i = 0; i < 121; ++i) {
    R = _earthR(d, 7, year, h + i / 60.0);
    if (R > minR) {
      minR = R;
      min = i;
    }
  }
  h = h + min / 60.0;

  if (h >= 24) {
    h = h - 24;
    d = d + 1;
  }

  double r0 = _earthR(d, 7, year, h);
  double rM = _earthR(d, 7, year, h - 1);
  double rP = _earthR(d, 7, year, h + 1);

  double minFrac = _quad(r0, rM, rP, 1);
  h = h + minFrac;

  double ra = _earthR(d, 7, year, h);

  var time = hoursToHHmmss(h);

  return DateTimeDouble(
      datetime: DateTime(year, 7, d, time.hour, time.minute, time.second, time.millisecond), value: ra);
}
