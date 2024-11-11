/***********************************************************************
    Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================

 * Copyright (c) Charles Karney (2014-2022) <charles@karney.com> and licensed
 * under the MIT/X11 License.  For more information, see
 * https://geographiclib.sourceforge.io/
 * https://sourceforge.net/projects/geographiclib/

 **********************************************************************/

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';

class _Rhumb {
  late _Ellipsoid _ell;
  bool _exact = true;
  // late double _c2;
  static const int _tm_maxord = _GEOGRAPHICLIB_TRANSVERSEMERCATOR_ORDER;
  late _DAuxLatitude _aux;
  late double _rm;

  /**
   * Constructor for an ellipsoid with
   *
   * @param[in] a equatorial radius (meters).
   * @param[in] f flattening of ellipsoid.  Setting \e f = 0 gives a sphere.
   *   Negative \e f gives a prolate ellipsoid.
   * @param[in] exact if true (the default) use an addition theorem for
   *   elliptic integrals to compute divided differences; otherwise use
   *   series expansion (accurate for |<i>f</i>| < 0.01).
   * @exception GeographicErr if \e a or (1 &minus; \e f) \e a is not
   *   positive.
   *
   * See \ref rhumb, for a detailed description of the \e exact parameter.
   **********************************************************************/

  _Rhumb(double a, double f, bool exact) {
    _aux = _DAuxLatitude(a, f);
    _ell = _Ellipsoid(a, f);
    _exact = exact;
    _rm = _aux.RectifyingRadius(_exact);
  }

  static double _gd(double x) {
    return atan(_sinh(x));
  }

  // N.B., x and y are in degrees
  static double _Dtan(double x, double y) {
    double d = x - y, tx = _GeoMath.tand(x), ty = _GeoMath.tand(y), txy = tx * ty;
    return d != 0 ? (2 * txy > -1 ? (1 + txy) * _GeoMath.tand(d) : tx - ty) / (d * _GeoMath.degree()) : 1 + txy;
  }

  static double _Datan(double x, double y) {
    double d = x - y, xy = x * y;
    return d != 0 ? (2 * xy > -1 ? atan(d / (1 + xy)) : atan(x) - atan(y)) / d : 1 / (1 + xy);
  }

  static double _Dsin(double x, double y) {
    double d = (x - y) / 2;
    return cos((x + y) / 2) * (d != 0 ? sin(d) / d : 1);
  }

  static double _Dsinh(double x, double y) {
    double d = (x - y) / 2;
    return _cosh((x + y) / 2) * (d != 0 ? _sinh(d) / d : 1);
  }

  static double _Dasinh(double x, double y) {
    double d = x - y, hx = _GeoMath.hypot(1.0, x), hy = _GeoMath.hypot(1.0, y);
    return d != 0 ? _GeoMath.asinh(x * y > 0 ? d * (x + y) / (x * hy + y * hx) : x * hy - y * hx) / d : 1 / hx;
  }

  static double Dgd(double x, double y) {
    return _Datan(_sinh(x), _sinh(y)) * _Dsinh(x, y);
  }

  // N.B., x and y are the tangents of the angles
  static double _Dgdinv(double x, double y) {
    return _Dasinh(x, y) / _Datan(x, y);
  }

  // Copied from LambertConformalConic...
  // Deatanhe(x,y) = eatanhe((x-y)/(1-e^2*x*y))/(x-y)
  double _Deatanhe(double x, double y) {
    double t = x - y, d = 1 - _ell.e2 * x * y;
    return t != 0 ? _GeoMath.eatanhe(t / d, _ell.es) / t : _ell.e2 / d;
  }

  // // (E(x) - E(y)) / (x - y) -- E = incomplete elliptic integral of 2nd kind
  // double DE(double x, double y) const;
  // // (mux - muy) / (phix - phiy) using elliptic integrals
  // double DRectifying(double latx, double laty) const;
  // // (psix - psiy) / (phix - phiy)
  // double DIsometric(double latx, double laty) const;
  //
  // // (sum(c[j]*sin(2*j*x),j=1..n) - sum(c[j]*sin(2*j*x),j=1..n)) / (x - y)
  // static double SinCosSeries(bool sinp,
  // double x, double y, const double c[], int n);
  // // (mux - muy) / (chix - chiy) using Krueger's series
  // double DConformalToRectifying(double chix, double chiy) const;
  // // (chix - chiy) / (mux - muy) using Krueger's series
  // double DRectifyingToConformal(double mux, double muy) const;
  //
  // // (mux - muy) / (psix - psiy)
  // // N.B., psix and psiy are in degrees
  // double DIsometricToRectifying(double psix, double psiy) const;
  // // (psix - psiy) / (mux - muy)
  // double DRectifyingToIsometric(double mux, double muy) const;
  //
  // double MeanSinXi(double psi1, double psi2) const;
  //
  // // The following two functions (with lots of ignored arguments) mimic the
  // // interface to the corresponding Geodesic function.  These are needed by
  // // PolygonAreaT.
  // void GenDirect(double lat1, double lon1, double azi12,
  // bool, double s12, unsigned outmask,
  // double& lat2, double& lon2, double&, double&, double&, double&, double&,
  // double& S12) const {
  // GenDirect(lat1, lon1, azi12, s12, outmask, lat2, lon2, S12);
  // }
  // void GenInverse(double lat1, double lon1, double lat2, double lon2,
  // unsigned outmask, double& s12, double& azi12,
  // double&, double& , double& , double& , double& S12) const {
  // GenInverse(lat1, lon1, lat2, lon2, outmask, s12, azi12, S12);

  /**
   * Bit masks for what calculations to do.  They specify which results to
   * return in the general routines Rhumb::GenDirect and Rhumb::GenInverse
   * routines.  RhumbLine::mask is a duplication of this enum.
   **********************************************************************/
  /**
   * No output.
   * @hideinitializer
   **********************************************************************/
  // ignore: unused_field
  static const int _MASK_NONE = 0;
  /**
   * Calculate latitude \e lat2.
   * @hideinitializer
   **********************************************************************/
  static const int _MASK_LATITUDE = 1 << 7;
  /**
   * Calculate longitude \e lon2.
   * @hideinitializer
   **********************************************************************/
  static const int _MASK_LONGITUDE = 1 << 8;
  /**
   * Calculate azimuth \e azi12.
   * @hideinitializer
   **********************************************************************/
  static const int _MASK_AZIMUTH = 1 << 9;
  /**
   * Calculate distance \e s12.
   * @hideinitializer
   **********************************************************************/
  static const int _MASK_DISTANCE = 1 << 10;
  /**
   * Calculate area \e S12.
   * @hideinitializer
   **********************************************************************/
  static const int _MASK_AREA = 1 << 14;
  /**
   * Unroll \e lon2 in the direct calculation.
   * @hideinitializer
   **********************************************************************/
  static const int _MASK_LONG_UNROLL = 1 << 15;
  /**
   * Calculate everything.  (LONG_UNROLL is not included in this mask.)
   * @hideinitializer
   **********************************************************************/
  // ignore: unused_field
  static const int _MASK_ALL = 0x7F80;

  /**
   * Solve the direct rhumb problem returning also the area.
   *
   * @param[in] lat1 latitude of point 1 (degrees).
   * @param[in] lon1 longitude of point 1 (degrees).
   * @param[in] azi12 azimuth of the rhumb line (degrees).
   * @param[in] s12 distance between point 1 and point 2 (meters); it can be
   *   negative.
   *
   * \e lat1 should be in the range [&minus;90&deg;, 90&deg;].  The value of
   * \e lon2 returned is in the range [&minus;180&deg;, 180&deg;].
   *
   * If point 1 is a pole, the cosine of its latitude is taken to be
   * 1/&epsilon;<sup>2</sup> (where &epsilon; is 2<sup>-52</sup>).  This
   * position, which is extremely close to the actual pole, allows the
   * calculation to be carried out in finite terms.  If \e s12 is large
   * enough that the rhumb line crosses a pole, the longitude of point 2
   * is indeterminate (a NaN is returned for \e lon2 and \e S12).
   **********************************************************************/
  RhumbDirectReturn _Direct(double lat1, double lon1, double azi12, double s12) {
    return _GenDirect(lat1, lon1, azi12, s12, _MASK_LATITUDE | _MASK_LONGITUDE /* | _MASK_AREA*/);
  }

  RhumbDirectReturn _GenDirect(double lat1, double lon1, double azi12, double s12, int outmask) {
    return _Line(lat1, lon1, azi12)._GenPosition(s12, outmask);
  }

  _RhumbLine _Line(double lat1, double lon1, double azi12) {
    return _RhumbLine(this, lat1, lon1, azi12);
  }

  /**
   * Solve the inverse rhumb problem returning also the area.
   *
   * @param[in] lat1 latitude of point 1 (degrees).
   * @param[in] lon1 longitude of point 1 (degrees).
   * @param[in] lat2 latitude of point 2 (degrees).
   * @param[in] lon2 longitude of point 2 (degrees).
   * @param[out] s12 rhumb distance between point 1 and point 2 (meters).
   * @param[out] azi12 azimuth of the rhumb line (degrees).
   * @param[out] S12 area under the rhumb line (meters<sup>2</sup>).
   *
   * The shortest rhumb line is found.  If the end points are on opposite
   * meridians, there are two shortest rhumb lines and the east-going one is
   * chosen.  \e lat1 and \e lat2 should be in the range [&minus;90&deg;,
   * 90&deg;].  The value of \e azi12 returned is in the range
   * [&minus;180&deg;, 180&deg;].
   *
   * If either point is a pole, the cosine of its latitude is taken to be
   * 1/&epsilon;<sup>2</sup> (where &epsilon; is 2<sup>-52</sup>).  This
   * position, which is extremely close to the actual pole, allows the
   * calculation to be carried out in finite terms.
   **********************************************************************/
  RhumbInverseReturn _Inverse(double lat1, double lon1, double lat2, double lon2) {
    return _GenInverse(lat1, lon1, lat2, lon2, _MASK_DISTANCE | _MASK_AZIMUTH | _MASK_AREA);
  }

  RhumbInverseReturn _GenInverse(double lat1, double lon1, double lat2, double lon2, int outmask) {
    _AuxAngle phi1 = _AuxAngle.degrees(lat1),
        phi2 = _AuxAngle.degrees(lat2),
        chi1 = _aux.Convert(_AuxLatitude._PHI, _AuxLatitude._CHI, phi1, _exact),
        chi2 = _aux.Convert(_AuxLatitude._PHI, _AuxLatitude._CHI, phi2, _exact);
    double lon12 = _GeoMath.AngDiff(lon1, lon2), lam12 = lon12 * _GeoMath.degree();
    double psi1 = chi1.lam(), psi2 = chi2.lam(), psi12 = psi2 - psi1;
    double azi12 = double.nan, S12 = double.nan, s12 = double.nan;
    if (outmask & _MASK_AZIMUTH != 0) {
      azi12 = _GeoMath.atan2d(lam12, psi12);
    }
    if (outmask & _MASK_DISTANCE != 0) {
      if (psi1.isInfinite || psi2.isInfinite) {
        s12 = (_aux.Convert(_AuxLatitude._PHI, _AuxLatitude._MU, phi2, _exact).radians0() -
                    _aux.Convert(_AuxLatitude._PHI, _AuxLatitude._MU, phi1, _exact).radians0())
                .abs() *
            _rm;
      } else {
        double h = _GeoMath.hypot(lam12, psi12);
        // dmu/dpsi = dmu/dchi / dpsi/dchi
        double dmudpsi = _exact
            ? _aux.DRectifying(phi1, phi2) / _aux.DIsometric(phi1, phi2)
            : _aux.DConvert(_AuxLatitude._CHI, _AuxLatitude._MU, chi1, chi2) /
                _DAuxLatitude.Dlam(chi1.tan(), chi2.tan());
        s12 = h * dmudpsi * _rm;
      }
    }

    return RhumbInverseReturn(s12, azi12, S12);
  }

  // ignore: unused_element
  double _DIsometricToRectifying(double psix, double psiy) {
    if (_exact) {
      double latx = _ell.InverseIsometricLatitude(psix), laty = _ell.InverseIsometricLatitude(psiy);
      return _DRectifying(latx, laty) / _DIsometric(latx, laty);
    } else {
      psix *= _GeoMath.degree();
      psiy *= _GeoMath.degree();
      return _DConformalToRectifying(_gd(psix), _gd(psiy)) * Dgd(psix, psiy);
    }
  }

  double _DConformalToRectifying(double chix, double chiy) {
    return 1 + _SinCosSeries(true, chix, chiy, _ell.ConformalToRectifyingCoeffs(), _tm_maxord);
  }

  double _DE(double x, double y) {
    _EllipticFunction ei = _ell.ell;
    double d = x - y;
    if (x * y <= 0) {
      return d != 0 ? (ei.E1(x) - ei.E1(y)) / d : 1;
    }
    // See DLMF: Eqs (19.11.2) and (19.11.4) letting
    // theta -> x, phi -> -y, psi -> z
    //
    // (E(x) - E(y)) / d = E(z)/d - k2 * sin(x) * sin(y) * sin(z)/d
    //
    // tan(z/2) = (sin(x)*Delta(y) - sin(y)*Delta(x)) / (cos(x) + cos(y))
    //          = d * Dsin(x,y) * (sin(x) + sin(y))/(cos(x) + cos(y)) /
    //             (sin(x)*Delta(y) + sin(y)*Delta(x))
    //          = t = d * Dt
    // sin(z) = 2*t/(1+t^2); cos(z) = (1-t^2)/(1+t^2)
    // Alt (this only works for |z| <= pi/2 -- however, this conditions holds
    // if x*y > 0):
    // sin(z) = d * Dsin(x,y) * (sin(x) + sin(y))/
    //          (sin(x)*cos(y)*Delta(y) + sin(y)*cos(x)*Delta(x))
    // cos(z) = sqrt((1-sin(z))*(1+sin(z)))
    double sx = sin(x), sy = sin(y), cx = cos(x), cy = cos(y);
    double Dt = _Dsin(x, y) * (sx + sy) / ((cx + cy) * (sx * ei.Delta(sy, cy) + sy * ei.Delta(sx, cx))),
        t = d * Dt,
        Dsz = 2 * Dt / (1 + t * t),
        sz = d * Dsz,
        cz = (1 - t) * (1 + t) / (1 + t * t);
    return ((sz != 0 ? ei.E3(sz, cz, ei.Delta(sz, cz)) / sz : 1) - ei.k2() * sx * sy) * Dsz;
  }

  // ignore: unused_element
  double _DRectifyingToIsometric(double mux, double muy) {
    double latx = _ell.InverseRectifyingLatitude(mux / _GeoMath.degree()),
        laty = _ell.InverseRectifyingLatitude(muy / _GeoMath.degree());
    return _exact
        ? _DIsometric(latx, laty) / _DRectifying(latx, laty)
        : _Dgdinv(_GeoMath.taupf(_GeoMath.tand(latx), _ell.es), _GeoMath.taupf(_GeoMath.tand(laty), _ell.es)) *
            _DRectifyingToConformal(mux, muy);
  }

  double _DRectifyingToConformal(double mux, double muy) {
    return 1 - _SinCosSeries(true, mux, muy, _ell.RectifyingToConformalCoeffs(), _tm_maxord);
  }

  double _DRectifying(double latx, double laty) {
    double tbetx = _ell.f1 * _GeoMath.tand(latx), tbety = _ell.f1 * _GeoMath.tand(laty);
    return (_GeoMath.pi() / 2) *
        _ell.b *
        _ell.f1 *
        _DE(atan(tbetx), atan(tbety)) *
        _Dtan(latx, laty) *
        _Datan(tbetx, tbety) /
        _ell.QuarterMeridian();
  }

  double _DIsometric(double latx, double laty) {
    double phix = latx * _GeoMath.degree(),
        tx = _GeoMath.tand(latx),
        phiy = laty * _GeoMath.degree(),
        ty = _GeoMath.tand(laty);
    return _Dasinh(tx, ty) * _Dtan(latx, laty) - _Deatanhe(sin(phix), sin(phiy)) * _Dsin(phix, phiy);
  }

  double _SinCosSeries(bool sinp, double x, double y, List<double> c, int n) {
    // N.B. n >= 0 and c[] has n+1 elements 0..n, of which c[0] is ignored.
    //
    // Use Clenshaw summation to evaluate
    //   m = (g(x) + g(y)) / 2         -- mean value
    //   s = (g(x) - g(y)) / (x - y)   -- average slope
    // where
    //   g(x) = sum(c[j]*SC(2*j*x), j = 1..n)
    //   SC = sinp ? sin : cos
    //   CS = sinp ? cos : sin
    //
    // This function returns only s; m is discarded.
    //
    // Write
    //   t = [m; s]
    //   t = sum(c[j] * f[j](x,y), j = 1..n)
    // where
    //   f[j](x,y) = [ (SC(2*j*x)+SC(2*j*y))/2 ]
    //               [ (SC(2*j*x)-SC(2*j*y))/d ]
    //
    //             = [       cos(j*d)*SC(j*p)    ]
    //               [ +/-(2/d)*sin(j*d)*CS(j*p) ]
    // (+/- = sinp ? + : -) and
    //    p = x+y, d = x-y
    //
    //   f[j+1](x,y) = A * f[j](x,y) - f[j-1](x,y)
    //
    //   A = [  2*cos(p)*cos(d)      -sin(p)*sin(d)*d]
    //       [ -4*sin(p)*sin(d)/d   2*cos(p)*cos(d)  ]
    //
    // Let b[n+1] = b[n+2] = [0 0; 0 0]
    //     b[j] = A * b[j+1] - b[j+2] + c[j] * I for j = n..1
    //    t =  (c[0] * I  - b[2]) * f[0](x,y) + b[1] * f[1](x,y)
    // c[0] is not accessed for s = t[2]
    double p = x + y,
        d = x - y,
        cp = cos(p),
        cd = cos(d),
        sp = sin(p),
        sd = d != 0 ? sin(d) / d : 1,
        m = 2 * cp * cd,
        s = sp * sd;
    // 2x2 matrices stored in row-major order
    List<double> a = [m, -s * d * d, -4 * s, m];
    List<double> ba = [0, 0, 0, 0];
    List<double> bb = [0, 0, 0, 0];
    List<double> b1 = List<double>.from(ba);
    List<double> b2 = List<double>.from(bb);
    if (n > 0) b1[0] = b1[3] = c[n];
    for (int j = n - 1; j > 0; --j) {
      // j = n-1 .. 1
      var _temp = b1;
      b1 = b2;
      b2 = _temp;
      // b1 = A * b2 - b1 + c[j] * I
      b1[0] = a[0] * b2[0] + a[1] * b2[2] - b1[0] + c[j];
      b1[1] = a[0] * b2[1] + a[1] * b2[3] - b1[1];
      b1[2] = a[2] * b2[0] + a[3] * b2[2] - b1[2];
      b1[3] = a[2] * b2[1] + a[3] * b2[3] - b1[3] + c[j];
    }
    // Here are the full expressions for m and s
    // m =   (c[0] - b2[0]) * f01 - b2[1] * f02 + b1[0] * f11 + b1[1] * f12;
    // s = - b2[2] * f01 + (c[0] - b2[3]) * f02 + b1[2] * f11 + b1[3] * f12;
    if (sinp) {
      // double f01 = 0, f02 = 0;
      double f11 = cd * sp, f12 = 2 * sd * cp;
      // m = b1[0] * f11 + b1[1] * f12;
      s = b1[2] * f11 + b1[3] * f12;
    } else {
      // double f01 = 1, f02 = 0;
      double f11 = cd * cp, f12 = -2 * sd * sp;
      // m = c[0] - b2[0] + b1[0] * f11 + b1[1] * f12;
      s = -b2[2] + b1[2] * f11 + b1[3] * f12;
    }
    return s;
  }
}

class RhumbDirectReturn {
  // @param[out] lat2 latitude of point 2 (degrees).
  // @param[out] lon2 longitude of point 2 (degrees).
  // @param[out] S12 area under the rhumb line (meters<sup>2</sup>).
  final double lat2;
  final double lon2;
  final double S12;

  RhumbDirectReturn(this.lat2, this.lon2, this.S12);
}

class RhumbInverseReturn {
  // @param[out] s12 rhumb distance between point 1 and point 2 (meters).
  // @param[out] azi12 azimuth of the rhumb line (degrees).
  // @param[out] S12 area under the rhumb line (meters<sup>2</sup>).

  final double s12;
  final double azi12;
  final double S12;

  RhumbInverseReturn(this.s12, this.azi12, this.S12);
}

/**
 * \brief Find a sequence of points on a single rhumb line.
 *
 * RhumbLine facilitates the determination of a series of points on a single
 * rhumb line.  The starting point (\e lat1, \e lon1) and the azimuth \e
 * azi12 are specified in the call to Rhumb::Line which returns a RhumbLine
 * object.  RhumbLine.Position returns the location of point 2 (and,
 * optionally, the corresponding area, \e S12) a distance \e s12 along the
 * rhumb line.
 *
 * There is no public constructor for this class.  (Use Rhumb::Line to create
 * an instance.)  The Rhumb object used to create a RhumbLine must stay in
 * scope as long as the RhumbLine.
 *
 * Example of use:
 * \include example-RhumbLine.cpp
 **********************************************************************/

class _RhumbLine {
  late final _Rhumb _rh;
  // ignore: unused_field
  late final double _lat1, _lon1, _azi12;
  // ignore: unused_field
  late final double _salp, _calp, _mu1, _psi1, _r1;

  late _AuxAngle _phi1, _chi1;

  // copy assignment not allowed
  // RhumbLine& operator=(const RhumbLine&) = delete;
  _RhumbLine(_Rhumb rh, double lat1, double lon1, double azi12) {
    _rh = rh;
    _lat1 = _GeoMath.LatFix(lat1);
    _lon1 = lon1;
    _azi12 = _GeoMath.AngNormalize(azi12);

    var p = _Pair();
    _GeoMath.sincosd(_azi12, p);
    _salp = p.first;
    _calp = p.second;
    _phi1 = _AuxAngle.degrees(lat1);
    _mu1 = _rh._aux.Convert(_AuxLatitude._PHI, _AuxLatitude._MU, _phi1, _rh._exact).degrees0();
    _chi1 = _rh._aux.Convert(_AuxLatitude._PHI, _AuxLatitude._CHI, _phi1, _rh._exact);
    _psi1 = _chi1.lam();
  }

  /**
   * The general position routine.  RhumbLine::Position is defined in term so
   * this function.
   *
   * @param[in] s12 distance between point 1 and point 2 (meters); it can be
   *   negative.
   * @param[in] outmask a bitor'ed combination of RhumbLine::mask values
   *   specifying which of the following parameters should be set.
   * @param[out] lat2 latitude of point 2 (degrees).
   * @param[out] lon2 longitude of point 2 (degrees).
   * @param[out] S12 area under the rhumb line (meters<sup>2</sup>).
   *
   * The RhumbLine::mask values possible for \e outmask are
   * - \e outmask |= RhumbLine::LATITUDE for the latitude \e lat2;
   * - \e outmask |= RhumbLine::LONGITUDE for the latitude \e lon2;
   * - \e outmask |= RhumbLine::AREA for the area \e S12;
   * - \e outmask |= RhumbLine::ALL for all of the above;
   * - \e outmask |= RhumbLine::LONG_UNROLL to unroll \e lon2 instead of
   *   wrapping it into the range [&minus;180&deg;, 180&deg;].
   * .
   * With the RhumbLine::LONG_UNROLL bit set, the quantity \e lon2 &minus; \e
   * lon1 indicates how many times and in what sense the rhumb line encircles
   * the ellipsoid.
   *
   * If \e s12 is large enough that the rhumb line crosses a pole, the
   * longitude of point 2 is indeterminate (a NaN is returned for \e lon2 and
   * \e S12).
   **********************************************************************/
  RhumbDirectReturn _GenPosition(double s12, int outmask) {
    double r12 = s12 / (_rh._rm * _GeoMath.degree()), // scaled distance in degrees
        mu12 = r12 * _calp,
        mu2 = _mu1 + mu12;
    double lat2x, lon2x;
    double S12 = double.nan;

    if (mu2.abs() <= _GeoMath.qd) {
      _AuxAngle mu2a = _AuxAngle.degrees(mu2);
      _AuxAngle phi2 = _rh._aux.Convert(_AuxLatitude._MU, _AuxLatitude._PHI, mu2a, _rh._exact);
      _AuxAngle chi2 = _rh._aux.Convert(_AuxLatitude._PHI, _AuxLatitude._CHI, phi2, _rh._exact);
      lat2x = phi2.degrees0();
      double dmudpsi = _rh._exact
          ? _rh._aux.DRectifying(_phi1, phi2) / _rh._aux.DIsometric(_phi1, phi2)
          : _rh._aux.DConvert(_AuxLatitude._CHI, _AuxLatitude._MU, _chi1, chi2) /
              _DAuxLatitude.Dlam(_chi1.tan(), chi2.tan());
      lon2x = r12 * _salp / dmudpsi;
      lon2x = outmask & _Rhumb._MASK_LONG_UNROLL != 0
          ? _lon1 + lon2x
          : _GeoMath.AngNormalize(_GeoMath.AngNormalize(_lon1) + lon2x);
    } else {
      // Reduce to the interval [-180, 180)
      mu2 = _GeoMath.AngNormalize(mu2);
      // Deal with points on the anti-meridian
      if (mu2.abs() > _GeoMath.qd) {
        mu2 = _GeoMath.AngNormalize(_GeoMath.hd - mu2);
      }
      lat2x = _rh._aux.Convert(_AuxLatitude._MU, _AuxLatitude._PHI, _AuxAngle.degrees(mu2), _rh._exact).degrees0();
      lon2x = double.nan;
      if (outmask & _Rhumb._MASK_AREA != 0) {
        S12 = double.nan;
      }
    }
    double lat2 = double.nan, lon2 = double.nan;

    if (outmask & _Rhumb._MASK_LATITUDE != 0) lat2 = lat2x;
    if (outmask & _Rhumb._MASK_LONGITUDE != 0) lon2 = lon2x;

    return RhumbDirectReturn(lat2, lon2, S12);
  }
}
