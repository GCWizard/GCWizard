/***********************************************************************
    Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================

 * Copyright (c) Charles Karney (2012-2022) <charles@karney.com> and licensed
 * under the MIT/X11 License.  For more information, see
 * https://geographiclib.sourceforge.io/
 * https://sourceforge.net/projects/geographiclib/

 **********************************************************************/

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';

// ignore_for_file: unused_field
// ignore_for_file: unused_element
class _Ellipsoid {
  late final double a;
  late final double f;

  _Ellipsoid(this.a, this.f);

  double get f1 {
    return 1 - f;
  }

  double get e2 {
    return f * (2 - f);
  }

  double get es {
    return (f < 0 ? -1 : 1) * sqrt(e2.abs());
  }

  double get e12 {
    return e2 / (1 - e2);
  }

  double get b {
    return a * f1;
  }

  _TransverseMercator get tm {
    return _TransverseMercator(a, f, 1.0);
  }

  _EllipticFunction get ell {
    return _EllipticFunction(-e12);
  }

  double QuarterMeridian() {
    return b * ell.E0();
  }

  double InverseParametricLatitude(double beta) {
    return _GeoMath.atand(_GeoMath.tand(_GeoMath.LatFix(beta)) / f1);
  }

  double InverseRectifyingLatitude(double mu) {
    if ((mu).abs() == _GeoMath.qd) return mu;
    return InverseParametricLatitude(ell.Einv(mu * ell.E0() / _GeoMath.qd) / _GeoMath.degree());
  }

  List<double> RectifyingToConformalCoeffs() {
    return tm._bet;
  }

  List<double> ConformalToRectifyingCoeffs() {
    return tm._alp;
  }

  double IsometricLatitude(double phi) {
    return _GeoMath.asinh(_GeoMath.taupf(_GeoMath.tand(_GeoMath.LatFix(phi)), es)) / _GeoMath.degree();
  }

  double InverseIsometricLatitude(double psi) {
    return _GeoMath.atand(_GeoMath.tauf(_sinh(psi * _GeoMath.degree()), es));
  }
}
