/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

/** Map azimuth or angle values from [0,2*pi] to [-pi,pi]
 * @param x (double)
 * @return Returns calculated value
 */
double _modlon(double x) {
  x = (x >= 0 ? x : x + _M_2PI);
  return _modpos(x + _M_PI, _M_2PI) - _M_PI;
}

/** Calculates the modulus of the input course
 * @param crs (double)
 * @return Returns the modulus of the input course
 */
double _modcrs(double crs) {
  /* Map [-pi,pi] to [0,2*pi] */
  return _modpos(crs + _M_2PI, _M_2PI);
}

/** Return positive remainder of x / y
 * @param x (double)
 * @param y (double)
 * @return Returns calculated value
 */
double _modpos(double x, double y) {
  /* returns positive remainder of x/y. */

  x = x % y;
  if (x < 0.0) {
    x = x + y;
  }
  return x;
}

/**
 * Based on linear approximation to error function evaluated at two locations \f$y(x_{n-1})\f$, \f$y(x_n)\f$, extrapolate to find root of
 * approximation \f$x_{n+1}\f$ where \f$y(x_{n+1})=0\f$.
 * @param x  two-element double array Two element array containing two \f$x\f$ values, \f$x_{n-1}\f$, \f$x_n\f$(double*)
 * @param y  two-element array array containing value of error function \f$y\f$ at corresponding \f$x\f$ values
 * @param err  pointer to ErrorSet (double*)
 * @returns new estimate of error function root
 */
double _findRootSecantMethod(List<double> x, List<double> y) {

  if (x[0] == x[1]) {
    return x[0];
  }
  if (y[0] == 0.0) {
    return x[0];
  }
  if (y[1] == 0.0) {
    return x[1];
  }
  if (y[0] == y[1]) {
    return 0.5 * (x[0] + x[1]);
  }

  return -y[0] * (x[1] - x[0]) / (y[1] - y[0]) + x[0];
}

/*
 *
 * DESCRIPTION:
 * 		This source file contains utility functions that are used for the
 * 		geolib project.  This source does not contain utility functions which are
 * 		strictly used for testing functions in the geolib project.
 *
 */

int _sgn(double x) {
  return x < 0.0 ? -1 : (x > 0.0 ? 1 : 0);
}

/** Calculate the angle subtended by an arc, taking into account its orientation
 * @param startCrs Initial azimuth (double)
 * @param endCrs Final azimuth (double)
 * @param orient Arc orientation (ArcDirection)
 * @return Returns the angle subtended between the two courses in the direction of the arc
 * @retval 0 <= return <= \f$2\pi\f$
 */
double _computeSubtendedAngle(double startCrs, double endCrs, _ArcDirection orient) {

  double alpha;
  double temp;

  if (orient != _ArcDirection.COUNTERCLOCKWISE) {
    /* always use counter-clockwise orientaion */
    temp = startCrs;
    startCrs = endCrs;
    endCrs = temp;
  }

  if (startCrs > endCrs) {
    alpha = startCrs - endCrs;
  } else {
    alpha = _M_2PI - (endCrs - startCrs);
  }

  alpha = (orient == _ArcDirection.CLOCKWISE ? 1 : -1) * alpha;

  return alpha;
}

double _geodeticLat(double lat, Ellipsoid ellipsoid) {
  /* Angular eccentricity */
  double cosoe = 1.0 - ellipsoid.f;
  return atan(tan(lat) / cosoe / cosoe);
}

/* Convert geodetic latitude to geocentric latitude */
double _geocentricLat(double lat, Ellipsoid ellipsoid) {
  /* Angular eccentricity */
  double cosoe = 1.0 - ellipsoid.f;
  return atan(cosoe * cosoe * tan(lat));
}

_LLPoint _geodeticToGeocentric(_LLPoint pt, Ellipsoid ellipsoid) {
  _LLPoint newPt = _LLPoint(pt.latitude, pt.longitude);
  newPt.latitude = _geocentricLat(newPt.latitude, ellipsoid);
  return newPt;
}

// ignore: unused_element
_LLPoint _geocentricToGeodetic(_LLPoint pt, Ellipsoid ellipsoid) {
  _LLPoint newPt = _LLPoint(pt.latitude, pt.longitude);
  newPt.latitude = _geodeticLat(newPt.latitude, ellipsoid);
  return newPt;
}