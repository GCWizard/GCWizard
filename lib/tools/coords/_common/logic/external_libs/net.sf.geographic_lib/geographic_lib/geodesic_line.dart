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
part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';

/*
 * A geodesic line.
 * <p>
 * GeodesicLine facilitates the determination of a series of points on a single
 * geodesic.  The starting point (<i>lat1</i>, <i>lon1</i>) and the azimuth
 * <i>azi1</i> are specified in the constructor; alternatively, the {@link
 * Geodesic#Line Geodesic.Line} method can be used to create a GeodesicLine.
 * {@link #Position Position} returns the location of point 2 a distance
 * <i>s12</i> along the geodesic.  Alternatively {@link #ArcPosition
 * ArcPosition} gives the position of point 2 an arc length <i>a12</i> along
 * the geodesic.
 * <p>
 * You can register the position of a reference point 3 a distance (arc
 * length), <i>s13</i> (<i>a13</i>) along the geodesic with the
 * {@link #SetDistance SetDistance} ({@link #SetArc SetArc}) functions.  Points
 * a fractional distance along the line can be found by providing, for example,
 * 0.5 * {@link #Distance} as an argument to {@link #Position Position}.  The
 * {@link Geodesic#InverseLine Geodesic.InverseLine} or
 * {@link Geodesic#DirectLine Geodesic.DirectLine} methods return GeodesicLine
 * objects with point 3 set to the point 2 of the corresponding geodesic
 * problem.  GeodesicLine objects created with the constructor or with
 * {@link Geodesic#Line Geodesic.Line} have <i>s13</i> and <i>a13</i> set to
 * NaNs.
 * <p>
 * The calculations are accurate to better than 15 nm (15 nanometers).  See
 * Sec. 9 of
 * <a href="https://arxiv.org/abs/1102.1215v1">arXiv:1102.1215v1</a> for
 * details.  The algorithms used by this class are based on series expansions
 * using the flattening <i>f</i> as a small parameter.  These are only accurate
 * for |<i>f</i>| &lt; 0.02; however reasonably accurate results will be
 * obtained for |<i>f</i>| &lt; 0.2.
 * <p>
 * The algorithms are described in
 * <ul>
 * <li>
 *   C. F. F. Karney,
 *   <a href="https://doi.org/10.1007/s00190-012-0578-z">
 *   Algorithms for geodesics</a>,
 *   J. Geodesy <b>87</b>, 43&ndash;55 (2013)
 *   (<a href="https://geographiclib.sourceforge.io/geod-addenda.html">addenda</a>).
 * </ul>
 * <p>
 * Here's an example of using this class
 * <pre>
 * {@code
 * import net.sf.geographiclib.*;
 * class GeodesicLineTest {
 *   static void main(String[] args) {
 *     // Print waypoints between JFK and SIN
 *     Geodesic geod = Geodesic.WGS84;
 *     double
 *       lat1 = 40.640, lon1 = -73.779, // JFK
 *       lat2 =  1.359, lon2 = 103.989; // SIN
 *     GeodesicLine line = geod.InverseLine(lat1, lon1, lat2, lon2,
 *                                          GeodesicMask.DISTANCE_IN |
 *                                          GeodesicMask.LATITUDE |
 *                                          GeodesicMask.LONGITUDE);
 *     double ds0 = 500e3;     // Nominal distance between points = 500 km
 *     // The number of intervals
 *     int num = (int)(Math.ceil(line.Distance() / ds0));
 *     {
 *       // Use intervals of equal length
 *       double ds = line.Distance() / num;
 *       for (int i = 0; i <= num; ++i) {
 *         GeodesicData g = line.Position(i * ds,
 *                                        GeodesicMask.LATITUDE |
 *                                        GeodesicMask.LONGITUDE);
 *         System.out.println(i + " " + g.lat2 + " " + g.lon2);
 *       }
 *     }
 *     {
 *       // Slightly faster, use intervals of equal arc length
 *       double da = line.Arc() / num;
 *       for (int i = 0; i <= num; ++i) {
 *         GeodesicData g = line.ArcPosition(i * da,
 *                                           GeodesicMask.LATITUDE |
 *                                           GeodesicMask.LONGITUDE);
 *         System.out.println(i + " " + g.lat2 + " " + g.lon2);
 *       }
 *     }
 *   }
 * }}</pre>
 **********************************************************************/
class _GeodesicLine {
  static final int _nC1_ = Geodesic.nC1_;
  static final int _nC1p_ = Geodesic.nC1p_;
  static final int _nC2_ = Geodesic.nC2_;
  static final int _nC3_ = Geodesic.nC3_;
  static final int _nC4_ = Geodesic.nC4_;

  double _lat1, _lon1, _azi1;
  double _a,
      _f,
      _b,
      _c2,
      _f1,
      _salp0,
      _calp0,
      _k2,
      _salp1,
      _calp1,
      _ssig1,
      _csig1,
      _dn1,
      _stau1,
      _ctau1,
      _somg1,
      _comg1,
      _A1m1,
      _A2m1,
      _A3c,
      _B11,
      _B21,
      _B31,
      _A4,
      _B41;
  double _a13, _s13;
  // index zero elements of _C1a, _C1pa, _C2a, _C3a are unused
  List<double> _C1a, _C1pa, _C2a, _C3a, _C4a; // all the elements of _C4a are used
  int _caps;
  /*
   * Constructor for a geodesic line staring at latitude <i>lat1</i>, longitude
   * <i>lon1</i>, and azimuth <i>azi1</i> (all in degrees) with a subset of the
   * capabilities included.
   * <p>
   * @param g A {@link Geodesic} object used to compute the necessary
   *   information about the GeodesicLine.
   * @param lat1 latitude of point 1 (degrees).
   * @param lon1 longitude of point 1 (degrees).
   * @param azi1 azimuth at point 1 (degrees).
   * @param caps bitor'ed combination of {@link GeodesicMask} values
   *   specifying the capabilities the GeodesicLine object should possess,
   *   i.e., which quantities can be returned in calls to {@link #Position
   *   Position}.
   * <p>
   * The {@link GeodesicMask} values are
   * <ul>
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#LATITUDE} for the latitude
   *   <i>lat2</i>; this is added automatically;
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#LONGITUDE} for the latitude
   *   <i>lon2</i>;
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#AZIMUTH} for the latitude
   *   <i>azi2</i>; this is added automatically;
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#DISTANCE} for the distance
   *   <i>s12</i>;
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#REDUCEDLENGTH} for the reduced length
   *   <i>m12</i>;
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#GEODESICSCALE} for the geodesic
   *   scales <i>M12</i> and <i>M21</i>;
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#AREA} for the area <i>S12</i>;
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#DISTANCE_IN} permits the length of
   *   the geodesic to be given in terms of <i>s12</i>; without this capability
   *   the length can only be specified in terms of arc length;
   * <li>
   *   <i>caps</i> |= {@link GeodesicMask#ALL} for all of the above.
   * </ul>
   **********************************************************************/
  _GeodesicLine(Geodesic g, double lat1, double lon1, double azi1, int caps) {
    azi1 = _GeoMath.AngNormalize(azi1);
    double salp1, calp1;
    _Pair p = new _Pair();
    // Guard against underflow in salp0
    _GeoMath.sincosd(p, _GeoMath.AngRound(azi1));
    salp1 = p.first;
    calp1 = p.second;
    _LineInit(g, lat1, lon1, azi1, salp1, calp1, caps, p);
  }

  void _LineInit(Geodesic g, double lat1, double lon1, double azi1, double salp1, double calp1, int caps, _Pair p) {
    _a = g.a;
    _f = g.f;
    _b = g.b;
    _c2 = g.c2;
    _f1 = g.f1;
    // Always allow latitude and azimuth and unrolling the longitude
    _caps = caps | _GeodesicMask.LATITUDE | _GeodesicMask.AZIMUTH | _GeodesicMask.LONG_UNROLL;

    _lat1 = _GeoMath.LatFix(lat1);
    _lon1 = lon1;
    _azi1 = azi1;
    _salp1 = salp1;
    _calp1 = calp1;
    double cbet1, sbet1;
    _GeoMath.sincosd(p, _GeoMath.AngRound(_lat1));
    sbet1 = _f1 * p.first;
    cbet1 = p.second;
    // Ensure cbet1 = +epsilon at poles
    _GeoMath.norm(p, sbet1, cbet1);
    sbet1 = p.first;
    cbet1 = max(Geodesic.tiny_, p.second);
    _dn1 = sqrt(1 + g.ep2 * _GeoMath.sq(sbet1));

    // Evaluate alp0 from sin(alp1) * cos(bet1) = sin(alp0),
    _salp0 = _salp1 * cbet1; // alp0 in [0, pi/2 - |bet1|]
    // Alt: calp0 = Math.hypot(sbet1, calp1 * cbet1).  The following
    // is slightly better (consider the case salp1 = 0).
    _calp0 = _hypot(_calp1, _salp1 * sbet1);
    // Evaluate sig with tan(bet1) = tan(sig1) * cos(alp1).
    // sig = 0 is nearest northward crossing of equator.
    // With bet1 = 0, alp1 = pi/2, we have sig1 = 0 (equatorial line).
    // With bet1 =  pi/2, alp1 = -pi, sig1 =  pi/2
    // With bet1 = -pi/2, alp1 =  0 , sig1 = -pi/2
    // Evaluate omg1 with tan(omg1) = sin(alp0) * tan(sig1).
    // With alp0 in (0, pi/2], quadrants for sig and omg coincide.
    // No atan2(0,0) ambiguity at poles since cbet1 = +epsilon.
    // With alp0 = 0, omg1 = 0 for alp1 = 0, omg1 = pi for alp1 = pi.
    _ssig1 = sbet1;
    _somg1 = _salp0 * sbet1;
    _csig1 = _comg1 = sbet1 != 0 || _calp1 != 0 ? cbet1 * _calp1 : 1;
    _GeoMath.norm(p, _ssig1, _csig1);
    _ssig1 = p.first;
    _csig1 = p.second; // sig1 in (-pi, pi]
    // GeoMath.norm(_somg1, _comg1); -- don't need to normalize!

    _k2 = _GeoMath.sq(_calp0) * g.ep2;
    double eps = _k2 / (2 * (1 + sqrt(1 + _k2)) + _k2);

    if ((_caps & _GeodesicMask.CAP_C1) != 0) {
      _A1m1 = Geodesic.A1m1f(eps);
      _C1a = List<double>.generate(_nC1_ + 1, (index) => 0.0);
      Geodesic.C1f(eps, _C1a);
      _B11 = Geodesic.SinCosSeries(true, _ssig1, _csig1, _C1a);
      double s = sin(_B11), c = cos(_B11);
      // tau1 = sig1 + B11
      _stau1 = _ssig1 * c + _csig1 * s;
      _ctau1 = _csig1 * c - _ssig1 * s;
      // Not necessary because C1pa reverts C1a
      //    _B11 = -SinCosSeries(true, _stau1, _ctau1, _C1pa, nC1p_);
    }

    if ((_caps & _GeodesicMask.CAP_C1p) != 0) {
      _C1pa = List<double>.generate(_nC1p_ + 1, (index) => 0.0);
      Geodesic.C1pf(eps, _C1pa);
    }

    if ((_caps & _GeodesicMask.CAP_C2) != 0) {
      _C2a = List<double>.generate(_nC2_ + 1, (index) => 0.0);
      _A2m1 = Geodesic.A2m1f(eps);
      Geodesic.C2f(eps, _C2a);
      _B21 = Geodesic.SinCosSeries(true, _ssig1, _csig1, _C2a);
    }

    if ((_caps & _GeodesicMask.CAP_C3) != 0) {
      _C3a = List<double>.generate(_nC3_, (index) => 0.0);
      g.C3f(eps, _C3a);
      _A3c = -_f * _salp0 * g.A3f(eps);
      _B31 = Geodesic.SinCosSeries(true, _ssig1, _csig1, _C3a);
    }

    if ((_caps & _GeodesicMask.CAP_C4) != 0) {
      _C4a = List<double>.generate(_nC4_, (index) => 0.0);
      g.C4f(eps, _C4a);
      // Multiplier = a^2 * e^2 * cos(alpha0) * sin(alpha0)
      _A4 = _GeoMath.sq(_a) * _calp0 * _salp0 * g.e2;
      _B41 = Geodesic.SinCosSeries(false, _ssig1, _csig1, _C4a);
    }
  }

  /*
   * The general position function.  {@link #Position(double, int) Position}
   * and {@link #ArcPosition(double, int) ArcPosition} are defined in terms of
   * this function.
   * <p>
   * @param arcmode bool flag determining the meaning of the second
   *   parameter; if arcmode is false, then the GeodesicLine object must have
   *   been constructed with <i>caps</i> |= {@link GeodesicMask#DISTANCE_IN}.
   * @param s12_a12 if <i>arcmode</i> is false, this is the distance between
   *   point 1 and point 2 (meters); otherwise it is the arc length between
   *   point 1 and point 2 (degrees); it can be negative.
   * @param outmask a bitor'ed combination of {@link GeodesicMask} values
   *   specifying which results should be returned.
   * @return a {@link GeodesicData} object with the requested results.
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
   *   <i>outmask</i> |= {@link GeodesicMask#ALL} for all of the above;
   * <li>
   *   <i>outmask</i> |= {@link GeodesicMask#LONG_UNROLL} to unroll <i>lon2</i>
   *   (instead of reducing it to the range [&minus;180&deg;, 180&deg;]).
   * </ul>
   * <p>
   * Requesting a value which the GeodesicLine object is not capable of
   * computing is not an error; Double.NaN is returned instead.
   **********************************************************************/
  GeodesicData Position(bool arcmode, double s12_a12, int outmask) {
    outmask &= _caps & _GeodesicMask.OUT_MASK;
    GeodesicData r = GeodesicData();
    if (!(_Init() && (arcmode || (_caps & (_GeodesicMask.OUT_MASK & _GeodesicMask.DISTANCE_IN)) != 0)))
      // Uninitialized or impossible distance calculation requested
      return r;
    r.lat1 = _lat1;
    r.azi1 = _azi1;
    r.lon1 = ((outmask & _GeodesicMask.LONG_UNROLL) != 0) ? _lon1 : _GeoMath.AngNormalize(_lon1);

    // Avoid warning about uninitialized B12.
    double sig12, ssig12, csig12, B12 = 0, AB1 = 0;
    if (arcmode) {
      // Interpret s12_a12 as spherical arc length
      r.a12 = s12_a12;
      sig12 = _toRadians(s12_a12);
      _Pair p = _Pair();
      _GeoMath.sincosd(p, s12_a12);
      ssig12 = p.first;
      csig12 = p.second;
    } else {
      // Interpret s12_a12 as distance
      r.s12 = s12_a12;
      double tau12 = s12_a12 / (_b * (1 + _A1m1)), s = sin(tau12), c = cos(tau12);
      // tau2 = tau1 + tau12
      B12 = -Geodesic.SinCosSeries(true, _stau1 * c + _ctau1 * s, _ctau1 * c - _stau1 * s, _C1pa);
      sig12 = tau12 - (B12 - _B11);
      ssig12 = sin(sig12);
      csig12 = cos(sig12);
      if (_f.abs() > 0.01) {
        // Reverted distance series is inaccurate for |f| > 1/100, so correct
        // sig12 with 1 Newton iteration.  The following table shows the
        // approximate maximum error for a = WGS_a() and various f relative to
        // GeodesicExact.
        //     erri = the error in the inverse solution (nm)
        //     errd = the error in the direct solution (series only) (nm)
        //     errda = the error in the direct solution
        //             (series + 1 Newton) (nm)
        //
        //       f     erri  errd errda
        //     -1/5    12e6 1.2e9  69e6
        //     -1/10  123e3  12e6 765e3
        //     -1/20   1110 108e3  7155
        //     -1/50  18.63 200.9 27.12
        //     -1/100 18.63 23.78 23.37
        //     -1/150 18.63 21.05 20.26
        //      1/150 22.35 24.73 25.83
        //      1/100 22.35 25.03 25.31
        //      1/50  29.80 231.9 30.44
        //      1/20   5376 146e3  10e3
        //      1/10  829e3  22e6 1.5e6
        //      1/5   157e6 3.8e9 280e6
        double ssig2 = _ssig1 * csig12 + _csig1 * ssig12, csig2 = _csig1 * csig12 - _ssig1 * ssig12;
        B12 = Geodesic.SinCosSeries(true, ssig2, csig2, _C1a);
        double serr = (1 + _A1m1) * (sig12 + (B12 - _B11)) - s12_a12 / _b;
        sig12 = sig12 - serr / sqrt(1 + _k2 * _GeoMath.sq(ssig2));
        ssig12 = sin(sig12);
        csig12 = cos(sig12);
        // Update B12 below
      }
      r.a12 = _toDegrees(sig12);
    }

    double ssig2, csig2, sbet2, cbet2, salp2, calp2;
    // sig2 = sig1 + sig12
    ssig2 = _ssig1 * csig12 + _csig1 * ssig12;
    csig2 = _csig1 * csig12 - _ssig1 * ssig12;
    double dn2 = sqrt(1 + _k2 * _GeoMath.sq(ssig2));
    if ((outmask & (_GeodesicMask.DISTANCE | _GeodesicMask.REDUCEDLENGTH | _GeodesicMask.GEODESICSCALE)) != 0) {
      if (arcmode || _f.abs() > 0.01) B12 = Geodesic.SinCosSeries(true, ssig2, csig2, _C1a);
      AB1 = (1 + _A1m1) * (B12 - _B11);
    }
    // sin(bet2) = cos(alp0) * sin(sig2)
    sbet2 = _calp0 * ssig2;
    // Alt: cbet2 = Math.hypot(csig2, salp0 * ssig2);
    cbet2 = _hypot(_salp0, _calp0 * csig2);
    if (cbet2 == 0)
      // I.e., salp0 = 0, csig2 = 0.  Break the degeneracy in this case
      cbet2 = csig2 = Geodesic.tiny_;
    // tan(alp0) = cos(sig2)*tan(alp2)
    salp2 = _salp0;
    calp2 = _calp0 * csig2; // No need to normalize

    if ((outmask & _GeodesicMask.DISTANCE) != 0 && arcmode) r.s12 = _b * ((1 + _A1m1) * sig12 + AB1);

    if ((outmask & _GeodesicMask.LONGITUDE) != 0) {
      // tan(omg2) = sin(alp0) * tan(sig2)
      double somg2 = _salp0 * ssig2,
          comg2 = csig2, // No need to normalize
          E = _copySign(1, _salp0); // east or west going?
      // omg12 = omg2 - omg1
      double omg12 = ((outmask & _GeodesicMask.LONG_UNROLL) != 0)
          ? E *
              (sig12 -
                  (atan2(ssig2, csig2) - atan2(_ssig1, _csig1)) +
                  (atan2(E * somg2, comg2) - atan2(E * _somg1, _comg1)))
          : atan2(somg2 * _comg1 - comg2 * _somg1, comg2 * _comg1 + somg2 * _somg1);
      double lam12 = omg12 + _A3c * (sig12 + (Geodesic.SinCosSeries(true, ssig2, csig2, _C3a) - _B31));
      double lon12 = _toDegrees(lam12);
      r.lon2 = ((outmask & _GeodesicMask.LONG_UNROLL) != 0)
          ? _lon1 + lon12
          : _GeoMath.AngNormalize(r.lon1 + _GeoMath.AngNormalize(lon12));
    }

    if ((outmask & _GeodesicMask.LATITUDE) != 0) r.lat2 = _GeoMath.atan2d(sbet2, _f1 * cbet2);

    if ((outmask & _GeodesicMask.AZIMUTH) != 0) r.azi2 = _GeoMath.atan2d(salp2, calp2);

    if ((outmask & (_GeodesicMask.REDUCEDLENGTH | _GeodesicMask.GEODESICSCALE)) != 0) {
      double B22 = Geodesic.SinCosSeries(true, ssig2, csig2, _C2a),
          AB2 = (1 + _A2m1) * (B22 - _B21),
          J12 = (_A1m1 - _A2m1) * sig12 + (AB1 - AB2);
      if ((outmask & _GeodesicMask.REDUCEDLENGTH) != 0)
        // Add parens around (_csig1 * ssig2) and (_ssig1 * csig2) to ensure
        // accurate cancellation in the case of coincident points.
        r.m12 = _b * ((dn2 * (_csig1 * ssig2) - _dn1 * (_ssig1 * csig2)) - _csig1 * csig2 * J12);
      if ((outmask & _GeodesicMask.GEODESICSCALE) != 0) {
        double t = _k2 * (ssig2 - _ssig1) * (ssig2 + _ssig1) / (_dn1 + dn2);
        r.M12 = csig12 + (t * ssig2 - csig2 * J12) * _ssig1 / _dn1;
        r.M21 = csig12 - (t * _ssig1 - _csig1 * J12) * ssig2 / dn2;
      }
    }

    if ((outmask & _GeodesicMask.AREA) != 0) {
      double B42 = Geodesic.SinCosSeries(false, ssig2, csig2, _C4a);
      double salp12, calp12;
      if (_calp0 == 0 || _salp0 == 0) {
        // alp12 = alp2 - alp1, used in atan2 so no need to normalize
        salp12 = salp2 * _calp1 - calp2 * _salp1;
        calp12 = calp2 * _calp1 + salp2 * _salp1;
      } else {
        // tan(alp) = tan(alp0) * sec(sig)
        // tan(alp2-alp1) = (tan(alp2) -tan(alp1)) / (tan(alp2)*tan(alp1)+1)
        // = calp0 * salp0 * (csig1-csig2) / (salp0^2 + calp0^2 * csig1*csig2)
        // If csig12 > 0, write
        //   csig1 - csig2 = ssig12 * (csig1 * ssig12 / (1 + csig12) + ssig1)
        // else
        //   csig1 - csig2 = csig1 * (1 - csig12) + ssig12 * ssig1
        // No need to normalize
        salp12 = _calp0 *
            _salp0 *
            (csig12 <= 0
                ? _csig1 * (1 - csig12) + ssig12 * _ssig1
                : ssig12 * (_csig1 * ssig12 / (1 + csig12) + _ssig1));
        calp12 = _GeoMath.sq(_salp0) + _GeoMath.sq(_calp0) * _csig1 * csig2;
      }
      r.S12 = _c2 * atan2(salp12, calp12) + _A4 * (B42 - _B41);
    }

    return r;
  }

  /*
   * @return true if the object has been initialized.
   **********************************************************************/
  bool _Init() {
    return _caps != 0;
  }
}
