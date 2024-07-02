/***********************************************************************
    Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================

* \file DAuxLatitude.hpp
* \brief Header for the GeographicLib::DAuxLatitude class
*
* Copyright (c) Charles Karney (2022-2023) <karney@alum.mit.edu> and licensed
* under the MIT/X11 License.  For more information, see
* https://geographiclib.sourceforge.io/
**********************************************************************/

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';

// ignore_for_file: unused_field
// ignore_for_file: unused_element
class _DAuxLatitude extends _AuxLatitude {
  double y = 0;
  double x = 1;

  _DAuxLatitude(this.y, this.x) : super(y, x);

  double DRectifying(_AuxAngle phi1, _AuxAngle phi2) {
    // Stipulate that phi1 and phi2 are in [-90d, 90d]
    double x = phi1.radians0(), y = phi2.radians0();
    if (x == y) {
      double? d = double.nan;
      var x = Rectifying(phi1, d);
      _AuxAngle mu1 = x.auxAngle;
      d = x.diff;
      double tphi1 = phi1.tan(), tmu1 = mu1.tan();
      return tphi1.isFinite ? d! * _GeoMath.sq(_AuxLatitude.sc(tphi1) / _AuxLatitude.sc(tmu1)) : 1 / d!;
    } else if (x * y < 0) {
      return (Rectifying(phi2).auxAngle.radians0() - Rectifying(phi1).auxAngle.radians0()) / (y - x);
    } else {
      _AuxAngle bet1 = Parametric(phi1).auxAngle;
      _AuxAngle bet2 = Parametric(phi2).auxAngle;
      double dEdbet = DE(bet1, bet2), dbetdphi = DParametric(phi1, phi2);
      return _b * dEdbet / RectifyingRadius(true) * dbetdphi;
    }
  }

  double DIsometric(_AuxAngle phi1, _AuxAngle phi2) {
    // psi = asinh(tan(phi)) - e^2 * atanhee(tan(phi))
    double tphi1 = phi1.tan(), tphi2 = phi2.tan();
    return tphi1.isNaN || tphi2.isNaN
        ? double.nan
        : (tphi1.isInfinite || tphi2.isInfinite
            ? double.infinity
            : (Dasinh(tphi1, tphi2) - _e2 * Datanhee(tphi1, tphi2)) / Datan(tphi1, tphi2));
  }

  double Dsn(double x, double y) {
    double sc1 = _AuxLatitude.sc(x);
    if (x == y) return 1 / (sc1 * (1 + x * x));
    double sc2 = _AuxLatitude.sc(y), sn1 = _AuxLatitude.sn(x), sn2 = _AuxLatitude.sn(y);
    return x * y > 0 ? (sn1 / sc2 + sn2 / sc1) / ((sn1 + sn2) * sc1 * sc2) : (sn2 - sn1) / (y - x);
  }

  double Datanhee(double x, double y) {
    // atan(e*sn(tphi))/e:
    //  Datan(e*sn(x),e*sn(y))*Dsn(x,y)/Datan(x,y)
    // asinh(e1*sn(fm1*tphi)):
    //  Dasinh(e1*sn(fm1*x)), e1*sn(fm1*y)) *
    // e1 * Dsn(fm1*x, fm1*y) *fm1 / (e * Datan(x,y))
    // = Dasinh(e1*sn(fm1*x)), e1*sn(fm1*y)) *
    //  Dsn(fm1*x, fm1*y) / Datan(x,y)
    return _f < 0
        ? Datan(_e * _AuxLatitude.sn(x), _e * _AuxLatitude.sn(y)) * Dsn(x, y)
        : Dasinh(_e1 * _AuxLatitude.sn(_fm1 * x), _e1 * _AuxLatitude.sn(_fm1 * y)) * Dsn(_fm1 * x, _fm1 * y);
  }

  static double Datan(double x, double y) {
    double d = y - x, xy = x * y;
    return doubleEquals(x, y, tolerance: 1e-15)
        ? 1 / (1 + xy)
        : (xy.isInfinite && xy > 0 ? 0 : (2 * xy > -1 ? atan(d / (1 + xy)) : atan(y) - atan(x)) / d);
  }

  static double Dasinh(double x, double y) {
    double d = y - x, xy = x * y, hx = _AuxLatitude.sc(x), hy = _AuxLatitude.sc(y);
    // KF formula for x*y < 0 is asinh(y*hx - x*hy) / (y - x)
    // but this has problem if x*y overflows to -inf
    return doubleEquals(x, y, tolerance: 1e-15)
        ? 1 / hx
        : (d.isInfinite
            ? 0
            : (xy > 0
                    ? _asinh(d * (x * y < 1 ? (x + y) / (x * hy + y * hx) : (1 / x + 1 / y) / (hy / y + hx / x)))
                    : _asinh(y) - _asinh(x)) /
                d);
  }

  double DParametric(_AuxAngle phi1, _AuxAngle phi2) {
    double tx = phi1.tan(), ty = phi2.tan(), r;
    // DbetaDphi = Datan(fm1*tx, fm1*ty) * fm1 / Datan(tx, ty)
    // Datan(x, y) = 1/(1 + x^2),                       for x = y
    //             = (atan(y) - atan(x)) / (y-x),       for x*y < 0
    //             = atan( (y-x) / (1 + x*y) ) / (y-x), for x*y > 0
    if (!(tx * ty >= 0)) {
      // This includes, e.g., tx = 0, ty = inf
      r = (atan(_fm1 * ty) - atan(_fm1 * tx)) / (atan(ty) - atan(tx));
    } else if (tx == ty) {
      // This includes the case tx = ty = inf
      tx *= tx;
      if (tx <= 1) {
        r = _fm1 * (1 + tx) / (1 + _e2m1 * tx);
      } else {
        tx = 1 / tx;
        r = _fm1 * (1 + tx) / (_e2m1 + tx);
      }
    } else {
      if (tx * ty <= 1) {
        r = atan2(_fm1 * (ty - tx), 1 + _e2m1 * tx * ty) / atan2(ty - tx, 1 + tx * ty);
      } else {
        tx = 1 / tx;
        ty = 1 / ty;
        r = atan2(_fm1 * (ty - tx), _e2m1 + tx * ty) / atan2(ty - tx, 1 + tx * ty);
      }
    }
    return r;
  }

  double DE(_AuxAngle X, _AuxAngle Y) {
    _AuxAngle Xn = X.normalized();
    _AuxAngle Yn = Y.normalized();
    // We assume that X and Y are in [-90d, 90d] and have the same sign
    // If not we would include
    //    if (Xn.y() * Yn.y() < 0)
    //      return d != 0 ? (E(X) - E(Y)) / d : 1;

    // The general formula fails for x = y = 0d and x = y = 90d.  Probably this
    // is fixable (the formula works for other x = y.  But let's also stipulate
    // that x != y .

    // Make both positive, so we can do the swap a <-> b trick
    Xn._y = Xn.y().abs();
    Yn._y = Yn.y().abs();
    double x = Xn.radians0(), y = Yn.radians0(), d = y - x, sx = Xn.y(), sy = Yn.y(), cx = Xn.x(), cy = Yn.x(), k2;
    // Switch prolate to oblate; we then can use the formulas for k2 < 0
    if (_f < 0) {
      d = -d;
      var _h = sx;
      sx = cx;
      cx = _h;
      _h = sy;
      sy = cy;
      cy = _h;
      k2 = _e2;
    } else {
      k2 = -_e12;
    }
    // See DLMF: Eqs (19.11.2) and (19.11.4) letting
    // theta -> x, phi -> -y, psi -> z
    //
    // (E(y) - E(x)) / d = E(z)/d - k2 * sin(x) * sin(y) * sin(z)/d
    //                   = (E(z)/sin(z) - k2 * sin(x) * sin(y)) * sin(z)/d
    // tan(z/2) = (sin(x)*Delta(y) - sin(y)*Delta(x)) / (cos(x) + cos(y))
    //          = d * Dsin(x,y) * (sin(x) + sin(y))/(cos(x) + cos(y)) /
    //             (sin(x)*Delta(y) + sin(y)*Delta(x))
    //          = t = d * Dt
    // Delta(x) = sqrt(1 - k2 * sin(x)^2)
    // sin(z) = 2*t/(1+t^2); cos(z) = (1-t^2)/(1+t^2)
    double Dt = Dsin(x, y) * (sx + sy) / ((cx + cy) * (sx * sqrt(1 - k2 * sy * sy) + sy * sqrt(1 - k2 * sx * sx)));
    double t = d * Dt,
        Dsz = 2 * Dt / (1 + t * t),
        sz = d * Dsz,
        cz = (1 - t) * (1 + t) / (1 + t * t),
        sz2 = sz * sz,
        cz2 = cz * cz,
        dz2 = 1 - k2 * sz2,
        // E(z)/sin(z)
        Ezbsz = _EllipticFunction.RF3(cz2, dz2, 1) - k2 * sz2 * _EllipticFunction.RD(cz2, dz2, 1) / 3;
    return (Ezbsz - k2 * sx * sy) * Dsz;
  }

  static double Dsin(double x, double y) {
    double d = (x - y) / 2;
    return cos((x + y) / 2) * (d != 0 ? sin(d) / d : 1);
  }

  double DConvert(int auxin, int auxout, _AuxAngle zeta1, _AuxAngle zeta2) {
    int k = _AuxLatitude.ind(auxout, auxin);
    if (k < 0) return double.nan;
    if (auxin == auxout) return 1;
    if ((_c[_AuxLatitude.Lmax * (k + 1) - 1]).isNaN) {
      fillcoeff(auxin, auxout, k);
    }
    _AuxAngle zeta1n = zeta1.normalized();
    _AuxAngle zeta2n = zeta2.normalized();
    return 1 +
        DClenshaw(true, zeta2n.radians0() - zeta1n.radians0(), zeta1n.y(), zeta1n.x(), zeta2n.y(), zeta2n.x(),
            _c.sublist(_AuxLatitude.Lmax * k), _AuxLatitude.Lmax);
  }

  static double DClenshaw(
      bool sinp, double Delta, double szeta1, double czeta1, double szeta2, double czeta2, List<double> c, int K) {
    // Evaluate
    // (Clenshaw(sinp, szeta2, czeta2, c, K) -
    //  Clenshaw(sinp, szeta1, czeta1, c, K)) / Delta
    // or
    // sum(c[k] * (sin( (2*k+2) * zeta2) - sin( (2*k+2) * zeta2)), i, 0, K-1)
    //   / Delta
    // (if !sinp, then change sin->cos here.)
    //
    // Delta is EITHER 1, giving the plain difference OR (zeta2 - zeta1) in
    // radians, giving the divided difference.  Other values will give
    // nonsense.
    //
    int k = K;
    // suffices a b denote [1,1], [2,1] elements of matrix/vector
    double D2 = Delta * Delta,
        czetap = czeta2 * czeta1 - szeta2 * szeta1,
        szetap = szeta2 * czeta1 + czeta2 * szeta1,
        czetam = czeta2 * czeta1 + szeta2 * szeta1,
        // sin(zetam) / Delta
        szetamd = (Delta == 1 ? szeta2 * czeta1 - czeta2 * szeta1 : (Delta != 0 ? sin(Delta) / Delta : 1)),
        Xa = 2 * czetap * czetam,
        Xb = -2 * szetap * szetamd,
        u0a = 0,
        u0b = 0,
        u1a = 0,
        u1b = 0; // accumulators for sum
    for (--k; k >= 0; --k) {
      // temporary double = X . U0 - U1 + c[k] * I
      double ta = Xa * u0a + D2 * Xb * u0b - u1a + c[k], tb = Xb * u0a + Xa * u0b - u1b;
      // U1 = U0; U0 = double
      u1a = u0a;
      u0a = ta;
      u1b = u0b;
      u0b = tb;
    }
    // P = U0 . F[0] - U1 . F[-1]
    // if sinp:
    //   F[0] = [ sin(2*zeta2) + sin(2*zeta1),
    //           (sin(2*zeta2) - sin(2*zeta1)) / Delta]
    //        = 2 * [ szetap * czetam, czetap * szetamd ]
    //   F[-1] = [0, 0]
    // else:
    //   F[0] = [ cos(2*zeta2) + cos(2*zeta1),
    //           (cos(2*zeta2) - cos(2*zeta1)) / Delta]
    //        = 2 * [ czetap * czetam, -szetap * szetamd ]
    //   F[-1] = [2, 0]
    double F0a = (sinp ? szetap : czetap) * czetam,
        F0b = (sinp ? czetap : -szetap) * szetamd,
        Fm1a = sinp ? 0 : 1; // Fm1b = 0;
    // Don't both to compute sum...
    // divided difference (or difference if Delta == 1)
    return 2 * (F0a * u0b + F0b * u0a - Fm1a * u1b);
  }

  static double Dlam(double x, double y) {
    return x == y
        ? _AuxLatitude.sc(x)
        : (x.isNaN || y.isNaN
            ? double.nan
            : (x.isInfinite || y.isInfinite ? double.infinity : Dasinh(x, y) / Datan(x, y)));
  }
}
