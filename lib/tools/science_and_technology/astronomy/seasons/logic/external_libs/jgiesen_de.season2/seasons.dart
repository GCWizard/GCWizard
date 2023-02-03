// ported from http://www.jgiesen.de/astro/astroJS/seasons2/seasons.js
// with permission of the owner via email (2020-06-26, forwarded to geocache.wizard@gmail.com on 2020-06-29)

/*
Equinoxes and Solstices
algorithm from Meeus
adapted by Juergen Giesen
*/

part of 'package:gc_wizard/tools/science_and_technology/astronomy/seasons/logic/seasons.dart';

Map<String, DateTime> _computeSeasons(int year) {
  return {'spring': _spring(year), 'summer': _summer(year), 'autumn': _autumn(year), 'winter': _winter(year)};
}

double _s(double T) {
  double K = pi / 180.0;

  double x;
  x = 485 * cos(K * (324.96 + 1934.136 * T));
  x = x + 203 * cos(K * (337.23 + 32964.467 * T));
  x = x + 199 * cos(K * (342.08 + 20.186 * T));
  x = x + 182 * cos(K * (27.85 + 445267.112 * T));
  x = x + 156 * cos(K * (73.14 + 45036.886 * T));
  x = x + 136 * cos(K * (171.52 + 22518.443 * T));
  x = x + 77 * cos(K * (222.54 + 65928.934 * T));
  x = x + 74 * cos(K * (296.72 + 3034.906 * T));
  x = x + 70 * cos(K * (243.58 + 9037.513 * T));
  x = x + 58 * cos(K * (119.81 + 33718.147 * T));
  x = x + 52 * cos(K * (297.17 + 150.678 * T));
  x = x + 50 * cos(K * (21.02 + 2281.226 * T));

  x = x + 45 * cos(K * (247.54 + 29929.562 * T));
  x = x + 44 * cos(K * (325.15 + 31555.956 * T));
  x = x + 29 * cos(K * (60.93 + 4443.417 * T));
  x = x + 18 * cos(K * (155.12 + 67555.328 * T));

  x = x + 17 * cos(K * (288.79 + 4562.452 * T));
  x = x + 16 * cos(K * (198.04 + 62894.029 * T));
  x = x + 14 * cos(K * (199.76 + 31436.921 * T));
  x = x + 12 * cos(K * (95.39 + 14577.848 * T));
  x = x + 12 * cos(K * (287.11 + 31931.756 * T));
  x = x + 12 * cos(K * (320.81 + 34777.259 * T));
  x = x + 9 * cos(K * (227.73 + 1222.114 * T));
  x = x + 8 * cos(K * (15.45 + 16859.074 * T));

  return x;
}

// Jean Meeus, Astronomical Algorithms, chapter 27, p. 178
double _JDE0(int year, int month) {
  if (year < 1000) {
    var y = year / 1000.0;

    switch (month) {
      case 3:
        return 1721139.29189 + 365242.13740 * y + 0.06134 * y * y + 0.00111 * y * y * y - 0.00071 * y * y * y * y;
      case 6:
        return 1721233.25401 + 365241.72562 * y - 0.05323 * y * y + 0.00907 * y * y * y + 0.00025 * y * y * y * y;
      case 9:
        return 1721325.70455 + 365242.49558 * y - 0.11677 * y * y - 0.00297 * y * y * y + 0.00074 * y * y * y * y;
      case 12:
        return 1721414.39987 + 365242.88257 * y - 0.00769 * y * y - 0.00933 * y * y * y - 0.00006 * y * y * y * y;
    }
  } else {
    var y = (year - 2000.0) / 1000.0;

    switch (month) {
      case 3:
        return 2451623.80984 + 365242.37404 * y + 0.05169 * y * y - 0.00411 * y * y * y - 0.00057 * y * y * y * y;
      case 6:
        return 2451716.56767 + 365241.62603 * y + 0.00325 * y * y + 0.00888 * y * y * y - 0.00030 * y * y * y * y;
      case 9:
        return 2451810.21715 + 365242.01767 * y - 0.11575 * y * y + 0.00337 * y * y * y + 0.00078 * y * y * y * y;
      case 12:
        return 2451900.05952 + 365242.74049 * y - 0.06223 * y * y - 0.00823 * y * y * y + 0.00032 * y * y * y * y;
    }
  }

  return 0;
}

double _JDE(int year, int month) {
  double K = pi / 180.0;
  double W;
  double dL;
  double JDE0 = _JDE0(year, month);
  double T = (JDE0 - 2451545.0) / 36525.0;
  W = 35999.373 * T - 2.47;
  W = K * W;
  dL = 1.0 + 0.0334 * cos(W) + 0.0007 * cos(W);
  double JDE = JDE0 + (0.00001 * _s(T)) / dL - (66.0 + (year - 2000) * 1.0) / 86400.0;

  return JDE;
}

DateTime _JDToDateTime(double JD) {
  var JD0 = (JD + 0.5).floor();
  var B = ((JD0 - 1867216.25) / 36524.25).floor();
  var C = JD0 + B - (B / 4).floor() + 1525.0;
  var D = ((C - 122.1) / 365.25).floor();
  var E = 365.0 * D + (D / 4).floor();
  var F = ((C - E) / 30.6001).floor();

  var day = (C - E + 0.5).floor() - (30.6001 * F).floor();
  var month = F - 1 - 12 * (F / 14).floor();
  var year = D - 4715 - ((7 + month) / 10).floor();
  var hour = 24.0 * (JD + 0.5 - JD0);
  var time = hoursToHHmmss(hour);

  return DateTime(year, month, day, time.hour, time.minute, time.second, time.millisecond);
}

DateTime _spring(int year) {
  return _JDToDateTime(_JDE(year, 3));
}

DateTime _summer(int year) {
  return _JDToDateTime(_JDE(year, 6));
}

DateTime _autumn(int year) {
  return _JDToDateTime(_JDE(year, 9));
}

DateTime _winter(int year) {
  return _JDToDateTime(_JDE(year, 12));
}
