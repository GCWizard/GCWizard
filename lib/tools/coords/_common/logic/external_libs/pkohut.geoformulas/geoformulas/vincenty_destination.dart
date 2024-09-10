part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas.dart';

/****************************************************************************/
/*  Port of Geoformulas https://github.com/pkohut/GeoFormulas               */
/*  VincentyDestination.cpp                                                 */
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
 * http://www.movable-type.co.uk/scripts/latlong-vincenty-direct.html
 * and Copyright 2005-2010 Chris Veness. Chris licensed the code
 * as Creative Commons Attribution,
 * http://creativecommons.org/licenses/by/3.0/
 */
_LLPoint _destVincenty(_LLPoint pt, double brng, double dist, Ellipsoid ells) {
  double kFlattening = ells.f;
  double kSemiMajorAxis = ells.a;
  double kSemiMinorAxis = ells.b;

  double s = dist;
  double alpha1 = brng;
  double sinAlpha1 = sin(alpha1);
  double cosAlpha1 = cos(alpha1);

  double tanU1 = (1.0 - kFlattening) * tan(pt.latitude);
  double cosU1 = 1.0 / sqrt((1.0 + tanU1 * tanU1));
  double sinU1 = tanU1 * cosU1;
  double sigma1 = atan2(tanU1, cosAlpha1);
  double sinAlpha = cosU1 * sinAlpha1;
  double cosSqAlpha = 1.0 - sinAlpha * sinAlpha;
  double uSq = cosSqAlpha * (kSemiMajorAxis * kSemiMajorAxis - kSemiMinorAxis * kSemiMinorAxis) /
      (kSemiMinorAxis * kSemiMinorAxis);
  double A = 1.0 + uSq / 16384.0 * (4096.0 + uSq * (-768.0 + uSq * (320.0 - 175.0 * uSq)));
  double B = uSq / 1024.0 * (256.0 + uSq * (-128.0 + uSq * (74.0 - 47.0 * uSq)));

  double sigma = s / (kSemiMinorAxis * A);
  double sigmaP = 2 * pi;
  double sinSigma = sin(sigma);
  double cosSigma = cos(sigma);
  double cos2SigmaM = cos(2.0 * sigma1 + sigma);
  int iterLimit = 0;
  while ((sigma - sigmaP).abs() > _kEps && ++iterLimit < 100) {
    cos2SigmaM = cos(2.0 * sigma1 + sigma);
    sinSigma = sin(sigma);
    cosSigma = cos(sigma);
    double cos2SigmaSq = cos2SigmaM * cos2SigmaM;
    double deltaSigma = B * sinSigma * (cos2SigmaM + B * 0.25 * (cosSigma * (-1.0 + 2.0 * cos2SigmaSq) -
        B / 6.0 * cos2SigmaM * (-3.0 + 4.0 * sinSigma * sinSigma) * (-3.0 + 4.0 * cos2SigmaSq)));

    sigmaP = sigma;
    sigma = s / (kSemiMinorAxis * A) + deltaSigma;
  }

  double tmp = sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1;
  double lat2 = atan2(sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1,
      (1.0 - kFlattening) * sqrt(sinAlpha * sinAlpha + tmp * tmp));
  double lambda = atan2(sinSigma * sinAlpha1, cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1);
  double C = kFlattening / 16.0 * cosSqAlpha * (4.0 + kFlattening * (4.0 - 3.0 * cosSqAlpha));
  double L = lambda - (1.0 - C) * kFlattening * sinAlpha *
      (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1.0 + 2.0 * cos2SigmaM * cos2SigmaM)));

  return _LLPoint(latitude: lat2, longitude: pt.longitude + L);
}