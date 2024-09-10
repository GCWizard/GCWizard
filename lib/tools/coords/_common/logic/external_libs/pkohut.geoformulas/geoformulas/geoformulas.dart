part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas.dart';

/****************************************************************************/
/*  Port of Geoformulas https://github.com/pkohut/GeoFormulas               */
/*  GeoFormulas.h                                                           */
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

/*
 *   \brief Epsilon
 *   \returns double epsilon of 0.5e-15.
 *   \note Order 8260.54A Appendix 2, 3.3 Tolerances, states
 *   "Empirical studies have shown that eps = 0.5e-13 and
 *   tol = 1.0-e9 work well."
 *
 *   When implementing the TerpsTest validation application
 *   eps must be set to 0.5e-15 for all tests to pass. If
 *   set as stated in section 3.3 of 8260.54A then the
 *   Tangent Fixed Radius Arc and Locus Tan Fixed Radius Arc
 *   fails validation.
 *
 */
const double _kEps = 0.5e-15;

class _InverseResult {
  double azimuth;
  double reverseAzimuth;
  double distance;

  _InverseResult({this.azimuth = 0.0, this.reverseAzimuth = 0.0, this.distance = 0.0});
}

class _LLPoint {
  double latitude;
  double longitude;

  _LLPoint({this.latitude = 0.0, this.longitude = 0.0});

  void set(double dLat, double dLon) {
    latitude = dLat;
    longitude = dLon;
  }

  static _LLPoint fromLatLng(LatLng latlng) {
    return _LLPoint(latitude: latlng.latitudeInRad, longitude: latlng.longitudeInRad);
  }

  LatLng toLatLng() {
    return LatLng(radianToDeg(latitude), radianToDeg(longitude));
  }

  String toString() {
    return latitude.toString() + ", " + longitude.toString();
  }
}