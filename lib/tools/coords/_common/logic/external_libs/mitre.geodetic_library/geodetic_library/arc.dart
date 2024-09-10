/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

/*******************************************************************************
 * Return arc's subtended angle in radians
 *  The sign of the returned value is the same as the sign of the arc's
 * orientation.  In other words, if the orientation < 0 (clockwise),
 * then arc extent < 0.  This is counterintuitive.  If you want to calculate
 * the arc extent with the opposite sign convention, use computeSubtendedAngle.
 *
 * NOTE: This function treats startCrs and endCrs as if they were of infinite
 * precision.  If you want 2*PI to be returned in the start/end points of the
 * arcs are closer than your distance tolerance, then you have to check that
 * before calling this function.
 *  */

double _getArcExtent(_LLPoint center, double radius, double startCrs, double endCrs,
  _ArcDirection orientation, double tol, Ellipsoid ellipsoid) {

  double distToPoint, tempStartCrs, tempEndCrs;
  _LLPoint startPoint, endPoint;
  bool ptsAreClose = false;
  double arcExtent;

  //map courses to [0,2Pi)
  tempStartCrs = _modpos(startCrs, _M_2PI);
  tempEndCrs = _modpos(endCrs, _M_2PI);

  //Calculate the start/end points of the given arc
  startPoint = _LLPoint.fromLatLng(projectionRadian(center.toLatLng(), tempStartCrs, radius / _NMI_IN_METERS, ellipsoid));
  endPoint = _LLPoint.fromLatLng(projectionRadian(center.toLatLng(), tempEndCrs, radius / _NMI_IN_METERS, ellipsoid));

  //Check if the arc start and end points are within tolerance of each other
  var distBear = distanceBearing(startPoint.toLatLng(), endPoint.toLatLng(), ellipsoid);
  distToPoint = distBear.distance;
  if (distToPoint <= tol) {
    ptsAreClose = true;
  }

  //Compute the arc extent
  arcExtent = _computeSubtendedAngle(tempStartCrs, tempEndCrs, orientation);

  if ((tempStartCrs != tempEndCrs) && (ptsAreClose)){
    /*
           * Since points are close, arc extent should either be really small or really close to 2Pi
           * No need to check to angular tolerance critera since the arc extent should be of several
           * orders of magnitude of difference with respect to Pi.
          */
    if (arcExtent.abs() < _M_PI) {
      arcExtent = 0.0;
    } else if (arcExtent.abs() > _M_PI) {
      arcExtent = _M_2PI * (orientation == _ArcDirection.CLOCKWISE ? 1 : -1);
    } else {
      //if abs(arc extent) ~= PI and points are close something is really wrong
      arcExtent = 0.0;
    }
  }

  return arcExtent;
}

/*******************************************************************************
 * Test whether given point lies on arc between start and end courses.
 *
 * Input:
 *
 * Input:
 *   center      = The arc center point
 *   radius      = The arc radius in nautical miles
 *   startCrs    = The course from the arc center point to the arc start point, in radians
 *   endCrs      = The course from the arc center point to the arc end point, in radians
 *   orientation = +1 if arc is traversed counter-clockwise (right handed)
 *                 -1 if arc is traversed clockwise
 *   testPt      = The point to be tested
 *   err         = A pointer to store any errors
 *   tol         = The distance tolerance in nautical miles
 *   eps         = The convergence criteria for the Vincenty Inverse/Forward algorithms, in radians
 *
 * Output:
 * 		Return 1 if point is on the arc.  Return 0 otherwise.
 *
 */

bool _ptIsOnArc(_LLPoint center, double radius, double startCrs, double endCrs, _ArcDirection orientation, _LLPoint testPt, double tol, Ellipsoid ellipsoid) {

  double distToPoint, crsToPoint, crsFromPoint;
  _LLPoint startPoint, endPoint;
  double arcExtent, subExtent;

  //Calculate the start/end points of the given arc
  startPoint = _LLPoint.fromLatLng(projectionRadian(center.toLatLng(), startCrs, radius / _NMI_IN_METERS, ellipsoid));
  endPoint = _LLPoint.fromLatLng(projectionRadian(center.toLatLng(), endCrs, radius / _NMI_IN_METERS, ellipsoid));

  //Check if the test point is within the neighborhood of the arc start point
  var distBear = distanceBearing(startPoint.toLatLng(), testPt.toLatLng(), ellipsoid);
  distToPoint = distBear.distance;
  if (distToPoint <= tol) return true;

  //Check if the test point is within the neighborhood of the arc end point
  distBear = distanceBearing(endPoint.toLatLng(), testPt.toLatLng(), ellipsoid);
  distToPoint = distBear.distance;
  if (distToPoint <= tol) return true;

  //Get the forward/inverse course with respect to test point and arc center point
  //Get the distance in nautical miles from test point to arc center point
  distBear = distanceBearing(center.toLatLng(), testPt.toLatLng(), ellipsoid);
  distToPoint = distBear.distance;
  crsToPoint = distBear.bearingAToBInRadian;
  crsFromPoint = distBear.bearingBToAInRadian;

  //Check if the test point is outside the neighborhood around the arc for a distance of tol
  //The arc extent may be assumed to be a full circle at this point
  if ((radius/_NMI_IN_METERS-distToPoint).abs() > tol) {
    //test point is outside neighborhood around arc and thus cannot be on the arc
    return false;
  }

  //Get the actual arc extent of the given arc
  arcExtent = _getArcExtent(center, radius, startCrs, endCrs, orientation, tol, ellipsoid);

  //Check whether the arc is actually a full circle
  /*If so then the test point must be on the arc since we know it lies within its neighborhood
    * Note: The distance check of the start/end points occurs when getArcExtent is called.
    */
  if (arcExtent.abs() >= _M_2PI) return true;

  /* find extent of new arc with same startCrs but testPt as endCrs */
  subExtent = _getArcExtent(center, radius, startCrs, crsToPoint,orientation, tol, ellipsoid);

  //Check whether the test point is in the arc extent of the given arc
  /*Note: If you have made it this far in the code then the test point is not within a distance of tol
    *      of the arc start/end point.  Hence the subextent must be greater than angleTol where the
    *      value of angleTol should be a function of the value of tol (due to the relationship d = r(theta)).
    *      Thus checking that the traversed arc extent difference is less than zero is sufficient as opposed
    *      to checking that it is less than angleTol
    */
  if (subExtent.abs() - arcExtent.abs() < 0) {
    /* traversing arc from startPt, one would run into testPt before endPt */
    return true;
  }

  return false;
}