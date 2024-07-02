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

const bool _GEOGRAPHICLIB_PANIC = false;
const int _GEOGRAPHICLIB_PRECISION = 3;

/*
 * Mathematical functions needed by GeographicLib.
 * <p>
 * Define mathematical functions and constants so that any version of Java
 * can be used.
 **********************************************************************/
// ignore_for_file: unused_field
// ignore_for_file: unused_element
class _GeoMath {
  /*
   * The number of binary digits in the fraction of a double precision
   * number (equivalent to C++'s {@code numeric_limits<double>::digits}).
   **********************************************************************/
  static const int digits = 53;

  /**
   * The constants defining the meaning of degrees, minutes, and seconds, for
   * angles.  Read the
   * constants as follows (for example): \e ms = 60 is the ratio 1 minute / 1
   * second.  The abbreviations are
   * - \e t a whole turn (360&deg;)
   * - \e h a half turn (180&deg;)
   * - \e q a quarter turn (a right angle = 90&deg;)
   * - \e d a degree
   * - \e m a minute
   * - \e s a second
   * .
   * Note that degree() is ratio 1 degree / 1 radian, thus, for example,
   * Math::degree() * Math::qd is the ratio 1 quarter turn / 1 radian =
   * &pi;/2.
   *
   * Defining all these in one place would mean that it's simple to convert
   * to the centesimal system for measuring angles.  The DMS class assumes
   * that Math::dm and Math::ms are less than or equal to 100 (so that two
   * digits suffice for the integer parts of the minutes and degrees
   * components of an angle).  Switching to the centesimal convention will
   * break most of the tests.  Also the normal degree definition is baked
   * into some classes, e.g., UTMUPS, MGRS, Georef, Geohash, etc.
   **********************************************************************/

  static const int qd = 90;

  ///< degrees per quarter turn
  static const int dm = 60;

  ///< minutes per degree
  static const int ms = 60;

  ///< seconds per minute
  static const int hd = 2 * qd;

  ///< degrees per half turn
  static const int td = 2 * hd;

  ///< degrees per turn
  static const int ds = dm * ms;

  ///< seconds per degree

  /*
   * Square a number.
   * <p>
   * @param x the argument.
   * @return <i>x</i><sup>2</sup>.
   **********************************************************************/
  static double sq(double x) {
    return x * x;
  }

  /*
   * The inverse hyperbolic sine function.  This is defined in terms of
   * Math::log1p(\e x) in order to maintain accuracy near \e x = 0.  In
   * addition, the odd parity of the function is enforced.
   *
   * @param[in] x
   * @return asinh(\e x).
   **********************************************************************/
  static double asinh(double x) {
    double y = x.abs(); // Enforce odd parity
    y = log1p(y * (1 + y / (hypot(1.0, y) + 1)));
    return x < 0 ? -y : y;
  }

  static double pi() {
    return atan2(0.0, -1.0);
  }

  static double degree() {
    return pi() / 180.0;
  }

  static double log1p(double x) {
    if (x.isInfinite && !x.isNegative) {
      return x;
    } else {
      final double u = 1 + x;
      final double d = u - 1;

      if (d == 0) {
        return x;
      } else {
        return log(u) * x / d;
      }
    }
  }

  /*
   * The inverse hyperbolic tangent function.  This is defined in terms of
   * Math.log1p(<i>x</i>) in order to maintain accuracy near <i>x</i> = 0.
   * In addition, the odd parity of the function is enforced.
   * <p>
   * @param x the argument.
   * @return atanh(<i>x</i>).
   **********************************************************************/
  static double atanh(double x) {
    double y = x.abs(); // Enforce odd parity
    y = log1p(2 * y / (1 - y)) / 2;
    return x > 0 ? y : (x < 0 ? -y : x);
  }

  /*
   * Normalize a sine cosine pair.
   * <p>
   * @param p return parameter for normalized quantities with sinx<sup>2</sup>
   *   + cosx<sup>2</sup> = 1.
   * @param sinx the sine.
   * @param cosx the cosine.
   **********************************************************************/
  static void norm(_Pair p, double sinx, double cosx) {
    double r = hypot(sinx, cosx);
    p.first = sinx / r;
    p.second = cosx / r;
  }

  /*
   * The error-free sum of two numbers.
   * <p>
   * @param u the first number in the sum.
   * @param v the second number in the sum.
   * @param p output Pair(<i>s</i>, <i>t</i>) with <i>s</i> = round(<i>u</i> +
   *   <i>v</i>) and <i>t</i> = <i>u</i> + <i>v</i> - <i>s</i>.
   * <p>
   * See D. E. Knuth, TAOCP, Vol 2, 4.2.2, Theorem B.
   **********************************************************************/
  static _Pair sum(double u, double v, double t) {
    double s = u + v;
    double up = s - v;
    double vpp = s - up;
    up -= u;
    vpp -= v;
    // if s = 0, then t = 0 and give t the same sign as s
    // mpreal needs T(0) here
    t = s != 0 ? 0.0 - (up + vpp) : s;
    // u + v =       s      + t
    //       = round(u + v) + t
    return _Pair(s, t);
  }

  /*
   * The hypotenuse function avoiding underflow and overflow.
   *
   * @param[in] x
   * @param[in] y
   * @return sqrt(\e x<sup>2</sup> + \e y<sup>2</sup>).
   **********************************************************************/
  static double hypot(double x, double y) {
    x = x.abs();
    y = y.abs();
    double a = max(x, y), b = min(x, y) / (a != 0.0 ? a : 1);
    return a * sqrt(1 + b * b);
  }

  /*
   * exp(\e x) - 1 accurate near \e x = 0.  This is taken from
   * N. J. Higham, Accuracy and Stability of Numerical Algorithms, 2nd
   * Edition (SIAM, 2002), Sec 1.14.1, p 19.
   *
   * @param[in] x
   * @return exp(\e x) - 1.
   **********************************************************************/
  static double expm1(double x) {
    double y = exp(x), z = y - 1;
    // The reasoning here is similar to that for log1p.  The expression
    // mathematically reduces to exp(x) - 1, and the factor z/log(y) = (y -
    // 1)/log(y) is a slowly varying quantity near y = 1 and is accurately
    // computed.
    return x.abs() > 1
        ? z
        : z == 0
            ? x
            : x * z / log(y);
  }

  /*
   * Evaluate a polynomial.
   * <p>
   * @param N the order of the polynomial.
   * @param p the coefficient array (of size <i>N</i> + <i>s</i> + 1 or more).
   * @param s starting index for the array.f
   * @param x the variable.
   * @return the value of the polynomial.
   * <p>
   * Evaluate <i>y</i> = &sum;<sub><i>n</i>=0..<i>N</i></sub>
   * <i>p</i><sub><i>s</i>+<i>n</i></sub>
   * <i>x</i><sup><i>N</i>&minus;<i>n</i></sup>.  Return 0 if <i>N</i> &lt; 0.
   * Return <i>p</i><sub><i>s</i></sub>, if <i>N</i> = 0 (even if <i>x</i> is
   * infinite or a nan).  The evaluation uses Horner's method.
   **********************************************************************/
  static double polyval(int N, List<double> p, int s, double x) {
    double y = N < 0 ? 0 : p[s++];
    while (--N >= 0) {
      y = y * x + p[s++];
    }
    return y;
  }

  /*
   * Coarsen a value close to zero.
   * <p>
   * @param x the argument
   * @return the coarsened value.
   * <p>
   * This makes the smallest gap in <i>x</i> = 1/16 &minus; nextafter(1/16, 0)
   * = 1/2<sup>57</sup> for reals = 0.7 pm on the earth if <i>x</i> is an angle
   * in degrees.  (This is about 1000 times more resolution than we get with
   * angles around 90 degrees.)  We use this to avoid having to deal with near
   * singular cases when <i>x</i> is non-zero but tiny (e.g.,
   * 10<sup>&minus;200</sup>).  This converts &minus;0 to +0; however tiny
   * negative numbers get converted to &minus;0.
   **********************************************************************/
  static double AngRound(double x) {
    const double z = 1 / 16.0;
    if (x == 0) return 0;
    double y = x.abs();
    // The compiler mustn't "simplify" z - (z - y) to y
    y = y < z ? z - (z - y) : y;
    return x < 0 ? -y : y;
  }

  /*
   * The remainder function.
   * <p>
   * @param x the numerator of the division
   * @param y the denominator of the division
   * @return the remainder in the range [&minus;<i>y</i>/2, <i>y</i>/2].
   * <p>
   * The range of <i>x</i> is unrestricted; <i>y</i> must be positive.
   **********************************************************************/
  static double remainder(double x, double y) {
    x = x % y;
    return x < -y / 2 ? x + y : (x < y / 2 ? x : x - y);
  }

  /*
   * Normalize an angle.
   * <p>
   * @param x the angle in degrees.
   * @return the angle reduced to the range [&minus;180&deg;, 180&deg;).
   * <p>
   * The range of <i>x</i> is unrestricted.
   **********************************************************************/
  static double AngNormalize(double x) {
    x = remainder(x, 360.0);
    return x == -180 ? 180 : x;
  }

  /*
   * Normalize a latitude.
   * <p>
   * @param x the angle in degrees.
   * @return x if it is in the range [&minus;90&deg;, 90&deg;], otherwise
   *   return NaN.
   **********************************************************************/
  static double LatFix(double x) {
    return x.abs() > 90 ? double.nan : x;
  }

  /**
   * The exact difference of two angles reduced to
   * [&minus;180&deg;, 180&deg;].
   *
   * @tparam T the type of the arguments and returned value.
   * @param[in] x the first angle in degrees.
   * @param[in] y the second angle in degrees.
   * @param[out] e the error term in degrees.
   * @return \e d, the truncated value of \e y &minus; \e x.
   *
   * This computes \e z = \e y &minus; \e x exactly, reduced to
   * [&minus;180&deg;, 180&deg;]; and then sets \e z = \e d + \e e where \e d
   * is the nearest representable number to \e z and \e e is the truncation
   * error.  If \e z = &plusmn;0&deg; or &plusmn;180&deg;, then the sign of
   * \e d is given by the sign of \e y &minus; \e x.  The maximum absolute
   * value of \e e is 2<sup>&minus;26</sup> (for doubles).
   **********************************************************************/
  static _Pair AngDiffError(double x, double y) {
    // Use remainder instead of AngNormalize, since we treat boundary cases
    // later taking account of the error
    var _d = sum(remainder(-x, td.toDouble()), remainder(y, td.toDouble()), double.nan);
    double d = _d.first;
    double e = _d.second;
    // This second sum can only change d if abs(d) < 128, so don't need to
    // apply remainder yet again.
    _d = sum(remainder(d, td.toDouble()), e, e);
    d = _d.first;
    e = _d.second;
    // Fix the sign if d = -180, 0, 180.
    if (d == 0 || d.abs() == hd) {
      // If e == 0, take sign from y - x
      // else (e != 0, implies d = +/-180), d and e must have opposite signs
      d = _copySign(d, e == 0 ? y - x : -e);
    }
    return _Pair(d, e);
  }

  /**
   * Difference of two angles reduced to [&minus;180&deg;, 180&deg;]
   *
   * @tparam T the type of the arguments and returned value.
   * @param[in] x the first angle in degrees.
   * @param[in] y the second angle in degrees.
   * @return \e y &minus; \e x, reduced to the range [&minus;180&deg;,
   *   180&deg;].
   *
   * The result is equivalent to computing the difference exactly, reducing
   * it to [&minus;180&deg;, 180&deg;] and rounding the result.
   **********************************************************************/
  static double AngDiff(double x, double y) {
    return AngDiffError(x, y).first;
  }

  /*
   * Evaluate the sine and cosine function with the argument in degrees
   *
   * @param p return Pair(<i>s</i>, <i>t</i>) with <i>s</i> = sin(<i>x</i>) and
   *   <i>c</i> = cos(<i>x</i>).
   * @param x in degrees.
   * <p>
   * The results obey exactly the elementary properties of the trigonometric
   * functions, e.g., sin 9&deg; = cos 81&deg; = &minus; sin 123456789&deg;.
   **********************************************************************/
  static void sincosd(_Pair p, double x) {
    // In order to minimize round-off errors, this function exactly reduces
    // the argument to the range [-45, 45] before converting it to radians.
    double r;
    int q;
    r = x % 360.0;
    q = (r / 90).round().toInt(); // If r is NaN this returns 0
    r -= 90 * q;
    // now abs(r) <= 45
    r = _toRadians(r);
    // Possibly could call the gnu extension sincos
    double s = sin(r), c = cos(r);
    double sinx, cosx;
    switch (q & 3) {
      case 0:
        sinx = s;
        cosx = c;
        break;
      case 1:
        sinx = c;
        cosx = -s;
        break;
      case 2:
        sinx = -s;
        cosx = -c;
        break;
      default:
        sinx = -c;
        cosx = s;
        break; // case 3
    }
    if (x != 0) {
      sinx += 0.0;
      cosx += 0.0;
    }
    p.first = sinx;
    p.second = cosx;
  }

  /**
   * Evaluate the atan function with the result in degrees
   *
   * @tparam T the type of the argument and the returned value.
   * @param[in] x
   * @return atan(<i>x</i>) in degrees.
   **********************************************************************/
  static double atand(double x) {
    return atan2d(x, 1.0);
  }

  /*
   * Evaluate the atan2 function with the result in degrees
   *
   * @param y the sine of the angle
   * @param x the cosine of the angle
   * @return atan2(<i>y</i>, <i>x</i>) in degrees.
   * <p>
   * The result is in the range (&minus;180&deg; 180&deg;].  N.B.,
   * atan2d(&plusmn;0, &minus;1) = +180&deg;; atan2d(&minus;&epsilon;,
   * &minus;1) = &minus;180&deg;, for &epsilon; positive and tiny;
   * atan2d(&plusmn;0, 1) = &plusmn;0&deg;.
   **********************************************************************/
  static double atan2d(double y, double x) {
    // In order to minimize round-off errors, this function rearranges the
    // arguments so that result of atan2 is in the range [-pi/4, pi/4] before
    // converting it to degrees and mapping the result to the correct
    // quadrant.
    int q = 0;
    if (y.abs() > x.abs()) {
      double _h = x;
      x = y;
      y = _h;
      q = 2;
    }
    if (x < 0) {
      x = -x;
      ++q;
    }
    // here x >= 0 and x >= abs(y), so angle is in [-pi/4, pi/4]
    double ang = atan2(y, x) / degree();
    switch (q) {
      // Note that atan2d(-0.0, 1.0) will return -0.  However, we expect that
      // atan2d will not be called with y = -0.  If need be, include
      //
      //   case 0: ang = 0 + ang; break;
      //
      // and handle mpfr as in AngRound.
      case 1:
        ang = _copySign(hd.toDouble(), y) - ang;
        break;
      case 2:
        ang = qd - ang;
        break;
      case 3:
        ang = -qd + ang;
        break;
      default:
        break;
    }
    return ang;
  }

  /*
   * Test for finiteness.
   * <p>
   * @param x the argument.
   * @return true if number is finite, false if NaN or infinite.
   **********************************************************************/
  static bool isfinite(double x) {
    return x.abs() <= double.maxFinite;
  }

  static double tand(double x) {
    double overflow = 1 / sq(practical_epsilon);
    _Pair p = _Pair();
    sincosd(p, x);
    double s = p.first;
    double c = p.second;
    // http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1950.pdf
    double r = s / c; // special values from F.10.1.14
    // With C++17 this becomes clamp(s / c, -overflow, overflow);
    // Use max/min here (instead of fmax/fmin) to preserve NaN
    return min(max(r, -overflow), overflow);
  }

  static double eatanhe(double x, double es) {
    return es > 0 ? es * atanh(es * x) : -es * atan(es * x);
  }

  /**
   * tan&chi; in terms of tan&phi;
   *
   * @tparam T the type of the argument and the returned value.
   * @param[in] tau &tau; = tan&phi;
   * @param[in] es the signed eccentricity = sign(<i>e</i><sup>2</sup>)
   *   sqrt(|<i>e</i><sup>2</sup>|)
   * @return &tau;&prime; = tan&chi;
   *
   * See Eqs. (7--9) of
   * C. F. F. Karney,
   * <a href="https://doi.org/10.1007/s00190-011-0445-3">
   * Transverse Mercator with an accuracy of a few nanometers,</a>
   * J. Geodesy 85(8), 475--485 (Aug. 2011)
   * (preprint
   * <a href="https://arxiv.org/abs/1002.1417">arXiv:1002.1417</a>).
   **********************************************************************/
  static double taupf(double tau, double es) {
    // Need this test, otherwise tau = +/-inf gives taup = nan.
    if (isfinite(tau)) {
      double tau1 = hypot(1.0, tau), sig = _sinh(eatanhe(tau / tau1, es));
      return hypot(1.0, sig) * tau - sig * tau1;
    } else {
      return tau;
    }
  }

  /**
   * tan&phi; in terms of tan&chi;
   *
   * @tparam T the type of the argument and the returned value.
   * @param[in] taup &tau;&prime; = tan&chi;
   * @param[in] es the signed eccentricity = sign(<i>e</i><sup>2</sup>)
   *   sqrt(|<i>e</i><sup>2</sup>|)
   * @return &tau; = tan&phi;
   *
   * See Eqs. (19--21) of
   * C. F. F. Karney,
   * <a href="https://doi.org/10.1007/s00190-011-0445-3">
   * Transverse Mercator with an accuracy of a few nanometers,</a>
   * J. Geodesy 85(8), 475--485 (Aug. 2011)
   * (preprint
   * <a href="https://arxiv.org/abs/1002.1417">arXiv:1002.1417</a>).
   **********************************************************************/
  static double tauf(double taup, double es) {
    const int numit = 5;
    // min iterations = 1, max iterations = 2; mean = 1.95
    double tol = sqrt(practical_epsilon) / 10;
    double taumax = 2 / sqrt(practical_epsilon);
    double e2m = 1 - sq(es),
        // To lowest order in e^2, taup = (1 - e^2) * tau = _e2m * tau; so use
        // tau = taup/e2m as a starting guess. Only 1 iteration is needed for
        // |lat| < 3.35 deg, otherwise 2 iterations are needed.  If, instead, tau
        // = taup is used the mean number of iterations increases to 1.999 (2
        // iterations are needed except near tau = 0).
        //
        // For large tau, taup = exp(-es*atanh(es)) * tau.  Use this as for the
        // initial guess for |taup| > 70 (approx |phi| > 89deg).  Then for
        // sufficiently large tau (such that sqrt(1+tau^2) = |tau|), we can exit
        // with the intial guess and avoid overflow problems.  This also reduces
        // the mean number of iterations slightly from 1.963 to 1.954.
        tau = taup.abs() > 70 ? taup * exp(eatanhe(1.0, es)) : taup / e2m,
        stol = tol * max<double>(1.0, taup.abs());
    if (!(tau.abs() < taumax)) return tau; // handles +/-inf and nan
    for (int i = 0; i < numit || _GEOGRAPHICLIB_PANIC; ++i) {
      double taupa = taupf(tau, es),
          dtau = (taup - taupa) * (1 + e2m * sq(tau)) / (e2m * hypot(1.0, tau) * hypot(1.0, taupa));
      tau += dtau;
      if (!(dtau.abs() >= stol)) {
        break;
      }
    }
    return tau;
  }
}
