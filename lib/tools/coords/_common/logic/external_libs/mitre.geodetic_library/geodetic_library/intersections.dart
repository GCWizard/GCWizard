/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

// ignore_for_file: unused_local_variable

/* Calculate points of intersection of two arcs.  Arcs are treated as full
* circles. Arc bounds must be applied by parent function, when applicable.
* @param center1 Center of first arc (LLPoint)
* @param r1 Radius of first arc in nmi. (double)
* @param center2 Center of second arc (LLPoint)
* @param r2 Radius of second arc in nmi. (double)
* @param intx Two-element array of LLPoint objects that will be updated with
*               intersections' coordinates. (LLPointPair)
* @param n Pointer to number of intersections found (result. 0, 1, or 2) (double*)
* @param tol Accuracy tolerance in nmi (max distance from found solution to true solution) (double)
* @param eps Convergence tolerance for Vincenty forward/inverse algorithms (double)
* @return Returns error code that indicates success or cause of failure; updates given memory
* addresses with calculated values.
* @retval SUCCESS Indicates successful execution.
* @retval CONCENTRIC_CIRCLE_ERR Indicates that two arcs or circles either do not intersect or are identical. Used as a status code.
* @retval NO_INTERSECTION_ERR Status code indicates that no intersection was found in the case that no intersection point gets returned.
* @retval RADIUS_OUT_OF_RANGE_ERR Indicates that given radius does not meet algorithm requirement.
* @retval SEC_NOT_CONVERGED_ERR Indicates that the secant method failed to converge.
* @retval ERROR_MAX_REACHED_ERR Indicates that an error value has grown larger than allowed.
* @retval UNEXPECTED_ERR Indicates that an unknown error has occurred.
 */
List<_LLPoint> _arcIntx(_LLPoint center1, double r1, _LLPoint center2, double r2, double tol, Ellipsoid ellipsoid) {

    _LLPoint pt, tempPt;
    _LLPointPair intx = [_LLPoint(), _LLPoint()];

    double crs12, crs21, dist12, tempr;
    double crs1x, crsx1, crs2x = 0.0, crsx2, dist1x, dist2x;
    List<double> crsarray = [double.nan, double.nan], errarray = [double.nan, double.nan], longarray = [double.nan, double.nan];
    bool arc1IsAtPole = false, arc2IsAtPole = false;
    double error, y;
    double intersectionLatitude, newLongitude;
    _Arc arcP = _Arc(), arcNP = _Arc();

    int sn; /* Number of intersecting points found from sphere approx. */
    //    int narray; /* number of approximations stored in crsarray, errarray   */
    int k; /* Iteration number */
    int i;
    bool c1EqualsC2 = false;
    bool c1OnArc2 = false;
    bool c2OnArc1 = false;

    int npN;
    _LLPointPair npIntx = [_LLPoint(), _LLPoint()];

    /* initialize count of intersections */
    int n = -1;

    /* Arcs with radius greater than approximate half-circumference of the Earth
         * are not defined and can't be solved with this algorithm. */
    if ((r1 > _MAX_ELLIPSOIDAL_ARC_RADIUS_NMI(ellipsoid)) || (r2 > _MAX_ELLIPSOIDAL_ARC_RADIUS_NMI(ellipsoid))) {
      return <_LLPoint>[];
    }

    //If allowed, this could lead to a logical inconsistency with respect to the geometry (including points) that is defined over a given mathematical space
    /*
         * Check for radius1 == 0, radius2 == 0, dist12 == 0
         */
    //handle arc(s) that are singular points
    if ((r1 == 0.0) && (r2 == 0.0)) {
      //Both arcs are actually singular points in space
      //Use the arc center points as the representations of the arcs themselves

      //check if the centers are identical
      c1EqualsC2 = _ptsAreSame(center1, center2, tol, ellipsoid);

      if (c1EqualsC2) {
        //centers are the same and both arcs are singular points
        //therefore the intersection of the points are the points themselves
        //pick center1 as the intersection point, with respect to the mathematical notion of neighborhoods
        n = 1;
        intx[0] = _LLPoint(center1.latitude, center1.longitude);
        return [intx[0]];
      } else {
        //centers are the same and both arcs are singular points
        //since the centers are distinct with respect to tol (and the mathematical notion of neighborhoods)
        //no intersection may exist
        n = 0;
        return <_LLPoint>[];
      }
    } else if (r1 == 0.0) {
      //Only arc1 is a singular point
      //Use the center1 point as the representation of arc1

      //check if center1 lies on arc2 (treating arc2 as a circle)
      c1OnArc2 = _ptIsOnArc(center2, r2, 0.0, 0.0, _ArcDirection.COUNTERCLOCKWISE, center1, tol, ellipsoid);

      if (c1OnArc2) {
        //center1 lies on arc2 so center1 must be the intersection since center1 is also a singular point
        n = 1;
        intx[0] = _LLPoint(center1.latitude, center1.longitude);
        return [intx[0]];
      } else {
        //center1 does not lie on arc2 and center1 is also a singular point
        //no intersection may exist
        n = 0;
        return <_LLPoint>[];
      }
    } else if (r2 == 0.0) {
      //Only arc2 is a singular point
      //Use the center2 point as the representation of arc2

      //check if center2 lies on arc1 (treating arc1 as a circle)
      c2OnArc1 = _ptIsOnArc(center1, r1, 0.0, 0.0, _ArcDirection.COUNTERCLOCKWISE, center2, tol, ellipsoid);

      if (c2OnArc1) {
        //center2 lies on arc1 so center1 must be the intersection since center2 is also a singular point
        n = 1;
        intx[0] = _LLPoint(center2.latitude, center2.longitude);
        return [intx[0]];
      } else {
        //center2 does not lie on arc1 and center2 is also a singular point
        //no intersection may exist
        n = 0;
        return <_LLPoint>[];
      }
    }

    /*
         * determine the number intersections.
         * Check radii to figure out number of intersections
         */

    // Ensure that circle1 is not smaller than circle2
    // This step simplifies the check for non-intersecting cases later.
    if (r2 > r1) {
      tempr = r1;
      tempPt = center1;
      r1 = r2;
      center1 = center2;
      r2 = tempr;
      center2 = tempPt;
    }

    //find the distance between the arc centers
    var distBear = distanceBearing(center1.toLatLng(), center2.toLatLng(), ellipsoid);
    crs12 = distBear.bearingAToBInRadian;
    crs21 = distBear.bearingBToAInRadian;
    dist12 = distBear.distance / _NMI_IN_METERS;

    //at this point in the algorithm, it is guaranteed that r1 >= r2
    if (dist12 <= tol) {
      //circles are concentric

      if ((r1 - r2).abs() > tol) {
        //circles are concentric but not coincidental, no intersections
        n = 0;
      }
    }

    //Six "simple" cases - the use of tolerance complicates the problem
    if ( r1 + tol + r2 + tol < dist12) {
      //circles are widely separated, no intersections
      n = 0;
    } else if (((r1 - tol) - (r2 + tol)).abs() > dist12) {
      //one circle lies within the other such that no intersection exists
      n = 0;
    } else if ((r1 + r2 - dist12).abs() <= tol) {
      //The discs, represented by the circles, are disjoint other than at the point of tangency
      n = 1;
    } else if (((r1 - r2).abs() - dist12).abs() <= tol) {
      //one circle lies within the other such that the inner circle is tangent to the outer circle
      n = 1;
    } else if (r1 + r2 > dist12) {
      //The discs, represented by the circles, overlap such that no center point overlaps either disc
      n = 2;
    } else if ((r1 - r2).abs() < dist12) {
      //The discs, represented by the circles, overlap such that at least one center point overlaps a disc
      n = 2;
    }

    //find the intersections if they exist
    if (n == 1) {
      intx[0] = _LLPoint.fromLatLng(projectionRadian(center1.toLatLng(), crs12, r1 / _NMI_IN_METERS, ellipsoid));
    } else if (n == 2) {
      // If both arcs are at a pole
      arc1IsAtPole = _ptIsAtPole(center1, tol, ellipsoid) != 0;
      arc2IsAtPole = _ptIsAtPole(center2, tol, ellipsoid) != 0;
      if (arc1IsAtPole && arc2IsAtPole) {
        //Umm...okay, what was the caller thinking?! Either no
        //intersections (if radii not equal) or infinite intersections.
        return <_LLPoint>[];
      }
      // If one arc is at a pole
        else if (arc1IsAtPole || arc2IsAtPole) {
        /* Algorithm Description:
               We know the latitude at which the intersection must
               occur (constant latitude of the arc at the pole). So,
               we can just iterate along that constant latitude line
               until we find a longitude that is on the non-pole arc.
               Once one intersection is known, the other is simply on
               the opposite side of the non-pole arc's center point.
               */


        // Figure out which one is at the pole
        if (arc1IsAtPole) {
          arcP.centerPoint = center1;
          arcP.radius = r1;
          arcNP.centerPoint = center2;
          arcNP.radius = r2;
        } else {
          arcP.centerPoint = center2;
          arcP.radius = r2;
          arcNP.centerPoint = center1;
          arcNP.radius = r1;
        }

        // Calculate the intersection latitude from the pole arc
        tempPt = _LLPoint.fromLatLng(projectionRadian(arcP.centerPoint.toLatLng(), 0, arcP.radius / _NMI_IN_METERS, ellipsoid));
        intersectionLatitude = tempPt.latitude;

        // Create a point on the latitude that we
        // know is correct for the intersection. Guess the longitude. This will help us
        // seed the iteration loop below.
        intx[0].latitude = intersectionLatitude; //initial guess for an intersection
        intx[0].longitude = arcNP.centerPoint.longitude;
        dist1x = distanceBearing(arcNP.centerPoint.toLatLng(), intx[0].toLatLng(), ellipsoid).distance; //distance btwn center and initial guess
        error = dist1x * _NMI_IN_METERS - arcNP.radius; //error of initial guess
        longarray[0] = intx[0].longitude; //store the longitude of initial guess
        errarray[0] = error; //store the error of initial guess

        // Create another point at a slightly different longitude. But,
        // the iteration below will fail if trying to find a solution across
        // the international date line (longitude of +/-pi). So, always
        // choose to search for the intersection point that is away from
        // that line.
        intx[0].latitude = intersectionLatitude; //next guess for intersection point
        intx[0].longitude = arcNP.centerPoint.longitude + (-_sgn(arcNP.centerPoint.longitude)) * 0.1;
        dist1x = distanceBearing(arcNP.centerPoint.toLatLng(), intx[0].toLatLng(), ellipsoid).distance;//distance from center to intersection point
        error = dist1x * _NMI_IN_METERS - arcNP.radius; //error in this guess
        longarray[1] = intx[0].longitude; //store the longitude
        errarray[1] = error; //store the error

        // Now we're ready to iterate the longitude of our guess along a
        // line of constant latitude until the distance value reaches
        // the radius value (error = 0).
        k = 0;
        while ((k < _MAX_ITERATIONS) && (error.abs() > tol) && (error.abs() < _MAX_ELLIPSOIDAL_ARC_RADIUS_NMI(ellipsoid))) {
          k++;

          // Get a new guess for the intersection longitude
          newLongitude = _findRootSecantMethod(longarray, errarray);
          newLongitude = _modlon(newLongitude); //force onto interval [-pi,pi]

          // Use newLongitude to create the new guess point
          intx[0].longitude = newLongitude;
          dist1x = distanceBearing(arcNP.centerPoint.toLatLng(), intx[0].toLatLng(), ellipsoid).distance; //distance from center to intersection point
          error = dist1x * _NMI_IN_METERS - arcNP.radius; //error in this guess

          // Now shift & store the values into the arrays
          longarray[0] = longarray[1];
          errarray[0] = errarray[1];
          longarray[1] = intx[0].longitude;
          errarray[1] = error;
        } //while

        // Now that we have one intersection point, we can calculate the other without difficulty
        // because it is opposite the known point.
        intx[1].latitude = intersectionLatitude;
        intx[1].longitude = _modlon(arcNP.centerPoint.longitude + (arcNP.centerPoint.longitude - intx[0].longitude));
      }
      // Neither arc is at a pole
        else {
        /* Spherical approx */
        intx = _initArcIntx(_geodeticToGeocentric(center1, ellipsoid), r1, _geodeticToGeocentric(center2, ellipsoid), r2, tol, ellipsoid);
        sn = intx.length;
        /* Sphere arc intersect may return NO_INTERSECTION_ERR in cases where the
               * circles are nearly tangent.  Non-intersecting cases are already handled by
               * the midptErr check above, so we mask out the NO_INTERSECTION_ERR and proceed,
               * pretending that the arcs are approximately tangent (number of approximate
               * intersections will be 0).*/

        if (sn < 2) {
          /* Spherical approximation doesn't exist, try more direct approximation *
                   * This case will occur when close to the tangent case.  Due to errors  *
                   * in the spherical approximation, the spherical solution may not exist *
                   * even though the ellipsoidal solution has at least one intersection.  */

          /* Flat-earth approximation of distance from midpoint to intersection */
          /* Distance from center1 to point along center1-center2 line abeam intersection */
          y = (r2 * r2 - r1 * r1 + dist12 * dist12) / (2.0 * dist12);

          /* angle between crs12 and crs to approximate intersection */
          crs1x = acos(y / r1);

          intx[0] = _LLPoint.fromLatLng(projectionRadian(center1.toLatLng(), crs12 + crs1x, r1 * _NMI_IN_METERS, ellipsoid));
          intx[1] = _LLPoint.fromLatLng(projectionRadian(center1.toLatLng(), crs12 - crs1x, r1 * _NMI_IN_METERS, ellipsoid));
        }

        /* intx will point to array of two points now
               * Refine position of each point until it lies on both circles.
               */

        for (i = 0; i < 2; i++) {
          if (i == 0) {
            intx[i].latitude = _geodeticLat(intx[i].latitude, ellipsoid);
            pt = intx[i];
            /* Find course from center 2 to approx point */
            distBear = distanceBearing(center2.toLatLng(), pt.toLatLng(), ellipsoid);
            crs2x = distBear.bearingAToBInRadian;
            crsx2 = distBear.bearingBToAInRadian;
            dist2x = distBear.distance / _NMI_IN_METERS;
          } else {
            /* use angle to first solution as starting point for
                       * second solution */
            crs2x = crs21 + _modlon(crs21 - crs2x);
          }

          k = 0;

          /* Place point on circumference of circle 2 */
          pt = _LLPoint.fromLatLng(projectionRadian(center2.toLatLng(), crs2x, r2 * _NMI_IN_METERS, ellipsoid));
          /* Find distance from center 1 to pt */
          /* As pt approaches intersection, this value will approach r1 */
          distBear = distanceBearing(center1.toLatLng(), pt.toLatLng(), ellipsoid);
          crs1x = distBear.bearingAToBInRadian;
          crsx1 = distBear.bearingBToAInRadian;
          dist1x = distBear.distance / _NMI_IN_METERS;
          error = r1 - dist1x;

          errarray[1] = error;
          crsarray[1] = crs1x;

          /* Iteratively improve solution */
          while ((k < _MAX_ITERATIONS) && (error.abs() > tol)) {
            k++;

            /* Use calculated course to move point to circumference 1 */
            pt = _LLPoint.fromLatLng(projectionRadian(center1.toLatLng(), crs1x, r1 * _NMI_IN_METERS, ellipsoid));

            /* Find course from center 2 to new approx point */
            distBear = distanceBearing(center2.toLatLng(), pt.toLatLng(), ellipsoid);
            crs2x = distBear.bearingAToBInRadian;
            crsx2 = distBear.bearingBToAInRadian;
            dist2x = distBear.distance / _NMI_IN_METERS;

            /* Move point along crs to circumference of circle 2 */
            pt = _LLPoint.fromLatLng(projectionRadian(center2.toLatLng(), crs2x, r2 * _NMI_IN_METERS, ellipsoid));

            /* Find distance from center 1 to pt */
            //      dist1x = invDist(center1,pt,eps);
            distBear = distanceBearing(center1.toLatLng(), pt.toLatLng(), ellipsoid);
            crs1x = distBear.bearingAToBInRadian;
            crsx1 = distBear.bearingBToAInRadian;
            dist1x = distBear.distance / _NMI_IN_METERS;

            error = r1 - dist1x;

            crsarray[0] = crsarray[1];
            crsarray[1] = crs1x;
            errarray[0] = errarray[1];
            errarray[1] = error;
            /* The error is a function that depends on crs1x
                       * Use linear approx to this function to find new
                       * intersection estimate */
            crs1x = _findRootSecantMethod(crsarray, errarray);
          } /* end while */

          intx[i] = pt;
        } /* end for */

      } /* if arc on pole */
    }

    var out = <_LLPoint>[];
    for (int i = 0; i < n; i++) {
      out.add(intx[i]);
    }

    return out;
}

/* Calculate points of intersection of arc and geodesic.  The arc is treated as a full
* circle and geodesic is treated as unbounded.  Bounds of either object must
* be applied by the parent function, when applicable.
* @param pt1 Starting point of geodesic (LLPoint)
* @param crs1 Azimuth of geodesic at pt1, in radians (double)
* @param center Center of arc (LLPoint)
* @param radius Radius of arc, in nmi (double)
* @param intx Two-element array of LLPoint objects that will be updated with
*               intersections' coordinates. (LLPointPair*)
* @param n Pointer to number of intersections found (result. 0, 1, or 2) (double*)
* @param tol Accuracy tolerance in nmi (max distance from found solution to true solution) (double)
* @param eps Convergence tolerance for Vincenty forward/inverse algorithms (double)
* @return Returns error code that indicates success or cause of failure; updates given memory
* addresses with calculated values.
* @retval SUCCESS Indicates successful execution.
* @retval CONCENTRIC_CIRCLE_ERR Indicates that two arcs or circles either do not intersect or are identical. Used as a status code.
* @retval TOL_TOO_SMALL_ERR Indicates that the requested tolerance cannot be met due to large requested Vincenty algorithm precision.
* @retval ITERATION_MAX_REACHED_ERR Indicates that a method has looped more than the allowed iteration count.
* @retval ERROR_MAX_REACHED_ERR Indicates that an error value has grown larger than allowed.
 */

List<_LLPoint> _geoArcIntx(_LLPoint pt1, double crs1, _LLPoint center, double radius, double tol, Ellipsoid ellipsoid) {
  _LLPoint perpPt;
  _LLPoint newStart;
  int i, k, j = 0;

  double perpDist, perpCrs; // Distance & crs from center to perp. point
  List<double> dist = [double.nan, double.nan]; // Distance from perpendicular point to approx. point
  List<double> crs = [double.nan, double.nan], bcrs = [double.nan, double.nan]; // Course and backcourse from perp. point to approx point
  double rcrs, brcrs; // Course and backcourse from intx to arc center point
  List<double> distarray = [double.nan, double.nan], errarray = [double.nan, double.nan];
  double A, B, c, error, radDist;
  double tempCrs, newCrs; // throw-away course value
  double stepSize = 9.0e99;

  double sphereRad = ellipsoid.sphereRadius / _NMI_IN_METERS;

  int n = 0; /* initialize number of intersections found */
  _LLPointPair intx = [_LLPoint(), _LLPoint()];

  /* Handle case if center and pt1 are essentially same point */
  /* Find dist from center to pt1 */
  radDist = distanceBearing(pt1.toLatLng(), center.toLatLng(), ellipsoid).distance / _NMI_IN_METERS;

  if (radDist < _TOL) {
    /* center and pt1 are indistinguishable */
    var intx0 = _LLPoint.fromLatLng(projectionRadian(center.toLatLng(), crs1, radius * _NMI_IN_METERS, ellipsoid));
    var intx1 = _LLPoint.fromLatLng(projectionRadian(center.toLatLng(), _modcrs(crs1 + _M_PI), radius * _NMI_IN_METERS, ellipsoid));
    return [intx0, intx1];
  }
  else if (radDist < radius) {
    /* pt1 is inside circle, numerical accuracy may not be good */
    /* Move start of line outside circle for better accuracy */
    /* New start will be at least one mile from circle */
    newStart = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), crs1 + _M_PI, (2.0 * radius + 10.0) * _NMI_IN_METERS, ellipsoid));

    var distBear = distanceBearing(newStart.toLatLng(), pt1.toLatLng(), ellipsoid);
    newCrs = distBear.bearingAToBInRadian;
    tempCrs = distBear.bearingBToAInRadian;
    pt1 = newStart;
    crs1 = newCrs;
  }

  /* project center of arc onto geodesic */
  _ProjectToGeoReturn ptGeo = _projectToGeo(pt1, crs1, center, tol, ellipsoid);
  perpPt = ptGeo.pt2;
  perpCrs = ptGeo.crsFromPoint;
  perpDist = ptGeo.distFromPoint;

  /* calc distance & crs from pt1 to projected point */
  var distBear = distanceBearing(perpPt.toLatLng(), pt1.toLatLng(), ellipsoid);
  crs[0] = distBear.bearingAToBInRadian;
  bcrs[0] = distBear.bearingBToAInRadian;
  crs[1] = _modcrs(crs[0] + _M_PI);

  if ((perpDist - radius).abs() < tol) {
    /* Line is tangent to circle */
    return [perpPt];
  } else if (perpDist > radius) {
    /* no intersections -- line too far from circle */
    return <_LLPoint>[];
  } else if (_ptsAreSame(perpPt,center,tol,ellipsoid)) {
    /* Line goes through center of arc.  This is a special case where
           * we can project the intersection points directly. Find azimuth of geodesic
           * at arc center, then project out radius distance along this azimuth (in
           * both directions) to find two intersections with arc. */
    double azFromCenter, azToCenter;
    /* Find azimuth of geodesic at arc center */
    var distBear = distanceBearing(center.toLatLng(), pt1.toLatLng(), ellipsoid);
    azFromCenter = distBear.bearingAToBInRadian;
    azToCenter = distBear.bearingBToAInRadian;
    radDist = _modcrs(crs[0] + _M_PI);

    if (radDist < 100.0) {
      /* line start is less than 100 meters from center point, so azimuth will not
                 * be very precise.  Use precise given azimuth to move start of geodesic farther away
                 * and then update pt1 to this location */
      if ((_modlon(crs1-azToCenter)).abs()<_M_PI_2) {
        /* Arc center lies in crs1 direction from pt1, so move pt1 backward 1.0 NM */
        pt1 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), crs1 + _M_PI, 1.0 * _NMI_IN_METERS, ellipsoid));
      } else {
        /* Arc center lies "behind" pt1, so move pt1 forward 1 NM */
        pt1 = _LLPoint.fromLatLng(projectionRadian(pt1.toLatLng(), crs1, 1.0 * _NMI_IN_METERS, ellipsoid));
      }
      /* Recompute azimuth */
      var distBear = distanceBearing(center.toLatLng(), pt1.toLatLng(), ellipsoid);
      azFromCenter = distBear.bearingAToBInRadian;
      azToCenter = distBear.bearingBToAInRadian;
      radDist = _modcrs(crs[0] + _M_PI);
    }

    intx[0] = _LLPoint.fromLatLng(projectionRadian(center.toLatLng(), azFromCenter, radius * _NMI_IN_METERS, ellipsoid));
    intx[1] = _LLPoint.fromLatLng(projectionRadian(center.toLatLng(), _modcrs(azFromCenter+_M_PI), radius * _NMI_IN_METERS, ellipsoid));
    return [intx[0], intx[1]];
  }

  if (cos(perpDist / sphereRad) > 0) {
    dist[0] = sphereRad * acos(cos(radius / sphereRad) / cos(perpDist / sphereRad));
  } else {
    /* Arc and geodesic describe the same great circle.
           * Intersection is entire arc. */
    return <_LLPoint>[];
  }

  /* move first approximate point to line */
  intx[0] = _LLPoint.fromLatLng(projectionRadian(perpPt.toLatLng(), crs[0], dist[0] * _NMI_IN_METERS, ellipsoid));

  /* Iterate to improve approximations */
  for (i = 0; i < 2; i++) {

    if (i == 1) {
      // Use solution to first point to find approximation to second point
      dist[1] = dist[0];
      intx[1] = _LLPoint.fromLatLng(projectionRadian(perpPt.toLatLng(), crs[1], dist[1] * _NMI_IN_METERS, ellipsoid));
    }

    k = 0;
    /* Calculate distance from center to approx. intersection point */
    var distBear = distanceBearing(intx[i].toLatLng(), center.toLatLng(), ellipsoid);
    rcrs = distBear.bearingAToBInRadian;
    brcrs = distBear.bearingBToAInRadian;
    radDist = _modcrs(crs[0] + _M_PI);
    /* error in approximation is difference between approx. distance and
           * arc radius */
    error = radius - radDist;

    /* Preload array to enable linear extrapolation/interpolation of
           * solution */
    distarray[1] = dist[i];
    errarray[1] = error;

    /* calculate distance adjustment */
    while ((k == 0) || //force entry to ensure at least one iteration
        (((error.abs() > tol) || (stepSize > tol)) &&
            (k < _MAX_ITERATIONS) )) {

      if (k == 0) {
        /* On first pass, improve approximation using triangle */
        var distBear = distanceBearing(intx[i].toLatLng(), perpPt.toLatLng(), ellipsoid);
        bcrs[i] = distBear.bearingAToBInRadian;
        tempCrs = distBear.bearingBToAInRadian;
        B = (_modlon(bcrs[i] - rcrs)).abs(); // into range [0,pi]

        /* C = 90 degrees             |\
                         a = error                  |A\
                         c = length adjustment      |  \
                                                   b|   \c
                       |    \
                                                    |     \
                                                    |90___B\
                                                       a
                       */
        /* Formulae for spherical triangles */
        /* NOTE: this uses a great circle to approximate small portion of
                       * arc near the intersection (side b in diagram). */
        A = acos(sin(B) * cos(error.abs() / sphereRad));
        if ((sin(A)).abs() < _INTERNAL_ZERO) {
          /* case where line is close to diameter */
          c = error;
        } else if (A.abs() < _INTERNAL_ZERO) {
          /* case where line is nearly tangent */
          c = error / cos(B);
        } else {
          /* normal case */
          c = sphereRad * asin(sin(error / sphereRad) / sin(A));
        }

        /* We move in different directions depending on which side of circle we are on */
        if (error > 0) {
          /* if intx[i] is inside circle, move away from perpendicular point */
          dist[i] += c.abs();
        } else {
          dist[i] -= c.abs();
        }

      } else {
        /* Subsequent approximations use linear extrapolation/interpolation */
        /* Can't do this on first pass -- need two points for linear approx */
        dist[i] = _findRootSecantMethod(distarray, errarray);
      }

      /* Place i-th approximate intersection point on geodesic */
      intx[i] = _LLPoint.fromLatLng(projectionRadian(perpPt.toLatLng(), crs[i], dist[i] * _NMI_IN_METERS, ellipsoid));
      /* Calculate distance from center of circle to approx. intersection */
      var distBear = distanceBearing(intx[i].toLatLng(), center.toLatLng(), ellipsoid);
      rcrs = distBear.bearingAToBInRadian;
      brcrs = distBear.bearingBToAInRadian;
      radDist = distBear.distance / _NMI_IN_METERS;

      error = radius - radDist;

      /* This function uses the secant root finding method. If the secant method gets
                 * stuck crossing back and forth over the root (see bug 33554) we switch to the
                 * regula falsi method and insure that the two points used in the method have
                 * opposite sign in the errarray. If that gets stuck we switch back to the
                 * secant method.
                 */
      if((_sgn(errarray[0]) == _sgn(errarray[1])) || (error == 0) || k < 5 || j.abs() == 2) {
        distarray[0] = distarray[1];
        distarray[1] = dist[i];
        errarray[0] = errarray[1];
        errarray[1] = error;
        j = 0;
      } else if (_sgn(error) == errarray[0]){
        errarray[0] = error;
        distarray[0] = dist[i];
        j++;
      } else {
        errarray[1] = error;
        distarray[1] = dist[i];
        j--;
      }

      stepSize = (distarray[1] - distarray[0]).abs();

      k++;
    } /* end while */

    n = n + 1;
  } /* end for(i) */

  var out = <_LLPoint>[];
  for (int i = 0; i < n; i++) {
    out.add(intx[i]);
  }

  return out;
}