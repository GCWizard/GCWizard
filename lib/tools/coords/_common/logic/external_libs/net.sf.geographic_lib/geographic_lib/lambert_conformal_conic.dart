/***********************************************************************
    Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================

 * \file LambertConformalConic.hpp
 * \brief Header for GeographicLib::LambertConformalConic class
 *
 * Copyright (c) Charles Karney (2010, 2011) <charles@karney.com> and licensed
 * under the MIT/X11 License.  For more information, see
 * http://geographiclib.sourceforge.net/
 **********************************************************************/
part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';

/*
 * \brief Lambert Conformal Conic Projection
 *
 * Implementation taken from the report,
 * - J. P. Snyder,
 *   <a href="http://pubs.er.usgs.gov/usgspubs/pp/pp1395"> Map Projections: A
 *   Working Manual</a>, USGS Professional Paper 1395 (1987),
 *   pp. 107&ndash;109.
 *
 * This is a implementation of the equations in Snyder except that divided
 * differences have been used to transform the expressions into ones which
 * may be evaluated accurately and that Newton's method is used to invert the
 * projection.  In this implementation, the projection correctly becomes the
 * Mercator_ projection or the polar sterographic projection when the standard
 * latitude is the equator or a pole.  The accuracy of the projections is
 * about 10 nm.
 *
 * The ellipsoid parameters, the standard parallels, and the scale on the
 * standard parallels are set in the constructor.  Internally, the case with
 * two standard parallels is converted into a single standard parallel, the
 * latitude of tangency (also the latitude of minimum scale), with a scale
 * specified on this parallel.  This latitude is also used as the latitude of
 * origin which is returned by LambertConformalConic::OriginLatitude.  The
 * scale on the latitude of origin is given by
 * LambertConformalConic::CentralScale.  The case with two distinct standard
 * parallels where one is a pole is singular and is disallowed.  The central
 * meridian (which is a trivial shift of the longitude) is specified as the
 * \e lon0 argument of the LambertConformalConic::Forward and
 * LambertConformalConic::Reverse functions.  There is no provision in this
 * class for specifying a false easting or false northing or a different
 * latitude of origin.  However these are can be simply included by the
 * calling function.  For example the Pennsylvania South state coordinate
 * system (<a href="http://www.spatialreference.org/ref/epsg/3364/">
 * EPSG:3364</a>) is obtained by:
    \code
    const double
    a = GeographicLib::Constants::WGS84_a<double>(),
    f = 1/298.257222101,                      // GRS80
    lat1 = 40 + 58/60.0, lat2 = 39 + 56/60.0, // standard parallels
    k1 = 1,                                   // scale
    lat0 = 39 + 20/60.0, lon0 =-77 - 45/60.0, // origin
    fe = 600000, fn = 0;                      // false easting and northing
    // Set up basic projection
    const GeographicLib::LambertConformalConic PASouth(a, f, lat1, lat2, k1);
    double x0, y0;
    {
    // Transform origin point
    PASouth.Forward(lon0, lat0, lon0, x0, y0);
    x0 -= fe; y0 -= fn;         // Combine result with false origin
    }
    double lat, lon, x, y;
    // Sample conversion from geodetic to PASouth grid
    std::cin >> lat >> lon;
    PASouth.Forward(lon0, lat, lon, x, y);
    x -= x0; y -= y0;
    std::cout << x << " " << y << "\n";
    // Sample conversion from PASouth grid to geodetic
    std::cin >> x >> y;
    x += x0; y += y0;
    PASouth.Reverse(lon0, x, y, lat, lon);
    std::cout << lat << " " << lon << "\n";
    \endcode
 **********************************************************************/

class LambertConformalConic {
  double _a, _f, _r, _fm, _e2, _e, _e2m;
  double _sign, _n, _nc, _t0nm1, _scale, _lat0, _k0;
  double _scbet0, _tchi0, _scchi0, _psi0, _nrho0;
  static double eps_ = Geodesic._tol0_;
  static double epsx_ = _GeoMath.sq(eps_);
  static double tol_ = 0.1 * sqrt(eps_);
  // static double ahypover_ = real(numeric_limits<real>::digits) * log(real(numeric_limits<real>::radix)) + 2;
  static double ahypover_ = 53.0 * log(2.0) + 2.0;
  static final int numit_ = 5;

  static double hyp(double x) {
    return _hypot(1.0, x);
  }

  // e * atanh(e * x) = log( ((1 + e*x)/(1 - e*x))^(e/2) ) if f >= 0
  // - sqrt(-e2) * atan( sqrt(-e2) * x)                    if f < 0
  double eatanhe(double x) {
    return _f >= 0 ? _e * _GeoMath.atanh(_e * x) : -_e * atan(_e * x);
  }

  // Divided differences
  // Definition: Df(x,y) = (f(x)-f(y))/(x-y)
  // See: W. M. Kahan and R. J. Fateman,
  // Symbolic computation of divided differences,
  // SIGSAM Bull. 33(3), 7-28 (1999)
  // http://dx.doi.org/10.1145/334714.334716
  // http://www.cs.berkeley.edu/~fateman/papers/divdiff.pdf
  //
  // General rules
  // h(x) = f(g(x)): Dh(x,y) = Df(g(x),g(y))*Dg(x,y)
  // h(x) = f(x)*g(x):
  //        Dh(x,y) = Df(x,y)*g(x) + Dg(x,y)*f(y)
  //                = Df(x,y)*g(y) + Dg(x,y)*f(x)
  //                = Df(x,y)*(g(x)+g(y))/2 + Dg(x,y)*(f(x)+f(y))/2
  //
  // hyp(x) = sqrt(1+x^2): Dhyp(x,y) = (x+y)/(hyp(x)+hyp(y))
  static double Dhyp(double x, double y, double hx, double hy) {
    // hx = hyp(x)
    return (x + y) / (hx + hy);
  }

  // sn(x) = x/sqrt(1+x^2): Dsn(x,y) = (x+y)/((sn(x)+sn(y))*(1+x^2)*(1+y^2))
  static double Dsn(double x, double y, double sx, double sy) {
    // sx = x/hyp(x)
    double t = x * y;
    return t > 0 ? (x + y) * _GeoMath.sq((sx * sy) / t) / (sx + sy) : (x - y != 0 ? (sx - sy) / (x - y) : 1);
  }

  // // Dlog1p(x,y) = log1p((x-y)/(1+y)/(x-y)
  static double Dlog1p(double x, double y) {
    double t = x - y;

    if (t < 0) {
      t = -t;
      y = x;
    }

    return t != 0 ? _GeoMath.log1p(t / (1 + y)) / t : 1 / (1 + x);
  }

  // Dexp(x,y) = exp((x+y)/2) * 2*sinh((x-y)/2)/(x-y)
  static double Dexp(double x, double y) {
    double t = (x - y) / 2;
    return (t != 0 ? sinh(t) / t : 1.0) * exp((x + y) / 2);
  }

  // Dsinh(x,y) = 2*sinh((x-y)/2)/(x-y) * cosh((x+y)/2)
  //   cosh((x+y)/2) = (c+sinh(x)*sinh(y)/c)/2
  //   c=sqrt((1+cosh(x))*(1+cosh(y)))
  //   cosh((x+y)/2) = sqrt( (sinh(x)*sinh(y) + cosh(x)*cosh(y) + 1)/2 )
  static double Dsinh(double x, double y, double sx, double sy, double cx, double cy) {
    // sx = sinh(x), cx = cosh(x)
    double t = (x - y) / 2;
    return (t != 0 ? sinh(t) / t : 1.0) * sqrt((sx * sy + cx * cy + 1) / 2);
  }

  // Dasinh(x,y) = asinh((x-y)*(x+y)/(x*sqrt(1+y^2)+y*sqrt(1+x^2)))/(x-y)
  //             = asinh((x*sqrt(1+y^2)-y*sqrt(1+x^2)))/(x-y)
  static double Dasinh(double x, double y, double hx, double hy) {
    // hx = hyp(x)
    double t = x - y;
    return t != 0 ? _GeoMath.asinh(x * y > 0 ? t * (x + y) / (x * hy + y * hx) : x * hy - y * hx) / t : 1 / hx;
  }

  // Deatanhe(x,y) = eatanhe((x-y)/(1-e^2*x*y))/(x-y)
  double Deatanhe(double x, double y) {
    double t = x - y, d = 1 - _e2 * x * y;
    return t != 0 ? eatanhe(t / d) / t : _e2 / d;
  }

  /*
   * Constructor with two standard parallels.
   *
   * @param[in] a equatorial radius of ellipsoid (meters)
   * @param[in] f flattening of ellipsoid.  Setting \e f = 0 gives a sphere.
   *   Negative \e f gives a prolate ellipsoid.  If \e f > 1, set flattening
   *   to 1/\e f.
   * @param[in] stdlat1 first standard parallel (degrees).
   * @param[in] stdlat2 second standard parallel (degrees).
   * @param[in] k1 scale on the standard parallels.
   *
   * An exception is thrown if \e a or \e k0 is not positive or if \e stdlat1
   * or \e stdlat2 is not in the range [-90, 90].  In addition, if either \e
   * stdlat1 or \e stdlat2 is a pole, then an exception is thrown if \e
   * stdlat1 is not equal \e stdlat2.
   **********************************************************************/

  LambertConformalConic(double a, double f, double stdlat1, double stdlat2, double k1) {
    _a = a;
    _f = f <= 1 ? f : 1 / f;
    _r = 1 / f;
    _fm = 1 - _f;
    _e2 = _f * (2 - _f);
    _e = sqrt(_e2.abs());
    _e2m = (1 - _e2);

    if (!(_GeoMath.isfinite(_a) && _a > 0)) throw Exception("Major radius is not positive");
    if (!(_GeoMath.isfinite(_f) && _f < 1)) throw Exception("Minor radius is not positive");
    if (!(_GeoMath.isfinite(k1) && k1 > 0)) throw Exception("Scale is not positive");
    if (!(stdlat1.abs() <= 90)) throw Exception("Standard latitude 1 not in [-90, 90]");
    if (!(stdlat2.abs() <= 90)) throw Exception("Standard latitude 2 not in [-90, 90]");

    double phi1 = stdlat1 * _GeoMath.degree(), phi2 = stdlat2 * _GeoMath.degree();

    _init(sin(phi1), stdlat1.abs() != 90 ? cos(phi1) : 0, sin(phi2), stdlat2.abs() != 90 ? cos(phi2) : 0, k1);
  }

  void _init(double sphi1, double cphi1, double sphi2, double cphi2, double k1) {
    double r;
    r = _GeoMath.hypot(sphi1, cphi1);
    sphi1 /= r;
    cphi1 /= r;
    r = _GeoMath.hypot(sphi2, cphi2);
    sphi2 /= r;
    cphi2 /= r;

    bool polar = (cphi1 == 0);

    cphi1 = max(epsx_, cphi1); // Avoid singularities at poles
    cphi2 = max(epsx_, cphi2);
    // Determine hemisphere of tangent latitude
    _sign = sphi1 + sphi2 >= 0 ? 1 : -1;
    // Internally work with tangent latitude positive
    sphi1 *= _sign;
    sphi2 *= _sign;
    if (sphi1 > sphi2) {
      // swap(sphi1, sphi2);
      var _sphi = sphi2;
      sphi2 = sphi1;
      sphi1 = _sphi;
      // swap(cphi1, cphi2); // Make phi1 < phi2
      var _cphi = cphi2;
      cphi2 = cphi1;
      cphi1 = _cphi;
    }
    double tphi1 = sphi1 / cphi1, tphi2 = sphi2 / cphi2, tphi0;
    //
    // Snyder: 15-8: n = (log(m1) - log(m2))/(log(t1)-log(t2))
    //
    // m = cos(bet) = 1/sec(bet) = 1/sqrt(1+tan(bet)^2)
    // bet = parametric lat, tan(bet) = (1-f)*tan(phi)
    //
    // t = tan(pi/4-chi/2) = 1/(sec(chi) + tan(chi)) = sec(chi) - tan(chi)
    // log(t) = -asinh(tan(chi)) = -psi
    // chi = conformal lat
    // tan(chi) = tan(phi)*cosh(xi) - sinh(xi)*sec(phi)
    // xi = eatanhe(sin(phi)), eatanhe(x) = e * atanh(e*x)
    //
    // n = (log(sec(bet2))-log(sec(bet1)))/(asinh(tan(chi2))-asinh(tan(chi1)))
    //
    // Let log(sec(bet)) = b(tphi), asinh(tan(chi)) = c(tphi)
    // Then n = Db(tphi2, tphi1)/Dc(tphi2, tphi1)
    // In limit tphi2 -> tphi1, n -> sphi1
    //
    double tbet1 = _fm * tphi1, scbet1 = hyp(tbet1), tbet2 = _fm * tphi2, scbet2 = hyp(tbet2);
    double scphi1 = 1 / cphi1,
        xi1 = eatanhe(sphi1),
        shxi1 = sinh(xi1),
        chxi1 = hyp(shxi1),
        tchi1 = chxi1 * tphi1 - shxi1 * scphi1,
        scchi1 = hyp(tchi1),
        scphi2 = 1 / cphi2,
        xi2 = eatanhe(sphi2),
        shxi2 = sinh(xi2),
        chxi2 = hyp(shxi2),
        tchi2 = chxi2 * tphi2 - shxi2 * scphi2,
        scchi2 = hyp(tchi2),
        psi1 = _GeoMath.asinh(tchi1);
    if (tphi2 - tphi1 != 0) {
      // Db(tphi2, tphi1)
      double num = Dlog1p(_GeoMath.sq(tbet2) / (1 + scbet2), _GeoMath.sq(tbet1) / (1 + scbet1)) *
          Dhyp(tbet2, tbet1, scbet2, scbet1) *
          _fm;
      // Dc(tphi2, tphi1)
      double den = Dasinh(tphi2, tphi1, scphi2, scphi1) - Deatanhe(sphi2, sphi1) * Dsn(tphi2, tphi1, sphi2, sphi1);
      _n = num / den;

      if (_n < 0.25)
        _nc = sqrt((1 - _n) * (1 + _n));
      else {
        // Compute nc = cos(phi0) = sqrt((1 - n) * (1 + n)), evaluating 1 - n
        // carefully.  First write
        //
        // Dc(tphi2, tphi1) * (tphi2 - tphi1)
        //   = log(tchi2 + scchi2) - log(tchi1 + scchi1)
        //
        // then den * (1 - n) =
        // (log((tchi2 + scchi2)/(2*scbet2)) - log((tchi1 + scchi1)/(2*scbet1)))
        // / (tphi2 - tphi1)
        // = Dlog1p(a2, a1) * (tchi2+scchi2 + tchi1+scchi1)/(4*scbet1*scbet2)
        //   * fm * Q
        //
        // where
        // a1 = ( (tchi1 - scbet1) + (scchi1 - scbet1) ) / (2 * scbet1)
        // Q = ((scbet2 + scbet1)/fm)/((scchi2 + scchi1)/D(tchi2, tchi1))
        //     - (tbet2 + tbet1)/(scbet2 + scbet1)
        double t;
        // s1 = (scbet1 - scchi1) * (scbet1 + scchi1)
        double s1 =
                (tphi1 * (2 * shxi1 * chxi1 * scphi1 - _e2 * tphi1) - _GeoMath.sq(shxi1) * (1 + 2 * _GeoMath.sq(tphi1))),
            s2 = (tphi2 * (2 * shxi2 * chxi2 * scphi2 - _e2 * tphi2) - _GeoMath.sq(shxi2) * (1 + 2 * _GeoMath.sq(tphi2))),
            // t1 = scbet1 - tchi1
            t1 = tchi1 < 0 ? scbet1 - tchi1 : (s1 + 1) / (scbet1 + tchi1),
            t2 = tchi2 < 0 ? scbet2 - tchi2 : (s2 + 1) / (scbet2 + tchi2),
            a2 = -(s2 / (scbet2 + scchi2) + t2) / (2 * scbet2),
            a1 = -(s1 / (scbet1 + scchi1) + t1) / (2 * scbet1);
        t = Dlog1p(a2, a1) / den;

        // multiply by (tchi2 + scchi2 + tchi1 + scchi1)/(4*scbet1*scbet2) * fm
        t *= (((tchi2 >= 0 ? scchi2 + tchi2 : 1 / (scchi2 - tchi2)) +
                    (tchi1 >= 0 ? scchi1 + tchi1 : 1 / (scchi1 - tchi1))) /
                (4 * scbet1 * scbet2)) *
            _fm;

        // Rewrite
        // Q = (1 - (tbet2 + tbet1)/(scbet2 + scbet1)) -
        //     (1 - ((scbet2 + scbet1)/fm)/((scchi2 + scchi1)/D(tchi2, tchi1)))
        //   = tbm - tam
        // where
        double tbm = (((tbet1 > 0 ? 1 / (scbet1 + tbet1) : scbet1 - tbet1) +
                (tbet2 > 0 ? 1 / (scbet2 + tbet2) : scbet2 - tbet2)) /
            (scbet1 + scbet2));

        // tam = (1 - ((scbet2+scbet1)/fm)/((scchi2+scchi1)/D(tchi2, tchi1)))
        //
        // Let
        //   (scbet2 + scbet1)/fm = scphi2 + scphi1 + dbet
        //   (scchi2 + scchi1)/D(tchi2, tchi1) = scphi2 + scphi1 + dchi
        // then
        //   tam = D(tchi2, tchi1) * (dchi - dbet) / (scchi1 + scchi2)
        double
            // D(tchi2, tchi1)
            dtchi = den / Dasinh(tchi2, tchi1, scchi2, scchi1),
            // (scbet2 + scbet1)/fm - (scphi2 + scphi1)
            dbet = (_e2 / _fm) * (1 / (scbet2 + _fm * scphi2) + 1 / (scbet1 + _fm * scphi1));

        // dchi = (scchi2 + scchi1)/D(tchi2, tchi1) - (scphi2 + scphi1)
        // Let
        //    tzet = chxiZ * tphi - shxiZ * scphi
        //    tchi = tzet + nu
        //    scchi = sczet + mu
        // where
        //    xiZ = eatanhe(1), shxiZ = sinh(xiZ), chxiZ = cosh(xiZ)
        //    nu =   scphi * (shxiZ - shxi) - tphi * (chxiZ - chxi)
        //    mu = - scphi * (chxiZ - chxi) + tphi * (shxiZ - shxi)
        // then
        // dchi = ((mu2 + mu1) - D(nu2, nu1) * (scphi2 +  scphi1)) /
        //         D(tchi2, tchi1)
        double xiZ = eatanhe(1.0),
            shxiZ = sinh(xiZ),
            chxiZ = hyp(shxiZ),
            // These are differences not divided differences
            // dxiZ1 = xiZ - xi1; dshxiZ1 = shxiZ - shxi; dchxiZ1 = chxiZ - chxi
            dxiZ1 = Deatanhe(1.0, sphi1) / (scphi1 * (tphi1 + scphi1)),
            dxiZ2 = Deatanhe(1.0, sphi2) / (scphi2 * (tphi2 + scphi2)),
            dshxiZ1 = Dsinh(xiZ, xi1, shxiZ, shxi1, chxiZ, chxi1) * dxiZ1,
            dshxiZ2 = Dsinh(xiZ, xi2, shxiZ, shxi2, chxiZ, chxi2) * dxiZ2,
            dchxiZ1 = Dhyp(shxiZ, shxi1, chxiZ, chxi1) * dshxiZ1,
            dchxiZ2 = Dhyp(shxiZ, shxi2, chxiZ, chxi2) * dshxiZ2,
            // mu1 + mu2
            amu12 = (-scphi1 * dchxiZ1 + tphi1 * dshxiZ1 - scphi2 * dchxiZ2 + tphi2 * dshxiZ2),
            // D(xi2, xi1)
            dxi = Deatanhe(sphi1, sphi2) * Dsn(tphi2, tphi1, sphi2, sphi1),
            // D(nu2, nu1)
            dnu12 = ((_f * 4 * scphi2 * dshxiZ2 > _f * scphi1 * dshxiZ1
                    // Use divided differences
                    ? (dshxiZ1 + dshxiZ2) / 2 * Dhyp(tphi1, tphi2, scphi1, scphi2) -
                        ((scphi1 + scphi2) / 2 * Dsinh(xi1, xi2, shxi1, shxi2, chxi1, chxi2) * dxi)
                    // Use ratio of differences
                    : (scphi2 * dshxiZ2 - scphi1 * dshxiZ1) / (tphi2 - tphi1)) +
                ((tphi1 + tphi2) /
                    2 *
                    Dhyp(shxi1, shxi2, chxi1, chxi2) *
                    Dsinh(xi1, xi2, shxi1, shxi2, chxi1, chxi2) *
                    dxi) -
                (dchxiZ1 + dchxiZ2) / 2),
            // dtchi * dchi
            dchia = (amu12 - dnu12 * (scphi2 + scphi1)),
            tam = (dchia - dtchi * dbet) / (scchi1 + scchi2);
        t *= tbm - tam;
        _nc = sqrt(max(0.0, t) * (1 + _n));
      }

      double r = _GeoMath.hypot(_n, _nc);
      _n /= r;
      _nc /= r;
      tphi0 = _n / _nc;
    } else {
      tphi0 = tphi1;
      _nc = 1 / hyp(tphi0);
      _n = tphi0 * _nc;
      if (polar) _nc = 0;
    }

    _scbet0 = hyp(_fm * tphi0);
    double shxi0 = sinh(eatanhe(_n));
    _tchi0 = tphi0 * hyp(shxi0) - shxi0 * hyp(tphi0);
    _scchi0 = hyp(_tchi0);
    _psi0 = _GeoMath.asinh(_tchi0);

    _lat0 = atan(_sign * tphi0) / _GeoMath.degree();
    _t0nm1 = _GeoMath.expm1(-_n * _psi0); // Snyder's t0^n - 1
    // a * k1 * m1/t1^n = a * k1 * m2/t2^n = a * k1 * n * (Snyder's F)
    // = a * k1 / (scbet1 * exp(-n * psi1))
    _scale = _a *
        k1 /
        scbet1 *
        // exp(n * psi1) = exp(- (1 - n) * psi1) * exp(psi1)
        // with (1-n) = nc^2/(1+n) and exp(-psi1) = scchi1 + tchi1
        exp(-(_GeoMath.sq(_nc) / (1 + _n)) * psi1) *
        (tchi1 >= 0 ? scchi1 + tchi1 : 1 / (scchi1 - tchi1));
    // Scale at phi0 = k0 = k1 * (scbet0*exp(-n*psi0))/(scbet1*exp(-n*psi1))
    //                    = k1 * scbet0/scbet1 * exp(n * (psi1 - psi0))
    // psi1 - psi0 = Dasinh(tchi1, tchi0) * (tchi1 - tchi0)
    _k0 = k1 *
        (_scbet0 / scbet1) *
        exp(-(_GeoMath.sq(_nc) / (1 + _n)) * Dasinh(tchi1, _tchi0, scchi1, _scchi0) * (tchi1 - _tchi0)) *
        (tchi1 >= 0 ? scchi1 + tchi1 : 1 / (scchi1 - tchi1)) /
        (_scchi0 + _tchi0);
    _nrho0 = polar ? 0 : _a * _k0 / _scbet0;
  }

  /*
   * Forward projection, from geographic to Lambert conformal conic.
   *
   * @param[in] lon0 central meridian longitude (degrees).
   * @param[in] lat latitude of point (degrees).
   * @param[in] lon longitude of point (degrees).
   * @param[out] x easting of point (meters).
   * @param[out] y northing of point (meters).
   * @param[out] gamma meridian convergence at point (degrees).
   * @param[out] k scale of projection at point.
   *
   * The latitude origin is given by LambertConformalConic::LatitudeOrigin().
   * No false easting or northing is added and \e lat should be in the range
   * [-90, 90]; \e lon and \e lon0 should be in the range [-180, 360].  The
   * error in the projection is less than about 10 nm (true distance) and the
   * errors in the meridian convergence and scale are consistent with this.
   * The values of \e x and \e y returned for points which project to
   * infinity (i.e., one or both of the poles) will be large but finite.
   **********************************************************************/

  GeographicLibLambert forward(double lon0, double lat, double lon) {
    if (lon - lon0 >= 180)
      lon -= lon0 + 360;
    else if (lon - lon0 < -180)
      lon -= lon0 - 360;
    else
      lon -= lon0;

    lat *= _sign;
    // From Snyder, we have
    //
    // theta = n * lambda
    // x = rho * sin(theta)
    //   = (nrho0 + n * drho) * sin(theta)/n
    // y = rho0 - rho * cos(theta)
    //   = nrho0 * (1-cos(theta))/n - drho * cos(theta)
    //
    // where nrho0 = n * rho0, drho = rho - rho0
    // and drho is evaluated with divided differences
    double lam = lon * _GeoMath.degree(),
        phi = lat * _GeoMath.degree(),
        sphi = sin(phi),
        cphi = lat.abs() != 90 ? cos(phi) : epsx_,
        tphi = sphi / cphi,
        tbet = _fm * tphi,
        scbet = hyp(tbet),
        scphi = 1 / cphi,
        shxi = sinh(eatanhe(sphi)),
        tchi = hyp(shxi) * tphi - shxi * scphi,
        scchi = hyp(tchi),
        psi = _GeoMath.asinh(tchi),
        theta = _n * lam,
        stheta = sin(theta),
        ctheta = cos(theta),
        dpsi = Dasinh(tchi, _tchi0, scchi, _scchi0) * (tchi - _tchi0),
        drho = -_scale *
            (2 * _nc < 1 && dpsi != 0
                ? (exp(_GeoMath.sq(_nc) / (1 + _n) * psi) * (tchi > 0 ? 1 / (scchi + tchi) : (scchi - tchi)) -
                        (_t0nm1 + 1)) /
                    (-_n)
                : Dexp(-_n * psi, -_n * _psi0) * dpsi);

    var x = (_nrho0 + _n * drho) * (_n != 0 ? stheta / _n : lam);
    var y = _nrho0 * (_n != 0 ? (ctheta < 0 ? 1 - ctheta : _GeoMath.sq(stheta) / (1 + ctheta)) / _n : 0) - drho * ctheta;
    var k = _k0 *
        (scbet / _scbet0) /
        (exp(-(_GeoMath.sq(_nc) / (1 + _n)) * dpsi) *
            (tchi >= 0 ? scchi + tchi : 1 / (scchi - tchi)) /
            (_scchi0 + _tchi0));
    y *= _sign;
    var gamma = _sign * theta / _GeoMath.degree();

    return GeographicLibLambert(x, y, gamma, k);
  }

  /*
   * Reverse projection, from Lambert conformal conic to geographic.
   *
   * @param[in] lon0 central meridian longitude (degrees).
   * @param[in] x easting of point (meters).
   * @param[in] y northing of point (meters).
   * @param[out] lat latitude of point (degrees).
   * @param[out] lon longitude of point (degrees).
   * @param[out] gamma meridian convergence at point (degrees).
   * @param[out] k scale of projection at point.
   *
   * The latitude origin is given by LambertConformalConic::LatitudeOrigin().
   * No false easting or northing is added.  \e lon0 should be in the range
   * [-180, 360].  The value of \e lon returned is in the range [-180, 180).
   * The error in the projection is less than about 10 nm (true distance) and
   * the errors in the meridian convergence and scale are consistent with
   * this.
   **********************************************************************/

  GeographicLibLambertLatLon Reverse(double lon0, double x, double y) {
    // From Snyder, we have
    //
    //        x = rho * sin(theta)
    // rho0 - y = rho * cos(theta)
    //
    // rho = hypot(x, rho0 - y)
    // drho = (n*x^2 - 2*y*nrho0 + n*y^2)/(hypot(n*x, nrho0-n*y) + nrho0)
    // theta = atan2(n*x, nrho0-n*y)
    //
    // From drho, obtain t^n-1
    // psi = -log(t), so
    // dpsi = - Dlog1p(t^n-1, t0^n-1) * drho / scale
    y *= _sign;
    double nx = _n * x,
        ny = _n * y,
        y1 = _nrho0 - ny,
        den = _GeoMath.hypot(nx, y1) + _nrho0, // 0 implies origin with polar aspect
        drho = den != 0 ? (x * nx - 2 * y * _nrho0 + y * ny) / den : 0,
        tnm1 = _t0nm1 + _n * drho / _scale,
        dpsi = (den == 0 ? 0 : (tnm1 + 1 != 0 ? -Dlog1p(tnm1, _t0nm1) * drho / _scale : ahypover_));

    double tchi;
    if (2 * _n <= 1) {
      // tchi = sinh(psi)
      double psi = _psi0 + dpsi,
          tchia = sinh(psi),
          scchi = hyp(tchia),
          dtchi = Dsinh(psi, _psi0, tchia, _tchi0, scchi, _scchi0) * dpsi;
      tchi = _tchi0 + dtchi; // Update tchi using divided difference
    } else {
      // tchi = sinh(-1/n * log(tn))
      //      = sinh((1-1/n) * log(tn) - log(tn))
      //      = + sinh((1-1/n) * log(tn)) * cosh(log(tn))
      //        - cosh((1-1/n) * log(tn)) * sinh(log(tn))
      // (1-1/n) = - nc^2/(n*(1+n))
      // cosh(log(tn)) = (tn + 1/tn)/2; sinh(log(tn)) = (tn - 1/tn)/2
      double tn = tnm1 + 1 == 0 ? epsx_ : tnm1 + 1,
          sh = sinh(-_GeoMath.sq(_nc) / (_n * (1 + _n)) * (2 * tn > 1 ? _GeoMath.log1p(tnm1) : log(tn)));
      tchi = sh * (tn + 1 / tn) / 2 - hyp(sh) * (tnm1 * (tn + 1) / tn) / 2;
    }

    // Use Newton's method to solve for tphi
    double tphi = tchi, stol = tol_ * max(1.0, tchi.abs());
    // min iterations = 1, max iterations = 2; mean = 1.99
    for (int i = 0; i < numit_; ++i) {
      double scphi = hyp(tphi),
          shxi = sinh(eatanhe(tphi / scphi)),
          tchia = hyp(shxi) * tphi - shxi * scphi,
          dtphi = (tchi - tchia) * (1 + _e2m * _GeoMath.sq(tphi)) / (_e2m * scphi * hyp(tchia));
      tphi += dtphi;
      if (!(dtphi.abs() >= stol)) break;
    }
    // log(t) = -asinh(tan(chi)) = -psi
    var gamma = atan2(nx, y1);
    double phi = _sign * atan(tphi), scbet = hyp(_fm * tphi), scchi = hyp(tchi), lam = _n != 0 ? gamma / _n : x / y1;
    var lat = phi / _GeoMath.degree();
    var lon = lam / _GeoMath.degree();

    // Avoid losing a bit of accuracy in lon (assuming lon0 is an integer)
    if (lon + lon0 >= 180)
      lon += lon0 - 360;
    else if (lon + lon0 < -180)
      lon += lon0 + 360;
    else
      lon += lon0;

    var k = _k0 *
        (scbet / _scbet0) /
        (exp(_nc != 0 ? -(_GeoMath.sq(_nc) / (1 + _n)) * dpsi : 0) *
            (tchi >= 0 ? scchi + tchi : 1 / (scchi - tchi)) /
            (_scchi0 + _tchi0));
    gamma /= _sign * _GeoMath.degree();

    return GeographicLibLambertLatLon(lat, lon, gamma, k);
  }
} // class GeographicLib

class GeographicLibLambert {
  final double x;
  final double y;
  final double gamma;
  final double k;

  GeographicLibLambert(this.x, this.y, this.gamma, this.k);
}

class GeographicLibLambertLatLon {
  final double lat;
  final double lon;
  final double gamma;
  final double k;

  GeographicLibLambertLatLon(this.lat, this.lon, this.gamma, this.k);
}
