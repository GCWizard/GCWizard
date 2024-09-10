/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

/*******************************************************************************
 * Test whether a point lies on line segment defined by startPt and endPt
 *
 * INPUT
 *     startPt: Starting point that defines the line segment
 *       endPt: End point that defines the line segment
 *      testPt: Point to test against line segment
 *  lengthCode: Integer that represents boundedness of line segment:
 *              Allowable values: 0 = finite = macro SEGMENT
 *                                1 = semi-infinite (extends beyond endPt)
 *                                  = macro SEMIINFINITE
 *                                2 = infinite (extends beyond startPt and endPt)
 *                                  = macro INFINITE
 *         tol: Minimum distance from line segment in order for test point
 *              to be considered on it.
 *         eps: Accuracy tolerance for direct/inverse algorithms
 * OUTPUT
 *   1: if the point satisfies all conditions
 *   0: otherwise
 */

bool _ptIsOnGeo(_LLPoint startPt, _LLPoint endPt, _LLPoint testPt, _LineType lengthCode, double tol, Ellipsoid ellipsoid) {

  _LLPoint newStart, newEnd;

  double dist12, crs12, crs21;
  double dist2Test;

  bool returnVal = false;
  bool onCrs = false;
  bool betweenEnds = false;

  if (_ptsAreSame(startPt, testPt, tol, ellipsoid)) {
    /* Point coincides with start point */
    returnVal = true;
  } else if (_ptsAreSame(endPt, testPt, tol, ellipsoid)) {
    /* Point coincides with end point */
    returnVal = true;
  } else {
    returnVal = false;
    var distBear = distanceBearing(startPt.toLatLng(), endPt.toLatLng(), ellipsoid);
    crs12 = distBear.bearingAToBInRadian;
    crs21 = distBear.bearingBToAInRadian;
    dist12 = distBear.distance;

    var ptIsOnCrsRet = _ptIsOnCrs(startPt, crs12, testPt, tol, ellipsoid);
    if (ptIsOnCrsRet.result) {
      onCrs = true;
      betweenEnds = ((ptIsOnCrsRet.dist1Test > 0.0) && (ptIsOnCrsRet.dist1Test < dist12));
    } else if ((ptIsOnCrsRet.dist1Test > 0.0) && (ptIsOnCrsRet.dist1Test < 10.0)) {
      /* Test point is extremely close to startPt.  Courses are not
                   * accurate enough in this case.  Move startPt back 1.0 nm and test again */
      newStart = _LLPoint.fromLatLng(projectionRadian(startPt.toLatLng(), crs12 + _M_PI, 1.0 * _NMI_IN_METERS, ellipsoid));
      var distBear = distanceBearing(newStart.toLatLng(), endPt.toLatLng(), ellipsoid);
      crs12 = distBear.bearingAToBInRadian;
      crs21 = distBear.bearingBToAInRadian;

      ptIsOnCrsRet = _ptIsOnCrs(newStart, crs12, testPt, tol, ellipsoid);
      if (ptIsOnCrsRet.result) {
        onCrs = true;
        betweenEnds = ((ptIsOnCrsRet.dist1Test >= 1.0) && (ptIsOnCrsRet.dist1Test - 1.0 < dist12));
      }
    }

    if (onCrs && ((lengthCode != _LineType.SEGMENT) || (betweenEnds))) {
      returnVal = true;
    } else if (lengthCode == _LineType.INFINITE) {

      ptIsOnCrsRet = _ptIsOnCrs(endPt, crs21, testPt, tol, ellipsoid);
      dist2Test = ptIsOnCrsRet.dist1Test;
      if (ptIsOnCrsRet.result) {
        returnVal = true;
      } else if ((dist2Test > 0.0) && (dist2Test < 10.0)) {

        newEnd = _LLPoint.fromLatLng(projectionRadian(startPt.toLatLng(), crs12 + _M_PI, dist12 + 1.0 * _NMI_IN_METERS, ellipsoid));
        distBear = distanceBearing(newEnd.toLatLng(), endPt.toLatLng(), ellipsoid);
        crs12 = distBear.bearingAToBInRadian;
        crs21 = distBear.bearingBToAInRadian;

        ptIsOnCrsRet = _ptIsOnCrs(newEnd, crs21, testPt, tol, ellipsoid);
        if (ptIsOnCrsRet.result) {
          returnVal = true;
        }
      } else {
        returnVal = false;
      }
    } else {
      returnVal = false;
    }
  }

  return returnVal;
}

/*
 * Starting at startPt and following crs12, will one eventually reach testPt?
 */
_PtIsOnCrsReturn _ptIsOnCrs(_LLPoint startPt, double crs12, _LLPoint testPt, double tol, Ellipsoid ellipsoid) {

  _LLPoint comparePt;
  double crs1Test;
  double dist1Test;
  double crsTest1;

  if (_ptsAreSame(startPt, testPt, tol, ellipsoid)) {
    /* Point coincides with start point */
    /* crsTest1 undefined */
    dist1Test = 0.0;
    return _PtIsOnCrsReturn(true, double.nan, dist1Test);
  }

  var distBear = distanceBearing(startPt.toLatLng(), testPt.toLatLng(), ellipsoid);
  crs1Test = distBear.bearingAToBInRadian;
  crsTest1 = distBear.bearingBToAInRadian;
  dist1Test = distBear.distance;
  comparePt = _LLPoint.fromLatLng(projectionRadian(startPt.toLatLng(), crs12, dist1Test, ellipsoid));
  if ((_modlon(crs12 - crs1Test)).abs() > _M_PI_2) {
    /* testPt is behind startPt, useful for calling function to know this */
    dist1Test = -dist1Test.abs();
  }

  if (_ptsAreSame(testPt, comparePt, tol, ellipsoid)) {
    return _PtIsOnCrsReturn(true, crsTest1, dist1Test);
  } else {
    /*Last possibility: the start point is at a pole in which case
    the test point is definitely on course. It is better to put
    this check at the end of this function so that it is rarely called. */
    if (_ptIsAtPole(startPt, tol, ellipsoid) != 0) {
      //Return 1.
      return _PtIsOnCrsReturn(true, crsTest1, dist1Test);
    } else {
      return _PtIsOnCrsReturn(false, crsTest1, dist1Test);
    }
  }
}

class _PtIsOnCrsReturn {
  final bool result;
  final double crsTest1;
  final double dist1Test;

  _PtIsOnCrsReturn(this.result, this.crsTest1, this.dist1Test);
}