/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

/*
 * Returns an integer that indicates whether a testPt is at a pole and which one.
 * Valid returns:
 *      -1 -> South Pole
 *       0 -> NOT at a pole
 *       1 -> North Pole
 * */
int _ptIsAtPole(_LLPoint testPt, double tol, Ellipsoid ellipsoid) {
  double distFromNPole, distFromSPole;
  _LLPoint northPolePt = _LLPoint(), southPolePt = _LLPoint();
  northPolePt.latitude = _M_PI_2;
  northPolePt.longitude = 0;
  southPolePt.latitude = -_M_PI_2;
  southPolePt.longitude = 0;

  /**\section Algorithm Algorithm Description
   *  <ol>
   *  <li> Get distance from North Pole using invDist, distFromNPole
   */
  distFromNPole = distanceBearing(northPolePt.toLatLng(), testPt.toLatLng(), ellipsoid).distance;
  /** <ul><li>if |distFromNPole| < tol, return 1 </ul> */
  if (distFromNPole.abs() < tol) {
    //Yes, at north pole.
    return 1;
  }

  /**\section Algorithm Algorithm Description
   *  <ol>
   *  <li> Get distance from South Pole using invDist, distFromSPole
   */
  distFromSPole = distanceBearing(southPolePt.toLatLng(), testPt.toLatLng(), ellipsoid).distance;
  /** <ul><li>if |distFromSPole| < tol, return 1 </ul> */
  if (distFromSPole.abs() < tol) {
    //Yes, at south pole.
    return 1;
  }

  //No, not at pole.
  /** <li>otherwise, return 0 </ol> */
  return 0;
}

bool _ptsAreSame(_LLPoint p1, _LLPoint p2, double tol, Ellipsoid ellipsoid) {
  double approxDist = 0.0;
//    smallDistInverse(p1, p2, NULL, &approxDist);
  approxDist = distanceBearing(p1.toLatLng(),p2.toLatLng(), ellipsoid).distance;
  return approxDist <= tol;
}