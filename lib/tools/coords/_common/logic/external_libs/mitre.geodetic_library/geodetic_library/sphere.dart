/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

// ignore_for_file: unused_local_variable

/*  Computes intersection points of two small circles on sphere
 *  Input points must be in geocentric coordinates
 *  Outputs will also be in geocentric coordinates
 *
 *  Tol represents the neighborhood around the intersection points. If the circles
 *  are separated by more than tol nmi, then no intersection will be found.  If the circles
 *  overlap by less than tol, then one tangent intersection will be returned.
 *
 * Bounds of arcs are not applied.
 * @param center1 Center of the first arc (LLPoint)
 * @param r1 Radius of the first arc (double)
 * @param center2 Center of the second arc (LLPoint)
 * @param r2 Radius of the second arc (double)
 * @param intx LLPointPair to hold intersection points (LLPointPair)
 * @param n Number of intersection points found (int*)
 * @param bestFitROC Pointer to double with value used as
 * 			sphere radius within function (double*)
 * @param eps convergence parameter for Vincenty forward/inverse algorithms (double)
 * @return Returns error code that indicates success or cause of failure; updates given memory
 * 				addresses with number of intersections and calculated points.
 * @retval SUCCESS Indicates successful execution.
 * @retval NO_INTERSECTION_ERR Status code indicates that no intersection was found in the case that no intersection point gets returned.
 * @retval RADIUS_OUT_OF_RANGE_ERR Indicates that given radius does not meet algorithm requirement.
 * @retval UNEXPECTED_ERR Indicates that an unknown error has occurred.
 */
List<_LLPoint> _initArcIntx(_LLPoint center1, double r1, _LLPoint center2, double r2, double tol, Ellipsoid ellipsoid) {
  int n;
  List<_LLPoint> intx = [_LLPoint(), _LLPoint()];

  _Vector temp = _Vector();
  _Vector norm1 = _Vector();
  _Vector norm2 = _Vector();
  _Vector xLineDir = _Vector();
  _Vector x0 = _Vector();

  double n1_dot_n2;
  double D;

  double t, lx0, delta, crs, dist, midptErr, insideErr;
  double nn;
  double conditionNumber = 0.0;

  double sphereRad = ellipsoid.sphereRadius / _NMI_IN_METERS;

  double halfCircumference = _M_PI * sphereRad;

  List<double> RHS = [0.0, 0.0];
  List<double> C = [0.0, 0.0];

  if ((r1 >= halfCircumference) || (r2 >= halfCircumference)) {
    return <_LLPoint>[];
  }

  /* If radius is large enough, then the center point is farther
       * from the circle than its antipode.  In this case,
       * the checks for non-intersecting arcs are invalid.
       * Here we replace the center point with its antipode and recalculate the
       * radius to give the same circle. */
  if (r1 > halfCircumference / 2.0) {
    center1.latitude = -center1.latitude;
    center1.longitude = _modlon(center1.longitude + _M_PI);
    r1 = halfCircumference - r1;
  }

  if (r2 > halfCircumference / 2.0) {
    center2.latitude = -center2.latitude;
    center2.longitude = _modlon(center2.longitude + _M_PI);
    r2 = halfCircumference - r2;
  }

  norm1 = _mapToUnitSphere(center1); // unit vector
  norm2 = _mapToUnitSphere(center2); // unit vector

  xLineDir = _cross(norm1, norm2); // v in documentation
  n1_dot_n2 = _dot(norm1, norm2); // n1.n2 in the documentation

  var _sphereInv = _sphereInverse(center1, center2, tol, ellipsoid);
  crs = _sphereInv.crs;
  dist = _sphereInv.dist;

  conditionNumber = (1 + n1_dot_n2) / (1 - n1_dot_n2);
  if (conditionNumber > 1.0e5) {
    /* Matrix is ill-conditioned and may lead to incorrect results,
             * so use spherical trig solution */
    double numerator = cos(r2 / sphereRad) - cos(dist / sphereRad) * cos(r1 / sphereRad);
    double denominator = sin(dist / sphereRad) * sin(r1 / sphereRad);
    double arg = numerator / denominator;

    if (arg <= -1.0) {
      /* Protects against one case where roundoff leads to non-physical solution */
      n = 1;
      intx[0] = sphereDirect(center1, crs + _M_PI, r1, ellipsoid);
      return [intx[0]];
    } else if (arg >= 1.0) { /* Protects against other case of non-physical solution */
      n = 1;
      intx[0] = sphereDirect(center1, crs, r1, ellipsoid);
      return [intx[0]];
    } else {
      double rho = acos(arg);
      n = 2;
      intx[0] = sphereDirect(center1, crs + rho, r1, ellipsoid);
      intx[1] = sphereDirect(center1, crs - rho, r1, ellipsoid);

      return [intx[0], intx[1]];
    }
  }

  nn = pow(n1_dot_n2, 2.0).toDouble();
  nn = 1.0 - nn;
  D = 1.0 / nn;

  //    D = 1.0 / (1.0 - n1_dot_n2 * n1_dot_n2); // Inverse of determinant of matrix to solve for C1, C2
  //    printf("    D: %20.15f\n",D);
  RHS[0] = sphereRad * cos(r1 / sphereRad);
  RHS[1] = sphereRad * cos(r2 / sphereRad);
  /* Doing these calcs in stages gives better agreement among compilers */
  //    C[0] = D * (RHS[0] - n1_dot_n2 * RHS[1]); // c1 in documentation
  nn = n1_dot_n2 * RHS[1];
  nn = RHS[0] - nn;
  C[0] = D * nn; // c1 in documentation
  //    C[1] = D * (RHS[1] - n1_dot_n2 * RHS[0]); // c2 in documentation
  nn = n1_dot_n2 * RHS[0];
  nn = RHS[1] - nn;
  C[1] = D * nn; // c2 in documentation

  /* Distance between circles along line joining centers */
  /* This is the dist between circles if neither center is inside
       * the other circle.   */
  midptErr = dist - (r1 + r2);

  /* if one circle inside other, distance between them
       * depends on which is bigger */
  if (r2 >= r1) {
    insideErr = r2 - r1 - dist;
  } else {
    insideErr = r1 - r2 - dist;
  }

  if ((midptErr > tol) || (insideErr > tol)) {
    /* Circles don't intersect (first clause => widely separated;
             * second clause => smaller circle contained within larger circle) */
    n = 0;
    return <_LLPoint>[];
  } else if ((midptErr.abs() <= tol) || (insideErr.abs() <= tol)) {
    /* Circles just barely touch at one tangent intersection */
    n = 1;
  } else {
    n = 2;
  }

  norm1 = _scalarMultiply(norm1, C[0]);
  norm2 = _scalarMultiply(norm2, C[1]);

  x0 = _vectorAdd(norm1, norm2); /* Vector to center of chord common to both circles */
  xLineDir = _normalize(xLineDir); /* make intersection vector have unit length */

  lx0 = sqrt(_dot(x0, x0)); //magnitude (length) of x0
  delta = sphereRad - lx0;

  if (n == 2) { //(delta > tol)
    if (delta < 0.0) {
      /* this should never happen if *n == 2 */
      /* Try spherical triangles solution */
      return <_LLPoint>[];
    }
    t = sqrt(delta) * sqrt(sphereRad + lx0);
    if (t < tol) {
      n = 1;
    }
    temp.x = x0.x + t * xLineDir.x;
    temp.y = x0.y + t * xLineDir.y;
    temp.z = x0.z + t * xLineDir.z;
    /* Will return geocentric coordinates */
    intx[0] = _mapVectorToSphere(temp);
    temp.x = x0.x - t * xLineDir.x;
    temp.y = x0.y - t * xLineDir.y;
    temp.z = x0.z - t * xLineDir.z;
    /* Will return geocentric coordinates */
    intx[1] = _mapVectorToSphere(temp);
  } else if (n == 1) {
    /* Tangent case */
    if ((dist > r1) && (dist > r2)) { /* intersection lies on line between circle centers */
      intx[0] = sphereDirect(center1, crs, r1 + midptErr / 2.0, ellipsoid);
    } else {
      /* One circle is inside another, but not concentric */
      if (r1 > r2) { /* implies r1 > dist > r2, or circle2 is inside circle 1*/
        intx[0] = sphereDirect(center1, crs, r1 - insideErr / 2.0, ellipsoid);
      } else { /* implies r2 < dist < r1, or circle 1 is inside circle 2 */
        intx[0] = sphereDirect(center1, crs + _M_PI, r1 + insideErr / 2.0, ellipsoid);
      }
    }
  }

  var out = <_LLPoint>[];
  for (int i = 0; i < n; i++) {
    out.add(intx[i]);
  }

  return out;
}

/*******************************************************************************
 * Carries out spherical inverse computations, returning course and distance

 *  Find distance and azimuth of great circle between two points on spherical
 * earth model
 * @param org Start point of great circle (LLPoint)
 * @param dest End point of great circle (LLPoint)
 * @param crs Pointer to double that will be updated with the azimuth of great circle at org in radians (double*)
 * @param dist Point to double that will be updated with the distance between org and dest in nmi (double*)
 * @param userROC Pointer to double used to pass desired sphere radius
 *                   (NULL is valid and revert to best fit or default) (double*)
 * @param eps Convergence parameter for Vincenty forward/inverse algorithms (double)
 * @return Updates given memory addresses with calculated course and distance.
 * @retval Nothing
*/

_SphereInverseReturn _sphereInverse(_LLPoint org, _LLPoint dest, double approxZero, Ellipsoid ellipsoid) {
  var crs = _sphereInvCrs(org, dest, approxZero);
  var dist = _sphereInvDist(org, dest, ellipsoid);

  return _SphereInverseReturn(crs, dist);
}

class _SphereInverseReturn {
  final double crs;
  final double dist;

  _SphereInverseReturn(this.crs, this.dist);
}

/*******************************************************************************/
/*
 * Carries out inverse computation but returns only the course.  Slightly
 * faster than sphereInverse if you don't need to know the distance.
 *
 */

double _sphereInvCrs(_LLPoint org, _LLPoint dest, double approxZero) {

  double course, yarg, xarg;

  yarg = sin(org.longitude - dest.longitude) * cos(dest.latitude);
  xarg = cos(org.latitude) * sin(dest.latitude) - (sin(org.latitude)
      * cos(dest.latitude) * cos(org.longitude - dest.longitude));
  course = _M_2PI - _modpos(atan2(yarg, xarg), _M_2PI);
  course = _modpos(course, _M_2PI);

  return course;
}

/*******************************************************************************
 * Carries out inverse computation but returns only the distance.  Slightly
 * faster than sphereInverse if you don't need to know the course.
 */

double _sphereInvDist(_LLPoint org, _LLPoint dest, Ellipsoid ellipsoid) {
  double dist = 0.0;
  double arg1, arg2;

  double sphereRad = ellipsoid.sphereRadius / _NMI_IN_METERS;

  arg1 = sin(0.5 * (org.latitude - dest.latitude));
  arg1 = arg1 * arg1;
  arg2 = sin(0.5 * (org.longitude - dest.longitude));
  arg2 = arg2 * arg2;
  arg2 = cos(org.latitude) * cos(dest.latitude) * arg2;

  dist = sqrt(arg1 + arg2);
  dist = asin(dist);
  dist = 2.0 * sphereRad * dist;

  return dist;
}

/*******************************************************************************/
/* This function returns a destination point given a starting point, course, and
 * distance.  It is called by the initArcIntx function.
 * Calculate a spherical position (lat/lon in radians) given starting position,
 * course and distance
 * @param org Start point of great circle (LLPoint)
 * @param course Course to destination point (double)
 * @param dist Distance to destination point (double)
 * @param dest Pointer to LLPoint struct to be updated by algorithm
 * @return Returns error code that indicates success or cause of failure; updates given memory
 * 				address with destination point.
 * @retval SUCCESS Indicates successful execution.
 */
_LLPoint sphereDirect(_LLPoint org, double course, double dist, Ellipsoid ellipsoid) {

  _LLPoint dest = _LLPoint();
  double sphereRad = ellipsoid.sphereRadius / _NMI_IN_METERS;
  double beta = dist / sphereRad;
  double newLat, newLon, dLon;
  int smallBetaForm = 0;
  double betaMax;
  double sinBeta;
  double angleToPole, angleToGo;
  double complementA;
  double sphereHalfCircum = _M_PI * sphereRad;
  double sphereCircum = _M_2PI * sphereRad;
  double dlat;
  _LLPoint npDest;

  if (dist < 0.0) {
    /* Make dist positive */
    dist = dist.abs();
    course = course + _M_PI;
  }
  dist = dist % sphereCircum; /* Do not wrap around earth */
  if (dist > sphereHalfCircum) {
    // Need to go farther than half way around globe, so turn around and
    // go shorter distance along reciprocal course
    course = course + _M_PI;
    dist = sphereCircum - dist;
  }
  beta = dist/sphereRad;

  course = _modpos(course, _M_2PI);

  /* Check for start at pole */
  if((org.latitude).abs() == _M_PI_2) {
    dlat = (org.latitude > 0) ? -beta : beta;
    newLat = org.latitude + dlat;
    newLon = (org.latitude > 0) ? _modlon((org.longitude + _M_PI) - course) : _modlon((org.longitude) + course);
  } else if (course == 0.0) {
    /* Due north path.  May go over pole, so check how far to project beyond */
    angleToPole = _M_PI_2 - org.latitude;
    angleToGo = beta;
    if (angleToGo <= angleToPole) {
      newLat = org.latitude + angleToGo;
      newLon = org.longitude;
    } else {
      newLat = _M_PI_2 - (angleToGo - angleToPole);
      newLon = org.longitude + _M_PI;
    }
  } else if (course == _M_PI) {
    /* Due south path.  May go over pole, so check how far to project beyond */
    angleToPole = (-_M_PI_2 - org.latitude).abs();
    angleToGo = beta;
    if (angleToGo <= angleToPole) {
      newLat = org.latitude - angleToGo;
      newLon = org.longitude;
    } else {
      newLat = -_M_PI_2 + (angleToGo - angleToPole);
      newLon = org.longitude + _M_PI;
    }
  } else {
    sinBeta = sin(beta);
    newLat = asin(cos(beta) * sin(org.latitude) + sinBeta * cos(
    org.latitude) * cos(course));

    /* betaMax is distance equivalent to 90 degree change in latitude.
             * If the given distance is less than this, then we can use the formula
             * for dLon directly.
             * If the given distance is greater than this, then we have to find the supplement
             * of the computed angle.
             * This is because asin is not singularly valued, and will return [-Pi/2,Pi/2] for
             * arguments in the range [-1,1].  Thus, changes in longitude greater than Pi/2
             * cannot be solved directly using this formula.
             */
    complementA = asin(sin(org.latitude) * sin(course));
    betaMax = acos(tan(complementA) / tan(course));
    /* The following formula is accurate for small angles, but will always return
             * -Pi/2 <= dLon <= Pi/2. Checking the required distance against the 90 degree
             * distance (betaMax) will tell us when to use the supplement to the
             * returned angle. */
    dLon = asin(sin(course) * sinBeta / cos(newLat));
    if (beta > betaMax.abs()) {
      if (dLon > 0.0) {
        dLon = _M_PI - dLon;
      } else {
        dLon = -_M_PI - dLon;
      }
    }
    newLon = org.longitude + dLon;
    smallBetaForm = 1;
  }

  newLon = _modlon(newLon);

  dest.latitude = newLat;
  dest.longitude = newLon;

  return dest;
}