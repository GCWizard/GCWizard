import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:latlong2/latlong.dart';

/*
 * BASIC CALCULATION CLASS!
 * 
 * Crazy class which calculates distance and bearings
 * between two coordinates A and B
 * 
 * Source: several geodetic websites.
 */

DistanceBearingData vincentyInverse(LatLng coord1, LatLng coord2, Ellipsoid ells) {
  double _lat1 = coord1.latitudeInRad;
  double _lon1 = coord1.longitudeInRad;
  double _lat2 = coord2.latitudeInRad;
  double _lon2 = coord2.longitudeInRad;

  double _L = _lon2 - _lon1;
  double _U1 = atan((1 - ells.f) * tan(_lat1));
  double _U2 = atan((1 - ells.f) * tan(_lat2));

  double _sinU1 = sin(_U1);
  double _cosU1 = cos(_U1);
  double _sinU2 = sin(_U2);
  double _cosU2 = cos(_U2);

  double _dCosU1CosU2 = _cosU1 * _cosU2;
  double _dCosU1SinU2 = _cosU1 * _sinU2;

  double _dSinU1SinU2 = _sinU1 * _sinU2;
  double _dSinU1CosU2 = _sinU1 * _cosU2;

  double _a = ells.a;
  double _lambda = _L;
  double _lambdaP = pi * 2;
  int _iterLimit = 0;
  double _cosSqAlpha;
  double _sinSigma;

  double _cos2SigmaM;
  double _cosSigma;
  double _sigma;
  double _sinAlpha;
  double _C;
  double _sinLambda, _cosLambda;

  DistanceBearingData _result = DistanceBearingData();

  do {
    _sinLambda = sin(_lambda);
    _cosLambda = cos(_lambda);
    _sinSigma = sqrt((_cosU2 * _sinLambda) * (_cosU2 * _sinLambda) +
        (_dCosU1SinU2 - _dSinU1CosU2 * _cosLambda) * (_dCosU1SinU2 - _dSinU1CosU2 * _cosLambda));

    if (_sinSigma == 0) {
      return _result;
    }

    _cosSigma = _dSinU1SinU2 + _dCosU1CosU2 * _cosLambda;
    _sigma = atan2(_sinSigma, _cosSigma);
    _sinAlpha = _dCosU1CosU2 * _sinLambda / _sinSigma;
    _cosSqAlpha = 1.0 - _sinAlpha * _sinAlpha;
    _cos2SigmaM = _cosSigma - 2.0 * _dSinU1SinU2 / _cosSqAlpha;

    if (_cos2SigmaM.isNaN) _cos2SigmaM = 0.0; // equatorial line: cosSqAlpha=0

    _C = ells.f / 16.0 * _cosSqAlpha * (4.0 + ells.f * (4.0 - 3.0 * _cosSqAlpha));
    _lambdaP = _lambda;
    _lambda = _L +
        (1.0 - _C) *
            ells.f *
            _sinAlpha *
            (_sigma + _C * _sinSigma * (_cos2SigmaM + _C * _cosSigma * (-1.0 + 2.0 * _cos2SigmaM * _cos2SigmaM)));
  } while ((_lambda - _lambdaP).abs() > practical_epsilon && ++_iterLimit < 40);

  double uSq = _cosSqAlpha * (_a * _a - ells.b * ells.b) / (ells.b * ells.b);
  double A = 1.0 + uSq / 16384.0 * (4096.0 + uSq * (-768.0 + uSq * (320.0 - 175.0 * uSq)));
  double B = uSq / 1024.0 * (256.0 + uSq * (-128.0 + uSq * (74.0 - 47.0 * uSq)));
  double deltaSigma = B *
      _sinSigma *
      (_cos2SigmaM +
          B /
              4.0 *
              (_cosSigma * (-1.0 + 2.0 * _cos2SigmaM * _cos2SigmaM) -
                  B /
                      6.0 *
                      _cos2SigmaM *
                      (-3.0 + 4.0 * _sinSigma * _sinSigma) *
                      (-3.0 + 4.0 * _cos2SigmaM * _cos2SigmaM)));

  //distance
  _result.distance = ells.b * A * (_sigma - deltaSigma);
  //coord1 -> coord2 direction
  var _bearingAToB = atan2(_cosU2 * _sinLambda, _dCosU1SinU2 - _dSinU1CosU2 * _cosLambda);
  //coord2 -> coord1 direction
  var _bearingBToA = pi + atan2(_cosU1 * _sinLambda, -_dSinU1CosU2 + _dCosU1SinU2 * _cosLambda);

  if (_bearingBToA < 0.0) _bearingBToA = (pi * 2) + _bearingBToA;

  if (_bearingAToB < 0.0) _bearingAToB = (pi * 2) + _bearingAToB;

  _result.bearingAToBInRadian = _bearingAToB;
  _result.bearingBToAInRadian = _bearingBToA;

  return _result;
}
