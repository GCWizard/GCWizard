/***********************************************************************
    Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================

 * Copyright (c) Charles Karney (2008-2022) <charles@karney.com> and licensed
 * under the MIT/X11 License.  For more information, see
 * https://geographiclib.sourceforge.io/
 * https://sourceforge.net/projects/geographiclib/

 **********************************************************************/

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';

/**
 * \brief Elliptic integrals and functions
 *
 * This provides the elliptic functions and integrals needed for Ellipsoid,
 * GeodesicExact, and TransverseMercatorExact.  Two categories of function
 * are provided:
 * - \e static functions to compute symmetric elliptic integrals
 *   (https://dlmf.nist.gov/19.16.i)
 * - \e member functions to compute Legrendre's elliptic
 *   integrals (https://dlmf.nist.gov/19.2.ii) and the
 *   Jacobi elliptic functions (https://dlmf.nist.gov/22.2).
 * .
 * In the latter case, an object is constructed giving the modulus \e k (and
 * optionally the parameter &alpha;<sup>2</sup>).  The modulus is always
 * passed as its square <i>k</i><sup>2</sup> which allows \e k to be pure
 * imaginary (<i>k</i><sup>2</sup> &lt; 0).  (Confusingly, Abramowitz and
 * Stegun call \e m = <i>k</i><sup>2</sup> the "parameter" and \e n =
 * &alpha;<sup>2</sup> the "characteristic".)
 *
 * In geodesic applications, it is convenient to separate the incomplete
 * integrals into secular and periodic components, e.g.,
 * \f[
 *   E(\phi, k) = (2 E(k) / \pi) [ \phi + \delta E(\phi, k) ]
 * \f]
 * where &delta;\e E(&phi;, \e k) is an odd periodic function with period
 * &pi;.
 *
 * The computation of the elliptic integrals uses the algorithms given in
 * - B. C. Carlson,
 *   <a href="https://doi.org/10.1007/BF02198293"> Computation of double or
 *   complex elliptic integrals</a>, Numerical Algorithms 10, 13--26 (1995);
 *   <a href="https://arxiv.org/abs/math/9409227">preprint</a>.
 * .
 * with the additional optimizations given in https://dlmf.nist.gov/19.36.i.
 * The computation of the Jacobi elliptic functions uses the algorithm given
 * in
 * - R. Bulirsch,
 *   <a href="https://doi.org/10.1007/BF01397975"> Numerical Calculation of
 *   Elliptic Integrals and Elliptic Functions</a>, Numericshe Mathematik 7,
 *   78--90 (1965).
 * .
 * The notation follows https://dlmf.nist.gov/19 and https://dlmf.nist.gov/22
 *
 * Example of use:
 * \include example-EllipticFunction.cpp
 **********************************************************************/

// ignore_for_file: unused_field
// ignore_for_file: unused_element
class _EllipticFunction {
  final int num_ = 13;

  late double _k2, _kp2, _alpha2, _alphap2, _eps;
  late double _kKc, _eEc, _dDc, _pPic, _gGc, _hHc;

  /** \name Constructor
   **********************************************************************/
  ///@{
  /**
   * Constructor specifying the modulus and parameter.
   *
   * @param[in] k2 the square of the modulus <i>k</i><sup>2</sup>.
   *   <i>k</i><sup>2</sup> must lie in (&minus;&infin;, 1].
   * @param[in] alpha2 the parameter &alpha;<sup>2</sup>.
   *   &alpha;<sup>2</sup> must lie in (&minus;&infin;, 1].
   * @exception GeographicErr if \e k2 or \e alpha2 is out of its legal
   *   range.
   *
   * If only elliptic integrals of the first and second kinds are needed,
   * then set &alpha;<sup>2</sup> = 0 (the default value); in this case, we
   * have &Pi;(&phi;, 0, \e k) = \e F(&phi;, \e k), \e G(&phi;, 0, \e k) = \e
   * E(&phi;, \e k), and \e H(&phi;, 0, \e k) = \e F(&phi;, \e k) - \e
   * D(&phi;, \e k).
   **********************************************************************/
  _EllipticFunction([double k2 = 0, double alpha2 = 0]) {
    _Reset2(k2, alpha2);
  }

  /**
   * The complete integral of the second kind.
   *
   * @return \e E(\e k).
   *
   * \e E(\e k) is defined in https://dlmf.nist.gov/19.2.E5
   * \f[
   *   E(k) = \int_0^{\pi/2} \sqrt{1-k^2\sin^2\phi}\,d\phi.
   * \f]
   **********************************************************************/
  double E0() {
    return _eEc;
  }

  //
  // /**
  //  * Constructor specifying the modulus and parameter and their complements.
  //  *
  //  * @param[in] k2 the square of the modulus <i>k</i><sup>2</sup>.
  //  *   <i>k</i><sup>2</sup> must lie in (&minus;&infin;, 1].
  //  * @param[in] alpha2 the parameter &alpha;<sup>2</sup>.
  //  *   &alpha;<sup>2</sup> must lie in (&minus;&infin;, 1].
  //  * @param[in] kp2 the complementary modulus squared <i>k'</i><sup>2</sup> =
  //  *   1 &minus; <i>k</i><sup>2</sup>.  This must lie in [0, &infin;).
  //  * @param[in] alphap2 the complementary parameter &alpha;'<sup>2</sup> = 1
  //  *   &minus; &alpha;<sup>2</sup>.  This must lie in [0, &infin;).
  //  * @exception GeographicErr if \e k2, \e alpha2, \e kp2, or \e alphap2 is
  //  *   out of its legal range.
  //  *
  //  * The arguments must satisfy \e k2 + \e kp2 = 1 and \e alpha2 + \e alphap2
  //  * = 1.  (No checking is done that these conditions are met.)  This
  //  * constructor is provided to enable accuracy to be maintained, e.g., when
  //  * \e k is very close to unity.
  //  **********************************************************************/
  // EllipticFunction(double k2, double alpha2, double kp2, double alphap2)
  // { Reset(k2, alpha2, kp2, alphap2); }
  //
  /**
   * Reset the modulus and parameter.
   *
   * @param[in] k2 the new value of square of the modulus
   *   <i>k</i><sup>2</sup> which must lie in (&minus;&infin;, ].
   *   done.)
   * @param[in] alpha2 the new value of parameter &alpha;<sup>2</sup>.
   *   &alpha;<sup>2</sup> must lie in (&minus;&infin;, 1].
   * @exception GeographicErr if \e k2 or \e alpha2 is out of its legal
   *   range.
   **********************************************************************/
  void _Reset2([double k2 = 0, double alpha2 = 0]) {
    _Reset(k2, alpha2, 1 - k2, 1 - alpha2);
  }

  /**
   * Reset the modulus and parameter supplying also their complements.
   *
   * @param[in] k2 the square of the modulus <i>k</i><sup>2</sup>.
   *   <i>k</i><sup>2</sup> must lie in (&minus;&infin;, 1].
   * @param[in] alpha2 the parameter &alpha;<sup>2</sup>.
   *   &alpha;<sup>2</sup> must lie in (&minus;&infin;, 1].
   * @param[in] kp2 the complementary modulus squared <i>k'</i><sup>2</sup> =
   *   1 &minus; <i>k</i><sup>2</sup>.  This must lie in [0, &infin;).
   * @param[in] alphap2 the complementary parameter &alpha;'<sup>2</sup> = 1
   *   &minus; &alpha;<sup>2</sup>.  This must lie in [0, &infin;).
   * @exception GeographicErr if \e k2, \e alpha2, \e kp2, or \e alphap2 is
   *   out of its legal range.
   *
   * The arguments must satisfy \e k2 + \e kp2 = 1 and \e alpha2 + \e alphap2
   * = 1.  (No checking is done that these conditions are met.)  This
   * constructor is provided to enable accuracy to be maintained, e.g., when
   * is very small.
   **********************************************************************/
  void _Reset(double k2, double alpha2, double kp2, double alphap2) {
    // Accept nans here (needed for GeodesicExact)
    // if (k2 > 1)
    //   throw GeographicErr("Parameter k2 is not in (-inf, 1]");
    // if (alpha2 > 1)
    //   throw GeographicErr("Parameter alpha2 is not in (-inf, 1]");
    // if (kp2 < 0)
    //   throw GeographicErr("Parameter kp2 is not in [0, inf)");
    // if (alphap2 < 0)
    //   throw GeographicErr("Parameter alphap2 is not in [0, inf)");
    _k2 = k2;
    _kp2 = kp2;
    _alpha2 = alpha2;
    _alphap2 = alphap2;
    _eps = _k2 / _GeoMath.sq(sqrt(_kp2) + 1);
    // Values of complete elliptic integrals for k = 0,1 and alpha = 0,1
    //         K     E     D
    // k = 0:  pi/2  pi/2  pi/4
    // k = 1:  inf   1     inf
    //                    Pi    G     H
    // k = 0, alpha = 0:  pi/2  pi/2  pi/4
    // k = 1, alpha = 0:  inf   1     1
    // k = 0, alpha = 1:  inf   inf   pi/2
    // k = 1, alpha = 1:  inf   inf   inf
    //
    // Pi(0, k) = K(k)
    // G(0, k) = E(k)
    // H(0, k) = K(k) - D(k)
    // Pi(0, k) = K(k)
    // G(0, k) = E(k)
    // H(0, k) = K(k) - D(k)
    // Pi(alpha2, 0) = pi/(2*sqrt(1-alpha2))
    // G(alpha2, 0) = pi/(2*sqrt(1-alpha2))
    // H(alpha2, 0) = pi/(2*(1 + sqrt(1-alpha2)))
    // Pi(alpha2, 1) = inf
    // H(1, k) = K(k)
    // G(alpha2, 1) = H(alpha2, 1) = RC(1, alphap2)
    if (_k2 != 0) {
      // Complete elliptic integral K(k), Carlson eq. 4.1
      // https://dlmf.nist.gov/19.25.E1
      _kKc = _kp2 != 0 ? RF2(_kp2, 1) : double.infinity;
      // Complete elliptic integral E(k), Carlson eq. 4.2
      // https://dlmf.nist.gov/19.25.E1
      _eEc = _kp2 != 0 ? 2 * RG(_kp2, 1) : 1;
      // D(k) = (K(k) - E(k))/k^2, Carlson eq.4.3
      // https://dlmf.nist.gov/19.25.E1
      _dDc = _kp2 != 0 ? RD(0, _kp2, 1) / 3 : double.infinity;
    } else {
      _kKc = _eEc = _GeoMath.pi() / 2;
      _dDc = _kKc / 2;
    }
    if (_alpha2 != 0) {
      // https://dlmf.nist.gov/19.25.E2
      double rj = (_kp2 != 0 && _alphap2 != 0) ? RJ(0, _kp2, 1, _alphap2) : double.infinity,
          // Only use rc if _kp2 = 0.
          rc = _kp2 != 0 ? 0 : (_alphap2 != 0 ? RC(1, _alphap2) : double.infinity);
      // Pi(alpha^2, k)
      _pPic = _kp2 != 0 ? _kKc + _alpha2 * rj / 3 : double.infinity;
      // G(alpha^2, k)
      _gGc = _kp2 != 0 ? _kKc + (_alpha2 - _k2) * rj / 3 : rc;
      // H(alpha^2, k)
      _hHc = _kp2 != 0 ? _kKc - (_alphap2 != 0 ? _alphap2 * rj : 0) / 3 : rc;
    } else {
      _pPic = _kKc;
      _gGc = _eEc;
      // Hc = Kc - Dc but this involves large cancellations if k2 is close to
      // 1.  So write (for alpha2 = 0)
      //   Hc = int(cos(phi)^2/sqrt(1-k2*sin(phi)^2),phi,0,pi/2)
      //      = 1/sqrt(1-k2) * int(sin(phi)^2/sqrt(1-k2/kp2*sin(phi)^2,...)
      //      = 1/kp * D(i*k/kp)
      // and use D(k) = RD(0, kp2, 1) / 3
      // so Hc = 1/kp * RD(0, 1/kp2, 1) / 3
      //       = kp2 * RD(0, 1, kp2) / 3
      // using https://dlmf.nist.gov/19.20.E18
      // Equivalently
      //   RF(x, 1) - RD(0, x, 1)/3 = x * RD(0, 1, x)/3 for x > 0
      // For k2 = 1 and alpha2 = 0, we have
      //   Hc = int(cos(phi),...) = 1
      _hHc = _kp2 != 0 ? _kp2 * RD(0, 1, _kp2) / 3 : 1;
    }
  }

  /*
   * Implementation of methods given in
   *
   *   B. C. Carlson
   *   Computation of elliptic integrals
   *   Numerical Algorithms 10, 13-26 (1995)
   */

  static double RF3(double x, double y, double z) {
    // Carlson, eqs 2.2 - 2.7
    num tolRF = pow(3 * practical_epsilon * 0.01, 1 / 8.0);
    double A0 = (x + y + z) / 3,
        An = A0,
        Q = max<double>(max<double>((A0 - x).abs(), (A0 - y).abs()), (A0 - z).abs()) / tolRF,
        x0 = x,
        y0 = y,
        z0 = z,
        mul = 1;
    while (Q >= mul * (An).abs()) {
      // Max 6 trips
      double lam = sqrt(x0) * sqrt(y0) + sqrt(y0) * sqrt(z0) + sqrt(z0) * sqrt(x0);
      An = (An + lam) / 4;
      x0 = (x0 + lam) / 4;
      y0 = (y0 + lam) / 4;
      z0 = (z0 + lam) / 4;
      mul *= 4;
    }
    double X = (A0 - x) / (mul * An), Y = (A0 - y) / (mul * An), Z = -(X + Y), E2 = X * Y - Z * Z, E3 = X * Y * Z;

    // https://dlmf.nist.gov/19.36.E1
    // Polynomial is
    // (1 - E2/10 + E3/14 + E2^2/24 - 3*E2*E3/44
    //    - 5*E2^3/208 + 3*E3^2/104 + E2^2*E3/16)
    // convert to Horner form...
    return (E3 * (6930 * E3 + E2 * (15015 * E2 - 16380) + 17160) + E2 * ((10010 - 5775 * E2) * E2 - 24024) + 240240) /
        (240240 * sqrt(An));
  }

  static double RF2(double x, double y) {
    // Carlson, eqs 2.36 - 2.38
    double tolRG0 = 2.7 * sqrt((practical_epsilon * 0.01));
    double xn = sqrt(x), yn = sqrt(y);
    if (xn < yn) {
      var _h = xn;
      xn = yn;
      yn = _h;
    }
    while ((xn - yn).abs() > tolRG0 * xn) {
      // Max 4 trips
      double t = (xn + yn) / 2;
      yn = sqrt(xn * yn);
      xn = t;
    }
    return _GeoMath.pi() / (xn + yn);
  }

  static double RJ(double x, double y, double z, double p) {
    // Carlson, eqs 2.17 - 2.25
    num tolRD = pow(0.2 * (practical_epsilon * 0.01), 1 / 8.0);
    double A0 = (x + y + z + 2 * p) / 5,
        An = A0,
        delta = (p - x) * (p - y) * (p - z),
        Q = max<double>(max<double>((A0 - x).abs(), (A0 - y).abs()), max<double>((A0 - z).abs(), (A0 - p).abs())) /
            tolRD,
        x0 = x,
        y0 = y,
        z0 = z,
        p0 = p,
        mul = 1,
        mul3 = 1,
        s = 0;
    while (Q >= mul * (An).abs()) {
      // Max 7 trips
      double lam = sqrt(x0) * sqrt(y0) + sqrt(y0) * sqrt(z0) + sqrt(z0) * sqrt(x0),
          d0 = (sqrt(p0) + sqrt(x0)) * (sqrt(p0) + sqrt(y0)) * (sqrt(p0) + sqrt(z0)),
          e0 = delta / (mul3 * _GeoMath.sq(d0));
      s += RC(1, 1 + e0) / (mul * d0);
      An = (An + lam) / 4;
      x0 = (x0 + lam) / 4;
      y0 = (y0 + lam) / 4;
      z0 = (z0 + lam) / 4;
      p0 = (p0 + lam) / 4;
      mul *= 4;
      mul3 *= 64;
    }
    double X = (A0 - x) / (mul * An),
        Y = (A0 - y) / (mul * An),
        Z = (A0 - z) / (mul * An),
        P = -(X + Y + Z) / 2,
        E2 = X * Y + X * Z + Y * Z - 3 * P * P,
        E3 = X * Y * Z + 2 * P * (E2 + 2 * P * P),
        E4 = (2 * X * Y * Z + P * (E2 + 3 * P * P)) * P,
        E5 = X * Y * Z * P * P;
    // https://dlmf.nist.gov/19.36.E2
    // Polynomial is
    // (1 - 3*E2/14 + E3/6 + 9*E2^2/88 - 3*E4/22 - 9*E2*E3/52 + 3*E5/26
    //    - E2^3/16 + 3*E3^2/40 + 3*E2*E4/20 + 45*E2^2*E3/272
    //    - 9*(E3*E4+E2*E5)/68)
    return ((471240 - 540540 * E2) * E5 +
                (612612 * E2 - 540540 * E3 - 556920) * E4 +
                E3 * (306306 * E3 + E2 * (675675 * E2 - 706860) + 680680) +
                E2 * ((417690 - 255255 * E2) * E2 - 875160) +
                4084080) /
            (4084080 * mul * An * sqrt(An)) +
        6 * s;
  }

  static double RC(double x, double y) {
    // Defined only for y != 0 and x >= 0.
    return (!(x >= y)
        ? // x < y  and catch nans
        // https://dlmf.nist.gov/19.2.E18
        atan(sqrt((y - x) / x)) / sqrt(y - x)
        : (x == y
            ? 1 / sqrt(y)
            : _GeoMath.asinh(y > 0
                    ?
                    // https://dlmf.nist.gov/19.2.E19
                    // atanh(sqrt((x - y) / x))
                    sqrt((x - y) / y)
                    :
                    // https://dlmf.nist.gov/19.2.E20
                    // atanh(sqrt(x / (x - y)))
                    sqrt(-x / y)) /
                sqrt(x - y)));
  }

  static double RG(double x, double y) {
    // Carlson, eqs 2.36 - 2.39
    double tolRG0 = 2.7 * sqrt((practical_epsilon * 0.01));
    double x0 = sqrt(max<double>(x, y)), y0 = sqrt(min<double>(x, y)), xn = x0, yn = y0, s = 0, mul = 0.25;
    while ((xn - yn).abs() > tolRG0 * xn) {
      // Max 4 trips
      double t = (xn + yn) / 2;
      yn = sqrt(xn * yn);
      xn = t;
      mul *= 2;
      t = xn - yn;
      s += mul * t * t;
    }
    return (_GeoMath.sq((x0 + y0) / 2) - s) * _GeoMath.pi() / (2 * (xn + yn));
  }

  static double RD(double x, double y, double z) {
    // Carlson, eqs 2.28 - 2.34
    num tolRD = pow(0.2 * (practical_epsilon * 0.01), 1 / 8.0);
    double A0 = (x + y + 3 * z) / 5,
        An = A0,
        Q = max<double>(max<double>(A0 - x.abs(), A0 - y.abs()), A0 - z.abs()) / tolRD,
        x0 = x,
        y0 = y,
        z0 = z,
        mul = 1,
        s = 0;
    while (Q >= mul * An.abs()) {
      // Max 7 trips
      double lam = sqrt(x0) * sqrt(y0) + sqrt(y0) * sqrt(z0) + sqrt(z0) * sqrt(x0);
      s += 1 / (mul * sqrt(z0) * (z0 + lam));
      An = (An + lam) / 4;
      x0 = (x0 + lam) / 4;
      y0 = (y0 + lam) / 4;
      z0 = (z0 + lam) / 4;
      mul *= 4;
    }
    double X = (A0 - x) / (mul * An),
        Y = (A0 - y) / (mul * An),
        Z = -(X + Y) / 3,
        E2 = X * Y - 6 * Z * Z,
        E3 = (3 * X * Y - 8 * Z * Z) * Z,
        E4 = 3 * (X * Y - Z * Z) * Z * Z,
        E5 = X * Y * Z * Z * Z;
    // https://dlmf.nist.gov/19.36.E2
    // Polynomial is
    // (1 - 3*E2/14 + E3/6 + 9*E2^2/88 - 3*E4/22 - 9*E2*E3/52 + 3*E5/26
    //    - E2^3/16 + 3*E3^2/40 + 3*E2*E4/20 + 45*E2^2*E3/272
    //    - 9*(E3*E4+E2*E5)/68)
    return ((471240 - 540540 * E2) * E5 +
                (612612 * E2 - 540540 * E3 - 556920) * E4 +
                E3 * (306306 * E3 + E2 * (675675 * E2 - 706860) + 680680) +
                E2 * ((417690 - 255255 * E2) * E2 - 875160) +
                4084080) /
            (4084080 * mul * An * sqrt(An)) +
        3 * s;
  }

  /**
   * The periodic incomplete integral of the second kind.
   *
   * @param[in] sn = sin&phi;.
   * @param[in] cn = cos&phi;.
   * @param[in] dn = sqrt(1 &minus; <i>k</i><sup>2</sup>
   *   sin<sup>2</sup>&phi;).
   * @return the periodic function &pi; \e E(&phi;, \e k) / (2 \e E(\e k)) -
   *   &phi;.
   **********************************************************************/
  double deltaE(double sn, double cn, double dn) {
    // Function is periodic with period pi
    if (cn < 0) {
      cn = -cn;
      sn = -sn;
    }
    return E3(sn, cn, dn) * (_GeoMath.pi() / 2) / E0() - atan2(sn, cn);
  }

  /**
   * The incomplete integral of the second kind.
   *
   * @param[in] phi
   * @return \e E(&phi;, \e k).
   *
   * \e E(&phi;, \e k) is defined in https://dlmf.nist.gov/19.2.E5
   * \f[
   *   E(\phi, k) = \int_0^\phi \sqrt{1-k^2\sin^2\theta}\,d\theta.
   * \f]
   **********************************************************************/
  double E1(double phi) {
    double sn = sin(phi), cn = cos(phi), dn = Delta(sn, cn);
    return (phi).abs() < _GeoMath.pi() ? E3(sn, cn, dn) : (deltaE(sn, cn, dn) + phi) * E0() / (_GeoMath.pi() / 2);
  }

  /**
   * The incomplete integral of the second kind in terms of Jacobi elliptic
   * functions.
   *
   * @param[in] sn = sin&phi;.
   * @param[in] cn = cos&phi;.
   * @param[in] dn = sqrt(1 &minus; <i>k</i><sup>2</sup>
   *   sin<sup>2</sup>&phi;).
   * @return \e E(&phi;, \e k) as though &phi; &isin; (&minus;&pi;, &pi;].
   **********************************************************************/
  double E3(double sn, double cn, double dn) {
    double cn2 = cn * cn,
        dn2 = dn * dn,
        sn2 = sn * sn,
        ei = cn2 != 0.0
            ? (sn).abs() *
                (_k2 <= 0
                    ?
                    // Carlson, eq. 4.6 and
                    // https://dlmf.nist.gov/19.25.E9
                    RF3(cn2, dn2, 1) - _k2 * sn2 * RD(cn2, dn2, 1) / 3
                    : (_kp2 >= 0
                        ?
                        // https://dlmf.nist.gov/19.25.E10
                        _kp2 * RF3(cn2, dn2, 1) + _k2 * _kp2 * sn2 * RD(cn2, 1, dn2) / 3 + _k2 * (cn).abs() / dn
                        :
                        // https://dlmf.nist.gov/19.25.E11
                        -_kp2 * sn2 * RD(dn2, 1, cn2) / 3 + dn / (cn).abs()))
            : E0();
    if (cn.isNegative) {
      ei = 2 * E0() - ei;
    }
    return (sn >= 0) ? ei : -ei;
  }

  /**
   * The &Delta; amplitude function.
   *
   * @param[in] sn sin&phi;.
   * @param[in] cn cos&phi;.
   * @return &Delta; = sqrt(1 &minus; <i>k</i><sup>2</sup>
   *   sin<sup>2</sup>&phi;).
   **********************************************************************/
  double Delta(double sn, double cn) {
    return sqrt(_k2 < 0 ? 1 - _k2 * sn * sn : _kp2 + _k2 * cn * cn);
  }

  double Einv(double x) {
    double tolJAC = sqrt(practical_epsilon * 0.01);
    double n = (x / (2.0 * _eEc) + 0.5).floor().toDouble();
    x -= 2 * _eEc * n; // x now in [-ec, ec)
    // Linear approximation
    double phi = _GeoMath.pi() * x / (2 * _eEc); // phi in [-pi/2, pi/2)
    // First order correction
    phi -= _eps * sin(2 * phi) / 2;
    // For kp2 close to zero use asin(x/_eEc) or
    // J. P. Boyd, Applied Math. and Computation 218, 7005-7013 (2012)
    // https://doi.org/10.1016/j.amc.2011.12.021
    // Ignore convergence failures with standard floating points types by allowing
    // loop to exit cleanly.
    //  #define GEOGRAPHICLIB_PANIC false
    for (int i = 0; i < num_ || /*GEOGRAPHICLIB_PANIC*/ false; ++i) {
      double sn = sin(phi), cn = cos(phi), dn = Delta(sn, cn), err = (E3(sn, cn, dn) - x) / dn;
      phi -= err;
      if (!((err).abs() > tolJAC)) break;
    }
    return n * _GeoMath.pi() + phi;
  }

  ///@}

  /** \name Inspector functions.
   **********************************************************************/
  ///@{
  /**
   * @return the square of the modulus <i>k</i><sup>2</sup>.
   **********************************************************************/
  double k2() {
    return _k2;
  }
} // namespace GeographicLib
