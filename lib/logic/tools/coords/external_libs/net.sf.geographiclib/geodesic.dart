/***********************************************************************
    Dart port of Java implementation of
    ======================
    GeographicLib
    ======================

 * Copyright (c) Charles Karney (2013-2021) <charles@karney.com> and licensed
 * under the MIT/X11 License.  For more information, see
 * https://geographiclib.sourceforge.io/
 * https://sourceforge.net/projects/geographiclib/

 **********************************************************************/
import 'dart:math';

import 'package:gc_wizard/logic/tools/coords/external_libs/net.sf.geographiclib/geo_math.dart';
import 'package:gc_wizard/logic/tools/coords/external_libs/net.sf.geographiclib/geodesic_data.dart';
import 'package:gc_wizard/logic/tools/coords/external_libs/net.sf.geographiclib/geodesic_line.dart';
import 'package:gc_wizard/logic/tools/coords/external_libs/net.sf.geographiclib/geodesic_mask.dart';
import 'package:gc_wizard/logic/tools/coords/external_libs/net.sf.geographiclib/math.dart';
import 'package:gc_wizard/logic/tools/coords/external_libs/net.sf.geographiclib/pair.dart';

/*
 * Geodesic calculations.
 * <p>
 * The shortest path between two points on a ellipsoid at (<i>lat1</i>,
 * <i>lon1</i>) and (<i>lat2</i>, <i>lon2</i>) is called the geodesic.  Its
 * length is <i>s12</i> and the geodesic from point 1 to point 2 has azimuths
 * <i>azi1</i> and <i>azi2</i> at the two end points.  (The azimuth is the
 * heading measured clockwise from north.  <i>azi2</i> is the "forward"
 * azimuth, i.e., the heading that takes you beyond point 2 not back to point
 * 1.)
 * <p>
 * Given <i>lat1</i>, <i>lon1</i>, <i>azi1</i>, and <i>s12</i>, we can
 * determine <i>lat2</i>, <i>lon2</i>, and <i>azi2</i>.  This is the
 * <i>direct</i> geodesic problem and its solution is given by the function
 * {@link #Direct Direct}.  (If <i>s12</i> is sufficiently large that the
 * geodesic wraps more than halfway around the earth, there will be another
 * geodesic between the points with a smaller <i>s12</i>.)
 * <p>
 * Given <i>lat1</i>, <i>lon1</i>, <i>lat2</i>, and <i>lon2</i>, we can
 * determine <i>azi1</i>, <i>azi2</i>, and <i>s12</i>.  This is the
 * <i>inverse</i> geodesic problem, whose solution is given by {@link #Inverse
 * Inverse}.  Usually, the solution to the inverse problem is unique.  In cases
 * where there are multiple solutions (all with the same <i>s12</i>, of
 * course), all the solutions can be easily generated once a particular
 * solution is provided.
 * <p>
 * The standard way of specifying the direct problem is the specify the
 * distance <i>s12</i> to the second point.  However it is sometimes useful
 * instead to specify the arc length <i>a12</i> (in degrees) on the auxiliary
 * sphere.  This is a mathematical construct used in solving the geodesic
 * problems.  The solution of the direct problem in this form is provided by
 * {@link #ArcDirect ArcDirect}.  An arc length in excess of 180&deg; indicates
 * that the geodesic is not a shortest path.  In addition, the arc length
 * between an equatorial crossing and the next extremum of latitude for a
 * geodesic is 90&deg;.
 * <p>
 * This class can also calculate several other quantities related to
 * geodesics.  These are:
 * <ul>
 * <li>
 *   <i>reduced length</i>.  If we fix the first point and increase
 *   <i>azi1</i> by <i>dazi1</i> (radians), the second point is displaced
 *   <i>m12</i> <i>dazi1</i> in the direction <i>azi2</i> + 90&deg;.  The
 *   quantity <i>m12</i> is called the "reduced length" and is symmetric under
 *   interchange of the two points.  On a curved surface the reduced length
 *   obeys a symmetry relation, <i>m12</i> + <i>m21</i> = 0.  On a flat
 *   surface, we have <i>m12</i> = <i>s12</i>.  The ratio <i>s12</i>/<i>m12</i>
 *   gives the azimuthal scale for an azimuthal equidistant projection.
 * <li>
 *   <i>geodesic scale</i>.  Consider a reference geodesic and a second
 *   geodesic parallel to this one at point 1 and separated by a small distance
 *   <i>dt</i>.  The separation of the two geodesics at point 2 is <i>M12</i>
 *   <i>dt</i> where <i>M12</i> is called the "geodesic scale".  <i>M21</i> is
 *   defined similarly (with the geodesics being parallel at point 2).  On a
 *   flat surface, we have <i>M12</i> = <i>M21</i> = 1.  The quantity
 *   1/<i>M12</i> gives the scale of the Cassini-Soldner projection.
 * <li>
 *   <i>area</i>.  The area between the geodesic from point 1 to point 2 and
 *   the equation is represented by <i>S12</i>; it is the area, measured
 *   counter-clockwise, of the geodesic quadrilateral with corners
 *   (<i>lat1</i>,<i>lon1</i>), (0,<i>lon1</i>), (0,<i>lon2</i>), and
 *   (<i>lat2</i>,<i>lon2</i>).  It can be used to compute the area of any
 *   geodesic polygon.
 * </ul>
 * <p>
 * The quantities <i>m12</i>, <i>M12</i>, <i>M21</i> which all specify the
 * behavior of nearby geodesics obey addition rules.  If points 1, 2, and 3 all
 * lie on a single geodesic, then the following rules hold:
 * <ul>
 * <li>
 *   <i>s13</i> = <i>s12</i> + <i>s23</i>
 * <li>
 *   <i>a13</i> = <i>a12</i> + <i>a23</i>
 * <li>
 *   <i>S13</i> = <i>S12</i> + <i>S23</i>
 * <li>
 *   <i>m13</i> = <i>m12</i> <i>M23</i> + <i>m23</i> <i>M21</i>
 * <li>
 *   <i>M13</i> = <i>M12</i> <i>M23</i> &minus; (1 &minus; <i>M12</i>
 *   <i>M21</i>) <i>m23</i> / <i>m12</i>
 * <li>
 *   <i>M31</i> = <i>M32</i> <i>M21</i> &minus; (1 &minus; <i>M23</i>
 *   <i>M32</i>) <i>m12</i> / <i>m23</i>
 * </ul>
 * <p>
 * The results of the geodesic calculations are bundled up into a {@link
 * GeodesicData} object which includes the input parameters and all the
 * computed results, i.e., <i>lat1</i>, <i>lon1</i>, <i>azi1</i>, <i>lat2</i>,
 * <i>lon2</i>, <i>azi2</i>, <i>s12</i>, <i>a12</i>, <i>m12</i>, <i>M12</i>,
 * <i>M21</i>, <i>S12</i>.
 * <p>
 * The functions {@link #Direct(double, double, double, double, int) Direct},
 * {@link #ArcDirect(double, double, double, double, int) ArcDirect}, and
 * {@link #Inverse(double, double, double, double, int) Inverse} include an
 * optional final argument <i>outmask</i> which allows you specify which
 * results should be computed and returned.  If you omit <i>outmask</i>, then
 * the "standard" geodesic results are computed (latitudes, longitudes,
 * azimuths, and distance).  <i>outmask</i> is bitor'ed combination of {@link
 * GeodesicMask} values.  For example, if you wish just to compute the distance
 * between two points you would call, e.g.,
 * <pre>
 * {@code
 *  GeodesicData g = Geodesic.WGS84.Inverse(lat1, lon1, lat2, lon2,
 *                      GeodesicMask.DISTANCE); }</pre>
 * <p>
 * Additional functionality is provided by the {@link GeodesicLine} class,
 * which allows a sequence of points along a geodesic to be computed.
 * <p>
 * The shortest distance returned by the solution of the inverse problem is
 * (obviously) uniquely defined.  However, in a few special cases there are
 * multiple azimuths which yield the same shortest distance.  Here is a
 * catalog of those cases:
 * <ul>
 * <li>
 *   <i>lat1</i> = &minus;<i>lat2</i> (with neither point at a pole).  If
 *   <i>azi1</i> = <i>azi2</i>, the geodesic is unique.  Otherwise there are
 *   two geodesics and the second one is obtained by setting [<i>azi1</i>,
 *   <i>azi2</i>] &rarr; [<i>azi2</i>, <i>azi1</i>], [<i>M12</i>, <i>M21</i>]
 *   &rarr; [<i>M21</i>, <i>M12</i>], <i>S12</i> &rarr; &minus;<i>S12</i>.
 *   (This occurs when the longitude difference is near &plusmn;180&deg; for
 *   oblate ellipsoids.)
 * <li>
 *   <i>lon2</i> = <i>lon1</i> &plusmn; 180&deg; (with neither point at a
 *   pole).  If <i>azi1</i> = 0&deg; or &plusmn;180&deg;, the geodesic is
 *   unique.  Otherwise there are two geodesics and the second one is obtained
 *   by setting [ <i>azi1</i>, <i>azi2</i>] &rarr; [&minus;<i>azi1</i>,
 *   &minus;<i>azi2</i>], <i>S12</i> &rarr; &minus; <i>S12</i>.  (This occurs
 *   when <i>lat2</i> is near &minus;<i>lat1</i> for prolate ellipsoids.)
 * <li>
 *   Points 1 and 2 at opposite poles.  There are infinitely many geodesics
 *   which can be generated by setting [<i>azi1</i>, <i>azi2</i>] &rarr;
 *   [<i>azi1</i>, <i>azi2</i>] + [<i>d</i>, &minus;<i>d</i>], for arbitrary
 *   <i>d</i>.  (For spheres, this prescription applies when points 1 and 2 are
 *   antipodal.)
 * <li>
 *   <i>s12</i> = 0 (coincident points).  There are infinitely many geodesics
 *   which can be generated by setting [<i>azi1</i>, <i>azi2</i>] &rarr;
 *   [<i>azi1</i>, <i>azi2</i>] + [<i>d</i>, <i>d</i>], for arbitrary <i>d</i>.
 * </ul>
 * <p>
 * The calculations are accurate to better than 15 nm (15 nanometers) for the
 * WGS84 ellipsoid.  See Sec. 9 of
 * <a href="https://arxiv.org/abs/1102.1215v1">arXiv:1102.1215v1</a> for
 * details.  The algorithms used by this class are based on series expansions
 * using the flattening <i>f</i> as a small parameter.  These are only accurate
 * for |<i>f</i>| &lt; 0.02; however reasonably accurate results will be
 * obtained for |<i>f</i>| &lt; 0.2.  Here is a table of the approximate
 * maximum error (expressed as a distance) for an ellipsoid with the same
 * equatorial radius as the WGS84 ellipsoid and different values of the
 * flattening.<pre>
 *     |f|      error
 *     0.01     25 nm
 *     0.02     30 nm
 *     0.05     10 um
 *     0.1     1.5 mm
 *     0.2     300 mm </pre>
 * <p>
 * The algorithms are described in
 * <ul>
 * <li>C. F. F. Karney,
 *   <a href="https://doi.org/10.1007/s00190-012-0578-z">
 *   Algorithms for geodesics</a>,
 *   J. Geodesy <b>87</b>, 43&ndash;55 (2013)
 *   (<a href="https://geographiclib.sourceforge.io/geod-addenda.html">
 *    addenda</a>).
 * </ul>
 * <p>
 * Example of use:
 * <pre>
 * {@code
 * // Solve the direct geodesic problem.
 *
 * // This program reads in lines with lat1, lon1, azi1, s12 and prints
 * // out lines with lat2, lon2, azi2 (for the WGS84 ellipsoid).
 *
 * import java.util.*;
 * import net.sf.geographiclib.*;
 * class Direct {
 *   static void main(String[] args) {
 *     try {
 *       Scanner in = new Scanner(System.in);
 *       double lat1, lon1, azi1, s12;
 *       while (true) {
 *         lat1 = in.nextDouble(); lon1 = in.nextDouble();
 *         azi1 = in.nextDouble(); s12 = in.nextDouble();
 *         GeodesicData g = Geodesic.WGS84.Direct(lat1, lon1, azi1, s12);
 *         System.out.println(g.lat2 + " " + g.lon2 + " " + g.azi2);
 *       }
 *     }
 *     catch (Exception e) {}
 *   }
 * }}</pre>
 **********************************************************************/
class Geodesic {
  /*
   * The order of the expansions used by Geodesic.
   **********************************************************************/
  static final int GEOGRAPHICLIB_GEODESIC_ORDER = 6;

  static final int nA1_ = GEOGRAPHICLIB_GEODESIC_ORDER;
  static final int nC1_ = GEOGRAPHICLIB_GEODESIC_ORDER;
  static final int nC1p_ = GEOGRAPHICLIB_GEODESIC_ORDER;
  static final int nA2_ = GEOGRAPHICLIB_GEODESIC_ORDER;
  static final int nC2_ = GEOGRAPHICLIB_GEODESIC_ORDER;
  static final int nA3_ = GEOGRAPHICLIB_GEODESIC_ORDER;
  static final int nA3x_ = nA3_;
  static final int nC3_ = GEOGRAPHICLIB_GEODESIC_ORDER;
  static final int nC3x_ = (nC3_ * (nC3_ - 1)) ~/ 2;
  static final int nC4_ = GEOGRAPHICLIB_GEODESIC_ORDER;
  static final int nC4x_ = (nC4_ * (nC4_ + 1)) ~/ 2;
  static final int _maxit1_ = 20;
  static final int _maxit2_ = _maxit1_ + GeoMath.digits + 10;

  // Underflow guard.  We require
  //   tiny_ * epsilon() > 0
  //   tiny_ + epsilon() == epsilon()
  static final double tiny_ = sqrt(double.minPositive);
  static final double _tol0_ = double.minPositive;
  // Increase multiplier in defn of tol1_ from 100 to 200 to fix inverse case
  // 52.784459512564 0 -52.784459512563990912 179.634407464943777557
  // which otherwise failed for Visual Studio 10 (Release and Debug)
  static final double _tol1_ = 200 * _tol0_;
  static final double _tol2_ = sqrt(_tol0_);
  // Check on bisection interval
  static final double _tolb_ = _tol0_ * _tol2_;
  static final double _xthresh_ = 1000 * _tol2_;

  double a, f, f1, e2, ep2, b, c2;
  double _n, _etol2;
  List<double> _A3x, _C3x, _C4x;

  /*
   * Constructor for a ellipsoid with
   * <p>
   * @param a equatorial radius (meters).
   * @param f flattening of ellipsoid.  Setting <i>f</i> = 0 gives a sphere.
   *   Negative <i>f</i> gives a prolate ellipsoid.
   * @exception GeographicErr if <i>a</i> or (1 &minus; <i>f</i> ) <i>a</i> is
   *   not positive.
   **********************************************************************/
  Geodesic(double _a, double _f) {
    a = _a;
    f = _f;
    f1 = 1 - f;
    e2 = f * (2 - f);
    ep2 = e2 / GeoMath.sq(f1); // e2 / (1 - e2)
    _n = f / (2 - f);
    b = a * f1;
    c2 = (GeoMath.sq(a) +
            GeoMath.sq(b) * (e2 == 0 ? 1 : (e2 > 0 ? GeoMath.atanh(sqrt(e2)) : atan(sqrt(-e2))) / sqrt(e2.abs()))) /
        2; // authalic radius squared
    // The sig12 threshold for "really short".  Using the auxiliary sphere
    // solution with dnm computed at (bet1 + bet2) / 2, the relative error in
    // the azimuth consistency check is sig12^2 * abs(f) * min(1, 1-f/2) / 2.
    // (Error measured for 1/100 < b/a < 100 and abs(f) >= 1/1000.  For a
    // given f and sig12, the max error occurs for lines near the pole.  If
    // the old rule for computing dnm = (dn1 + dn2)/2 is used, then the error
    // increases by a factor of 2.)  Setting this equal to epsilon gives
    // sig12 = etol2.  Here 0.1 is a safety factor (error decreased by 100)
    // and max(0.001, abs(f)) stops etol2 getting too large in the nearly
    // spherical case.
    _etol2 = 0.1 * _tol2_ / sqrt(max(0.001, f.abs()) * min(1.0, 1 - f / 2) / 2);
    if (!(GeoMath.isfinite(a) && a > 0)) throw Exception("Equatorial radius is not positive");
    if (!(GeoMath.isfinite(b) && b > 0)) throw Exception("Polar semi-axis is not positive");
    _A3x = List<double>.generate(nA3x_, (index) => 0.0);
    _C3x = List<double>.generate(nC3x_, (index) => 0.0);
    _C4x = List<double>.generate(nC4x_, (index) => 0.0);

    A3coeff();
    C3coeff();
    C4coeff();
  }

  /*
   * Solve the direct geodesic problem where the length of the geodesic
   * is specified in terms of distance.
   * <p>
   * @param lat1 latitude of point 1 (degrees).
   * @param lon1 longitude of point 1 (degrees).
   * @param azi1 azimuth at point 1 (degrees).
   * @param s12 distance between point 1 and point 2 (meters); it can be
   *   negative.
   * @return a {@link GeodesicData} object with the following fields:
   *   <i>lat1</i>, <i>lon1</i>, <i>azi1</i>, <i>lat2</i>, <i>lon2</i>,
   *   <i>azi2</i>, <i>s12</i>, <i>a12</i>.
   * <p>
   * <i>lat1</i> should be in the range [&minus;90&deg;, 90&deg;].  The values
   * of <i>lon2</i> and <i>azi2</i> returned are in the range [&minus;180&deg;,
   * 180&deg;].
   * <p>
   * If either point is at a pole, the azimuth is defined by keeping the
   * longitude fixed, writing <i>lat</i> = &plusmn;(90&deg; &minus; &epsilon;),
   * and taking the limit &epsilon; &rarr; 0+.  An arc length greater that
   * 180&deg; signifies a geodesic which is not a shortest path.  (For a
   * prolate ellipsoid, an additional condition is necessary for a shortest
   * path: the longitudinal extent must not exceed of 180&deg;.)
   **********************************************************************/
  GeodesicData direct(double lat1, double lon1, double azi1, double s12) {
    return _direct(lat1, lon1, azi1, false, s12, GeodesicMask.STANDARD);
  }

  /*
   * The general direct geodesic problem.  {@link #Direct Direct} and
   * {@link #ArcDirect ArcDirect} are defined in terms of this function.
   * <p>
   * @param lat1 latitude of point 1 (degrees).
   * @param lon1 longitude of point 1 (degrees).
   * @param azi1 azimuth at point 1 (degrees).
   * @param arcmode bool flag determining the meaning of the
   *   <i>s12_a12</i>.
   * @param s12_a12 if <i>arcmode</i> is false, this is the distance between
   *   point 1 and point 2 (meters); otherwise it is the arc length between
   *   point 1 and point 2 (degrees); it can be negative.
   * @param outmask a bitor'ed combination of {@link GeodesicMask} values
   *   specifying which results should be returned.
   * @return a {@link GeodesicData} object with the fields specified by
   *   <i>outmask</i> computed.
   * <p>
   * The {@link GeodesicMask} values possible for <i>outmask</i> are
   * <ul>
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#LATITUDE} for the latitude
   *   <i>lat2</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#LONGITUDE} for the latitude
   *   <i>lon2</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#AZIMUTH} for the latitude
   *   <i>azi2</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#DISTANCE} for the distance
   *   <i>s12</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#REDUCEDLENGTH} for the reduced
   *   length <i>m12</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#GEODESICSCALE} for the geodesic
   *   scales <i>M12</i> and <i>M21</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#AREA} for the area <i>S12</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#ALL} for all of the above;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#LONG_UNROLL}, if set then
   *   <i>lon1</i> is unchanged and <i>lon2</i> &minus; <i>lon1</i> indicates
   *   how many times and in what sense the geodesic encircles the ellipsoid.
   *   Otherwise <i>lon1</i> and <i>lon2</i> are both reduced to the range
   *   [&minus;180&deg;, 180&deg;].
   * </ul>
   * <p>
   * The function value <i>a12</i> is always computed and returned and this
   * equals <i>s12_a12</i> is <i>arcmode</i> is true.  If <i>outmask</i>
   * includes {@link GeodesicMask#DISTANCE} and <i>arcmode</i> is false, then
   * <i>s12</i> = <i>s12_a12</i>.  It is not necessary to include {@link
   * GeodesicMask#DISTANCE_IN} in <i>outmask</i>; this is automatically
   * included is <i>arcmode</i> is false.
   **********************************************************************/
  GeodesicData _direct(double lat1, double lon1, double azi1, bool arcmode, double s12_a12, int outmask) {
    // Automatically supply DISTANCE_IN if necessary
    if (!arcmode) outmask |= GeodesicMask.DISTANCE_IN;
    return new GeodesicLine(this, lat1, lon1, azi1, outmask)
        . // Note the dot!
        Position(arcmode, s12_a12, outmask);
  }

  /*
   * Solve the inverse geodesic problem.
   * <p>
   * @param lat1 latitude of point 1 (degrees).
   * @param lon1 longitude of point 1 (degrees).
   * @param lat2 latitude of point 2 (degrees).
   * @param lon2 longitude of point 2 (degrees).
   * @return a {@link GeodesicData} object with the following fields:
   *   <i>lat1</i>, <i>lon1</i>, <i>azi1</i>, <i>lat2</i>, <i>lon2</i>,
   *   <i>azi2</i>, <i>s12</i>, <i>a12</i>.
   * <p>
   * <i>lat1</i> and <i>lat2</i> should be in the range [&minus;90&deg;,
   * 90&deg;].  The values of <i>azi1</i> and <i>azi2</i> returned are in the
   * range [&minus;180&deg;, 180&deg;].
   * <p>
   * If either point is at a pole, the azimuth is defined by keeping the
   * longitude fixed, writing <i>lat</i> = &plusmn;(90&deg; &minus; &epsilon;),
   * taking the limit &epsilon; &rarr; 0+.
   * <p>
   * The solution to the inverse problem is found using Newton's method.  If
   * this fails to converge (this is very unlikely in geodetic applications
   * but does occur for very eccentric ellipsoids), then the bisection method
   * is used to refine the solution.
   **********************************************************************/
  GeodesicData inverse(double lat1, double lon1, double lat2, double lon2) {
    return _inverse(lat1, lon1, lat2, lon2, GeodesicMask.STANDARD);
  }

  _InverseData _inverseInt(double lat1, double lon1, double lat2, double lon2, int outmask) {
    _InverseData result = _InverseData();
    Pair p = Pair();
    GeodesicData r = result._g;
    // Compute longitude difference (AngDiff does this carefully).  Result is
    // in [-180, 180] but -180 is only for west-going geodesics.  180 is for
    // east-going and meridional geodesics.
    r.lat1 = lat1 = GeoMath.LatFix(lat1);
    r.lat2 = lat2 = GeoMath.LatFix(lat2);
    // If really close to the equator, treat as on equator.
    lat1 = GeoMath.AngRound(lat1);
    lat2 = GeoMath.AngRound(lat2);
    double lon12, lon12s;
    GeoMath.AngDiff(p, lon1, lon2);
    lon12 = p.first;
    lon12s = p.second;
    if ((outmask & GeodesicMask.LONG_UNROLL) != 0) {
      r.lon1 = lon1;
      r.lon2 = (lon1 + lon12) + lon12s;
    } else {
      r.lon1 = GeoMath.AngNormalize(lon1);
      r.lon2 = GeoMath.AngNormalize(lon2);
    }
    // Make longitude difference positive.
    int lonsign = lon12 >= 0 ? 1 : -1;
    // If very close to being on the same half-meridian, then make it so.
    lon12 = lonsign * GeoMath.AngRound(lon12);
    lon12s = GeoMath.AngRound((180 - lon12) - lonsign * lon12s);
    double lam12 = toRadians(lon12), slam12, clam12;
    GeoMath.sincosd(p, lon12 > 90 ? lon12s : lon12);
    slam12 = p.first;
    clam12 = (lon12 > 90 ? -1 : 1) * p.second;

    // Swap points so that point with higher (abs) latitude is point 1
    // If one latitude is a nan, then it becomes lat1.
    int swapp = lat1.abs() < lat2.abs() ? -1 : 1;
    if (swapp < 0) {
      lonsign *= -1;
      {
        double t = lat1;
        lat1 = lat2;
        lat2 = t;
      }
    }
    // Make lat1 <= 0
    int latsign = lat1 < 0 ? 1 : -1;
    lat1 *= latsign;
    lat2 *= latsign;
    // Now we have
    //
    //     0 <= lon12 <= 180
    //     -90 <= lat1 <= 0
    //     lat1 <= lat2 <= -lat1
    //
    // longsign, swapp, latsign register the transformation to bring the
    // coordinates to this canonical form.  In all cases, 1 means no change was
    // made.  We make these transformations so that there are few cases to
    // check, e.g., on verifying quadrants in atan2.  In addition, this
    // enforces some symmetries in the results returned.

    double sbet1, cbet1, sbet2, cbet2, s12x, m12x;

    GeoMath.sincosd(p, lat1);
    sbet1 = f1 * p.first;
    cbet1 = p.second;
    // Ensure cbet1 = +epsilon at poles; doing the fix on beta means that sig12
    // will be <= 2*tiny for two points at the same pole.
    GeoMath.norm(p, sbet1, cbet1);
    sbet1 = p.first;
    cbet1 = p.second;
    cbet1 = max(tiny_, cbet1);

    GeoMath.sincosd(p, lat2);
    sbet2 = f1 * p.first;
    cbet2 = p.second;
    // Ensure cbet2 = +epsilon at poles
    GeoMath.norm(p, sbet2, cbet2);
    sbet2 = p.first;
    cbet2 = p.second;
    cbet2 = max(tiny_, cbet2);

    // If cbet1 < -sbet1, then cbet2 - cbet1 is a sensitive measure of the
    // |bet1| - |bet2|.  Alternatively (cbet1 >= -sbet1), abs(sbet2) + sbet1 is
    // a better measure.  This logic is used in assigning calp2 in Lambda12.
    // Sometimes these quantities vanish and in that case we force bet2 = +/-
    // bet1 exactly.  An example where is is necessary is the inverse problem
    // 48.522876735459 0 -48.52287673545898293 179.599720456223079643
    // which failed with Visual Studio 10 (Release and Debug)

    if (cbet1 < -sbet1) {
      if (cbet2 == cbet1) sbet2 = sbet2 < 0 ? sbet1 : -sbet1;
    } else {
      if (sbet2.abs() == -sbet1) cbet2 = cbet1;
    }

    double dn1 = sqrt(1 + ep2 * GeoMath.sq(sbet1)), dn2 = sqrt(1 + ep2 * GeoMath.sq(sbet2));

    double a12, sig12, _calp1, _salp1, calp2, salp2;
    // index zero elements of these arrays are unused
    List<double> C1a = List<double>.generate(nC1_ + 1, (index) => 0.0);
    List<double> C2a = List<double>.generate(nC2_ + 1, (index) => 0.0);
    List<double> C3a = List<double>.generate(nC3_, (index) => 0.0);

    bool meridian = lat1 == -90 || slam12 == 0;
    _LengthsV v = _LengthsV();

    if (meridian) {
      // Endpoints are on a single full meridian, so the geodesic might lie on
      // a meridian.

      _calp1 = clam12;
      _salp1 = slam12; // Head to the target longitude
      calp2 = 1;
      salp2 = 0; // At the target we're heading north

      double
          // tan(bet) = tan(sig) * cos(alp)
          ssig1 = sbet1,
          csig1 = _calp1 * cbet1,
          ssig2 = sbet2,
          csig2 = calp2 * cbet2;

      // sig12 = sig2 - sig1
      sig12 = atan2(max(0.0, csig1 * ssig2 - ssig1 * csig2), csig1 * csig2 + ssig1 * ssig2);
      _Lengths(v, _n, sig12, ssig1, csig1, dn1, ssig2, csig2, dn2, cbet1, cbet2,
          outmask | GeodesicMask.DISTANCE | GeodesicMask.REDUCEDLENGTH, C1a, C2a);
      s12x = v._s12b;
      m12x = v._m12b;
      if ((outmask & GeodesicMask.GEODESICSCALE) != 0) {
        r.M12 = v._M12;
        r.M21 = v._M21;
      }
      // Add the check for sig12 since zero length geodesics might yield m12 <
      // 0.  Test case was
      //
      //    echo 20.001 0 20.001 0 | GeodSolve -i
      //
      // In fact, we will have sig12 > pi/2 for meridional geodesic which is
      // not a shortest path.
      if (sig12 < 1 || m12x >= 0) {
        // Need at least 2, to handle 90 0 90 180
        if (sig12 < 3 * tiny_ ||
            // Prevent negative s12 or m12 for short lines
            (sig12 < _tol0_ && (s12x < 0 || m12x < 0))) sig12 = m12x = s12x = 0;
        m12x *= b;
        s12x *= b;
        a12 = toDegrees(sig12);
      } else
        // m12 < 0, i.e., prolate and too close to anti-podal
        meridian = false;
    }

    double omg12, somg12 = 2, comg12;
    if (!meridian &&
        sbet1 == 0 && // and sbet2 == 0
        // Mimic the way Lambda12 works with _calp1 = 0
        (f <= 0 || lon12s >= f * 180)) {
      // Geodesic runs along equator
      _calp1 = calp2 = 0;
      _salp1 = salp2 = 1;
      s12x = a * lam12;
      sig12 = omg12 = lam12 / f1;
      m12x = b * sin(sig12);
      if ((outmask & GeodesicMask.GEODESICSCALE) != 0) r.M12 = r.M21 = cos(sig12);
      a12 = lon12 / f1;
    } else if (!meridian) {
      // Now point1 and point2 belong within a hemisphere bounded by a
      // meridian and geodesic is neither meridional or equatorial.

      // Figure a starting point for Newton's method
      double dnm;
      {
        _InverseStartV s = _InverseStart(sbet1, cbet1, dn1, sbet2, cbet2, dn2, lam12, slam12, clam12, C1a, C2a, p, v);
        sig12 = s._sig12;
        _salp1 = s._salp1;
        _calp1 = s._calp1;
        salp2 = s._salp2;
        calp2 = s._calp2;
        dnm = s._dnm;
      }

      if (sig12 >= 0) {
        // Short lines (InverseStart sets salp2, calp2, dnm)
        s12x = sig12 * b * dnm;
        m12x = GeoMath.sq(dnm) * b * sin(sig12 / dnm);
        if ((outmask & GeodesicMask.GEODESICSCALE) != 0) r.M12 = r.M21 = cos(sig12 / dnm);
        a12 = toDegrees(sig12);
        omg12 = lam12 / (f1 * dnm);
      } else {
        // Newton's method.  This is a straightforward solution of f(alp1) =
        // lambda12(alp1) - lam12 = 0 with one wrinkle.  f(alp) has exactly one
        // root in the interval (0, pi) and its derivative is positive at the
        // root.  Thus f(alp) is positive for alp > alp1 and negative for alp <
        // alp1.  During the course of the iteration, a range (alp1a, alp1b) is
        // maintained which brackets the root and with each evaluation of
        // f(alp) the range is shrunk, if possible.  Newton's method is
        // restarted whenever the derivative of f is negative (because the new
        // value of alp1 is then further from the solution) or if the new
        // estimate of alp1 lies outside (0,pi); in this case, the new starting
        // guess is taken to be (alp1a + alp1b) / 2.
        double ssig1, csig1, ssig2, csig2, eps, domg12;
        int numit = 0;
        // Bracketing range
        double _salp1a = tiny_, _calp1a = 1, _salp1b = tiny_, _calp1b = -1;
        _Lambda12V w = _Lambda12V();
        for (bool tripn = false, tripb = false; numit < _maxit2_; ++numit) {
          // the WGS84 test set: mean = 1.47, sd = 1.25, max = 16
          // WGS84 and random input: mean = 2.85, sd = 0.60
          double V, dV;
          _Lambda12(w, sbet1, cbet1, dn1, sbet2, cbet2, dn2, _salp1, _calp1, slam12, clam12, numit < _maxit1_, C1a, C2a,
              C3a, p, v);
          V = w.lam12;
          salp2 = w.salp2;
          calp2 = w.calp2;
          sig12 = w.sig12;
          ssig1 = w.ssig1;
          csig1 = w.csig1;
          ssig2 = w.ssig2;
          csig2 = w.csig2;
          eps = w.eps;
          domg12 = w.domg12;
          dV = w.dlam12;
          // Reversed test to allow escape with NaNs
          if (tripb || !(V.abs() >= (tripn ? 8 : 1) * _tol0_)) break;
          // Update bracketing values
          if (V > 0 && (numit > _maxit1_ || _calp1 / _salp1 > _calp1b / _salp1b)) {
            _salp1b = _salp1;
            _calp1b = _calp1;
          } else if (V < 0 && (numit > _maxit1_ || _calp1 / _salp1 < _calp1a / _salp1a)) {
            _salp1a = _salp1;
            _calp1a = _calp1;
          }
          if (numit < _maxit1_ && dV > 0) {
            double dalp1 = -V / dV;
            double sdalp1 = sin(dalp1), cdalp1 = cos(dalp1), n_salp1 = _salp1 * cdalp1 + _calp1 * sdalp1;
            if (n_salp1 > 0 && dalp1.abs() < pi) {
              _calp1 = _calp1 * cdalp1 - _salp1 * sdalp1;
              _salp1 = n_salp1;
              GeoMath.norm(p, _salp1, _calp1);
              _salp1 = p.first;
              _calp1 = p.second;
              // In some regimes we don't get quadratic convergence because
              // slope -> 0.  So use convergence conditions based on epsilon
              // instead of sqrt(epsilon).
              tripn = V.abs() <= 16 * _tol0_;
              continue;
            }
          }
          // Either dV was not positive or updated value was outside legal
          // range.  Use the midpoint of the bracket as the next estimate.
          // This mechanism is not needed for the WGS84 ellipsoid, but it does
          // catch problems with more eccentric ellipsoids.  Its efficacy is
          // such for the WGS84 test set with the starting guess set to alp1 =
          // 90deg:
          // the WGS84 test set: mean = 5.21, sd = 3.93, max = 24
          // WGS84 and random input: mean = 4.74, sd = 0.99
          _salp1 = (_salp1a + _salp1b) / 2;
          _calp1 = (_calp1a + _calp1b) / 2;
          GeoMath.norm(p, _salp1, _calp1);
          _salp1 = p.first;
          _calp1 = p.second;
          tripn = false;
          tripb = ((_salp1a - _salp1).abs() + (_calp1a - _calp1) < _tolb_ ||
              (_salp1 - _salp1b).abs() + (_calp1 - _calp1b) < _tolb_);
        }
        {
          // Ensure that the reduced length and geodesic scale are computed in
          // a "canonical" way, with the I2 integral.
          int lengthmask = outmask |
              ((outmask & (GeodesicMask.REDUCEDLENGTH | GeodesicMask.GEODESICSCALE)) != 0
                  ? GeodesicMask.DISTANCE
                  : GeodesicMask.NONE);
          _Lengths(v, eps, sig12, ssig1, csig1, dn1, ssig2, csig2, dn2, cbet1, cbet2, lengthmask, C1a, C2a);
          s12x = v._s12b;
          m12x = v._m12b;
          if ((outmask & GeodesicMask.GEODESICSCALE) != 0) {
            r.M12 = v._M12;
            r.M21 = v._M21;
          }
        }
        m12x *= b;
        s12x *= b;
        a12 = toDegrees(sig12);
        if ((outmask & GeodesicMask.AREA) != 0) {
          // omg12 = lam12 - domg12
          double sdomg12 = sin(domg12), cdomg12 = cos(domg12);
          somg12 = slam12 * cdomg12 - clam12 * sdomg12;
          comg12 = clam12 * cdomg12 + slam12 * sdomg12;
        }
      }
    }

    if ((outmask & GeodesicMask.DISTANCE) != 0) r.s12 = 0 + s12x; // Convert -0 to 0

    if ((outmask & GeodesicMask.REDUCEDLENGTH) != 0) r.m12 = 0 + m12x; // Convert -0 to 0

    if ((outmask & GeodesicMask.AREA) != 0) {
      double
          // From Lambda12: sin(alp1) * cos(bet1) = sin(alp0)
          salp0 = _salp1 * cbet1,
          calp0 = hypot(_calp1, _salp1 * sbet1); // calp0 > 0
      double alp12;
      if (calp0 != 0 && salp0 != 0) {
        double
            // From Lambda12: tan(bet) = tan(sig) * cos(alp)
            ssig1 = sbet1,
            csig1 = _calp1 * cbet1,
            ssig2 = sbet2,
            csig2 = calp2 * cbet2,
            k2 = GeoMath.sq(calp0) * ep2,
            eps = k2 / (2 * (1 + sqrt(1 + k2)) + k2),
            // Multiplier = a^2 * e^2 * cos(alpha0) * sin(alpha0).
            A4 = GeoMath.sq(a) * calp0 * salp0 * e2;
        GeoMath.norm(p, ssig1, csig1);
        ssig1 = p.first;
        csig1 = p.second;
        GeoMath.norm(p, ssig2, csig2);
        ssig2 = p.first;
        csig2 = p.second;
        List<double> C4a = List<double>.generate(nC4_, (index) => 0.0);
        C4f(eps, C4a);
        double B41 = SinCosSeries(false, ssig1, csig1, C4a), B42 = SinCosSeries(false, ssig2, csig2, C4a);
        r.S12 = A4 * (B42 - B41);
      } else
        // Avoid problems with indeterminate sig1, sig2 on equator
        r.S12 = 0;

      if (!meridian && somg12 > 1) {
        somg12 = sin(omg12);
        comg12 = cos(omg12);
      }

      if (!meridian &&
          comg12 > -0.7071 && // Long difference not too big
          sbet2 - sbet1 < 1.75) {
        // Lat difference not too big
        // Use tan(Gamma/2) = tan(omg12/2)
        // * (tan(bet1/2)+tan(bet2/2))/(1+tan(bet1/2)*tan(bet2/2))
        // with tan(x/2) = sin(x)/(1+cos(x))
        double domg12 = 1 + comg12, dbet1 = 1 + cbet1, dbet2 = 1 + cbet2;
        alp12 = 2 * atan2(somg12 * (sbet1 * dbet2 + sbet2 * dbet1), domg12 * (sbet1 * sbet2 + dbet1 * dbet2));
      } else {
        // alp12 = alp2 - alp1, used in atan2 so no need to normalize
        double _salp12 = salp2 * _calp1 - calp2 * _salp1, _calp12 = calp2 * _calp1 + salp2 * _salp1;
        // The right thing appears to happen if alp1 = +/-180 and alp2 = 0, viz
        // _salp12 = -0 and alp12 = -180.  However this depends on the sign
        // being attached to 0 correctly.  The following ensures the correct
        // behavior.
        if (_salp12 == 0 && _calp12 < 0) {
          _salp12 = tiny_ * _calp1;
          _calp12 = -1;
        }
        alp12 = atan2(_salp12, _calp12);
      }
      r.S12 += c2 * alp12;
      r.S12 *= swapp * lonsign * latsign;
      // Convert -0 to 0
      r.S12 += 0;
    }

    // Convert calp, salp to azimuth accounting for lonsign, swapp, latsign.
    if (swapp < 0) {
      {
        double t = _salp1;
        _salp1 = salp2;
        salp2 = t;
      }
      {
        double t = _calp1;
        _calp1 = calp2;
        calp2 = t;
      }
      if ((outmask & GeodesicMask.GEODESICSCALE) != 0) {
        double t = r.M12;
        r.M12 = r.M21;
        r.M21 = t;
      }
    }

    _salp1 *= swapp * lonsign;
    _calp1 *= swapp * latsign;
    salp2 *= swapp * lonsign;
    calp2 *= swapp * latsign;

    // Returned value in [0, 180]
    r.a12 = a12;
    result._salp1 = _salp1;
    result._calp1 = _calp1;
    result._salp2 = salp2;
    result._calp2 = calp2;
    return result;
  }

  /*
   * Solve the inverse geodesic problem with a subset of the geodesic results
   * returned.
   * <p>
   * @param lat1 latitude of point 1 (degrees).
   * @param lon1 longitude of point 1 (degrees).
   * @param lat2 latitude of point 2 (degrees).
   * @param lon2 longitude of point 2 (degrees).
   * @param outmask a bitor'ed combination of {@link GeodesicMask} values
   *   specifying which results should be returned.
   * @return a {@link GeodesicData} object with the fields specified by
   *   <i>outmask</i> computed.
   * <p>
   * The {@link GeodesicMask} values possible for <i>outmask</i> are
   * <ul>
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#DISTANCE} for the distance
   *   <i>s12</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#AZIMUTH} for the latitude
   *   <i>azi2</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#REDUCEDLENGTH} for the reduced
   *   length <i>m12</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#GEODESICSCALE} for the geodesic
   *   scales <i>M12</i> and <i>M21</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#AREA} for the area <i>S12</i>;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#ALL} for all of the above.
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#LONG_UNROLL}, if set then
   *   <i>lon1</i> is unchanged and <i>lon2</i> &minus; <i>lon1</i> indicates
   *   whether the geodesic is east going or west going.  Otherwise <i>lon1</i>
   *   and <i>lon2</i> are both reduced to the range [&minus;180&deg;,
   *   180&deg;].
   * </ul>
   * <p>
   * <i>lat1</i>, <i>lon1</i>, <i>lat2</i>, <i>lon2</i>, and <i>a12</i> are
   * always included in the returned result.
   **********************************************************************/
  GeodesicData _inverse(double lat1, double lon1, double lat2, double lon2, int outmask) {
    outmask &= GeodesicMask.OUT_MASK;
    _InverseData result = _inverseInt(lat1, lon1, lat2, lon2, outmask);
    GeodesicData r = result._g;
    if ((outmask & GeodesicMask.AZIMUTH) != 0) {
      r.azi1 = GeoMath.atan2d(result._salp1, result._calp1);
      r.azi2 = GeoMath.atan2d(result._salp2, result._calp2);
    }
    return r;
  }

  static double SinCosSeries(bool sinp, double sinx, double cosx, List<double> c) {
    // Evaluate
    // y = sinp ? sum(c[i] * sin( 2*i    * x), i, 1, n) :
    //            sum(c[i] * cos((2*i+1) * x), i, 0, n-1)
    // using Clenshaw summation.  N.B. c[0] is unused for sin series
    // Approx operation count = (n + 5) mult and (2 * n + 2) add
    int k = c.length, // Point to one beyond last element
        n = k - (sinp ? 1 : 0);
    double ar = 2 * (cosx - sinx) * (cosx + sinx), // 2 * cos(2 * x)
        y0 = (n & 1) != 0 ? c[--k] : 0,
        y1 = 0; // accumulators for sum
    // Now n is even
    n ~/= 2;
    while (n-- != 0) {
      // Unroll loop x 2, so accumulators return to their original role
      y1 = ar * y0 - y1 + c[--k];
      y0 = ar * y1 - y0 + c[--k];
    }
    return sinp
        ? 2 * sinx * cosx * y0 // sin(2 * x) * y0
        : cosx * (y0 - y1); // cos(x) * (y0 - y1)
  }

  void _Lengths(
      _LengthsV v,
      double eps,
      double sig12,
      double ssig1,
      double csig1,
      double dn1,
      double ssig2,
      double csig2,
      double dn2,
      double cbet1,
      double cbet2,
      int outmask,
      // Scratch areas of the right size
      List<double> C1a,
      List<double> C2a) {
    // Return m12b = (reduced length)/_b; also calculate s12b = distance/_b,
    // and m0 = coefficient of secular term in expression for reduced length.
    outmask &= GeodesicMask.OUT_MASK;
    // v to hold compute s12b, m12b, m0, M12, M21;

    double m0x = 0, J12 = 0, A1 = 0, A2 = 0;
    if ((outmask & (GeodesicMask.DISTANCE | GeodesicMask.REDUCEDLENGTH | GeodesicMask.GEODESICSCALE)) != 0) {
      A1 = A1m1f(eps);
      C1f(eps, C1a);
      if ((outmask & (GeodesicMask.REDUCEDLENGTH | GeodesicMask.GEODESICSCALE)) != 0) {
        A2 = A2m1f(eps);
        C2f(eps, C2a);
        m0x = A1 - A2;
        A2 = 1 + A2;
      }
      A1 = 1 + A1;
    }
    if ((outmask & GeodesicMask.DISTANCE) != 0) {
      double B1 = SinCosSeries(true, ssig2, csig2, C1a) - SinCosSeries(true, ssig1, csig1, C1a);
      // Missing a factor of _b
      v._s12b = A1 * (sig12 + B1);
      if ((outmask & (GeodesicMask.REDUCEDLENGTH | GeodesicMask.GEODESICSCALE)) != 0) {
        double B2 = SinCosSeries(true, ssig2, csig2, C2a) - SinCosSeries(true, ssig1, csig1, C2a);
        J12 = m0x * sig12 + (A1 * B1 - A2 * B2);
      }
    } else if ((outmask & (GeodesicMask.REDUCEDLENGTH | GeodesicMask.GEODESICSCALE)) != 0) {
      // Assume here that nC1_ >= nC2_
      for (int l = 1; l <= nC2_; ++l) C2a[l] = A1 * C1a[l] - A2 * C2a[l];
      J12 = m0x * sig12 + (SinCosSeries(true, ssig2, csig2, C2a) - SinCosSeries(true, ssig1, csig1, C2a));
    }
    if ((outmask & GeodesicMask.REDUCEDLENGTH) != 0) {
      v._m0 = m0x;
      // Missing a factor of _b.
      // Add parens around (csig1 * ssig2) and (ssig1 * csig2) to ensure
      // accurate cancellation in the case of coincident points.
      v._m12b = dn2 * (csig1 * ssig2) - dn1 * (ssig1 * csig2) - csig1 * csig2 * J12;
    }
    if ((outmask & GeodesicMask.GEODESICSCALE) != 0) {
      double csig12 = csig1 * csig2 + ssig1 * ssig2;
      double t = ep2 * (cbet1 - cbet2) * (cbet1 + cbet2) / (dn1 + dn2);
      v._M12 = csig12 + (t * ssig2 - csig2 * J12) * ssig1 / dn1;
      v._M21 = csig12 - (t * ssig1 - csig1 * J12) * ssig2 / dn2;
    }
  }

  static double _Astroid(double x, double y) {
    // Solve k^4+2*k^3-(x^2+y^2-1)*k^2-2*y^2*k-y^2 = 0 for positive root k.
    // This solution is adapted from Geocentric::Reverse.
    double k;
    double p = GeoMath.sq(x), q = GeoMath.sq(y), r = (p + q - 1) / 6;
    if (!(q == 0 && r <= 0)) {
      double
          // Avoid possible division by zero when r = 0 by multiplying equations
          // for s and t by r^3 and r, resp.
          S = p * q / 4, // S = r^3 * s
          r2 = GeoMath.sq(r),
          r3 = r * r2,
          // The discriminant of the quadratic equation for T3.  This is zero on
          // the evolute curve p^(1/3)+q^(1/3) = 1
          disc = S * (S + 2 * r3);
      double u = r;
      if (disc >= 0) {
        double T3 = S + r3;
        // Pick the sign on the sqrt to maximize abs(T3).  This minimizes loss
        // of precision due to cancellation.  The result is unchanged because
        // of the way the T is used in definition of u.
        T3 += T3 < 0 ? -sqrt(disc) : sqrt(disc); // T3 = (r * t)^3
        // N.B. cbrt always returns the double root.  cbrt(-8) = -2.
        double T = cbrt(T3); // T = r * t
        // T can be zero; but then r2 / T -> 0.
        u += T + (T != 0 ? r2 / T : 0);
      } else {
        // T is complex, but the way u is defined the result is double.
        double ang = atan2(sqrt(-disc), -(S + r3));
        // There are three possible cube roots.  We choose the root which
        // avoids cancellation.  Note that disc < 0 implies that r < 0.
        u += 2 * r * cos(ang / 3);
      }
      double v = sqrt(GeoMath.sq(u) + q), // guaranteed positive
          // Avoid loss of accuracy when u < 0.
          uv = u < 0 ? q / (v - u) : u + v, // u+v, guaranteed positive
          w = (uv - q) / (2 * v); // positive?
      // Rearrange expression for k to avoid loss of accuracy due to
      // subtraction.  Division by 0 not possible because uv > 0, w >= 0.
      k = uv / (sqrt(uv + GeoMath.sq(w)) + w); // guaranteed positive
    } else {
      // q == 0 && r <= 0
      // y = 0 with |x| <= 1.  Handle this case directly.
      // for y small, positive root is k = abs(y)/sqrt(1-x^2)
      k = 0;
    }
    return k;
  }

  _InverseStartV _InverseStart(
      double sbet1,
      double cbet1,
      double dn1,
      double sbet2,
      double cbet2,
      double dn2,
      double lam12,
      double slam12,
      double clam12,
      // Scratch areas of the right size
      List<double> C1a,
      List<double> C2a,
      Pair p,
      _LengthsV v) {
    // Return a starting point for Newton's method in _salp1 and _calp1 (function
    // value is -1).  If Newton's method doesn't need to be used, return also
    // salp2 and calp2 and function value is sig12.

    // To hold sig12, _salp1, _calp1, salp2, calp2, dnm.
    _InverseStartV w = _InverseStartV();
    w._sig12 = -1; // Return value
    double
        // bet12 = bet2 - bet1 in [0, pi); bet12a = bet2 + bet1 in (-pi, 0]
        sbet12 = sbet2 * cbet1 - cbet2 * sbet1,
        cbet12 = cbet2 * cbet1 + sbet2 * sbet1;
    double sbet12a = sbet2 * cbet1 + cbet2 * sbet1;
    bool shortline = cbet12 >= 0 && sbet12 < 0.5 && cbet2 * lam12 < 0.5;
    double somg12, comg12;
    if (shortline) {
      double sbetm2 = GeoMath.sq(sbet1 + sbet2);
      // sin((bet1+bet2)/2)^2
      // =  (sbet1 + sbet2)^2 / ((sbet1 + sbet2)^2 + (cbet1 + cbet2)^2)
      sbetm2 /= sbetm2 + GeoMath.sq(cbet1 + cbet2);
      w._dnm = sqrt(1 + ep2 * sbetm2);
      double omg12 = lam12 / (f1 * w._dnm);
      somg12 = sin(omg12);
      comg12 = cos(omg12);
    } else {
      somg12 = slam12;
      comg12 = clam12;
    }

    w._salp1 = cbet2 * somg12;
    w._calp1 = comg12 >= 0
        ? sbet12 + cbet2 * sbet1 * GeoMath.sq(somg12) / (1 + comg12)
        : sbet12a - cbet2 * sbet1 * GeoMath.sq(somg12) / (1 - comg12);

    double ssig12 = hypot(w._salp1, w._calp1), csig12 = sbet1 * sbet2 + cbet1 * cbet2 * comg12;

    if (shortline && ssig12 < _etol2) {
      // really short lines
      w._salp2 = cbet1 * somg12;
      w._calp2 = sbet12 - cbet1 * sbet2 * (comg12 >= 0 ? GeoMath.sq(somg12) / (1 + comg12) : 1 - comg12);
      GeoMath.norm(p, w._salp2, w._calp2);
      w._salp2 = p.first;
      w._calp2 = p.second;
      // Set return value
      w._sig12 = atan2(ssig12, csig12);
    } else if (_n.abs() > 0.1 || // Skip astroid calc if too eccentric
        csig12 >= 0 ||
        ssig12 >= 6 * _n.abs() * pi * GeoMath.sq(cbet1)) {
      // Nothing to do, zeroth order spherical approximation is OK
    } else {
      // Scale lam12 and bet2 to x, y coordinate system where antipodal point
      // is at origin and singular point is at y = 0, x = -1.
      double y, lamscale, betscale;
      // In C++ volatile declaration needed to fix inverse case
      // 56.320923501171 0 -56.320923501171 179.664747671772880215
      // which otherwise fails with g++ 4.4.4 x86 -O3
      double x;
      double lam12x = atan2(-slam12, -clam12); // lam12 - pi
      if (f >= 0) {
        // In fact f == 0 does not get here
        // x = dlong, y = dlat
        {
          double k2 = GeoMath.sq(sbet1) * ep2, eps = k2 / (2 * (1 + sqrt(1 + k2)) + k2);
          lamscale = f * cbet1 * A3f(eps) * pi;
        }
        betscale = lamscale * cbet1;

        x = lam12x / lamscale;
        y = sbet12a / betscale;
      } else {
        // _f < 0
        // x = dlat, y = dlong
        double cbet12a = cbet2 * cbet1 - sbet2 * sbet1, bet12a = atan2(sbet12a, cbet12a);
        double m12b, m0;
        // In the case of lon12 = 180, this repeats a calculation made in
        // Inverse.
        _Lengths(v, _n, pi + bet12a, sbet1, -cbet1, dn1, sbet2, cbet2, dn2, cbet1, cbet2, GeodesicMask.REDUCEDLENGTH,
            C1a, C2a);
        m12b = v._m12b;
        m0 = v._m0;

        x = -1 + m12b / (cbet1 * cbet2 * m0 * pi);
        betscale = x < -0.01 ? sbet12a / x : -f * GeoMath.sq(cbet1) * pi;
        lamscale = betscale / cbet1;
        y = lam12x / lamscale;
      }

      if (y > -_tol1_ && x > -1 - _xthresh_) {
        // strip near cut
        if (f >= 0) {
          w._salp1 = min(1.0, -x);
          w._calp1 = -sqrt(1 - GeoMath.sq(w._salp1));
        } else {
          w._calp1 = max(x > -_tol1_ ? 0.0 : -1.0, x);
          w._salp1 = sqrt(1 - GeoMath.sq(w._calp1));
        }
      } else {
        // Estimate alp1, by solving the astroid problem.
        //
        // Could estimate alpha1 = theta + pi/2, directly, i.e.,
        //   _calp1 = y/k; _salp1 = -x/(1+k);  for _f >= 0
        //   _calp1 = x/(1+k); _salp1 = -y/k;  for _f < 0 (need to check)
        //
        // However, it's better to estimate omg12 from astroid and use
        // spherical formula to compute alp1.  This reduces the mean number of
        // Newton iterations for astroid cases from 2.24 (min 0, max 6) to 2.12
        // (min 0 max 5).  The changes in the number of iterations are as
        // follows:
        //
        // change percent
        //    1       5
        //    0      78
        //   -1      16
        //   -2       0.6
        //   -3       0.04
        //   -4       0.002
        //
        // The histogram of iterations is (m = number of iterations estimating
        // alp1 directly, n = number of iterations estimating via omg12, total
        // number of trials = 148605):
        //
        //  iter    m      n
        //    0   148    186
        //    1 13046  13845
        //    2 93315 102225
        //    3 36189  32341
        //    4  5396      7
        //    5   455      1
        //    6    56      0
        //
        // Because omg12 is near pi, estimate work with omg12a = pi - omg12
        double k = _Astroid(x, y);
        double omg12a = lamscale * (f >= 0 ? -x * k / (1 + k) : -y * (1 + k) / k);
        somg12 = sin(omg12a);
        comg12 = -cos(omg12a);
        // Update spherical estimate of alp1 using omg12 instead of lam12
        w._salp1 = cbet2 * somg12;
        w._calp1 = sbet12a - cbet2 * sbet1 * GeoMath.sq(somg12) / (1 - comg12);
      }
    }
    // Sanity check on starting guess.  Backwards check allows NaN through.
    if (!(w._salp1 <= 0)) {
      GeoMath.norm(p, w._salp1, w._calp1);
      w._salp1 = p.first;
      w._calp1 = p.second;
    } else {
      w._salp1 = 1;
      w._calp1 = 0;
    }
    return w;
  }

  void _Lambda12(
      _Lambda12V w,
      double sbet1,
      double cbet1,
      double dn1,
      double sbet2,
      double cbet2,
      double dn2,
      double _salp1,
      double _calp1,
      double slam120,
      double clam120,
      bool diffp,
      // Scratch areas of the right size
      List<double> C1a,
      List<double> C2a,
      List<double> C3a,
      Pair p,
      _LengthsV v) {
    // Object to hold lam12, salp2, calp2, sig12, ssig1, csig1, ssig2, csig2,
    // eps, domg12, dlam12;

    if (sbet1 == 0 && _calp1 == 0)
      // Break degeneracy of equatorial line.  This case has already been
      // handled.
      _calp1 = -tiny_;

    double
        // sin(alp1) * cos(bet1) = sin(alp0)
        salp0 = _salp1 * cbet1,
        calp0 = hypot(_calp1, _salp1 * sbet1); // calp0 > 0

    double somg1, comg1, somg2, comg2, somg12, comg12;
    // tan(bet1) = tan(sig1) * cos(alp1)
    // tan(omg1) = sin(alp0) * tan(sig1) = tan(omg1)=tan(alp1)*sin(bet1)
    w.ssig1 = sbet1;
    somg1 = salp0 * sbet1;
    w.csig1 = comg1 = _calp1 * cbet1;
    GeoMath.norm(p, w.ssig1, w.csig1);
    w.ssig1 = p.first;
    w.csig1 = p.second;
    // GeoMath.norm(somg1, comg1); -- don't need to normalize!

    // Enforce symmetries in the case abs(bet2) = -bet1.  Need to be careful
    // about this case, since this can yield singularities in the Newton
    // iteration.
    // sin(alp2) * cos(bet2) = sin(alp0)
    w.salp2 = cbet2 != cbet1 ? salp0 / cbet2 : _salp1;
    // calp2 = sqrt(1 - sq(salp2))
    //       = sqrt(sq(calp0) - sq(sbet2)) / cbet2
    // and subst for calp0 and rearrange to give (choose positive sqrt
    // to give alp2 in [0, pi/2]).
    w.calp2 = cbet2 != cbet1 || sbet2.abs() != -sbet1
        ? sqrt(GeoMath.sq(_calp1 * cbet1) +
                (cbet1 < -sbet1 ? (cbet2 - cbet1) * (cbet1 + cbet2) : (sbet1 - sbet2) * (sbet1 + sbet2))) /
            cbet2
        : _calp1.abs();
    // tan(bet2) = tan(sig2) * cos(alp2)
    // tan(omg2) = sin(alp0) * tan(sig2).
    w.ssig2 = sbet2;
    somg2 = salp0 * sbet2;
    w.csig2 = comg2 = w.calp2 * cbet2;
    GeoMath.norm(p, w.ssig2, w.csig2);
    w.ssig2 = p.first;
    w.csig2 = p.second;
    // GeoMath.norm(somg2, comg2); -- don't need to normalize!

    // sig12 = sig2 - sig1, limit to [0, pi]
    w.sig12 = atan2(max(0.0, w.csig1 * w.ssig2 - w.ssig1 * w.csig2), w.csig1 * w.csig2 + w.ssig1 * w.ssig2);

    // omg12 = omg2 - omg1, limit to [0, pi]
    somg12 = max(0.0, comg1 * somg2 - somg1 * comg2);
    comg12 = comg1 * comg2 + somg1 * somg2;
    // eta = omg12 - lam120
    double eta = atan2(somg12 * clam120 - comg12 * slam120, comg12 * clam120 + somg12 * slam120);
    double B312;
    double k2 = GeoMath.sq(calp0) * ep2;
    w.eps = k2 / (2 * (1 + sqrt(1 + k2)) + k2);
    C3f(w.eps, C3a);
    B312 = (SinCosSeries(true, w.ssig2, w.csig2, C3a) - SinCosSeries(true, w.ssig1, w.csig1, C3a));
    w.domg12 = -f * A3f(w.eps) * salp0 * (w.sig12 + B312);
    w.lam12 = eta + w.domg12;

    if (diffp) {
      if (w.calp2 == 0)
        w.dlam12 = -2 * f1 * dn1 / sbet1;
      else {
        _Lengths(v, w.eps, w.sig12, w.ssig1, w.csig1, dn1, w.ssig2, w.csig2, dn2, cbet1, cbet2,
            GeodesicMask.REDUCEDLENGTH, C1a, C2a);
        w.dlam12 = v._m12b;
        w.dlam12 *= f1 / (w.calp2 * cbet2);
      }
    }
  }

  double A3f(double eps) {
    // Evaluate A3
    return GeoMath.polyval(nA3_ - 1, _A3x, 0, eps);
  }

  void C3f(double eps, List<double> c) {
    // Evaluate C3 coeffs
    // Elements c[1] thru c[nC3_ - 1] are set
    double mult = 1;
    int o = 0;
    for (int l = 1; l < nC3_; ++l) {
      // l is index of C3[l]
      int m = nC3_ - l - 1; // order of polynomial in eps
      mult *= eps;
      c[l] = mult * GeoMath.polyval(m, _C3x, o, eps);
      o += m + 1;
    }
  }

  void C4f(double eps, List<double> c) {
    // Evaluate C4 coeffs
    // Elements c[0] thru c[nC4_ - 1] are set
    double mult = 1;
    int o = 0;
    for (int l = 0; l < nC4_; ++l) {
      // l is index of C4[l]
      int m = nC4_ - l - 1; // order of polynomial in eps
      c[l] = mult * GeoMath.polyval(m, _C4x, o, eps);
      o += m + 1;
      mult *= eps;
    }
  }

  // The scale factor A1-1 = mean value of (d/dsigma)I1 - 1
  static double A1m1f(double eps) {
    final List<double> coeff = [
      // (1-eps)*A1-1, polynomial in eps2 of order 3
      1, 4, 64, 0, 256,
    ];
    int m = nA1_ ~/ 2;
    double t = GeoMath.polyval(m, coeff, 0, GeoMath.sq(eps)) / coeff[m + 1];
    return (t + eps) / (1 - eps);
  }

  // The coefficients C1[l] in the Fourier expansion of B1
  static void C1f(double eps, List<double> c) {
    final List<double> coeff = [
      // C1[1]/eps^1, polynomial in eps2 of order 2
      -1, 6, -16, 32,
      // C1[2]/eps^2, polynomial in eps2 of order 2
      -9, 64, -128, 2048,
      // C1[3]/eps^3, polynomial in eps2 of order 1
      9, -16, 768,
      // C1[4]/eps^4, polynomial in eps2 of order 1
      3, -5, 512,
      // C1[5]/eps^5, polynomial in eps2 of order 0
      -7, 1280,
      // C1[6]/eps^6, polynomial in eps2 of order 0
      -7, 2048,
    ];
    double eps2 = GeoMath.sq(eps), d = eps;
    int o = 0;
    for (int l = 1; l <= nC1_; ++l) {
      // l is index of C1p[l]
      int m = (nC1_ - l) ~/ 2; // order of polynomial in eps^2
      c[l] = d * GeoMath.polyval(m, coeff, o, eps2) / coeff[o + m + 1];
      o += m + 2;
      d *= eps;
    }
  }

  // The coefficients C1p[l] in the Fourier expansion of B1p
  static void C1pf(double eps, List<double> c) {
    final List<double> coeff = [
      // C1p[1]/eps^1, polynomial in eps2 of order 2
      205, -432, 768, 1536,
      // C1p[2]/eps^2, polynomial in eps2 of order 2
      4005, -4736, 3840, 12288,
      // C1p[3]/eps^3, polynomial in eps2 of order 1
      -225, 116, 384,
      // C1p[4]/eps^4, polynomial in eps2 of order 1
      -7173, 2695, 7680,
      // C1p[5]/eps^5, polynomial in eps2 of order 0
      3467, 7680,
      // C1p[6]/eps^6, polynomial in eps2 of order 0
      38081, 61440,
    ];
    double eps2 = GeoMath.sq(eps), d = eps;
    int o = 0;
    for (int l = 1; l <= nC1p_; ++l) {
      // l is index of C1p[l]
      int m = (nC1p_ - l) ~/ 2; // order of polynomial in eps^2
      c[l] = d * GeoMath.polyval(m, coeff, o, eps2) / coeff[o + m + 1];
      o += m + 2;
      d *= eps;
    }
  }

  // The scale factor A2-1 = mean value of (d/dsigma)I2 - 1
  static double A2m1f(double eps) {
    final List<double> coeff = [
      // (eps+1)*A2-1, polynomial in eps2 of order 3
      -11, -28, -192, 0, 256,
    ];
    int m = nA2_ ~/ 2;
    double t = GeoMath.polyval(m, coeff, 0, GeoMath.sq(eps)) / coeff[m + 1];
    return (t - eps) / (1 + eps);
  }

  // The coefficients C2[l] in the Fourier expansion of B2
  static void C2f(double eps, List<double> c) {
    final List<double> coeff = [
      // C2[1]/eps^1, polynomial in eps2 of order 2
      1, 2, 16, 32,
      // C2[2]/eps^2, polynomial in eps2 of order 2
      35, 64, 384, 2048,
      // C2[3]/eps^3, polynomial in eps2 of order 1
      15, 80, 768,
      // C2[4]/eps^4, polynomial in eps2 of order 1
      7, 35, 512,
      // C2[5]/eps^5, polynomial in eps2 of order 0
      63, 1280,
      // C2[6]/eps^6, polynomial in eps2 of order 0
      77, 2048,
    ];
    double eps2 = GeoMath.sq(eps), d = eps;
    int o = 0;
    for (int l = 1; l <= nC2_; ++l) {
      // l is index of C2[l]
      int m = (nC2_ - l) ~/ 2; // order of polynomial in eps^2
      c[l] = d * GeoMath.polyval(m, coeff, o, eps2) / coeff[o + m + 1];
      o += m + 2;
      d *= eps;
    }
  }

  // The scale factor A3 = mean value of (d/dsigma)I3
  void A3coeff() {
    final List<double> coeff = [
      // A3, coeff of eps^5, polynomial in n of order 0
      -3, 128,
      // A3, coeff of eps^4, polynomial in n of order 1
      -2, -3, 64,
      // A3, coeff of eps^3, polynomial in n of order 2
      -1, -3, -1, 16,
      // A3, coeff of eps^2, polynomial in n of order 2
      3, -1, -2, 8,
      // A3, coeff of eps^1, polynomial in n of order 1
      1, -1, 2,
      // A3, coeff of eps^0, polynomial in n of order 0
      1, 1,
    ];
    int o = 0, k = 0;
    for (int j = nA3_ - 1; j >= 0; --j) {
      // coeff of eps^j
      int m = min(nA3_ - j - 1, j); // order of polynomial in n
      _A3x[k++] = GeoMath.polyval(m, coeff, o, _n) / coeff[o + m + 1];
      o += m + 2;
    }
  }

  // The coefficients C3[l] in the Fourier expansion of B3
  void C3coeff() {
    final List<double> coeff = [
      // C3[1], coeff of eps^5, polynomial in n of order 0
      3, 128,
      // C3[1], coeff of eps^4, polynomial in n of order 1
      2, 5, 128,
      // C3[1], coeff of eps^3, polynomial in n of order 2
      -1, 3, 3, 64,
      // C3[1], coeff of eps^2, polynomial in n of order 2
      -1, 0, 1, 8,
      // C3[1], coeff of eps^1, polynomial in n of order 1
      -1, 1, 4,
      // C3[2], coeff of eps^5, polynomial in n of order 0
      5, 256,
      // C3[2], coeff of eps^4, polynomial in n of order 1
      1, 3, 128,
      // C3[2], coeff of eps^3, polynomial in n of order 2
      -3, -2, 3, 64,
      // C3[2], coeff of eps^2, polynomial in n of order 2
      1, -3, 2, 32,
      // C3[3], coeff of eps^5, polynomial in n of order 0
      7, 512,
      // C3[3], coeff of eps^4, polynomial in n of order 1
      -10, 9, 384,
      // C3[3], coeff of eps^3, polynomial in n of order 2
      5, -9, 5, 192,
      // C3[4], coeff of eps^5, polynomial in n of order 0
      7, 512,
      // C3[4], coeff of eps^4, polynomial in n of order 1
      -14, 7, 512,
      // C3[5], coeff of eps^5, polynomial in n of order 0
      21, 2560,
    ];
    int o = 0, k = 0;
    for (int l = 1; l < nC3_; ++l) {
      // l is index of C3[l]
      for (int j = nC3_ - 1; j >= l; --j) {
        // coeff of eps^j
        int m = min(nC3_ - j - 1, j); // order of polynomial in n
        _C3x[k++] = GeoMath.polyval(m, coeff, o, _n) / coeff[o + m + 1];
        o += m + 2;
      }
    }
  }

  void C4coeff() {
    final List<double> coeff = [
      // C4[0], coeff of eps^5, polynomial in n of order 0
      97, 15015,
      // C4[0], coeff of eps^4, polynomial in n of order 1
      1088, 156, 45045,
      // C4[0], coeff of eps^3, polynomial in n of order 2
      -224, -4784, 1573, 45045,
      // C4[0], coeff of eps^2, polynomial in n of order 3
      -10656, 14144, -4576, -858, 45045,
      // C4[0], coeff of eps^1, polynomial in n of order 4
      64, 624, -4576, 6864, -3003, 15015,
      // C4[0], coeff of eps^0, polynomial in n of order 5
      100, 208, 572, 3432, -12012, 30030, 45045,
      // C4[1], coeff of eps^5, polynomial in n of order 0
      1, 9009,
      // C4[1], coeff of eps^4, polynomial in n of order 1
      -2944, 468, 135135,
      // C4[1], coeff of eps^3, polynomial in n of order 2
      5792, 1040, -1287, 135135,
      // C4[1], coeff of eps^2, polynomial in n of order 3
      5952, -11648, 9152, -2574, 135135,
      // C4[1], coeff of eps^1, polynomial in n of order 4
      -64, -624, 4576, -6864, 3003, 135135,
      // C4[2], coeff of eps^5, polynomial in n of order 0
      8, 10725,
      // C4[2], coeff of eps^4, polynomial in n of order 1
      1856, -936, 225225,
      // C4[2], coeff of eps^3, polynomial in n of order 2
      -8448, 4992, -1144, 225225,
      // C4[2], coeff of eps^2, polynomial in n of order 3
      -1440, 4160, -4576, 1716, 225225,
      // C4[3], coeff of eps^5, polynomial in n of order 0
      -136, 63063,
      // C4[3], coeff of eps^4, polynomial in n of order 1
      1024, -208, 105105,
      // C4[3], coeff of eps^3, polynomial in n of order 2
      3584, -3328, 1144, 315315,
      // C4[4], coeff of eps^5, polynomial in n of order 0
      -128, 135135,
      // C4[4], coeff of eps^4, polynomial in n of order 1
      -2560, 832, 405405,
      // C4[5], coeff of eps^5, polynomial in n of order 0
      128, 99099,
    ];
    int o = 0, k = 0;
    for (int l = 0; l < nC4_; ++l) {
      // l is index of C4[l]
      for (int j = nC4_ - 1; j >= l; --j) {
        // coeff of eps^j
        int m = nC4_ - j - 1; // order of polynomial in n
        _C4x[k++] = GeoMath.polyval(m, coeff, o, _n) / coeff[o + m + 1];
        o += m + 2;
      }
    }
  }
}

class _InverseData {
  GeodesicData _g;
  double _salp1, _calp1, _salp2, _calp2;

  _InverseData() {
    _g = GeodesicData();
  }
}

class _LengthsV {
  double _s12b, _m12b, _m0, _M12, _M21;
}

class _Lambda12V {
  double lam12, salp2, calp2, sig12, ssig1, csig1, ssig2, csig2, eps, domg12, dlam12;
}

class _InverseStartV {
  double _sig12,
      _salp1,
      _calp1,
      // Only updated if return val >= 0
      _salp2,
      _calp2,
      // Only updated for short lines
      _dnm;
}
