part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas.dart';

/****************************************************************************/
/*  Port of Geoformulas https://github.com/pkohut/GeoFormulas               */
/*  VincentyDistance.h                                                      */
/****************************************************************************/
/*                                                                          */
/*  Copyright 2008 - 2016 Paul Kohut                                        */
/*  Licensed under the Apache License, Version 2.0 (the "License"); you may */
/*  not use this file except in compliance with the License. You may obtain */
/*  a copy of the License at                                                */
/*                                                                          */
/*  http://www.apache.org/licenses/LICENSE-2.0                              */
/*                                                                          */
/*  Unless required by applicable law or agreed to in writing, software     */
/*  distributed under the License is distributed on an "AS IS" BASIS,       */
/*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or         */
/*  implied. See the License for the specific language governing            */
/*  permissions and limitations under the License.                          */
/*                                                                          */
/****************************************************************************/

/**
 * \note
 * This function is a modified version found at
 * http://www.movable-type.co.uk/scripts/latlong-vincenty.html#inverse
 * and Copyright 2005-2010 Chris Veness. Chris licensed the code
 * as Creative Commons Attribution,
 * http://creativecommons.org/licenses/by/3.0/
 */
_InverseResult _distVincenty(_LLPoint pt1, _LLPoint pt2, Ellipsoid ells) {
  double kFlattening = ells.f;
  double kSemiMajorAxis = ells.a;
  double kSemiMinorAxis = ells.b;

  double L = pt2.longitude - pt1.longitude;
  double U1 = atan((1 - kFlattening) * tan(pt1.latitude));
  double U2 = atan((1 - kFlattening) * tan(pt2.latitude));

  double sinU1 = sin(U1);
  double cosU1 = cos(U1);
  double sinU2 = sin(U2);
  double cosU2 = cos(U2);

  double dCosU1CosU2 = cosU1 * cosU2;
  double dCosU1SinU2 = cosU1 * sinU2;

  double dSinU1SinU2 = sinU1 * sinU2;
  double dSinU1CosU2 = sinU1 * cosU2;

  double lambda = L;
  double lambdaP = 2 * pi;
  int iterLimit = 0;
  double cosSqAlpha;
  double sinSigma;
  double cos2SigmaM;
  double cosSigma;
  double sigma;
  double sinAlpha;
  double C;
  double sinLambda, cosLambda;

  do {
    sinLambda = sin(lambda);
    cosLambda = cos(lambda);
    sinSigma = sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
        (dCosU1SinU2 - dSinU1CosU2 * cosLambda) * (dCosU1SinU2 - dSinU1CosU2 * cosLambda));

    if (sinSigma == 0) {
      return _InverseResult(azimuth: 0.0, reverseAzimuth: 0.0, distance: 0.0);
    }
    cosSigma = dSinU1SinU2 + dCosU1CosU2 * cosLambda;
    sigma = atan2(sinSigma, cosSigma);
    sinAlpha = dCosU1CosU2 * sinLambda / sinSigma;
    cosSqAlpha = 1.0 - sinAlpha * sinAlpha;
    cos2SigmaM = cosSigma - 2.0 * dSinU1SinU2 / cosSqAlpha;

    if (cos2SigmaM.isNaN) cos2SigmaM = 0.0; // equatorial line: cosSqAlpha=0
    C = kFlattening / 16.0 * cosSqAlpha * (4.0 + kFlattening * (4.0 - 3.0 * cosSqAlpha));
    lambdaP = lambda;
    lambda = L + (1.0 - C) * kFlattening * sinAlpha *
        (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1.0 + 2.0 * cos2SigmaM * cos2SigmaM)));
  } while ((lambda - lambdaP).abs() > _kEps && ++iterLimit < 40);

  double uSq = cosSqAlpha * (kSemiMajorAxis * kSemiMajorAxis - kSemiMinorAxis * kSemiMinorAxis) /
      (kSemiMinorAxis * kSemiMinorAxis);
  double A = 1.0 + uSq / 16384.0 * (4096.0 + uSq * (-768.0 + uSq * (320.0 - 175.0 * uSq)));
  double B = uSq / 1024.0 * (256.0 + uSq * (-128.0 + uSq * (74.0 - 47.0 * uSq)));
  double deltaSigma = B * sinSigma * (cos2SigmaM + B / 4.0 * (cosSigma * (-1.0 + 2.0 * cos2SigmaM * cos2SigmaM) -
      B / 6.0 * cos2SigmaM * (-3.0 + 4.0 * sinSigma * sinSigma) * (-3.0 + 4.0 * cos2SigmaM * cos2SigmaM)));

  var result = _InverseResult();
  result.distance = kSemiMinorAxis * A * (sigma - deltaSigma);
  result.azimuth = atan2(cosU2 * sinLambda, dCosU1SinU2 - dSinU1CosU2 * cosLambda);
  result.reverseAzimuth = pi + atan2(cosU1 * sinLambda, -dSinU1CosU2 + dCosU1SinU2 * cosLambda);

  if (result.reverseAzimuth < 0.0) result.reverseAzimuth = 2 * pi + result.reverseAzimuth;

  if (result.azimuth < 0.0) result.azimuth = 2 * pi + result.azimuth;

  return result;
}