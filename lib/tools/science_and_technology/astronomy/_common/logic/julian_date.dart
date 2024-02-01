import 'dart:math';

import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/datetime_utils.dart';

class JulianDate {
  late double julianDateUTCNoon;
  late double julianDate;
  late double deltaT;
  late double terrestrialDynamicalTime;

  JulianDate(DateTimeTimezone datetime) {
    julianDateUTCNoon = gregorianCalendarToJulianDate(datetime.datetime);

    julianDate = julianDateUTCNoon +
        (datetime.datetime.hour -
                datetime.timezone.inMinutes / 60.0 +
                datetime.datetime.minute / 60.0 +
                datetime.datetime.second / 3600.0) /
            24.0;

    deltaT = _deltaT(datetime.datetime.year, datetime.datetime.month);
    terrestrialDynamicalTime = julianDate + deltaT / 24.0 / 3600.0;
  }

  //http://eclipse.gsfc.nasa.gov/SEcat5/deltatpoly.html
  double _deltaT(int year, int month) {
    double y = year + (month - 0.5) / 12;
    double u;

    if (year < -500) {
      u = (y - 1820) / 100;
      return -20 + 32 * u * u;
    }

    if ((year >= -500) && (year < 500)) {
      u = y / 100;
      return 10583.6 -
          1014.41 * u +
          33.78311 * u * u -
          5.952053 * pow(u, 3) -
          0.1798452 * pow(u, 4) +
          0.022174192 * pow(u, 5) +
          0.0090316521 * pow(u, 6);
    }

    if ((year >= 500) && (year < 1600)) {
      u = (y - 1000) / 100;
      return 1574.2 -
          556.01 * u +
          71.23472 * u * u +
          0.319781 * pow(u, 3) -
          0.8503463 * pow(u, 4) -
          0.005050998 * pow(u, 5) +
          0.0083572073 * pow(u, 6);
    }

    if ((year >= 1600) && (year < 1700)) {
      u = (y - 1600);
      return 120 - 0.9808 * u - 0.01532 * u * u + u * u * u / 7129;
    }

    if ((year >= 1700) && (year < 1800)) {
      u = (y - 1700);
      return 8.83 + 0.1603 * u - 0.0059285 * u * u + 0.00013336 * u * u * u - pow(u, 4) / 1174000;
    }

    if ((year >= 1800) && (year < 1860)) {
      u = (y - 1800);
      return 13.72 -
          0.332447 * u +
          0.0068612 * u * u +
          0.0041116 * pow(u, 3) -
          0.00037436 * pow(u, 4) +
          0.0000121272 * pow(u, 5) -
          0.0000001699 * pow(u, 6) +
          0.000000000875 * pow(u, 7);
    }

    if ((year >= 1860) && (year < 1900)) {
      u = (y - 1860);
      return 7.62 +
          0.5737 * u -
          0.251754 * u * u +
          0.01680668 * pow(u, 3) -
          0.0004473624 * pow(u, 4) +
          pow(u, 5) / 233174;
    }

    if ((year >= 1900) && (year < 1920)) {
      u = (y - 1900);
      return -2.79 + 1.494119 * u - 0.0598939 * u * u + 0.0061966 * pow(u, 3) - 0.000197 * pow(u, 4);
    }

    if ((year >= 1920) && (year < 1941)) {
      u = (y - 1920);
      return 21.20 + 0.84493 * u - 0.076100 * u * u + 0.0020936 * u * u * u;
    }

    if ((year >= 1941) && (year < 1961)) {
      u = (y - 1950);
      return 29.07 + 0.407 * u - u * u / 233 + u * u * u / 2547;
    }

    if ((year >= 1961) && (year < 1986)) {
      u = (y - 1975);
      return 45.45 + 1.067 * u - u * u / 260 - u * u * u / 718;
    }

    if ((year >= 1986) && (year < 2005)) {
      u = (y - 2000);
      return 63.86 +
          0.3345 * u -
          0.060374 * u * u +
          0.0017275 * pow(u, 3) +
          0.000651814 * pow(u, 4) +
          0.00002373599 * pow(u, 5);
    }

    if ((year >= 2005) && (year < 2050)) {
      u = (y - 2000);
      return 62.92 + 0.32217 * u + 0.005589 * u * u;
    }

    if ((year >= 2050) && (year <= 2150)) {
      return -20 + 32 * pow((y - 1820) / 100, 2) - 0.5628 * (2150 - y);
    }

    if (year > 2150) {
      u = (y - 1820) / 100;
      return -20 + 32 * u * u;
    }

    return 0.0;
  }
}
