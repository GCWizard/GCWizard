import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

class _Vector {
  double x = 0;
  double y = 0;
  double z = 0;

  _Vector(this.x, this.y, this.z);
}

_Vector add(_Vector v1, _Vector v2) {
  return _Vector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
}

_Vector multiply(_Vector v, double s) {
  return _Vector(v.x * s, v.y * s, v.z * s);
}

class _Matrix {
  late List<List<double>> M;

  _Matrix(double M00, double M01, double M02, double M10, double M11, double M12, double M20, double M21, double M22) {
    M = [
      [M00, M01, M02],
      [M10, M11, M12],
      [M20, M21, M22]
    ];
  }

  _Vector multiply(_Vector V) {
    return _Vector(M[0][0] * V.x + M[0][1] * V.y + M[0][2] * V.z, M[1][0] * V.x + M[1][1] * V.y + M[1][2] * V.z,
        M[2][0] * V.x + M[2][1] * V.y + M[2][2] * V.z);
  }
}

class EllipsoidTransformation {
  late _Vector mRParam;
  late _Vector mTParam;
  late double mDeformation;
  late Ellipsoid srcElls;
  late Ellipsoid dstElls;

  EllipsoidTransformation(Ellipsoid _srcElls, Ellipsoid _dstElls, double ex, double ey, double ez, double dx, double dy,
      double dz, double m) {
    mRParam = _Vector(ex, ey, ez);
    mTParam = _Vector(dx, dy, dz);
    mDeformation = m;
    srcElls = _srcElls;
    dstElls = _dstElls;
  }

  EllipsoidTransformation invert() {
    return EllipsoidTransformation(
        dstElls, srcElls, -mRParam.x, -mRParam.y, -mRParam.z, -mTParam.x, -mTParam.y, -mTParam.z, -mDeformation);
  }

  _Matrix RotationMatrix() {
    double ex = mRParam.x * pi / 180.0 / 3600.0;
    double ey = mRParam.y * pi / 180.0 / 3600.0;
    double ez = mRParam.z * pi / 180.0 / 3600.0;

    return _Matrix(1, ez, -ey, -ez, 1, ex, ey, -ex, 1);
  }
}

const List<_TransformationData> _transformationsGK = [
  _TransformationData(
      ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, -1.040, -0.350, 3.080, 582.0, 105.0, 414.0, 8.3e-6), //GK1 2001
  _TransformationData(
      ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, -0.202, -0.045, 2.455, 598.1, 73.7, 418.2, 6.7e-6), //GK2 1995
  _TransformationData(ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, -0.105, -0.013, 2.378, 584.8, 67.0, 400.3,
      10.29e-6), //GK3 D-Nord
  _TransformationData(
      ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, 0.796, 0.052, 3.601, 590.5, 69.5, 411.6, 8.3e-6), //GK4 D-Mitte
  _TransformationData(
      ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, -0.894, -0.068, 1.563, 597.1, 71.4, 412.1, 7.58e-6), //GK5 D-Süd
];

class TransformableDate {
  final String name;
  final int? transformationIndex;
  final Ellipsoid ellipsoid;

  const TransformableDate(this.name, this.transformationIndex, this.ellipsoid);
}

final List<TransformableDate> transformableDates = [
  TransformableDate(ELLIPSOID_NAME_WGS84, null, getEllipsoidByName(ELLIPSOID_NAME_WGS84)!),
  TransformableDate(
      '$ELLIPSOID_NAME_BESSEL1841: DHDN(Potsdam) 2001', 0, getEllipsoidByName(ELLIPSOID_NAME_BESSEL1841)!),
  TransformableDate(
      '$ELLIPSOID_NAME_BESSEL1841: DHDN(Potsdam) 1995', 1, getEllipsoidByName(ELLIPSOID_NAME_BESSEL1841)!),
  TransformableDate('$ELLIPSOID_NAME_BESSEL1841: MGI', 4, getEllipsoidByName(ELLIPSOID_NAME_BESSEL1841)!),
  TransformableDate('$ELLIPSOID_NAME_BESSEL1841: LV95', 5, getEllipsoidByName(ELLIPSOID_NAME_BESSEL1841)!),
  TransformableDate(
      '$ELLIPSOID_NAME_KRASOVSKY1940: S42/83(Pulkowo) 2001', 3, getEllipsoidByName(ELLIPSOID_NAME_KRASOVSKY1940)!),
  TransformableDate(
      '$ELLIPSOID_NAME_KRASOVSKY1940: S42/83(Pulkowo) 1995', 2, getEllipsoidByName(ELLIPSOID_NAME_KRASOVSKY1940)!),
  TransformableDate('$ELLIPSOID_NAME_AIRY1830: OSGB36', 6, getEllipsoidByName(ELLIPSOID_NAME_AIRY1830)!),
  TransformableDate('$ELLIPSOID_NAME_AIRYMODIFIED: IRL 1965', 7, getEllipsoidByName(ELLIPSOID_NAME_AIRYMODIFIED)!),
  TransformableDate('$ELLIPSOID_NAME_HAYFORD1924: ED50', 8, getEllipsoidByName(ELLIPSOID_NAME_HAYFORD1924)!),
  TransformableDate(ELLIPSOID_NAME_CLARKE1866, 9, getEllipsoidByName(ELLIPSOID_NAME_CLARKE1866)!),
];

class _TransformationData {
  final String from;
  final String to;
  final double ex;
  final double ey;
  final double ez;
  final double dx;
  final double dy;
  final double dz;
  final double m;

  const _TransformationData(this.from, this.to, this.ex, this.ey, this.ez, this.dx, this.dy, this.dz, this.m);
}

const List<_TransformationData> _transformations = [
  _TransformationData(ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, -0.202, -0.045, 2.455, 598.1, 73.7, 418.2,
      6.7e-6), //DHDN(Potsdam) 2001
  _TransformationData(ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, -1.04, -0.35, 3.08, 582.0, 105.0, 414.0,
      8.3e-6), //DHDN(Potsdam) 2001
  _TransformationData(ELLIPSOID_NAME_KRASOVSKY1940, ELLIPSOID_NAME_WGS84, 0.02, -0.26, -0.13, 24.0, -123.0, -94.0,
      1.1e-6), //DHDN(Potsdam) 2001
  _TransformationData(ELLIPSOID_NAME_KRASOVSKY1940, ELLIPSOID_NAME_WGS84, 0.063, 0.247, 0.041, 24.9, -126.4, -93.2,
      1.01e-6), //DHDN(Potsdam) 2001
  _TransformationData(ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, -5.137, -1.474, -5.297, 577.326, 90.129, 463.919,
      2.423e-6), //DHDN(Potsdam) 2001
  _TransformationData(ELLIPSOID_NAME_BESSEL1841, ELLIPSOID_NAME_WGS84, 0.0, 0.0, 0.0, 674.374, 15.056, 405.346,
      0.0e-6), //DHDN(Potsdam) 2001
  _TransformationData(ELLIPSOID_NAME_AIRY1830, ELLIPSOID_NAME_WGS84, -0.1502, -0.247, -0.8421, 446.448, -125.157,
      542.06, -20.4894e-6), //DHDN(Potsdam) 2001
  _TransformationData(ELLIPSOID_NAME_AIRYMODIFIED, ELLIPSOID_NAME_WGS84, -0.202, -0.045, 2.455, 482.53, -130.596,
      564.557, 8.15e-6), //DHDN(Potsdam) 2001
  _TransformationData(ELLIPSOID_NAME_HAYFORD1924, ELLIPSOID_NAME_WGS84, -0.4, 0.2, -0.4, -102.0, -102.0, -129.0,
      2.5e-6), //DHDN(Potsdam) 2001
  _TransformationData(
      ELLIPSOID_NAME_CLARKE1866, ELLIPSOID_NAME_WGS84, 0.0, 0.0, 0.0, -8.0, 160.0, 176.0, 0.0e-6) //Clarke 1866
];

EllipsoidTransformation _getTransformation(Ellipsoid srcElls, Ellipsoid dstElls, int index, bool back) {
  //back = true: WGS > anderen...
  EllipsoidTransformation trans = EllipsoidTransformation(
      srcElls,
      dstElls,
      _transformations[index].ex,
      _transformations[index].ey,
      _transformations[index].ez,
      _transformations[index].dx,
      _transformations[index].dy,
      _transformations[index].dz,
      _transformations[index].m);

  if (back) {
    return trans.invert();
  }

  return trans;
}

EllipsoidTransformation _getTransformationGK(Ellipsoid srcElls, Ellipsoid dstElls, int index, bool back) {
  //back = true: WGS > anderen...
  EllipsoidTransformation trans = EllipsoidTransformation(
      srcElls,
      dstElls,
      _transformationsGK[index].ex,
      _transformationsGK[index].ey,
      _transformationsGK[index].ez,
      _transformationsGK[index].dx,
      _transformationsGK[index].dy,
      _transformationsGK[index].dz,
      _transformationsGK[index].m);

  if (back) {
    return trans.invert();
  }

  return trans;
}

LatLng ellipsoidTransformLatLng(LatLng coord, int transformationIndex, bool back, bool GK) {
  Ellipsoid srcElls;
  Ellipsoid dstElls;
  if (!GK) {
    srcElls = getEllipsoidByName(_transformations[transformationIndex].from)!;
    dstElls = getEllipsoidByName(_transformations[transformationIndex].to)!;
  } else {
    srcElls = getEllipsoidByName(_transformationsGK[transformationIndex].from)!;
    dstElls = getEllipsoidByName(_transformationsGK[transformationIndex].to)!;
  }

  if (srcElls.name == dstElls.name) {
    return coord;
  }

  Ellipsoid currentElls = back ? dstElls : srcElls;
  double h = 0;
  double a = currentElls.a;
  double b = currentElls.b;
  double e2 = currentElls.e2;

  double _lat = coord.latitudeInRad;
  double _lon = coord.longitudeInRad;

  double N = a / sqrt(1 - e2 * sin(_lat) * sin(_lat));
  var mVx = (N + h) * cos(_lat) * cos(_lon);
  var mVy = (N + h) * cos(_lat) * sin(_lon);
  var mVz = (N * b * b / (a * a) + h) * sin(_lat);
  _Vector mV = _Vector(mVx, mVy, mVz);

  EllipsoidTransformation trans;
  if (!GK) {
    trans = _getTransformation(srcElls, dstElls, transformationIndex, back);
  } else {
    trans = _getTransformationGK(srcElls, dstElls, transformationIndex, back);
  }

  _Vector RotV = trans.RotationMatrix().multiply(mV);
  _Vector dV = trans.RotationMatrix().multiply(trans.mTParam);

  double m = 1 + trans.mDeformation;
  mV = multiply(add(RotV, dV), m);

  currentElls = back ? srcElls : dstElls;
  h = 0;
  a = currentElls.a;
  b = currentElls.b;
  e2 = currentElls.e2;

  double s = sqrt(mV.x * mV.x + mV.y * mV.y);
  double T = atan(mV.z * a / (s * b));

  _lat = atan((mV.z + e2 * a * a / b * pow(sin(T), 3)) / (s - e2 * a * pow(cos(T), 3)));
  _lon = atan(mV.y / mV.x);

  return LatLng(radianToDeg(_lat), radianToDeg(_lon));
}
