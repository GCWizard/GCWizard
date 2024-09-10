/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

/** Maps a point onto the spherical earth model
 * @param p (LLPoint)
 * @return Returns a vector representing the point on the spherical earth model
 */

class _Vector {
  double x;
  double y;
  double z;

  _Vector([this.x = 0.0, this.y = 0.0, this.z = 0.0]);
}

_Vector _mapToUnitSphere(_LLPoint p) {
  _Vector v = _Vector();

  v.x = cos(p.latitude) * cos(p.longitude);
  v.y = cos(p.latitude) * sin(p.longitude);
  v.z = sin(p.latitude);

  return v;
}

_Vector _cross(_Vector v1, _Vector v2) {
  _Vector prod = _Vector();

  prod.x = v1.y * v2.z - v2.y * v1.z;
  prod.y = v1.z * v2.x - v1.x * v2.z;
  prod.z = v1.x * v2.y - v1.y * v2.x;

  return prod;
}

double _dot(_Vector v1, _Vector v2) {
  return (v1.x * v2.x + v1.y * v2.y + v1.z * v2.z);
}

_Vector _scalarMultiply(_Vector v, double scal) {
  var _v = _Vector();

  _v.x = v.x * scal;
  _v.y = v.y * scal;
  _v.z = v.z * scal;

  return _v;
}

_Vector _vectorAdd(_Vector v1, _Vector v2) {
  _Vector sum = _Vector();

  sum.x = v1.x + v2.x;
  sum.y = v1.y + v2.y;
  sum.z = v1.z + v2.z;

  return sum;
}

double _norm(_Vector v) {
  return sqrt(_dot(v, v));
}

_Vector _normalize(_Vector v) {
  var _v = _Vector();

  double length = _norm(v);
  _v.x = v.x / length;
  _v.y = v.y / length;
  _v.z = v.z / length;

  return _v;
}

/** Maps a vector onto the spherical earth model
 * @param v  (Vector)
 * @return Returns an LLPoint representing the vector on the spherical earth model
 */
_LLPoint _mapVectorToSphere(_Vector v) {

  _LLPoint p = _LLPoint();
  v = _normalize(v);
  p.latitude = asin(v.z);
  p.longitude = atan2(v.y, v.x);

  return p;
}