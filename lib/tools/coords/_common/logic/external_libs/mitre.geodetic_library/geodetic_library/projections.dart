/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

// ignore_for_file: unused_local_variable

class _ProjectToGeoReturn {
  final _LLPoint pt2;
  final double crsFromPoint;
  final double distFromPoint;

  _ProjectToGeoReturn(this.pt2, this.crsFromPoint, this.distFromPoint);
}

/******************************************************************************
 * Perpendicular Intercept
 *
 * Find location on geodesic at which course to given point is 90 degrees
 * different from geodesic course.
 *
 */
_ProjectToGeoReturn _projectToGeo(_LLPoint pt1, double geoStartAz, _LLPoint pt3, double tol, Ellipsoid ellipsoid) {

  // Spherical solution is first approximation
  _LLPoint newPt1, pt2 = _LLPoint();
  //    LLPoint testPt3 = { 0.0, 0.0 };
  double crs13, dist13, crs23, crs32, tmpCrs12;
  double crs21, dist12, crs31;
  double angle, error;
  double newDist;
  double dist23 = 0;
  double a, b, A, B, c; /* Angles of spherical triangle */
  List<double> errarray = [double.nan, double.nan];
  List<double> distarray = [double.nan, double.nan];
  double approxDist23;
  double npCrsFromPoint, npDistFromPoint;
  _LLPoint npPt2;
  double startNbhdRadius = 1.0 / _NMI_IN_METERS; /* one meter in NM */
  double delta = 9.0e99;
  double perpDistUpperBound = 1.0 / _NMI_IN_METERS; /* one meter in NM */

  int pt1IsAtPole = 0;

  int k = 0;

  double sphereRad = ellipsoid.sphereRadius / _NMI_IN_METERS;

  double crsFromPoint = 0;
  double distFromPoint = 0;

  /*determine if pt1 is at a pole */
  pt1IsAtPole = _ptIsAtPole(pt1, tol, ellipsoid);

  var distBear = distanceBearing(pt1.toLatLng(), pt3.toLatLng(), ellipsoid);
  crs13 = distBear.bearingAToBInRadian;
  crs31 = distBear.bearingBToAInRadian;
  dist13 = distBear.distance / _NMI_IN_METERS;

  /* Check for perp intercept "behind" pt1 */
  angle = (_modlon(geoStartAz - crs13)).abs();

  /* Do approximate check for pt3 on geodesic */
  /* If it's close, then we check more carefully */
  approxDist23 = sphereRad * (asin(sin(dist13 / sphereRad) * sin(angle))).abs();

  if (dist13 <= tol) {
    /* pt2 is same as pt1 */
    var pt2 = pt1;
    return _ProjectToGeoReturn(pt2, double.nan, distFromPoint);
  } else if (approxDist23 < (300.0 / 6076.0) && pt1IsAtPole == 0) {
    /* pt3 is near geodesic.  Move start point back 10 nm and check again */
    newPt1 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), geoStartAz + _M_PI, 10.0, ellipsoid));
    if (_ptIsOnGeo(pt1, newPt1, pt3, _LineType.INFINITE, tol, ellipsoid))  {
      /* point to be projected already lies on geodesic, so return it */
      /* NOTE: crsFromPoint undefined, distFromPoint == 0 in this case */
      var pt2 = pt3;
      return _ProjectToGeoReturn(pt2, double.nan, distFromPoint);
    }
    else {
      /* point is near geodesic, but not within tol
      * Use special approximation for small angle
      */
    }
  }

  /* Check for orientation of start point/test point geometry
     * Approximate spherical solution relies on having correct supplement
     * of angle
     */
  if (angle > _M_PI_2) {
    B = _M_PI - angle;
  } else {
    B = angle;
  }

  //determine the distance d12 of the first guess of pt2 from the pt1
  /* Check for situation where perp projected point is near p1
     * This must be handled as special case to avoid numerical instabilities
     */
  //    if (fabs(B - M_PI_2) < startNbhdRadius/sphereRad)

  if ((dist13 < startNbhdRadius) || (B > acos(tan(startNbhdRadius / sphereRad) / tan(dist13 / sphereRad)))) {
    //B must not be allowed to equal A or the calculation of dist12 will
    //blow up (divide by 0). Need to handle this numerical boundary condition.
    //B = M_PI_2 - 1e-10; //shift slightly
    /* Approximate projected point will be within startNbhdRadius of pt1
         * In this situation, spherical solution may fail, so set dist12 to trigger
         * re-location of pt1 backwards along geodesic
         */
    dist12 = 0.0;
  } else {
    /* Calculate spherical approximation to distance from pt1 to perp projection */
    a = dist13 / sphereRad;
    //        A = M_PI_2;
    //        b = asin(sin(B) * sin(a)); /* sin(A) = 1, so omitted from denominator */
    //        c = 2.0 * atan(tan(0.5 * (a - b)) * sin(0.5 * (A + B)) / sin(0.5 * (A
    //                - B))); //Napier's analogies (identities) from Spherical Trig
    c = atan(cos(B) * tan(a));
    if (c < 0.0) {
      c = c + _M_PI;
    }
    dist12 = c * sphereRad;
  }

  if (angle > _M_PI_2) {
    /* pt3 was behind pt1.  Need to move pt1 1.0 NM behind point that would
         * be abeam pt3 */
    newPt1 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), geoStartAz + _M_PI, (5.0 + dist12) * _NMI_IN_METERS, ellipsoid));
    dist12 = 5.0;
    distBear = distanceBearing(newPt1.toLatLng(), pt1.toLatLng(), ellipsoid);
    geoStartAz = distBear.distance;
    crs21 = distBear.bearingAToBInRadian;
    pt1 = newPt1;

  } else if (dist12.abs() < 5.0) {
    /* pt3 is within 5.0 nmi of being abeam pt1
         * move pt1 backward 5 nmi to give the algorithms room to work */
    newPt1 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), geoStartAz + _M_PI, (5.0 + dist12) * _NMI_IN_METERS, ellipsoid));
    dist12 = 5.0 + dist12;
    distBear = distanceBearing(newPt1.toLatLng(), pt1.toLatLng(), ellipsoid);
    geoStartAz = distBear.distance / _NMI_IN_METERS;
    crs21 = distBear.bearingAToBInRadian;
    pt1 = newPt1;
  }

  /*
     * check if pt3 is very close to geodesic but not quite on the geodesic
     * if so, then find the spherical approximation of pt2 and return this value
     * A spherical approximation is sufficient for cases that fall within this case
     * The perpDistUpperBound value was verified using the analysis described in the following bug
     * See Geolib Bug 19576 for additional details
     */
  if (approxDist23 > tol && approxDist23 < perpDistUpperBound) {
    //recalculate distances, courses, angles in case pt1 moved
    distBear = distanceBearing(pt1.toLatLng(), pt3.toLatLng(), ellipsoid);
    crs13 = distBear.bearingAToBInRadian;
    crs31 = distBear.bearingBToAInRadian;
    dist13 = distBear.distance / _NMI_IN_METERS;
    angle = (_modlon(geoStartAz - crs13)).abs();
    if (angle > _M_PI_2) {
      B = _M_PI - angle;
    } else {
      B = angle;
    }

    /* Calculate spherical approximation of distance from pt1 to perp projection */
    a = dist13 / sphereRad;
    //        A = M_PI_2;
    //        b = asin(sin(B) * sin(a)); /* sin(A) = 1, so omitted from denominator */
    //        c = 2.0 * atan(tan(0.5 * (a - b)) * sin(0.5 * (A + B)) / sin(0.5 * (A
    //                - B))); //Napier's analogies (identities) from Spherical Trig
    c = atan(cos(B) * tan(a));
    if (c < 0.0) {
      c = c + _M_PI;
    }
    dist12 = c * sphereRad;

    //find the projection point of pt3 on the geodesic using the spherical distance approx
    pt2 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), geoStartAz, dist12 * _NMI_IN_METERS, ellipsoid));

    //determine the course and distance info with respect to pt2
    distBear = distanceBearing(pt1.toLatLng(), pt3.toLatLng(), ellipsoid);
    crs32 = distBear.bearingAToBInRadian;
    crsFromPoint = distBear.bearingBToAInRadian;
    distFromPoint = distBear.distance;

    return _ProjectToGeoReturn(pt2, crsFromPoint, distFromPoint);
  } else {
    pt2 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), geoStartAz, dist12 * _NMI_IN_METERS, ellipsoid));
  }

  /* Calculate angle between radial and approximate perpendicular */
  distBear = distanceBearing(pt2.toLatLng(), pt1.toLatLng(), ellipsoid);
  crs21 = distBear.bearingAToBInRadian;
  tmpCrs12 = distBear.bearingBToAInRadian;
  dist12 = distBear.distance / _NMI_IN_METERS;
  distBear = distanceBearing(pt2.toLatLng(), pt3.toLatLng(), ellipsoid);
  crs23 = distBear.bearingAToBInRadian;
  crs32 = distBear.bearingBToAInRadian;
  dist23 = distBear.distance / _NMI_IN_METERS;

  /* Cast angle between main course and perpendicular into range [-Pi,Pi] */
  angle = (_modlon(crs21 - crs23)).abs();
  errarray[0] = angle - _M_PI_2;
  distarray[0] = dist12;

  distarray[1] = distarray[0] + errarray[0] * dist23;

  pt2 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), geoStartAz, distarray[1] * _NMI_IN_METERS, ellipsoid));

  // Calculate angle between radial and approximate perpendicular
  distBear = distanceBearing(pt2.toLatLng(), pt1.toLatLng(), ellipsoid);
  crs21 = distBear.bearingAToBInRadian;
  tmpCrs12 = distBear.bearingBToAInRadian;
  dist12 = distBear.distance / _NMI_IN_METERS;
  distBear = distanceBearing(pt2.toLatLng(), pt3.toLatLng(), ellipsoid);
  crs23 = distBear.bearingAToBInRadian;
  crs32 = distBear.bearingBToAInRadian;
  dist23 = distBear.distance / _NMI_IN_METERS;

  /* Cast angle between main course and perpendicular into range [-Pi,Pi] */
  angle = _modlon(crs21 - crs23);
  errarray[1] = dist23 * (angle.abs() - _M_PI_2);
  error = errarray[1];

  while ((error.abs() > tol || (delta > tol)) && (k < _MAX_ITERATIONS)) {
    newDist = _findRootSecantMethod(distarray, errarray);

    if(delta == 0){
      // If the iteration stops progressing but error > tol then move a little bit to get restarted.
      newDist += tol;
    }

    pt2 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), geoStartAz, newDist * _NMI_IN_METERS, ellipsoid));
    /* Calculate angle between given line and approximate perpendicular */
    distBear = distanceBearing(pt2.toLatLng(), pt1.toLatLng(), ellipsoid);
    crs21 = distBear.bearingAToBInRadian;
    tmpCrs12 = distBear.bearingBToAInRadian;
    dist12 = distBear.distance / _NMI_IN_METERS;
    distBear = distanceBearing(pt2.toLatLng(), pt3.toLatLng(), ellipsoid);
    crs23 = distBear.bearingAToBInRadian;
    crs32 = distBear.bearingBToAInRadian;
    dist23 = distBear.distance / _NMI_IN_METERS;

    /* Cast angle between main course and perpendicular into range [-Pi,Pi] */
    angle = _modlon(crs21 - crs23);
    error = dist23 * (angle.abs() - _M_PI_2);

    errarray[0] = errarray[1];
    distarray[0] = distarray[1];

    errarray[1] = error;
    distarray[1] = newDist;

    delta = (distarray[0] - distarray[1]).abs();
    k++;
  }

  crsFromPoint = crs32;
  distFromPoint = dist23;

  return _ProjectToGeoReturn(pt2, crsFromPoint, distFromPoint);
}