import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

LatLng vincentyDirect(LatLng coord, double bearing, double dist, Ellipsoid ells) {
  double lat = coord.latitudeInRad;
  double lon = coord.longitudeInRad;

  double _s = dist;
  double _alpha1 = bearing;
  double _sinAlpha1 = sin(_alpha1);
  double _cosAlpha1 = cos(_alpha1);
  double _a = ells.a;
  double _b = ells.b;
  double _tanU1 = (1.0 - ells.f) * tan(lat);
  double _cosU1 = 1.0 / sqrt((1.0 + _tanU1 * _tanU1));
  double _sinU1 = _tanU1 * _cosU1;
  double _sigma1 = atan2(_tanU1, _cosAlpha1);
  double _sinAlpha = _cosU1 * _sinAlpha1;
  double _cosSqAlpha = 1.0 - _sinAlpha * _sinAlpha;
  double _uSq = _cosSqAlpha * (_a * _a - _b * _b) / (_b * _b);
  double _A = 1.0 + _uSq / 16384.0 * (4096.0 + _uSq * (-768.0 + _uSq * (320.0 - 175.0 * _uSq)));
  double _B = _uSq / 1024.0 * (256.0 + _uSq * (-128.0 + _uSq * (74.0 - 47.0 * _uSq)));

  double _sigma = _s / (_b * _A);
  double _sigmaP = pi * 2;
  double _sinSigma = sin(_sigma);
  double _cosSigma = cos(_sigma);
  double _cos2SigmaM = cos(2.0 * _sigma1 + _sigma);
  int _iterLimit = 0;
  while ((_sigma - _sigmaP).abs() > practical_epsilon && ++_iterLimit < 100) {
    _cos2SigmaM = cos(2.0 * _sigma1 + _sigma);
    _sinSigma = sin(_sigma);
    _cosSigma = cos(_sigma);
    double _cos2SigmaSq = _cos2SigmaM * _cos2SigmaM;
    double _deltaSigma = _B *
        _sinSigma *
        (_cos2SigmaM +
            _B *
                0.25 *
                (_cosSigma * (-1.0 + 2.0 * _cos2SigmaSq) -
                    _B / 6.0 * _cos2SigmaM * (-3.0 + 4.0 * _sinSigma * _sinSigma) * (-3.0 + 4.0 * _cos2SigmaSq)));

    _sigmaP = _sigma;
    _sigma = _s / (_b * _A) + _deltaSigma;
  }

  double _tmp = _sinU1 * _sinSigma - _cosU1 * _cosSigma * _cosAlpha1;
  double _lat2 = atan2(
      _sinU1 * _cosSigma + _cosU1 * _sinSigma * _cosAlpha1, (1.0 - ells.f) * sqrt(_sinAlpha * _sinAlpha + _tmp * _tmp));
  double _lambda = atan2(_sinSigma * _sinAlpha1, _cosU1 * _cosSigma - _sinU1 * _sinSigma * _cosAlpha1);
  double _C = ells.f / 16.0 * _cosSqAlpha * (4.0 + ells.f * (4.0 - 3.0 * _cosSqAlpha));
  double _L = _lambda -
      (1.0 - _C) *
          ells.f *
          _sinAlpha *
          (_sigma + _C * _sinSigma * (_cos2SigmaM + _C * _cosSigma * (-1.0 + 2.0 * _cos2SigmaM * _cos2SigmaM)));

  _lat2 = radianToDeg(_lat2);
  lon = _modLon(radianToDeg(lon + _L));
  return LatLng(_lat2, lon);
}

double _modLon(double x) {
  x = modulo360(x);

  if (x > 180) x -= 360;

  return x;
}
