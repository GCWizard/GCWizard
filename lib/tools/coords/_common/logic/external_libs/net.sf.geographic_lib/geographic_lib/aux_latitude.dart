/***********************************************************************
    Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================

 * \file AuxLatitude.hpp
 * \brief Header for the GeographicLib::AuxLatitude class
 *
 * This file is an implementation of the methods described in
 * - C. F. F. Karney,
 *   <a href="https://doi.org/10.1080/00396265.2023.2217604">
 *   On auxiliary latitudes,</a>
 *   Survey Review (2023);
 *   preprint
 *   <a href="https://arxiv.org/abs/2212.05818">arXiv:2212.05818</a>.
 * .
 * Copyright (c) Charles Karney (2022-2023) <karney@alum.mit.edu> and licensed
 * under the MIT/X11 License.  For more information, see
 * https://geographiclib.sourceforge.io/
 **********************************************************************/

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';

/**
 * The order of the series approximation used in AuxLatitude.
 * GEOGRAPHICLIB_AUXLATITUDE_ORDER can be set to one of [4, 6, 8].  Use order
 * appropriate for double precision, 6, also for GEOGRAPHICLIB_PRECISION == 5
 * to enable truncation errors to be measured easily.
 **********************************************************************/

const int _GEOGRAPHICLIB_AUXLATITUDE_ORDER = (_GEOGRAPHICLIB_PRECISION == 2 || _GEOGRAPHICLIB_PRECISION == 5 ? 6 : (_GEOGRAPHICLIB_PRECISION == 1 ? 4 : 8));

// ignore_for_file: unused_field
// ignore_for_file: unused_element
class _AuxLatitude {
  // Maximum number of iterations for Newton's method
  static const int numit_ = 1000;
  late final double tol_, bmin_, bmax_;       // Static consts for Newton's method
  late final double _a, _b, _f, _fm1, _e2, _e2m1, _e12, _e12p1, _n, _e, _e1, _n2, _q;

  late final List<double> _c;

  /**
   * The order of the series expansions.  This is set at compile time to
   * either 4, 6, or 8, by the preprocessor macro
   * GEOGRAPHICLIB_AUXLATITUDE_ORDER.
   * @hideinitializer
   **********************************************************************/
  static const int Lmax = _GEOGRAPHICLIB_AUXLATITUDE_ORDER;

  /**
   * Geographic latitude, \e phi, &phi;
   * @hideinitializer
   **********************************************************************/
  static const _GEOGRAPHIC = 0;
  /**
   * Parametric latitude, \e beta, &beta;
   * @hideinitializer
   **********************************************************************/
  static const _PARAMETRIC = 1;
  /**
   * %Geocentric latitude, \e theta, &theta;
   * @hideinitializer
   **********************************************************************/
  static const _GEOCENTRIC = 2;
  /**
   * Rectifying latitude, \e mu, &mu;
   * @hideinitializer
   **********************************************************************/
  static const _RECTIFYING = 3;
  /**
   * Conformal latitude, \e chi, &chi;
   * @hideinitializer
   **********************************************************************/
  static const _CONFORMAL  = 4;
  /**
   * Authalic latitude, \e xi, &xi;
   * @hideinitializer
   **********************************************************************/
  static const _AUTHALIC   = 5;
  /**
   * The total number of auxiliary latitudes
   * @hideinitializer
   **********************************************************************/
  static const _AUXNUMBER  = 6;
  /**
  * An alias for GEOGRAPHIC
  * @hideinitializer
  **********************************************************************/
  static const _PHI = _GEOGRAPHIC;
  /**
   * An alias for PARAMETRIC
   * @hideinitializer
   **********************************************************************/
  static const _BETA = _PARAMETRIC;
  /**
   * An alias for GEOCENTRIC
   * @hideinitializer
   **********************************************************************/
  static const _THETA = _GEOCENTRIC;
  /**
   * An alias for RECTIFYING
   * @hideinitializer
   **********************************************************************/
  static const _MU = _RECTIFYING;
  /**
   * An alias for CONFORMAL
   * @hideinitializer
   **********************************************************************/
  static const _CHI = _CONFORMAL;
  /**
   * An alias for AUTHALIC
   * @hideinitializer
   **********************************************************************/
  static const _XI = _AUTHALIC;

  _AuxLatitude( double a, double f) {
    tol_ = sqrt(practical_epsilon);
    bmin_ = _log2(double.minPositive);
    bmax_ = _log2(double.maxFinite);

    _a = a;
    _f = f;
    _b = _a * (1 - _f);
    _fm1 = 1 - _f;
    _e2 = _f * (2 - _f);
    _e2m1 = _fm1 * _fm1;
    _e12 = _e2/(1 - _e2);
    _e12p1 = 1 / _e2m1;
    _n = _f/(2 - _f);
    _e = sqrt(_e2.abs());
    _e1 = sqrt(_e12.abs());
    _n2 = _n * _n;
    _q = _e12p1 + (_f == 0 ? 1 : (_f > 0 ? _asinh(_e1) : atan(_e)) / _e);

    _c = List<double>.generate(Lmax * _AUXNUMBER * _AUXNUMBER, (index) => double.nan);
  }

  /**
   * @return \e f, the flattening of the ellipsoid.
   **********************************************************************/
  double Flattening() { return _f; }

  _AuxAngle Convert(int auxin, int auxout, _AuxAngle zeta, bool exact) {
    int k = ind(auxout, auxin);
    if (k < 0) return _AuxAngle.NaN();
    if (auxin == auxout) return zeta;
    if (exact) {
      if (auxin < 3 && auxout < 3) {
        // Need extra double because, since C++11, pow(float, int) returns double
        return _AuxAngle(zeta.y() * pow(_fm1, auxout - auxin), zeta.x());
      }
      else {
        return ToAuxiliary(auxout, FromAuxiliary(auxin, zeta).auxAngle).auxAngle;
      }
    } else {
      if ((_c[Lmax * (k + 1) - 1]).isNaN) {
        fillcoeff(auxin, auxout, k);
      }
      _AuxAngle zetan = zeta.normalized();
      double d = Clenshaw(true, zetan.y(), zetan.x(), _c.sublist(Lmax * k), Lmax);
      zetan += _AuxAngle.radians(d);
      return zetan;
    }
  }

  /**
   * Use Clenshaw to sum a Fouier series.
   *
   * @param[in] sinp if true sum the sine series, else sum the cosine series.
   * @param[in] szeta sin(\e zeta).
   * @param[in] czeta cos(\e zeta).
   * @param[in] c the array of coefficients.
   * @param[in] K the number of coefficients.
   * @return the Clenshaw sum.
   *
   * The result returned is \f$ \sum_0^{K-1} c_k \sin (2k+2)\zeta \f$, if \e
   * sinp is true; with \e sinp false, replace sin by cos.
   **********************************************************************/
  // Clenshaw applied to sum(c[k] * sin( (2*k+2) * zeta), i, 0, K-1);
  // if !sinp then subst sine->cosine.
  double Clenshaw(bool sinp, double szeta, double czeta, List<double> c, int K) {
    // Evaluate
    // y = sum(c[k] * sin( (2*k+2) * zeta), i, 0, K-1) if  sinp
    // y = sum(c[k] * cos( (2*k+2) * zeta), i, 0, K-1) if !sinp
    // Approx operation count = (K + 5) mult and (2 * K + 2) add
    int k = K;
    double u0 = 0, u1 = 0,        // accumulators for sum
    x = 2 * (czeta - szeta) * (czeta + szeta); // 2 * cos(2*zeta)
    for (; k > 0;) {
      double t = x * u0 - u1 + c[--k];
      u1 = u0; u0 = t;
    }
    // u0*f0(zeta) - u1*fm1(zeta)
    // f0 = sinp ? sin(2*zeta) : cos(2*zeta)
    // fm1 = sinp ? 0 : 1
    double f0 = sinp ? 2 * szeta * czeta : x / 2, fm1 = sinp ? 0 : 1;
    return f0 * u0 - fm1 * u1;
  }

  static int ind(int auxout, int auxin) {
    return (auxout >= 0 && auxout < _AUXNUMBER && auxin  >= 0 && auxin  < _AUXNUMBER)
        ? _AUXNUMBER * auxout + auxin
        : -1;
  }

  _AuxAngleDiff Parametric(_AuxAngle phi, [double? diff]) {
    if (diff != null) diff = _fm1;
    return _AuxAngleDiff(_AuxAngle(phi.y() * _fm1, phi.x()), diff);
  }

  _AuxAngleDiff Geocentric(_AuxAngle phi, double? diff) {
    if (diff != null) diff = _e2m1;
    return _AuxAngleDiff(_AuxAngle(phi.y() * _e2m1, phi.x()), diff);
  }

  _AuxAngleDiff Rectifying(_AuxAngle phi, [double? diff]) {
    _AuxAngle beta = Parametric(phi).auxAngle.normalized();
    double sbeta = beta.y().abs(), cbeta = beta.x().abs();
    double a = 1, b = _fm1, ka = _e2, kb = -_e12, ka1 = _e2m1, kb1 = _e12p1,
    smu, cmu, mr;
    if (_f < 0) {
      var _h = a;
      a = b;
      b = _h;
      _h = ka;
      ka = kb;
      kb = _h;
      _h = ka1;
      ka1 = kb1;
      kb1 = _h;
      _h = sbeta;
      sbeta = cbeta;
      cbeta = _h;
      // swap(a, b); swap(ka, kb); swap(ka1, kb1); swap(sbeta, cbeta);
    }
    // now a,b = larger/smaller semiaxis
    // beta now measured from larger semiaxis
    // kb,ka = modulus-squared for distance from beta = 0,pi/2
    // NB kb <= 0; 0 <= ka <= 1
    // sa = b*E(beta,sqrt(kb)), sb = a*E(beta',sqrt(ka))
    //    1 - ka * (1 - sb2) = 1 -ka + ka*sb2
    double
    sb2 = sbeta * sbeta,
    cb2 = cbeta * cbeta,
    db2 = 1 - kb * sb2,
    da2 = ka1 + ka * sb2,
    // DLMF Eq. 19.25.9
    sa = b * sbeta * ( _EllipticFunction.RF3(cb2, db2, 1) -
    kb * sb2 * _EllipticFunction.RD(cb2, db2, 1)/3 ),
    // DLMF Eq. 19.25.10 with complementary angles
    sb = a * cbeta * ( ka1 * _EllipticFunction.RF3(sb2, da2, 1)
    + ka * ka1 * cb2 * _EllipticFunction.RD(sb2, 1, da2)/3
    + ka * sbeta / sqrt(da2) );
    // sa + sb  = 2*EllipticFunction::RG(a*a, b*b) = a*E(e) = b*E(i*e')
    // mr = a*E(e)*(2/pi) = b*E(i*e')*(2/pi)
    mr = (2 * (sa + sb)) / _GeoMath.pi();
    smu = sin(sa / mr);
    cmu = sin(sb / mr);
    if (_f < 0) {
      var _h = smu;
      smu = cmu;
      cmu = _h;
      _h = a;
      a = b;
      b = _h;
      // swap(smu, cmu); swap(a, b);
    }
    // mu is normalized
    _AuxAngle mu = _AuxAngle(smu, cmu).copyquadrant(phi);
    if (diff != null) {
      double cphi = phi.normalized().x(), tphi = phi.tan();
      if (!tphi.isInfinite) {
        cmu = mu.x(); cbeta = beta.x();
        diff = _fm1 * b/mr * _GeoMath.sq(cbeta / cmu) * (cbeta / cphi);
      } else {
        diff = _fm1 * mr/a;
      }
    }
    return _AuxAngleDiff(mu, diff);
  }

 double RectifyingRadius(bool exact) {
   if (exact) {
     return _EllipticFunction.RG(_GeoMath.sq(_a), _GeoMath.sq(_b)) * 4 / _GeoMath.pi();
   } else {
     // Maxima code for these coefficients:
     // df[i]:=if i<0 then df[i+2]/(i+2) else i!!$
     // R(Lmax):=sum((df[2*j-3]/df[2*j])^2*n^(2*j),j,0,floor(Lmax/2))$
     // cf(Lmax):=block([t:R(Lmax)],
     //  t:makelist(coeff(t,n,2*(floor(Lmax/2)-j)),j,0,floor(Lmax/2)),
     //  map(lambda([x],num(x)/
     //         (if denom(x) = 1 then 1 else denom(x.0))),t))$
     List<double> coeff = [];
     if (_GEOGRAPHICLIB_AUXLATITUDE_ORDER == 4) {
       coeff = [1 / 64.0, 1 / 4.0, 1];
     } else if (_GEOGRAPHICLIB_AUXLATITUDE_ORDER == 6) {
       coeff = [1 / 256.0, 1 / 64.0, 1 / 4.0, 1];
     } else if (_GEOGRAPHICLIB_AUXLATITUDE_ORDER == 8) {
       coeff = [25/16384.0, 1/256.0, 1/64.0, 1/4.0, 1];
     }
     int m = Lmax ~/ 2;
     return (_a + _b) / 2 * _GeoMath.polyval(m, coeff, 0, _n2);
   }
 }

  // the function sqrt(1 + tphi^2), convert tan to sec
  static double sc(double tphi) {
    return _GeoMath.hypot(1.0, tphi);
  }

  // the function tphi / sqrt(1 + tphi^2), convert tan to sin
  static double sn(double tphi) {
    return tphi.isInfinite ? _copySign(1.0, tphi) : tphi / sc(tphi);
  }

  double atanhee(double tphi) {
    double s = _f <= 0 ? sn(tphi) : sn(_fm1 * tphi);
    return _f == 0 ? s :
    // atanh(e * sphi) = asinh(e' * sbeta)
    (_f < 0 ? atan( _e * s ) : _asinh( _e1 * s )) / _e;
  }

  _AuxAngleDiff Conformal(_AuxAngle phi, double? diff) {
    double tphi = phi.tan().abs(), tchi = tphi;
    if ( !( !tphi.isFinite || tphi == 0 || _f == 0 ) ) {
      double scphi = sc(tphi),
      sig = _sinh(_e2 * atanhee(tphi) ),
      scsig = sc(sig);
      if (_f <= 0) {
        tchi = tphi * scsig - sig * scphi;
      } else {
        // The general expression for tchi is
        //   tphi * scsig - sig * scphi
        // This involves cancellation if f > 0, so change to
        //   (tphi - sig) * (tphi + sig) / (tphi * scsig + sig * scphi)
        // To control overflow, write as (sigtphi = sig / tphi)
        //   (tphi - sig) * (1 + sigtphi) / (scsig + sigtphi * scphi)
        double sigtphi = sig / tphi, tphimsig;
        if (sig < tphi / 2) {
          tphimsig = tphi - sig;
        }
        else {
          // Still have possibly dangerous cancellation in tphi - sig.
          //
          // Write tphi - sig = (1 - e) * Dg(1, e)
          //   Dg(x, y) = (g(x) - g(y)) / (x - y)
          //   g(x) = sinh(x * atanh(sphi * x))
          // Note sinh(atanh(sphi)) = tphi
          // Turn the crank on divided differences, substitute
          //   sphi = tphi/sc(tphi)
          //   atanh(x) = asinh(x/sqrt(1-x^2))
          double em1 = _e2m1 / (1 + _e),              // 1 - e
          atanhs = _asinh(tphi),                // atanh(sphi)
          scbeta = sc(_fm1 * tphi),            // sec(beta)
          scphibeta = sc(tphi) / scbeta,       // sec(phi)/sec(beta)
          atanhes = _asinh(_e * tphi / scbeta), // atanh(e * sphi)
          t1 = (atanhs - _e * atanhes)/2,
          t2 = _asinh(em1 * (tphi * scphibeta)) / em1,
          Dg = _cosh((atanhs + _e * atanhes)/2) * (_sinh(t1) / t1)
          * ((atanhs + atanhes)/2 + (1 + _e)/2 * t2);
          tphimsig = em1 * Dg;  // tphi - sig
        }
        tchi = tphimsig * (1 + sigtphi) / (scsig + sigtphi * scphi);
      }
    }
    _AuxAngle chi = _AuxAngle(tchi).copyquadrant(phi);
    if (diff != null) {
      if (!tphi.isInfinite) {
        double cchi = chi.normalized().x(),
        cphi = phi.normalized().x(),
        cbeta = Parametric(phi).auxAngle.normalized().x();
        diff = _e2m1 * (cbeta / cchi) * (cbeta / cphi);
      } else {
        double ss = _f > 0 ? _sinh(_e * _asinh(_e1)) : _sinh(-_e * atan(_e));
        diff = _f > 0 ? 1/( sc(ss) + ss ) : sc(ss) - ss;
      }
    }
    return _AuxAngleDiff(chi, diff);
  }

  double q(double tphi) {
    double scbeta = sc(_fm1 * tphi);
    return atanhee(tphi) + (tphi / scbeta) * (sc(tphi) / scbeta);
  }

  double Dq(double tphi) {
    double scphi = sc(tphi), sphi = sn(tphi),
    // d = (1 - sphi) can underflow to zero for large tphi
    d = tphi > 0 ? 1 / (scphi * scphi * (1 + sphi)) : 1 - sphi;
    if (tphi <= 0) {
      // This branch is not reached; this case is open-coded in Authalic.
      return (_q - q(tphi)) / d;
    } else {
      if (d == 0) {
        return 2 / _GeoMath.sq(_e2m1);
      } else {
        // General expression for Dq(1, sphi) is
        // atanh(e * d / (1 - e2 * sphi)) / (e * d) +
        //   (1 + e2 * sphi) / ((1 - e2 * sphi * sphi) * e2m1);
        // atanh( e * d / (1 - e2 * sphi))
        // = atanh( e * d * scphi/(scphi - e2 * tphi))
        // =
        double scbeta = sc(_fm1 * tphi);
        return (_f == 0 ? 1 :
          (_f > 0 ? _asinh(_e1 * d * scphi / scbeta) :
          atan(_e * d / (1 - _e2 * sphi))) / (_e * d)) +
              (_f > 0 ?
              ((scphi + _e2 * tphi) / (_e2m1 * scbeta)) * (scphi / scbeta) :
              (1 + _e2 * sphi) / ((1 - _e2 * sphi * sphi) * _e2m1));
      }
    }
  }

  _AuxAngleDiff Authalic(_AuxAngle phi, double? diff) {
    double tphi = phi.tan().abs();
    _AuxAngle xi = _AuxAngle.copy(phi), phin = _AuxAngle.copy(phi.normalized());
    if ( !( !tphi.isInfinite || tphi == 0 || _f == 0 ) ) {
    double qv = q(tphi),
    Dqp = Dq(tphi),
    Dqm = (_q + qv) / (1 + phin.y().abs()); // Dq(-tphi)
    xi = _AuxAngle(_copySign(qv, phi.y()), phin.x() * sqrt(Dqp * Dqm) );
    }
      if (diff != null) {
      if (!tphi.isNaN) {
        double cbeta = Parametric(phi).auxAngle.normalized().x(),
        cxi = xi.normalized().x();
        diff = (2/_q) * _GeoMath.sq(cbeta / cxi) * (cbeta / cxi) * (cbeta / phin.x());
      } else {
        diff = _e2m1 * sqrt(_q/2);
      }
    }
    return _AuxAngleDiff(xi, diff);
  }

  _AuxAngleDiff ToAuxiliary(int auxout, _AuxAngle phi, [double? diff]) {
    switch (auxout) {
      case _GEOGRAPHIC:
        if (diff != null) {
          diff = 1;
        }
        return _AuxAngleDiff(phi, diff);
      case _PARAMETRIC: return Parametric(phi, diff);
      case _GEOCENTRIC: return Geocentric(phi, diff);
      case _RECTIFYING: return Rectifying(phi, diff);
      case _CONFORMAL : return Conformal (phi, diff);
      case _AUTHALIC  : return Authalic  (phi, diff);
      default:
        if (diff != null) {
          diff = double.nan;
        }
      return _AuxAngleDiff(_AuxAngle.NaN(), diff);
    }
  }

  _AuxAngleNiter FromAuxiliary(int auxin, _AuxAngle zeta, [int? niter]) {
    int n = 0;
    if (niter != null) {
      niter = n;
    }
    double tphi = _fm1;
    switch (auxin) {
      case _GEOGRAPHIC: return _AuxAngleNiter(zeta, niter);
      case _PARAMETRIC: return _AuxAngleNiter(_AuxAngle(zeta.y() / _fm1, zeta.x()), niter);
      case _GEOCENTRIC: return _AuxAngleNiter(_AuxAngle(zeta.y() / _e2m1, zeta.x()), niter);
      case _RECTIFYING: tphi *= sqrt(_fm1); break;
      case _CONFORMAL : tphi *= _fm1  ; break;
      case _AUTHALIC  : tphi *= _cbrt(_fm1); break;
      default: return _AuxAngleNiter(_AuxAngle.NaN(), niter);
    }
  
    // Drop through to solution by Newton's method
    double tzeta = zeta.tan().abs(), ltzeta = _log2(tzeta);
    if (!ltzeta.isFinite) {
      return _AuxAngleNiter(zeta, niter);
    }
    tphi = tzeta / tphi;
    double ltphi = _log2(tphi),
    bmin = min<double>(ltphi, bmin_), bmax = max<double>(ltphi, bmax_);
    for (int sign = 0, osign = 0, ntrip = 0; n < numit_;) {
      ++n;
      double diff = double.nan;
      var x = ToAuxiliary(auxin, _AuxAngle(tphi), diff);
      _AuxAngle zeta1 = x.auxAngle;
      diff = x.diff!;
      double tzeta1 = zeta1.tan(), ltzeta1 = _log2(tzeta1);
      // Convert derivative from dtan(zeta)/dtan(phi) to
      // dlog(tan(zeta))/dlog(tan(phi))
      diff *= tphi / tzeta1;
      osign = sign;
      if (tzeta1 == tzeta) {
        break;
      } else {
        if (tzeta1 > tzeta) {
          sign = 1;
          bmax = ltphi;
        } else {
          sign = -1;
          bmin = ltphi;
        }
      }
      double dltphi = -(ltzeta1 - ltzeta) / diff;
      ltphi += dltphi;
      tphi = _exp2(ltphi);
      if (!(dltphi.abs() >= tol_)) {
        ++n;
        // Final Newton iteration without the logs

        var x = ToAuxiliary(auxin, _AuxAngle(tphi), diff);
        zeta1 = x.auxAngle;
        diff = x.diff!;
        tphi -= (zeta1.tan() - tzeta) / diff;
        break;
      }
      if ((sign * osign < 0 && n - ntrip > 2) || ltphi >= bmax || ltphi <= bmin) {
        sign = 0; ntrip = n;
        ltphi = (bmin + bmax) / 2;
        tphi = _exp2(ltphi);
      }
    }
    if (niter != null) {
      niter = n;
    }
    return _AuxAngleNiter(_AuxAngle(tphi).copyquadrant(zeta), niter);
  }

  void fillcoeff(int auxin, int auxout, int k) {
    List<double> coeffs = [];
    List<int> ptrs = [];
  
    if (_GEOGRAPHICLIB_AUXLATITUDE_ORDER == 4) {
      coeffs = [
        // C[phi,phi] skipped
        // C[phi,beta]; even coeffs only
        0, 1,
        0, 1 / 2.0,
        1 / 3.0,
        1 / 4.0,
        // C[phi,theta]; even coeffs only
        -2, 2,
        -4, 2,
        8 / 3.0,
        4,
        // C[phi,mu]; even coeffs only
        -27 / 32.0, 3 / 2.0,
        -55 / 32.0, 21 / 16.0,
        151 / 96.0,
        1097 / 512.0,
        // C[phi,chi]
        116 / 45.0, -2, -2 / 3.0, 2,
        -227 / 45.0, -8 / 5.0, 7 / 3.0,
        -136 / 35.0, 56 / 15.0,
        4279 / 630.0,
        // C[phi,xi]
        -2582 / 14175.0, -16 / 35.0, 4 / 45.0, 4 / 3.0,
        -11966 / 14175.0, 152 / 945.0, 46 / 45.0,
        3802 / 14175.0, 3044 / 2835.0,
        6059 / 4725.0,
        // C[beta,phi]; even coeffs only
        0, -1,
        0, 1 / 2.0,
        -1 / 3.0,
        1 / 4.0,
        // C[beta,beta] skipped
        // C[beta,theta]; even coeffs only
        0, 1,
        0, 1 / 2.0,
        1 / 3.0,
        1 / 4.0,
        // C[beta,mu]; even coeffs only
        -9 / 32.0, 1 / 2.0,
        -37 / 96.0, 5 / 16.0,
        29 / 96.0,
        539 / 1536.0,
        // C[beta,chi]
        38 / 45.0, -1 / 3.0, -2 / 3.0, 1,
        -7 / 9.0, -14 / 15.0, 5 / 6.0,
        -34 / 21.0, 16 / 15.0,
        2069 / 1260.0,
        // C[beta,xi]
        -1082 / 14175.0, -46 / 315.0, 4 / 45.0, 1 / 3.0,
        -338 / 2025.0, 68 / 945.0, 17 / 90.0,
        1102 / 14175.0, 461 / 2835.0,
        3161 / 18900.0,
        // C[theta,phi]; even coeffs only
        2, -2,
        -4, 2,
        -8 / 3.0,
        4,
        // C[theta,beta]; even coeffs only
        0, -1,
        0, 1 / 2.0,
        -1 / 3.0,
        1 / 4.0,
        // C[theta,theta] skipped
        // C[theta,mu]; even coeffs only
        -23 / 32.0, -1 / 2.0,
        -5 / 96.0, 5 / 16.0,
        1 / 32.0,
        283 / 1536.0,
        // C[theta,chi]
        4 / 9.0, -2 / 3.0, -2 / 3.0, 0,
        -23 / 45.0, -4 / 15.0, 1 / 3.0,
        -24 / 35.0, 2 / 5.0,
        83 / 126.0,
        // C[theta,xi]
        -2102 / 14175.0, -158 / 315.0, 4 / 45.0, -2 / 3.0,
        934 / 14175.0, -16 / 945.0, 16 / 45.0,
        922 / 14175.0, -232 / 2835.0,
        719 / 4725.0,
        // C[mu,phi]; even coeffs only
        9 / 16.0, -3 / 2.0,
        -15 / 32.0, 15 / 16.0,
        -35 / 48.0,
        315 / 512.0,
        // C[mu,beta]; even coeffs only
        3 / 16.0, -1 / 2.0,
        1 / 32.0, -1 / 16.0,
        -1 / 48.0,
        -5 / 512.0,
        // C[mu,theta]; even coeffs only
        13 / 16.0, 1 / 2.0,
        33 / 32.0, -1 / 16.0,
        -5 / 16.0,
        -261 / 512.0,
        // C[mu,mu] skipped
        // C[mu,chi]
        41 / 180.0, 5 / 16.0, -2 / 3.0, 1 / 2.0,
        557 / 1440.0, -3 / 5.0, 13 / 48.0,
        -103 / 140.0, 61 / 240.0,
        49561 / 161280.0,
        // C[mu,xi]
        -1609 / 28350.0, 121 / 1680.0, 4 / 45.0, -1 / 6.0,
        16463 / 453600.0, 26 / 945.0, -29 / 720.0,
        449 / 28350.0, -1003 / 45360.0,
        -40457 / 2419200.0,
        // C[chi,phi]
        -82 / 45.0, 4 / 3.0, 2 / 3.0, -2,
        -13 / 9.0, -16 / 15.0, 5 / 3.0,
        34 / 21.0, -26 / 15.0,
        1237 / 630.0,
        // C[chi,beta]
        -16 / 45.0, 0, 2 / 3.0, -1,
        19 / 45.0, -2 / 5.0, 1 / 6.0,
        16 / 105.0, -1 / 15.0,
        17 / 1260.0,
        // C[chi,theta]
        -2 / 9.0, 2 / 3.0, 2 / 3.0, 0,
        43 / 45.0, 4 / 15.0, -1 / 3.0,
        2 / 105.0, -2 / 5.0,
        -55 / 126.0,
        // C[chi,mu]
        1 / 360.0, -37 / 96.0, 2 / 3.0, -1 / 2.0,
        437 / 1440.0, -1 / 15.0, -1 / 48.0,
        37 / 840.0, -17 / 480.0,
        -4397 / 161280.0,
        // C[chi,chi] skipped
        // C[chi,xi]
        -2312 / 14175.0, -88 / 315.0, 34 / 45.0, -2 / 3.0,
        6079 / 14175.0, -184 / 945.0, 1 / 45.0,
        772 / 14175.0, -106 / 2835.0,
        -167 / 9450.0,
        // C[xi,phi]
        538 / 4725.0, 88 / 315.0, -4 / 45.0, -4 / 3.0,
        -2482 / 14175.0, 8 / 105.0, 34 / 45.0,
        -898 / 14175.0, -1532 / 2835.0,
        6007 / 14175.0,
        // C[xi,beta]
        34 / 675.0, 32 / 315.0, -4 / 45.0, -1 / 3.0,
        74 / 2025.0, -4 / 315.0, -7 / 90.0,
        2 / 14175.0, -83 / 2835.0,
        -797 / 56700.0,
        // C[xi,theta]
        778 / 4725.0, 62 / 105.0, -4 / 45.0, 2 / 3.0,
        12338 / 14175.0, -32 / 315.0, 4 / 45.0,
        -1618 / 14175.0, -524 / 2835.0,
        -5933 / 14175.0,
        // C[xi,mu]
        1297 / 18900.0, -817 / 10080.0, -4 / 45.0, 1 / 6.0,
        -29609 / 453600.0, -2 / 35.0, 49 / 720.0,
        -2917 / 56700.0, 4463 / 90720.0,
        331799 / 7257600.0,
        // C[xi,chi]
        2458 / 4725.0, 46 / 315.0, -34 / 45.0, 2 / 3.0,
        3413 / 14175.0, -256 / 315.0, 19 / 45.0,
        -15958 / 14175.0, 248 / 567.0,
        16049 / 28350.0,
        // C[xi,xi] skipped
      ];
      ptrs = [
        0, 0, 6, 12, 18, 28, 38, 44, 44, 50, 56, 66, 76, 82, 88, 88, 94, 104,
        114, 120, 126, 132, 132, 142, 152, 162, 172, 182, 192, 192, 202, 212,
        222, 232, 242, 252, 252,
      ];
    }
    if (_GEOGRAPHICLIB_AUXLATITUDE_ORDER == 6) {
      coeffs = [
        // C[phi,phi] skipped
        // C[phi,beta]; even coeffs only
        0, 0, 1,
        0, 0, 1 / 2.0,
        0, 1 / 3.0,
        0, 1 / 4.0,
        1 / 5.0,
        1 / 6.0,
        // C[phi,theta]; even coeffs only
        2, -2, 2,
        6, -4, 2,
        -8, 8 / 3.0,
        -16, 4,
        32 / 5.0,
        32 / 3.0,
        // C[phi,mu]; even coeffs only
        269 / 512.0, -27 / 32.0, 3 / 2.0,
        6759 / 4096.0, -55 / 32.0, 21 / 16.0,
        -417 / 128.0, 151 / 96.0,
        -15543 / 2560.0, 1097 / 512.0,
        8011 / 2560.0,
        293393 / 61440.0,
        // C[phi,chi]
        -2854 / 675.0, 26 / 45.0, 116 / 45.0, -2, -2 / 3.0, 2,
        2323 / 945.0, 2704 / 315.0, -227 / 45.0, -8 / 5.0, 7 / 3.0,
        73814 / 2835.0, -1262 / 105.0, -136 / 35.0, 56 / 15.0,
        -399572 / 14175.0, -332 / 35.0, 4279 / 630.0,
        -144838 / 6237.0, 4174 / 315.0,
        601676 / 22275.0,
        // C[phi,xi]
        28112932 / 212837625.0, 60136 / 467775.0, -2582 / 14175.0,
        -16 / 35.0, 4 / 45.0, 4 / 3.0,
        251310128 / 638512875.0, -21016 / 51975.0, -11966 / 14175.0,
        152 / 945.0, 46 / 45.0,
        -8797648 / 10945935.0, -94388 / 66825.0, 3802 / 14175.0,
        3044 / 2835.0,
        -1472637812 / 638512875.0, 41072 / 93555.0, 6059 / 4725.0,
        455935736 / 638512875.0, 768272 / 467775.0,
        4210684958 / 1915538625.0,
        // C[beta,phi]; even coeffs only
        0, 0, -1,
        0, 0, 1 / 2.0,
        0, -1 / 3.0,
        0, 1 / 4.0,
        -1 / 5.0,
        1 / 6.0,
        // C[beta,beta] skipped
        // C[beta,theta]; even coeffs only
        0, 0, 1,
        0, 0, 1 / 2.0,
        0, 1 / 3.0,
        0, 1 / 4.0,
        1 / 5.0,
        1 / 6.0,
        // C[beta,mu]; even coeffs only
        205 / 1536.0, -9 / 32.0, 1 / 2.0,
        1335 / 4096.0, -37 / 96.0, 5 / 16.0,
        -75 / 128.0, 29 / 96.0,
        -2391 / 2560.0, 539 / 1536.0,
        3467 / 7680.0,
        38081 / 61440.0,
        // C[beta,chi]
        -3118 / 4725.0, -1 / 3.0, 38 / 45.0, -1 / 3.0, -2 / 3.0, 1,
        -247 / 270.0, 50 / 21.0, -7 / 9.0, -14 / 15.0, 5 / 6.0,
        17564 / 2835.0, -5 / 3.0, -34 / 21.0, 16 / 15.0,
        -49877 / 14175.0, -28 / 9.0, 2069 / 1260.0,
        -28244 / 4455.0, 883 / 315.0,
        797222 / 155925.0,
        // C[beta,xi]
        7947332 / 212837625.0, 11824 / 467775.0, -1082 / 14175.0,
        -46 / 315.0, 4 / 45.0, 1 / 3.0,
        39946703 / 638512875.0, -16672 / 155925.0, -338 / 2025.0,
        68 / 945.0, 17 / 90.0,
        -255454 / 1563705.0, -101069 / 467775.0, 1102 / 14175.0,
        461 / 2835.0,
        -189032762 / 638512875.0, 1786 / 18711.0, 3161 / 18900.0,
        80274086 / 638512875.0, 88868 / 467775.0,
        880980241 / 3831077250.0,
        // C[theta,phi]; even coeffs only
        -2, 2, -2,
        6, -4, 2,
        8, -8 / 3.0,
        -16, 4,
        -32 / 5.0,
        32 / 3.0,
        // C[theta,beta]; even coeffs only
        0, 0, -1,
        0, 0, 1 / 2.0,
        0, -1 / 3.0,
        0, 1 / 4.0,
        -1 / 5.0,
        1 / 6.0,
        // C[theta,theta] skipped
        // C[theta,mu]; even coeffs only
        499 / 1536.0, -23 / 32.0, -1 / 2.0,
        6565 / 12288.0, -5 / 96.0, 5 / 16.0,
        -77 / 128.0, 1 / 32.0,
        -4037 / 7680.0, 283 / 1536.0,
        1301 / 7680.0,
        17089 / 61440.0,
        // C[theta,chi]
        -3658 / 4725.0, 2 / 9.0, 4 / 9.0, -2 / 3.0, -2 / 3.0, 0,
        61 / 135.0, 68 / 45.0, -23 / 45.0, -4 / 15.0, 1 / 3.0,
        9446 / 2835.0, -46 / 35.0, -24 / 35.0, 2 / 5.0,
        -34712 / 14175.0, -80 / 63.0, 83 / 126.0,
        -2362 / 891.0, 52 / 45.0,
        335882 / 155925.0,
        // C[theta,xi]
        216932 / 2627625.0, 109042 / 467775.0, -2102 / 14175.0,
        -158 / 315.0, 4 / 45.0, -2 / 3.0,
        117952358 / 638512875.0, -7256 / 155925.0, 934 / 14175.0,
        -16 / 945.0, 16 / 45.0,
        -7391576 / 54729675.0, -25286 / 66825.0, 922 / 14175.0,
        -232 / 2835.0,
        -67048172 / 638512875.0, 268 / 18711.0, 719 / 4725.0,
        46774256 / 638512875.0, 14354 / 467775.0,
        253129538 / 1915538625.0,
        // C[mu,phi]; even coeffs only
        -3 / 32.0, 9 / 16.0, -3 / 2.0,
        135 / 2048.0, -15 / 32.0, 15 / 16.0,
        105 / 256.0, -35 / 48.0,
        -189 / 512.0, 315 / 512.0,
        -693 / 1280.0,
        1001 / 2048.0,
        // C[mu,beta]; even coeffs only
        -1 / 32.0, 3 / 16.0, -1 / 2.0,
        -9 / 2048.0, 1 / 32.0, -1 / 16.0,
        3 / 256.0, -1 / 48.0,
        3 / 512.0, -5 / 512.0,
        -7 / 1280.0,
        -7 / 2048.0,
        // C[mu,theta]; even coeffs only
        -15 / 32.0, 13 / 16.0, 1 / 2.0,
        -1673 / 2048.0, 33 / 32.0, -1 / 16.0,
        349 / 256.0, -5 / 16.0,
        963 / 512.0, -261 / 512.0,
        -921 / 1280.0,
        -6037 / 6144.0,
        // C[mu,mu] skipped
        // C[mu,chi]
        7891 / 37800.0, -127 / 288.0, 41 / 180.0, 5 / 16.0, -2 / 3.0,
        1 / 2.0,
        -1983433 / 1935360.0, 281 / 630.0, 557 / 1440.0, -3 / 5.0,
        13 / 48.0,
        167603 / 181440.0, 15061 / 26880.0, -103 / 140.0, 61 / 240.0,
        6601661 / 7257600.0, -179 / 168.0, 49561 / 161280.0,
        -3418889 / 1995840.0, 34729 / 80640.0,
        212378941 / 319334400.0,
        // C[mu,xi]
        12674323 / 851350500.0, -384229 / 14968800.0, -1609 / 28350.0,
        121 / 1680.0, 4 / 45.0, -1 / 6.0,
        -31621753811 / 1307674368000.0, -431 / 17325.0,
        16463 / 453600.0, 26 / 945.0, -29 / 720.0,
        -32844781 / 1751349600.0, 3746047 / 119750400.0, 449 / 28350.0,
        -1003 / 45360.0,
        10650637121 / 326918592000.0, 629 / 53460.0,
        -40457 / 2419200.0,
        205072597 / 20432412000.0, -1800439 / 119750400.0,
        -59109051671 / 3923023104000.0,
        // C[chi,phi]
        4642 / 4725.0, 32 / 45.0, -82 / 45.0, 4 / 3.0, 2 / 3.0, -2,
        -1522 / 945.0, 904 / 315.0, -13 / 9.0, -16 / 15.0, 5 / 3.0,
        -12686 / 2835.0, 8 / 5.0, 34 / 21.0, -26 / 15.0,
        -24832 / 14175.0, -12 / 5.0, 1237 / 630.0,
        109598 / 31185.0, -734 / 315.0,
        444337 / 155925.0,
        // C[chi,beta]
        -998 / 4725.0, 2 / 5.0, -16 / 45.0, 0, 2 / 3.0, -1,
        -2 / 27.0, -22 / 105.0, 19 / 45.0, -2 / 5.0, 1 / 6.0,
        116 / 567.0, -22 / 105.0, 16 / 105.0, -1 / 15.0,
        2123 / 14175.0, -8 / 105.0, 17 / 1260.0,
        128 / 4455.0, -1 / 105.0,
        149 / 311850.0,
        // C[chi,theta]
        1042 / 4725.0, -14 / 45.0, -2 / 9.0, 2 / 3.0, 2 / 3.0, 0,
        -712 / 945.0, -4 / 45.0, 43 / 45.0, 4 / 15.0, -1 / 3.0,
        274 / 2835.0, 124 / 105.0, 2 / 105.0, -2 / 5.0,
        21068 / 14175.0, -16 / 105.0, -55 / 126.0,
        -9202 / 31185.0, -22 / 45.0,
        -90263 / 155925.0,
        // C[chi,mu]
        -96199 / 604800.0, 81 / 512.0, 1 / 360.0, -37 / 96.0, 2 / 3.0,
        -1 / 2.0,
        1118711 / 3870720.0, -46 / 105.0, 437 / 1440.0, -1 / 15.0,
        -1 / 48.0,
        -5569 / 90720.0, 209 / 4480.0, 37 / 840.0, -17 / 480.0,
        830251 / 7257600.0, 11 / 504.0, -4397 / 161280.0,
        108847 / 3991680.0, -4583 / 161280.0,
        -20648693 / 638668800.0,
        // C[chi,chi] skipped
        // C[chi,xi]
        -55271278 / 212837625.0, 27128 / 93555.0, -2312 / 14175.0,
        -88 / 315.0, 34 / 45.0, -2 / 3.0,
        106691108 / 638512875.0, -65864 / 155925.0, 6079 / 14175.0,
        -184 / 945.0, 1 / 45.0,
        5921152 / 54729675.0, -14246 / 467775.0, 772 / 14175.0,
        -106 / 2835.0,
        75594328 / 638512875.0, -5312 / 467775.0, -167 / 9450.0,
        2837636 / 638512875.0, -248 / 13365.0,
        -34761247 / 1915538625.0,
        // C[xi,phi]
        -44732 / 2837835.0, 20824 / 467775.0, 538 / 4725.0, 88 / 315.0,
        -4 / 45.0, -4 / 3.0,
        -12467764 / 212837625.0, -37192 / 467775.0, -2482 / 14175.0,
        8 / 105.0, 34 / 45.0,
        100320856 / 1915538625.0, 54968 / 467775.0, -898 / 14175.0,
        -1532 / 2835.0,
        -5884124 / 70945875.0, 24496 / 467775.0, 6007 / 14175.0,
        -839792 / 19348875.0, -23356 / 66825.0,
        570284222 / 1915538625.0,
        // C[xi,beta]
        -70496 / 8513505.0, 2476 / 467775.0, 34 / 675.0, 32 / 315.0,
        -4 / 45.0, -1 / 3.0,
        53836 / 212837625.0, 3992 / 467775.0, 74 / 2025.0, -4 / 315.0,
        -7 / 90.0,
        -661844 / 1915538625.0, 7052 / 467775.0, 2 / 14175.0,
        -83 / 2835.0,
        1425778 / 212837625.0, 934 / 467775.0, -797 / 56700.0,
        390088 / 212837625.0, -3673 / 467775.0,
        -18623681 / 3831077250.0,
        // C[xi,theta]
        -4286228 / 42567525.0, -193082 / 467775.0, 778 / 4725.0,
        62 / 105.0, -4 / 45.0, 2 / 3.0,
        -61623938 / 70945875.0, 92696 / 467775.0, 12338 / 14175.0,
        -32 / 315.0, 4 / 45.0,
        427003576 / 1915538625.0, 612536 / 467775.0, -1618 / 14175.0,
        -524 / 2835.0,
        427770788 / 212837625.0, -8324 / 66825.0, -5933 / 14175.0,
        -9153184 / 70945875.0, -320044 / 467775.0,
        -1978771378 / 1915538625.0,
        // C[xi,mu]
        -9292991 / 302702400.0, 7764059 / 239500800.0, 1297 / 18900.0,
        -817 / 10080.0, -4 / 45.0, 1 / 6.0,
        36019108271 / 871782912000.0, 35474 / 467775.0,
        -29609 / 453600.0, -2 / 35.0, 49 / 720.0,
        3026004511 / 30648618000.0, -4306823 / 59875200.0,
        -2917 / 56700.0, 4463 / 90720.0,
        -368661577 / 4036032000.0, -102293 / 1871100.0,
        331799 / 7257600.0,
        -875457073 / 13621608000.0, 11744233 / 239500800.0,
        453002260127 / 7846046208000.0,
        // C[xi,chi]
        2706758 / 42567525.0, -55222 / 93555.0, 2458 / 4725.0,
        46 / 315.0, -34 / 45.0, 2 / 3.0,
        -340492279 / 212837625.0, 516944 / 467775.0, 3413 / 14175.0,
        -256 / 315.0, 19 / 45.0,
        4430783356 / 1915538625.0, 206834 / 467775.0, -15958 / 14175.0,
        248 / 567.0,
        62016436 / 70945875.0, -832976 / 467775.0, 16049 / 28350.0,
        -651151712 / 212837625.0, 15602 / 18711.0,
        2561772812 / 1915538625.0,
        // C[xi,xi] skipped
      ];
      ptrs = [
        0, 0, 12, 24, 36, 57, 78, 90, 90, 102, 114, 135, 156, 168, 180, 180, 192,
        213, 234, 246, 258, 270, 270, 291, 312, 333, 354, 375, 396, 396, 417,
        438, 459, 480, 501, 522, 522,
      ];
    }
    if (_GEOGRAPHICLIB_AUXLATITUDE_ORDER == 8) {
      coeffs = [
        // C[phi,phi] skipped
        // C[phi,beta]; even coeffs only
        0, 0, 0, 1,
        0, 0, 0, 1 / 2.0,
        0, 0, 1 / 3.0,
        0, 0, 1 / 4.0,
        0, 1 / 5.0,
        0, 1 / 6.0,
        1 / 7.0,
        1 / 8.0,
        // C[phi,theta]; even coeffs only
        -2, 2, -2, 2,
        -8, 6, -4, 2,
        16, -8, 8 / 3.0,
        40, -16, 4,
        -32, 32 / 5.0,
        -64, 32 / 3.0,
        128 / 7.0,
        32,
        // C[phi,mu]; even coeffs only
        -6607 / 24576.0, 269 / 512.0, -27 / 32.0, 3 / 2.0,
        -155113 / 122880.0, 6759 / 4096.0, -55 / 32.0, 21 / 16.0,
        87963 / 20480.0, -417 / 128.0, 151 / 96.0,
        2514467 / 245760.0, -15543 / 2560.0, 1097 / 512.0,
        -69119 / 6144.0, 8011 / 2560.0,
        -5962461 / 286720.0, 293393 / 61440.0,
        6459601 / 860160.0,
        332287993 / 27525120.0,
        // C[phi,chi]
        189416 / 99225.0, 16822 / 4725.0, -2854 / 675.0, 26 / 45.0,
        116 / 45.0, -2, -2 / 3.0, 2,
        141514 / 8505.0, -31256 / 1575.0, 2323 / 945.0, 2704 / 315.0,
        -227 / 45.0, -8 / 5.0, 7 / 3.0,
        -2363828 / 31185.0, 98738 / 14175.0, 73814 / 2835.0,
        -1262 / 105.0, -136 / 35.0, 56 / 15.0,
        14416399 / 935550.0, 11763988 / 155925.0, -399572 / 14175.0,
        -332 / 35.0, 4279 / 630.0,
        258316372 / 1216215.0, -2046082 / 31185.0, -144838 / 6237.0,
        4174 / 315.0,
        -2155215124 / 14189175.0, -115444544 / 2027025.0,
        601676 / 22275.0,
        -170079376 / 1216215.0, 38341552 / 675675.0,
        1383243703 / 11351340.0,
        // C[phi,xi]
        -1683291094 / 37574026875.0, 22947844 / 1915538625.0,
        28112932 / 212837625.0, 60136 / 467775.0, -2582 / 14175.0,
        -16 / 35.0, 4 / 45.0, 4 / 3.0,
        -14351220203 / 488462349375.0, 1228352 / 3007125.0,
        251310128 / 638512875.0, -21016 / 51975.0, -11966 / 14175.0,
        152 / 945.0, 46 / 45.0,
        505559334506 / 488462349375.0, 138128272 / 147349125.0,
        -8797648 / 10945935.0, -94388 / 66825.0, 3802 / 14175.0,
        3044 / 2835.0,
        973080708361 / 488462349375.0, -45079184 / 29469825.0,
        -1472637812 / 638512875.0, 41072 / 93555.0, 6059 / 4725.0,
        -1385645336626 / 488462349375.0, -550000184 / 147349125.0,
        455935736 / 638512875.0, 768272 / 467775.0,
        -2939205114427 / 488462349375.0, 443810768 / 383107725.0,
        4210684958 / 1915538625.0,
        101885255158 / 54273594375.0, 387227992 / 127702575.0,
        1392441148867 / 325641566250.0,
        // C[beta,phi]; even coeffs only
        0, 0, 0, -1,
        0, 0, 0, 1 / 2.0,
        0, 0, -1 / 3.0,
        0, 0, 1 / 4.0,
        0, -1 / 5.0,
        0, 1 / 6.0,
        -1 / 7.0,
        1 / 8.0,
        // C[beta,beta] skipped
        // C[beta,theta]; even coeffs only
        0, 0, 0, 1,
        0, 0, 0, 1 / 2.0,
        0, 0, 1 / 3.0,
        0, 0, 1 / 4.0,
        0, 1 / 5.0,
        0, 1 / 6.0,
        1 / 7.0,
        1 / 8.0,
        // C[beta,mu]; even coeffs only
        -4879 / 73728.0, 205 / 1536.0, -9 / 32.0, 1 / 2.0,
        -86171 / 368640.0, 1335 / 4096.0, -37 / 96.0, 5 / 16.0,
        2901 / 4096.0, -75 / 128.0, 29 / 96.0,
        1082857 / 737280.0, -2391 / 2560.0, 539 / 1536.0,
        -28223 / 18432.0, 3467 / 7680.0,
        -733437 / 286720.0, 38081 / 61440.0,
        459485 / 516096.0,
        109167851 / 82575360.0,
        // C[beta,chi]
        -25666 / 99225.0, 4769 / 4725.0, -3118 / 4725.0, -1 / 3.0,
        38 / 45.0, -1 / 3.0, -2 / 3.0, 1,
        193931 / 42525.0, -14404 / 4725.0, -247 / 270.0, 50 / 21.0,
        -7 / 9.0, -14 / 15.0, 5 / 6.0,
        -1709614 / 155925.0, -36521 / 14175.0, 17564 / 2835.0, -5 / 3.0,
        -34 / 21.0, 16 / 15.0,
        -637699 / 85050.0, 2454416 / 155925.0, -49877 / 14175.0,
        -28 / 9.0, 2069 / 1260.0,
        48124558 / 1216215.0, -20989 / 2835.0, -28244 / 4455.0,
        883 / 315.0,
        -16969807 / 1091475.0, -2471888 / 184275.0, 797222 / 155925.0,
        -1238578 / 42525.0, 2199332 / 225225.0,
        87600385 / 4540536.0,
        // C[beta,xi]
        -5946082372 / 488462349375.0, 9708931 / 1915538625.0,
        7947332 / 212837625.0, 11824 / 467775.0, -1082 / 14175.0,
        -46 / 315.0, 4 / 45.0, 1 / 3.0,
        190673521 / 69780335625.0, 164328266 / 1915538625.0,
        39946703 / 638512875.0, -16672 / 155925.0, -338 / 2025.0,
        68 / 945.0, 17 / 90.0,
        86402898356 / 488462349375.0, 236067184 / 1915538625.0,
        -255454 / 1563705.0, -101069 / 467775.0, 1102 / 14175.0,
        461 / 2835.0,
        110123070361 / 488462349375.0, -98401826 / 383107725.0,
        -189032762 / 638512875.0, 1786 / 18711.0, 3161 / 18900.0,
        -200020620676 / 488462349375.0, -802887278 / 1915538625.0,
        80274086 / 638512875.0, 88868 / 467775.0,
        -296107325077 / 488462349375.0, 66263486 / 383107725.0,
        880980241 / 3831077250.0,
        4433064236 / 18091198125.0, 37151038 / 127702575.0,
        495248998393 / 1302566265000.0,
        // C[theta,phi]; even coeffs only
        2, -2, 2, -2,
        -8, 6, -4, 2,
        -16, 8, -8 / 3.0,
        40, -16, 4,
        32, -32 / 5.0,
        -64, 32 / 3.0,
        -128 / 7.0,
        32,
        // C[theta,beta]; even coeffs only
        0, 0, 0, -1,
        0, 0, 0, 1 / 2.0,
        0, 0, -1 / 3.0,
        0, 0, 1 / 4.0,
        0, -1 / 5.0,
        0, 1 / 6.0,
        -1 / 7.0,
        1 / 8.0,
        // C[theta,theta] skipped
        // C[theta,mu]; even coeffs only
        -14321 / 73728.0, 499 / 1536.0, -23 / 32.0, -1 / 2.0,
        -201467 / 368640.0, 6565 / 12288.0, -5 / 96.0, 5 / 16.0,
        2939 / 4096.0, -77 / 128.0, 1 / 32.0,
        1155049 / 737280.0, -4037 / 7680.0, 283 / 1536.0,
        -19465 / 18432.0, 1301 / 7680.0,
        -442269 / 286720.0, 17089 / 61440.0,
        198115 / 516096.0,
        48689387 / 82575360.0,
        // C[theta,chi]
        64424 / 99225.0, 76 / 225.0, -3658 / 4725.0, 2 / 9.0, 4 / 9.0,
        -2 / 3.0, -2 / 3.0, 0,
        2146 / 1215.0, -2728 / 945.0, 61 / 135.0, 68 / 45.0,
        -23 / 45.0, -4 / 15.0, 1 / 3.0,
        -95948 / 10395.0, 428 / 945.0, 9446 / 2835.0, -46 / 35.0,
        -24 / 35.0, 2 / 5.0,
        29741 / 85050.0, 4472 / 525.0, -34712 / 14175.0, -80 / 63.0,
        83 / 126.0,
        280108 / 13365.0, -17432 / 3465.0, -2362 / 891.0, 52 / 45.0,
        -48965632 / 4729725.0, -548752 / 96525.0, 335882 / 155925.0,
        -197456 / 15795.0, 51368 / 12285.0,
        1461335 / 174636.0,
        // C[theta,xi]
        -230886326 / 6343666875.0, -189115382 / 1915538625.0,
        216932 / 2627625.0, 109042 / 467775.0, -2102 / 14175.0,
        -158 / 315.0, 4 / 45.0, -2 / 3.0,
        -11696145869 / 69780335625.0, 288456008 / 1915538625.0,
        117952358 / 638512875.0, -7256 / 155925.0, 934 / 14175.0,
        -16 / 945.0, 16 / 45.0,
        91546732346 / 488462349375.0, 478700902 / 1915538625.0,
        -7391576 / 54729675.0, -25286 / 66825.0, 922 / 14175.0,
        -232 / 2835.0,
        218929662961 / 488462349375.0, -67330724 / 383107725.0,
        -67048172 / 638512875.0, 268 / 18711.0, 719 / 4725.0,
        -129039188386 / 488462349375.0, -117954842 / 273648375.0,
        46774256 / 638512875.0, 14354 / 467775.0,
        -178084928947 / 488462349375.0, 2114368 / 34827975.0,
        253129538 / 1915538625.0,
        6489189398 / 54273594375.0, 13805944 / 127702575.0,
        59983985827 / 325641566250.0,
        // C[mu,phi]; even coeffs only
        57 / 2048.0, -3 / 32.0, 9 / 16.0, -3 / 2.0,
        -105 / 4096.0, 135 / 2048.0, -15 / 32.0, 15 / 16.0,
        -105 / 2048.0, 105 / 256.0, -35 / 48.0,
        693 / 16384.0, -189 / 512.0, 315 / 512.0,
        693 / 2048.0, -693 / 1280.0,
        -1287 / 4096.0, 1001 / 2048.0,
        -6435 / 14336.0,
        109395 / 262144.0,
        // C[mu,beta]; even coeffs only
        19 / 2048.0, -1 / 32.0, 3 / 16.0, -1 / 2.0,
        7 / 4096.0, -9 / 2048.0, 1 / 32.0, -1 / 16.0,
        -3 / 2048.0, 3 / 256.0, -1 / 48.0,
        -11 / 16384.0, 3 / 512.0, -5 / 512.0,
        7 / 2048.0, -7 / 1280.0,
        9 / 4096.0, -7 / 2048.0,
        -33 / 14336.0,
        -429 / 262144.0,
        // C[mu,theta]; even coeffs only
        509 / 2048.0, -15 / 32.0, 13 / 16.0, 1 / 2.0,
        2599 / 4096.0, -1673 / 2048.0, 33 / 32.0, -1 / 16.0,
        -2989 / 2048.0, 349 / 256.0, -5 / 16.0,
        -43531 / 16384.0, 963 / 512.0, -261 / 512.0,
        5545 / 2048.0, -921 / 1280.0,
        16617 / 4096.0, -6037 / 6144.0,
        -19279 / 14336.0,
        -490925 / 262144.0,
        // C[mu,mu] skipped
        // C[mu,chi]
        -18975107 / 50803200.0, 72161 / 387072.0, 7891 / 37800.0,
        -127 / 288.0, 41 / 180.0, 5 / 16.0, -2 / 3.0, 1 / 2.0,
        148003883 / 174182400.0, 13769 / 28800.0, -1983433 / 1935360.0,
        281 / 630.0, 557 / 1440.0, -3 / 5.0, 13 / 48.0,
        79682431 / 79833600.0, -67102379 / 29030400.0, 167603 / 181440.0,
        15061 / 26880.0, -103 / 140.0, 61 / 240.0,
        -40176129013 / 7664025600.0, 97445 / 49896.0,
        6601661 / 7257600.0, -179 / 168.0, 49561 / 161280.0,
        2605413599 / 622702080.0, 14644087 / 9123840.0,
        -3418889 / 1995840.0, 34729 / 80640.0,
        175214326799 / 58118860800.0, -30705481 / 10378368.0,
        212378941 / 319334400.0,
        -16759934899 / 3113510400.0, 1522256789 / 1383782400.0,
        1424729850961 / 743921418240.0,
        // C[mu,xi]
        -375027460897 / 125046361440000.0,
        7183403063 / 560431872000.0, 12674323 / 851350500.0,
        -384229 / 14968800.0, -1609 / 28350.0, 121 / 1680.0, 4 / 45.0,
        -1 / 6.0,
        30410873385097 / 2000741783040000.0,
        1117820213 / 122594472000.0, -31621753811 / 1307674368000.0,
        -431 / 17325.0, 16463 / 453600.0, 26 / 945.0, -29 / 720.0,
        151567502183 / 17863765920000.0,
        -116359346641 / 3923023104000.0, -32844781 / 1751349600.0,
        3746047 / 119750400.0, 449 / 28350.0, -1003 / 45360.0,
        -317251099510901 / 8002967132160000.0, -13060303 / 766215450.0,
        10650637121 / 326918592000.0, 629 / 53460.0,
        -40457 / 2419200.0,
        -2105440822861 / 125046361440000.0,
        146875240637 / 3923023104000.0, 205072597 / 20432412000.0,
        -1800439 / 119750400.0,
        91496147778023 / 2000741783040000.0, 228253559 / 24518894400.0,
        -59109051671 / 3923023104000.0,
        126430355893 / 13894040160000.0,
        -4255034947 / 261534873600.0,
        -791820407649841 / 42682491371520000.0,
        // C[chi,phi]
        1514 / 1323.0, -8384 / 4725.0, 4642 / 4725.0, 32 / 45.0,
        -82 / 45.0, 4 / 3.0, 2 / 3.0, -2,
        142607 / 42525.0, -2288 / 1575.0, -1522 / 945.0, 904 / 315.0,
        -13 / 9.0, -16 / 15.0, 5 / 3.0,
        120202 / 51975.0, 44644 / 14175.0, -12686 / 2835.0, 8 / 5.0,
        34 / 21.0, -26 / 15.0,
        -1097407 / 187110.0, 1077964 / 155925.0, -24832 / 14175.0,
        -12 / 5.0, 1237 / 630.0,
        -12870194 / 1216215.0, 1040 / 567.0, 109598 / 31185.0,
        -734 / 315.0,
        -126463 / 72765.0, -941912 / 184275.0, 444337 / 155925.0,
        3463678 / 467775.0, -2405834 / 675675.0,
        256663081 / 56756700.0,
        // C[chi,beta]
        1384 / 11025.0, -34 / 4725.0, -998 / 4725.0, 2 / 5.0,
        -16 / 45.0, 0, 2 / 3.0, -1,
        -12616 / 42525.0, 1268 / 4725.0, -2 / 27.0, -22 / 105.0,
        19 / 45.0, -2 / 5.0, 1 / 6.0,
        1724 / 51975.0, -1858 / 14175.0, 116 / 567.0, -22 / 105.0,
        16 / 105.0, -1 / 15.0,
        115249 / 935550.0, -26836 / 155925.0, 2123 / 14175.0, -8 / 105.0,
        17 / 1260.0,
        140836 / 1216215.0, -424 / 6237.0, 128 / 4455.0, -1 / 105.0,
        210152 / 4729725.0, -31232 / 2027025.0, 149 / 311850.0,
        30208 / 6081075.0, -499 / 225225.0,
        -68251 / 113513400.0,
        // C[chi,theta]
        -1738 / 11025.0, 18 / 175.0, 1042 / 4725.0, -14 / 45.0,
        -2 / 9.0, 2 / 3.0, 2 / 3.0, 0,
        23159 / 42525.0, 332 / 945.0, -712 / 945.0, -4 / 45.0,
        43 / 45.0, 4 / 15.0, -1 / 3.0,
        13102 / 31185.0, -1352 / 945.0, 274 / 2835.0, 124 / 105.0,
        2 / 105.0, -2 / 5.0,
        -2414843 / 935550.0, 1528 / 4725.0, 21068 / 14175.0, -16 / 105.0,
        -55 / 126.0,
        60334 / 93555.0, 20704 / 10395.0, -9202 / 31185.0, -22 / 45.0,
        40458083 / 14189175.0, -299444 / 675675.0, -90263 / 155925.0,
        -3818498 / 6081075.0, -8962 / 12285.0,
        -4259027 / 4365900.0,
        // C[chi,mu]
        -7944359 / 67737600.0, 5406467 / 38707200.0, -96199 / 604800.0,
        81 / 512.0, 1 / 360.0, -37 / 96.0, 2 / 3.0, -1 / 2.0,
        -24749483 / 348364800.0, -51841 / 1209600.0, 1118711 / 3870720.0,
        -46 / 105.0, 437 / 1440.0, -1 / 15.0, -1 / 48.0,
        6457463 / 17740800.0, -9261899 / 58060800.0, -5569 / 90720.0,
        209 / 4480.0, 37 / 840.0, -17 / 480.0,
        -324154477 / 7664025600.0, -466511 / 2494800.0,
        830251 / 7257600.0, 11 / 504.0, -4397 / 161280.0,
        -22894433 / 124540416.0, 8005831 / 63866880.0, 108847 / 3991680.0,
        -4583 / 161280.0,
        2204645983 / 12915302400.0, 16363163 / 518918400.0,
        -20648693 / 638668800.0,
        497323811 / 12454041600.0, -219941297 / 5535129600.0,
        -191773887257 / 3719607091200.0,
        // C[chi,chi] skipped
        // C[chi,xi]
        -17451293242 / 488462349375.0, 308365186 / 1915538625.0,
        -55271278 / 212837625.0, 27128 / 93555.0, -2312 / 14175.0,
        -88 / 315.0, 34 / 45.0, -2 / 3.0,
        -101520127208 / 488462349375.0, 149984636 / 1915538625.0,
        106691108 / 638512875.0, -65864 / 155925.0, 6079 / 14175.0,
        -184 / 945.0, 1 / 45.0,
        10010741462 / 37574026875.0, -99534832 / 383107725.0,
        5921152 / 54729675.0, -14246 / 467775.0, 772 / 14175.0,
        -106 / 2835.0,
        1615002539 / 75148053750.0, -35573728 / 273648375.0,
        75594328 / 638512875.0, -5312 / 467775.0, -167 / 9450.0,
        -3358119706 / 488462349375.0, 130601488 / 1915538625.0,
        2837636 / 638512875.0, -248 / 13365.0,
        46771947158 / 488462349375.0, -3196 / 3553875.0,
        -34761247 / 1915538625.0,
        -18696014 / 18091198125.0, -2530364 / 127702575.0,
        -14744861191 / 651283132500.0,
        // C[xi,phi]
        -88002076 / 13956067125.0, -86728 / 16372125.0,
        -44732 / 2837835.0, 20824 / 467775.0, 538 / 4725.0, 88 / 315.0,
        -4 / 45.0, -4 / 3.0,
        -2641983469 / 488462349375.0, -895712 / 147349125.0,
        -12467764 / 212837625.0, -37192 / 467775.0, -2482 / 14175.0,
        8 / 105.0, 34 / 45.0,
        8457703444 / 488462349375.0, 240616 / 4209975.0,
        100320856 / 1915538625.0, 54968 / 467775.0, -898 / 14175.0,
        -1532 / 2835.0,
        -4910552477 / 97692469875.0, -4832848 / 147349125.0,
        -5884124 / 70945875.0, 24496 / 467775.0, 6007 / 14175.0,
        9393713176 / 488462349375.0, 816824 / 13395375.0,
        -839792 / 19348875.0, -23356 / 66825.0,
        -4532926649 / 97692469875.0, 1980656 / 54729675.0,
        570284222 / 1915538625.0,
        -14848113968 / 488462349375.0, -496894276 / 1915538625.0,
        224557742191 / 976924698750.0,
        // C[xi,beta]
        29232878 / 97692469875.0, -18484 / 4343625.0, -70496 / 8513505.0,
        2476 / 467775.0, 34 / 675.0, 32 / 315.0, -4 / 45.0, -1 / 3.0,
        -324943819 / 488462349375.0, -4160804 / 1915538625.0,
        53836 / 212837625.0, 3992 / 467775.0, 74 / 2025.0, -4 / 315.0,
        -7 / 90.0,
        -168643106 / 488462349375.0, 237052 / 383107725.0,
        -661844 / 1915538625.0, 7052 / 467775.0, 2 / 14175.0,
        -83 / 2835.0,
        113042383 / 97692469875.0, -2915326 / 1915538625.0,
        1425778 / 212837625.0, 934 / 467775.0, -797 / 56700.0,
        -558526274 / 488462349375.0, 6064888 / 1915538625.0,
        390088 / 212837625.0, -3673 / 467775.0,
        155665021 / 97692469875.0, 41288 / 29469825.0,
        -18623681 / 3831077250.0,
        504234982 / 488462349375.0, -6205669 / 1915538625.0,
        -8913001661 / 3907698795000.0,
        // C[xi,theta]
        182466964 / 8881133625.0, 53702182 / 212837625.0,
        -4286228 / 42567525.0, -193082 / 467775.0, 778 / 4725.0,
        62 / 105.0, -4 / 45.0, 2 / 3.0,
        367082779691 / 488462349375.0, -32500616 / 273648375.0,
        -61623938 / 70945875.0, 92696 / 467775.0, 12338 / 14175.0,
        -32 / 315.0, 4 / 45.0,
        -42668482796 / 488462349375.0, -663111728 / 383107725.0,
        427003576 / 1915538625.0, 612536 / 467775.0, -1618 / 14175.0,
        -524 / 2835.0,
        -327791986997 / 97692469875.0, 421877252 / 1915538625.0,
        427770788 / 212837625.0, -8324 / 66825.0, -5933 / 14175.0,
        74612072536 / 488462349375.0, 6024982024 / 1915538625.0,
        -9153184 / 70945875.0, -320044 / 467775.0,
        489898512247 / 97692469875.0, -46140784 / 383107725.0,
        -1978771378 / 1915538625.0,
        -42056042768 / 488462349375.0, -2926201612 / 1915538625.0,
        -2209250801969 / 976924698750.0,
        // C[xi,mu]
        39534358147 / 2858202547200.0,
        -25359310709 / 1743565824000.0, -9292991 / 302702400.0,
        7764059 / 239500800.0, 1297 / 18900.0, -817 / 10080.0, -4 / 45.0,
        1 / 6.0,
        -13216941177599 / 571640509440000.0,
        -14814966289 / 245188944000.0, 36019108271 / 871782912000.0,
        35474 / 467775.0, -29609 / 453600.0, -2 / 35.0, 49 / 720.0,
        -27782109847927 / 250092722880000.0,
        99871724539 / 1569209241600.0, 3026004511 / 30648618000.0,
        -4306823 / 59875200.0, -2917 / 56700.0, 4463 / 90720.0,
        168979300892599 / 1600593426432000.0,
        2123926699 / 15324309000.0, -368661577 / 4036032000.0,
        -102293 / 1871100.0, 331799 / 7257600.0,
        1959350112697 / 9618950880000.0,
        -493031379277 / 3923023104000.0, -875457073 / 13621608000.0,
        11744233 / 239500800.0,
        -145659994071373 / 800296713216000.0,
        -793693009 / 9807557760.0, 453002260127 / 7846046208000.0,
        -53583096419057 / 500185445760000.0,
        103558761539 / 1426553856000.0,
        12272105438887727.0 / 128047474114560000.0,
        // C[xi,chi]
        -64724382148 / 97692469875.0, 16676974 / 30405375.0,
        2706758 / 42567525.0, -55222 / 93555.0, 2458 / 4725.0,
        46 / 315.0, -34 / 45.0, 2 / 3.0,
        85904355287 / 37574026875.0, 158999572 / 1915538625.0,
        -340492279 / 212837625.0, 516944 / 467775.0, 3413 / 14175.0,
        -256 / 315.0, 19 / 45.0,
        2986003168 / 37574026875.0, -7597644214 / 1915538625.0,
        4430783356 / 1915538625.0, 206834 / 467775.0, -15958 / 14175.0,
        248 / 567.0,
        -375566203 / 39037950.0, 851209552 / 174139875.0,
        62016436 / 70945875.0, -832976 / 467775.0, 16049 / 28350.0,
        5106181018156 / 488462349375.0, 3475643362 / 1915538625.0,
        -651151712 / 212837625.0, 15602 / 18711.0,
        34581190223 / 8881133625.0, -10656173804 / 1915538625.0,
        2561772812 / 1915538625.0,
        -5150169424688 / 488462349375.0, 873037408 / 383107725.0,
        7939103697617 / 1953849397500.0,
        // C[xi,xi] skipped
      ];
      ptrs = [
        0, 0, 20, 40, 60, 96, 132, 152, 152, 172, 192, 228, 264, 284, 304, 304,
        324, 360, 396, 416, 436, 456, 456, 492, 528, 564, 600, 636, 672, 672,
        708, 744, 780, 816, 852, 888, 888,
      ];
    }

    if (k < 0) {return;}         // auxout or auxin out of range
    if (auxout == auxin) {
      for (int i = Lmax * k; i < Lmax * (k + 1); i++) {
        _c[i] = 0;
      }
    } else {
      int o = ptrs[k];
      double d = _n;
      if (auxin <= _RECTIFYING && auxout <= _RECTIFYING) {
        for (int l = 0; l < Lmax; ++l) {
          int m = (Lmax - l - 1) ~/ 2; // order of polynomial in n^2
          _c[Lmax * k + l] = d * _GeoMath.polyval(m, coeffs.sublist(o), 0, _n2);
          o += m + 1;
          d *= _n;
        }
      } else {
        for (int l = 0; l < Lmax; ++l) {
          int m = (Lmax - l - 1); // order of polynomial in n
          _c[Lmax * k + l] = d * _GeoMath.polyval(m, coeffs.sublist(o), 0, _n);
          o += m + 1;
          d *= _n;
        }
      }
    }
  }
}

class _AuxAngleDiff {
  final _AuxAngle auxAngle;
  final double? diff;

  _AuxAngleDiff(this.auxAngle, [this.diff]);
}

class _AuxAngleNiter{
  final _AuxAngle auxAngle;
  final int? niter;

  _AuxAngleNiter(this.auxAngle, [this.niter]);
}