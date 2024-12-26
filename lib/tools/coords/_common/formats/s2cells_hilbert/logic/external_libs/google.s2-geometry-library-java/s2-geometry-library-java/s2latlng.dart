// Dart port of s2-geometry-library-java.S2LatLng

/*
 * Copyright 2005 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

part of 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/s2cells_hilbert.dart';

/**
 * This class represents a point on the unit sphere as a pair of latitude-longitude coordinates.
 * Like the rest of the "geometry" package, the intent is to represent spherical geometry as a
 * mathematical abstraction, so functions that are specifically related to the Earth's geometry
 * (e.g. easting/northing conversions) should be put elsewhere. Note that the serialized form of
 * this class is not stable and should not be relied upon for long-term persistence.
 *
 * @author danieldanciu@google.com (Daniel Danciu) ported from util/geometry
 * @author ericv@google.com (Eric Veach) original author
 */
class _S2LatLng {
  late final double latRadians;
  late final double lngRadians;

  _S2LatLng(this.latRadians, this.lngRadians);

  /** Convert a point (not necessarily normalized) to an S2LatLng. */
  static _S2LatLng fromPoint(_S2Point p) {
    // The "+ 0.0" is to ensure that points with coordinates of -0.0 and +0.0 (which compare equal)
    // are converted to identical S2LatLng values, since even though -0.0 == +0.0 they can be
    // formatted differently.
    return _S2LatLng(atan2(p.z + 0.0, sqrt(p.x * p.x + p.y * p.y)), atan2(p.y + 0.0, p.x + 0.0));
    // The latitude and longitude are already normalized. We use atan2 to compute the latitude
    // because the input vector is not necessarily unit length, and atan2 is much more accurate than
    // asin near the poles. Note that atan2(0, 0) is defined to be zero.
  }

  /**
   * Convert an S2LatLng to the equivalent unit-length vector (S2Point). Unnormalized values (see
   * {normalized()}) are wrapped around the sphere as would be expected based on their
   * definition as spherical angles. So for example the following pairs yield equivalent points
   * (modulo numerical error):
   * <pre>
   *   (90.5, 10) =~ (89.5, -170)
   *   (a, b) =~ (a + 360 * n, b)
   * </pre>
   * The maximum error in the result is 1.5 * DBL_EPSILON. (This does not include the error of
   * converting degrees, E5, E6, or E7 to radians.)
   */
  _S2Point toPoint() {
    double phi = latRadians;
    double theta = lngRadians;
    double cosphi = cos(phi);
    return _S2Point(cos(theta) * cosphi, sin(theta) * cosphi, sin(phi));
  }
}