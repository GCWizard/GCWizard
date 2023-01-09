// port from https://lexikon.astronomie.info/java/sunmoon/progs/Astronomy.java

/*
 *
 * Copyright (C) 2010-2012, Helmut Lehmeyer <helmut.lehmeyer@gmail.com>
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General License as
 * published by the Free Software Foundation; either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General License for more details.
 *
 * You should have received a copy of the GNU General License
 * along with this program; if not, see <http://www.gnu.org/licenses>.
 *
 */

/**
 *
 * Astronomical Calculations and and helper Classes
 *
 * java Source code based on the javascript by Arnold Barmettler, www.astronomie.info / www.CalSky.com
 * based on algorithms by Peter Duffett-Smith's great and easy book 'Practical Astronomy with your Calculator'.
 *
 * @author Helmut Lehmeyer
 * @date 15.05.2012
 * @version 0.1
 */
import 'dart:math';

import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/astronomy/utils.dart';

const double _DEG = pi / 180.0;
const double _RAD = 180.0 / pi;

// return integer value, closer to 0
int _Int(double x) {
  if (x < 0) {
    return x.ceil();
  } else
    return x.floor();
}

double _sqr(double x) {
  return x * x;
}

double _frac(double x) {
  return x - x.floor();
}

double _mod(double a, double b) {
  if (a.isNaN) {
    return double.nan;
  }

  return a - (a / b).floor() * b;
}

double _mod2Pi(double x) {
  return _mod(x, 2.0 * pi);
} // Modulo PI

/*
 * @param lon geographical longitude in degree
 * @return    the name <code>String</code> of a sign
 */
AstrologicalSign sign(double lon) {
  var signs = AstrologicalSign.values;

  return signs[(lon * _RAD / 30.0).floor()];
}

/*
 * @param day
 * @param month
 * @param year
 * @return Julian date: valid only from 1.3.1901 to 28.2.2100
 */
/*double calcJD(int day, int month, int year) {
  double jd = 2415020.5 - 64.0; // 1.1.1900 - correction of algorithm
  if (month <= 2) {
    year--;
    month += 12;
  }

  jd += _Int((year - 1900) * 365.25);
  jd += _Int(30.6001 * (1 + month));

  return jd + day;
}*/

/*
 * @param JD Julian Date
 * @return Julian Date converted to Greenwich Mean Sidereal Time
 */
double GMST(double JD) {
  double UT = _frac(JD - 0.5) * 24.0; // UT in hours
  JD = (JD - 0.5).floor() + 0.5; // JD at 0 hours UT
  double T = (JD - 2451545.0) / 36525.0;
  double T0 = 6.697374558 + T * (2400.051336 + T * 0.000025862);

  return _mod(T0 + UT * 1.002737909, 24.0);
}

/*
 * @param JD  Julian Date
 * @param gmst Greenwich mean sidereal
 * @return convert Greenweek mean sidereal time to UT
 */
double _GMST2UT(double JD, double gmst) {
  JD = (JD - 0.5).floor() + 0.5; // JD at 0 hours UT
  double T = (JD - 2451545.0) / 36525.0;
  double T0 = _mod(6.697374558 + T * (2400.051336 + T * 0.000025862), 24.0);
  double UT = 0.9972695663 * ((gmst - T0));

  return UT;
}

/*
 * @param gmst Greenwich mean sidereal
 * @param lon geographical longitude in radians, East is positive
 * @return Local Mean Sidereal Time
 */
double GMST2LMST(double gmst, double lon) {
  return _mod(gmst + _RAD * lon / 15, 24.0);
}

/*
 * Transform ecliptical coordinates (lon/lat) to equatorial coordinates (RA/dec)
 *
 * @param coor
 * @param TDT
 * @return equatorial coordinate (RA/dec)
 */
Coor _ecl2Equ(Coor coor, double TDT) {
  double T = (TDT - 2451545.0) / 36525.0; // Epoch 2000 January 1.5
  double eps = (23.0 + (26 + 21.45 / 60.0) / 60.0 + T * (-46.815 + T * (-0.0006 + T * 0.00181)) / 3600.0) * _DEG;
  double coseps = cos(eps);
  double sineps = sin(eps);

  double sinlon = sin(coor.lon);
  coor.ra = _mod2Pi(atan2((sinlon * coseps - tan(coor.lat) * sineps), cos(coor.lon)));
  coor.dec = asin(sin(coor.lat) * coseps + cos(coor.lat) * sineps * sinlon);

  return (coor);
}

/*
 * Transform equatorial coordinates (RA/Dec) to horizonal coordinates (azimuth/altitude)
 * Refraction is ignored
 *
 * @param coor
 * @param TDT
 * @param geolat
 * @param lmst
 * @return horizonal coordinates (azimuth/altitude)
 */
Coor _equ2Altaz(Coor coor, double TDT, double geolat, double lmst) {
  double cosdec = cos(coor.dec);
  double sindec = sin(coor.dec);
  double lha = lmst - coor.ra;
  double coslha = cos(lha);
  double sinlha = sin(lha);
  double coslat = cos(geolat);
  double sinlat = sin(geolat);

  double N = -cosdec * sinlha;
  double D = sindec * coslat - cosdec * coslha * sinlat;
  coor.az = _mod2Pi(atan2(N, D));
  coor.alt = asin(sindec * sinlat + cosdec * coslha * coslat);

  return (coor);
}

/*
 * Transform geocentric equatorial coordinates (RA/Dec) to topocentric equatorial coordinates
 *
 * @param coor
 * @param observer
 * @param lmst
 * @return topocentric equatorial coordinates
 */
Coor _geoEqu2TopoEqu(Coor coor, Coor observer, double lmst) {
  double cosdec = cos(coor.dec);
  double sindec = sin(coor.dec);
  double coslst = cos(lmst);
  double sinlst = sin(lmst);
  double coslat = cos(observer.lat); // we should use geocentric latitude, not geodetic latitude
  double sinlat = sin(observer.lat);
  double rho = observer.radius; // observer-geocenter in Kilometer

  double x = coor.distance * cosdec * cos(coor.ra) - rho * coslat * coslst;
  double y = coor.distance * cosdec * sin(coor.ra) - rho * coslat * sinlst;
  double z = coor.distance * sindec - rho * sinlat;

  coor.distanceTopocentric = sqrt(x * x + y * y + z * z);
  coor.decTopocentric = asin(z / coor.distanceTopocentric);
  coor.raTopocentric = _mod2Pi(atan2(y, x));

  return (coor);
}

/*
 *  Calculate cartesian from polar coordinates
 *
 * @param lon
 * @param lat
 * @param distance
 * @return cartesian
 */
Coor equPolar2Cart(double lon, double lat, double distance) {
  Coor c1 = Coor();
  double rcd = cos(lat) * distance;
  c1.x = rcd * cos(lon);
  c1.y = rcd * sin(lon);
  c1.z = distance * sin(lat);

  return c1;
}

/*
 * Calculate observers cartesian equatorial coordinates (x,y,z in celestial frame)
 * from geodetic coordinates (longitude, latitude, height above WGS84 ellipsoid)
 * Currently only used to calculate distance of a body from the observer
 *
 * @param lon
 * @param lat
 * @param height
 * @param gmst
 * @return observers cartesian equatorial coordinates
 */
Coor observer2EquCart(double lon, double lat, double height, double gmst, Ellipsoid ells) {
  double flat = ells.invf;
  double aearth = ells.a / 1000.0;

  Coor cart = Coor();
  // Calculate geocentric latitude from geodetic latitude
  double co = cos(lat);
  double si = sin(lat);
  double fl = 1.0 - 1.0 / flat;
  fl = fl * fl;
  si = si * si;
  double u = 1.0 / sqrt(co * co + fl * si);
  double a = aearth * u + height;
  double b = aearth * fl * u + height;
  double radius = sqrt(a * a * co * co + b * b * si); // geocentric distance from earth center
  cart.y = acos(a * co / radius); // geocentric latitude, rad
  cart.x = lon; // longitude stays the same

  if (lat < 0.0) {
    cart.y = -cart.y;
  } // adjust sign

  cart = equPolar2Cart(
      cart.x, cart.y, radius); // convert from geocentric polar to geocentric cartesian, with regard to Greenwich
  // rotate around earth's polar axis to align coordinate system from Greenwich to vernal equinox
  double x = cart.x;
  double y = cart.y;
  double rotangle = gmst / 24.0 * 2.0 * pi; // sideral time gmst given in hours. Convert to radians
  cart.x = x * cos(rotangle) - y * sin(rotangle);
  cart.y = x * sin(rotangle) + y * cos(rotangle);
  cart.radius = radius;
  cart.lon = lon;
  cart.lat = lat;

  return (cart);
}

/*
 * @param TDT
 * @param geolat
 * @param lmst
 * @param useGeo
 * @return coordinates for Sun
 */
Coor sunPosition(double TDT, double earthRadius, [double geolat = 0, double lmst = 0, bool useGeo = false]) {
  double D = TDT - 2447891.5;

  double eg = 279.403303 * _DEG;
  double wg = 282.768422 * _DEG;
  double e = 0.016713;
  int a = 149598500; // km
  double diameter0 = 0.533128 * _DEG; // angular diameter of Moon at a distance

  double MSun = 360 * _DEG / 365.242191 * D + eg - wg;
  double nu = MSun + 360.0 * _DEG / pi * e * sin(MSun);

  Coor sunCoor = Coor();
  sunCoor.lon = _mod2Pi(nu + wg);
  sunCoor.lat = 0;
  sunCoor.anomalyMean = MSun;

  sunCoor.distance = (1 - _sqr(e)) / (1 + e * cos(nu)); // distance in astronomical units
  sunCoor.diameter = diameter0 / sunCoor.distance; // angular diameter in radians
  sunCoor.distance *= a; // distance in km
  sunCoor.parallax = earthRadius / sunCoor.distance; // horizonal parallax

  sunCoor = _ecl2Equ(sunCoor, TDT);

  // Calculate horizonal coordinates of sun, if geographic positions is given
  if (useGeo) {
    sunCoor = _equ2Altaz(sunCoor, TDT, geolat, lmst);
  }

  sunCoor.sign = sign(sunCoor.lon);
  return sunCoor;
}

/*
 * @param sunCoor
 * @param TDT
 * @param observer
 * @param lmst
 * @param useObs
 * @return data and coordinates for the Moon
 */
Coor moonPosition(Coor sunCoor, double TDT, [Coor observer, double lmst = 0, bool useObs = false]) {
  if (observer == null) observer = Coor();

  double D = TDT - 2447891.5;

  // Mean Moon orbit elements as of 1990.0
  double l0 = 318.351648 * _DEG;
  double P0 = 36.340410 * _DEG;
  double N0 = 318.510107 * _DEG;
  double i = 5.145396 * _DEG;
  double e = 0.054900;
  int a = 384401; // km
  double diameter0 = 0.5181 * _DEG; // angular diameter of Moon at a distance
  double parallax0 = 0.9507 * _DEG; // parallax at distance a

  double l = 13.1763966 * _DEG * D + l0;
  double MMoon = l - 0.1114041 * _DEG * D - P0; // Moon's mean anomaly M
  double N = N0 - 0.0529539 * _DEG * D; // Moon's mean ascending node longitude
  double C = l - sunCoor.lon;
  double Ev = 1.2739 * _DEG * sin(2 * C - MMoon);
  double Ae = 0.1858 * _DEG * sin(sunCoor.anomalyMean);
  double A3 = 0.37 * _DEG * sin(sunCoor.anomalyMean);
  double MMoon2 = MMoon + Ev - Ae - A3; // corrected Moon anomaly
  double Ec = 6.2886 * _DEG * sin(MMoon2); // equation of centre
  double A4 = 0.214 * _DEG * sin(2 * MMoon2);
  double l2 = l + Ev + Ec - Ae + A4; // corrected Moon's longitude
  double V = 0.6583 * _DEG * sin(2 * (l2 - sunCoor.lon));
  double l3 = l2 + V; // true orbital longitude;

  double N2 = N - 0.16 * _DEG * sin(sunCoor.anomalyMean);

  Coor moonCoor = Coor();
  moonCoor.lon = _mod2Pi(N2 + atan2(sin(l3 - N2) * cos(i), cos(l3 - N2)));
  moonCoor.lat = asin(sin(l3 - N2) * sin(i));
  moonCoor.orbitLon = l3;

  moonCoor = _ecl2Equ(moonCoor, TDT);
  // relative distance to semi mayor axis of lunar orbit
  moonCoor.distance = (1 - _sqr(e)) / (1 + e * cos(MMoon2 + Ec));
  moonCoor.diameter = diameter0 / moonCoor.distance; // angular diameter in radians
  moonCoor.parallax = parallax0 / moonCoor.distance; // horizontal parallax in radians
  moonCoor.distance *= a; // distance in km

  // Calculate horizonal coordinates of sun, if geographic positions is given
  if (useObs) {
    // transform geocentric coordinates into topocentric (==observer based) coordinates
    moonCoor = _geoEqu2TopoEqu(moonCoor, observer, lmst);
    moonCoor.raGeocentric = moonCoor.ra; // backup geocentric coordinates
    moonCoor.decGeocentric = moonCoor.dec;
    moonCoor.ra = moonCoor.raTopocentric;
    moonCoor.dec = moonCoor.decTopocentric;
    moonCoor = _equ2Altaz(moonCoor, TDT, observer.lat, lmst); // now ra and dec are topocentric
  }

  // Age of Moon in radians since New Moon (0) - Full Moon (pi)
  moonCoor.moonAge = _mod2Pi(l3 - sunCoor.lon);
  moonCoor.phase = 0.5 * (1 - cos(moonCoor.moonAge)); // Moon phase, 0-1

  double mainPhase = 1.0 / 29.53 * 360 * _DEG; // show 'Newmoon, 'Quarter' for +/-1 day arond the actual event
  double p = _mod(moonCoor.moonAge, 90.0 * _DEG);

  if (p < mainPhase || p > 90 * _DEG - mainPhase)
    p = 2 * (moonCoor.moonAge / (90.0 * _DEG)).roundToDouble();
  else
    p = 2 * (moonCoor.moonAge / (90.0 * _DEG)).roundToDouble() + 1;

  moonCoor.moonPhase = MoonPhase.values[p.floor() % 7];
  moonCoor.sign = sign(moonCoor.lon);

  return moonCoor;
}

/*
 * Rough refraction formula using standard atmosphere: 1015 mbar and 10°C
 * Input true altitude in radians, Output: increase in altitude in degrees
 *
 * @param alt
 * @return increase in altitude in degrees
 */
double refraction(double alt) {
  int pressure = 1015;
  int temperature = 10;
  double altdeg = alt * _RAD;

  if (altdeg < -2 || altdeg >= 90) return 0;

  if (altdeg > 15) return 0.00452 * pressure / ((273 + temperature) * tan(alt));

  double y = alt;
  double D = 0.0;
  double P = (pressure - 80.0) / 930.0;
  double Q = 0.0048 * (temperature - 10.0);
  double y0 = y;
  double D0 = D;
  double N = 0.0;

  for (int i = 0; i < 3; i++) {
    N = y + (7.31 / (y + 4.4));
    N = 1.0 / tan(N * _DEG);
    D = N * P / (60.0 + Q * (N + 39.0));
    N = y - y0;
    y0 = D - D0 - N;
    N = ((N != 0.0) && (y0 != 0.0)) ? y - N * (alt + D - y) / y0 : alt + D;
    y0 = y;
    D0 = D;
    y = N;
  }

  return D; // Lifting by refraction in radians
}

/*
 * Correction for refraction and semi-diameter/parallax of body is taken care of in function RiseSet
 *
 * @param corr
 * @param lon
 * @param lat
 * @param h is used to calculate the twilights. It gives the required elevation of the disk center of the sun
 * @return Greenwich sidereal time (hours) of time of rise and set of object with coordinates Coor.ra/Coor.dec at geographic position lon/lat (all values in radians)
 */
RiseSet _gMSTRiseSet(Coor corr, double lon, double lat, double h) {
  double tagbogen = acos((sin(h) - sin(lat) * sin(corr.dec)) / (cos(lat) * cos(corr.dec)));

  RiseSet r1 = RiseSet();
  r1.transit = _RAD / 15 * (corr.ra - lon);
  r1.rise = 24.0 + _RAD / 15 * (-tagbogen + corr.ra - lon); // calculate GMST of rise of object
  r1.set = _RAD / 15 * (tagbogen + corr.ra - lon); // calculate GMST of set of object

  // using the modulo function Mod, the day number goes missing. This may get a problem for the moon
  r1.transit = _mod(r1.transit, 24);
  r1.rise = _mod(r1.rise, 24);
  r1.set = _mod(r1.set, 24);

  return r1;
}

/*
 * Find GMST of rise/set of object from the two calculates
 * (start)points (day 1 and 2) and at midnight UT(0)
 *
 * @param gmst0
 * @param gmst1
 * @param gmst2
 * @param timefactor
 * @return GMST of rise/set of object
 */
double _interpolateGMST(double gmst0, double gmst1, double gmst2, double timefactor) {
  return (timefactor * 24.07 * gmst1 - gmst0 * (gmst2 - gmst1)) / (timefactor * 24.07 + gmst1 - gmst2);
}

RiseSet _riseSet(double jd0UT, Coor coor1, Coor coor2, double lon, double lat, double timeinterval,
    [double altitude = 0, bool useAlt = false]) {
  // altitude of sun center: semi-diameter, horizontal parallax and (standard) refraction of 34'
  double alt = 0.0; // calculate

  // true height of sun center for sunrise and set calculation. Is kept 0 for twilight (ie. altitude given):
  if (!useAlt && altitude == 0.0) alt = 0.5 * coor1.diameter - coor1.parallax + 34.0 / 60 * _DEG;

  RiseSet rise1 = _gMSTRiseSet(coor1, lon, lat, altitude);
  RiseSet rise2 = _gMSTRiseSet(coor2, lon, lat, altitude);

  RiseSet rise = RiseSet();

  // unwrap GMST in case we move across 24h -> 0h
  if (rise1.transit > rise2.transit && (rise1.transit - rise2.transit).abs() > 18) rise2.transit += 24;

  if (rise1.rise > rise2.rise && (rise1.rise - rise2.rise).abs() > 18) rise2.rise += 24;

  if (rise1.set > rise2.set && (rise1.set - rise2.set).abs() > 18) rise2.set += 24;

  double T0 = GMST(jd0UT);
  //  var T02 = T0-zone*1.002738; // Greenwich sidereal time at 0h time zone (zone: hours)

  // Greenwich sidereal time for 0h at selected longitude
  double T02 = T0 - lon * _RAD / 15 * 1.002738;
  if (T02 < 0) T02 += 24;

  if (rise1.transit < T02) {
    rise1.transit += 24;
    rise2.transit += 24;
  }
  if (rise1.rise < T02) {
    rise1.rise += 24;
    rise2.rise += 24;
  }
  if (rise1.set < T02) {
    rise1.set += 24;
    rise2.set += 24;
  }

  // Refraction and Parallax correction
  double decMean = 0.5 * (coor2.dec + coor2.dec);
  double psi = acos(sin(lat) / cos(decMean));
  double y = asin(sin(alt) / sin(psi));
  double dt = 240 * _RAD * y / cos(decMean) / 3600; // time correction due to refraction, parallax

  rise.transit = _GMST2UT(jd0UT, _interpolateGMST(T0, rise1.transit, rise2.transit, timeinterval));
  rise.rise = _GMST2UT(jd0UT, _interpolateGMST(T0, rise1.rise, rise2.rise, timeinterval) - dt);
  rise.set = _GMST2UT(jd0UT, _interpolateGMST(T0, rise1.set, rise2.set, timeinterval) + dt);

  return rise;
}

/*
 * Find (local) time of sunrise and sunset, and twilights
 * JD is the Julian Date of 0h local time (midnight)
 * Accurate to about 1-2 minutes
 * recursive: 1 - calculate rise/set in UTC in a second run
 * recursive: 0 - find rise/set on the current local day. This is set when doing the first call to this function
 *
 * @param JD
 * @param deltaT
 * @param lon
 * @param lat
 * @param zone
 * @param recursive
 * @return (local) time of sunrise and sunset, and twilights
 */
RiseSet sunRise(double JD, double deltaT, double lon, double lat, double zone, bool recursive, Ellipsoid ells) {
  double jd0UT = (JD - 0.5).floor() + 0.5; // JD at 0 hours UT
  Coor coor1 = sunPosition(jd0UT + deltaT / 24.0 / 3600.0, ells.a / 1000.0);
  Coor coor2 =
      sunPosition(jd0UT + 1.0 + deltaT / 24.0 / 3600.0, ells.a / 1000.0); // calculations for next day's UTC midnight

  RiseSet risetemp = RiseSet();
  RiseSet rise = RiseSet();
  // rise/set time in UTC.
  rise = _riseSet(jd0UT, coor1, coor2, lon, lat, 1);
  if (!recursive) {
    // check and adjust to have rise/set time on local calendar day
    if (zone > 0) {
      // rise time was yesterday local time -> calculate rise time for next UTC day
      if (rise.rise >= 24 - zone || rise.transit >= 24 - zone || rise.set >= 24 - zone) {
        risetemp = sunRise(JD + 1, deltaT, lon, lat, zone, true, ells);

        if (rise.rise >= 24 - zone) rise.rise = risetemp.rise;

        if (rise.transit >= 24 - zone) rise.transit = risetemp.transit;

        if (rise.set >= 24 - zone) rise.set = risetemp.set;
      }
    } else if (zone < 0) {
      // rise time was yesterday local time -> calculate rise time for next UTC day
      if (rise.rise < -zone || rise.transit < -zone || rise.set < -zone) {
        risetemp = sunRise(JD - 1, deltaT, lon, lat, zone, true, ells);

        if (rise.rise < -zone) rise.rise = risetemp.rise;

        if (rise.transit < -zone) rise.transit = risetemp.transit;

        if (rise.set < -zone) rise.set = risetemp.set;
      }
    }

    rise.transit = _mod(rise.transit + zone, 24.0);
    rise.rise = _mod(rise.rise + zone, 24.0);
    rise.set = _mod(rise.set + zone, 24.0);

    // Twilight calculation
    // civil twilight time in UTC.
    risetemp = _riseSet(jd0UT, coor1, coor2, lon, lat, 1, -6.0 * _DEG, true);
    rise.civilTwilightMorning = _mod(risetemp.rise + zone, 24.0);
    rise.civilTwilightEvening = _mod(risetemp.set + zone, 24.0);

    // nautical twilight time in UTC.
    risetemp = _riseSet(jd0UT, coor1, coor2, lon, lat, 1, -12.0 * _DEG, true);
    rise.nauticalTwilightMorning = _mod(risetemp.rise + zone, 24.0);
    rise.nauticalTwilightEvening = _mod(risetemp.set + zone, 24.0);

    // astronomical twilight time in UTC.
    risetemp = _riseSet(jd0UT, coor1, coor2, lon, lat, 1, -18.0 * _DEG, true);
    rise.astronomicalTwilightMorning = _mod(risetemp.rise + zone, 24.0);
    rise.astronomicalTwilightEvening = _mod(risetemp.set + zone, 24.0);
  }

  return rise;
}

/*
 * Find local time of moonrise and moonset
 * JD is the Julian Date of 0h local time (midnight)
 * Accurate to about 5 minutes or better
 * recursive: 1 - calculate rise/set in UTC
 * recursive: 0 - find rise/set on the current local day (set could also be first)
 * returns 0.000000000 for moonrise/set does not occur on selected day
 *
 * @param JD
 * @param deltaT
 * @param lon
 * @param lat
 * @param zone
 * @param recursive
 * @return local time of moonrise and moonset
 */
RiseSet moonRise(double JD, double deltaT, double lon, double lat, double zone, bool recursive, Ellipsoid ells) {
  double timeinterval = 0.5;

  double jd0UT = (JD - 0.5).floor() + 0.5; // JD at 0 hours UT
  Coor suncoor1 = sunPosition(jd0UT + deltaT / 24.0 / 3600.0, ells.a / 1000.0);
  Coor coor1 = moonPosition(suncoor1, jd0UT + deltaT / 24.0 / 3600.0);

  Coor suncoor2 = sunPosition(jd0UT + timeinterval + deltaT / 24.0 / 3600.0, ells.a / 1000.0); // calculations for noon
  // calculations for next day's midnight
  Coor coor2 = moonPosition(suncoor2, jd0UT + timeinterval + deltaT / 24.0 / 3600.0);

  RiseSet risetemp = RiseSet();
  RiseSet rise = RiseSet();

  // rise/set time in UTC, time zone corrected later.
  // Taking into account refraction, semi-diameter and parallax
  rise = _riseSet(jd0UT, coor1, coor2, lon, lat, timeinterval);

  if (!recursive) {
    // check and adjust to have rise/set time on local calendar day
    if (zone > 0) {
      // recursive call to MoonRise returns events in UTC
      RiseSet riseprev = moonRise(JD - 1.0, deltaT, lon, lat, zone, true, ells);

      if (rise.transit >= 24.0 - zone || rise.transit < -zone) {
        // transit time is tomorrow local time
        if (riseprev.transit < 24.0 - zone)
          rise.transit = 0.000000000; // there is no moontransit today
        else
          rise.transit = riseprev.transit;
      }

      if (rise.rise >= 24.0 - zone || rise.rise < -zone) {
        // transit time is tomorrow local time
        if (riseprev.rise < 24.0 - zone)
          rise.rise = 0.000000000; // there is no moontransit today
        else
          rise.rise = riseprev.rise;
      }

      if (rise.set >= 24.0 - zone || rise.set < -zone) {
        // transit time is tomorrow local time
        if (riseprev.set < 24.0 - zone)
          rise.set = 0.000000000; // there is no moontransit today
        else
          rise.set = riseprev.set;
      }
    } else if (zone < 0) {
      // rise/set time was tomorrow local time -> calculate rise time for former UTC day
      if (rise.rise < -zone || rise.set < -zone || rise.transit < -zone) {
        risetemp = moonRise(JD + 1.0, deltaT, lon, lat, zone, true, ells);

        if (rise.rise < -zone) {
          if (risetemp.rise > -zone)
            rise.rise = 0.0; // there is no moonrise today
          else
            rise.rise = risetemp.rise;
        }

        if (rise.transit < -zone) {
          if (risetemp.transit > -zone)
            rise.transit = 0.0; // there is no moonset today
          else
            rise.transit = risetemp.transit;
        }

        if (rise.set < -zone) {
          if (risetemp.set > -zone)
            rise.set = 0.0; // there is no moonset today
          else
            rise.set = risetemp.set;
        }
      }
    }

    if (rise.rise != 0.0)
      rise.rise = _mod(rise.rise + zone, 24.0); // correct for time zone, if time is valid
    else
      rise.rise = double.nan;

    if (rise.transit != 0.0)
      rise.transit = _mod(rise.transit + zone, 24.0); // correct for time zone, if time is valid
    else
      rise.transit = double.nan;

    if (rise.set != 0.0)
      rise.set = _mod(rise.set + zone, 24.0); // correct for time zone, if time is valid
    else
      rise.set = double.nan;
  }

  return rise;
}

/*
 * set of variables for sun calculations
 */
class Coor {
  double lon;
  double lat;

  double ra;
  double dec;
  double raGeocentric;
  double decGeocentric;

  double az;
  double alt;

  double x;
  double y;
  double z;

  double radius;
  double diameter;
  double distance;
  double distanceTopocentric;
  double decTopocentric;
  double raTopocentric;

  double anomalyMean;
  double parallax;
  double orbitLon;

  double moonAge;
  double phase;

  MoonPhase moonPhase;
  AstrologicalSign sign;

  Coor();
}

/*
 * set of variables for sunrise calculations
 */
class RiseSet {
  double transit;
  double rise;
  double set;

  double civilTwilightMorning;
  double civilTwilightEvening;

  double nauticalTwilightMorning;
  double nauticalTwilightEvening;

  double astronomicalTwilightMorning;
  double astronomicalTwilightEvening;

  RiseSet();
}

/*
 * time calculations
 */
class Time {
  int hh;
  int mm;
  int ss;

  String hhmmString;
  String hhmmStringdec;
  String hhmmssString;
  String hhmmssStringdec;

  Time(double hhi) {
    double mD = _frac(hhi) * 60;
    int h = _Int(hhi);
    double s = _frac(mD) * 60.0;
    int m = _Int(mD);

    if (s >= 59.5) {
      m++;
      s -= 60.0;
    }

    if (m >= 60) {
      h++;
      m -= 60;
    }

    s = s.roundToDouble();

    //create String HH:MM and HH:MM:SS
    hhmmssString = h.toString().padLeft(2, '0');
    hhmmssString += ':';
    hhmmssString += m.toString().padLeft(2, '0');
    hhmmString = hhmmssString;

    hhmmssString += ':';
    hhmmssString += s.toString().padLeft(2, '0');

    //create String HH:MM = dec and HH:MM:SS = dec
    hhmmssStringdec = '$hhmmssString = $hhi';
    hhmmStringdec = '$hhmmString = $hhi';
  }
}
