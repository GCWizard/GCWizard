/***********************************************************************
    Dart port of C++ implementation of
    ======================
    GeographicLib
    ======================
 * \file AuxAngle.hpp
 * \brief Header for the GeographicLib::AuxAngle class
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

// ignore_for_file: unused_field
// ignore_for_file: unused_element
class _AuxAngle {
  double _y;
  double _x;

  _AuxAngle([this._y = 0, this._x = 1]);

  double y() {
    return _y;
  }

  double x() {
    return _x;
  }

  static _AuxAngle degrees(double d) {
    var p = _Pair();
    _GeoMath.sincosd(p, d);
    return _AuxAngle(p.first, p.second);
  }

  double degrees0() {
    return _GeoMath.atan2d(_y, _x);
  }

  static _AuxAngle NaN() {
    return _AuxAngle(double.nan, double.nan);
  }

  static _AuxAngle radians(double r) {
    return _AuxAngle(sin(r), cos(r));
  }

  double radians0() {
    return atan2(_y, _x);
  }

  static _AuxAngle copy(_AuxAngle p) {
    return _AuxAngle(p._y, p._x);
  }

  _AuxAngle operator +(_AuxAngle p) {
    // Do nothing if p.tan() == 0 to preserve signs of y() and x()
    if (p.tan() != 0) {
      double x = _x * p._x - _y * p._y;
      _y = _y * p._x + _x * p._y;
      _x = x;
    }
    return this;
  }

  /**
   * @return the tangent of the angle.
   **********************************************************************/
  double tan() {
    return _y / _x;
  }

  double lam() {
    return _asinh(tan());
  }

  _AuxAngle normalized() {
    if ((tan().isNaN) || (_y.abs() > double.maxFinite / 2 && _x.abs() > double.maxFinite / 2)) {
      // deal with
      // (0,0), (inf,inf), (nan,nan), (nan,x), (y,nan), (toobig,toobig)
      return NaN();
    }
    double r = _GeoMath.hypot(_y, _x), y = _y / r, x = _x / r;
    // deal with r = inf, then one of y,x becomes 1
    if (y.isNaN) y = _copySign(1.0, _y);
    if (x.isNaN) x = _copySign(1.0, _x);
    return _AuxAngle(y, x);
  }

  _AuxAngle copyquadrant(_AuxAngle p) {
    return _AuxAngle(_copySign(y(), p.y()), _copySign(x(), p.x()));
  }
}
