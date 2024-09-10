/*
 * Dart port of: https://github.com/mitre/geodetic_library (Apache-2.0 license)
 * Copyright 2007-2011 The MITRE Corporation.
 */

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/mitre.geodetic_library/geodetic_library.dart';

// ignore_for_file: unused_field

typedef _LLPointPair = List<_LLPoint>;

class _LLPoint {
  /* Coordinates must be in radians. */
  double latitude; /**< Number representing the latitude. Valid range is \f$[-\pi/2,\pi/2]\f$.
      A positive latitude indicates a position in the northern hemisphere*/
  double longitude; /**< Number representing the longitude.
                          * Valid range is \f$[-\pi,\pi]\f$.  A positive longitude indicates a position in the eastern hemisphere */

  _LLPoint([this.latitude = 0.0, this.longitude = 0.0]);

  void set(double dLat, double dLon) {
    latitude = dLat;
    longitude = dLon;
  }

  static _LLPoint fromLatLng(LatLng latlng) {
    return _LLPoint(latlng.latitudeInRad, latlng.longitudeInRad);
  }

  LatLng toLatLng() {
    return LatLng(radianToDeg(latitude), radianToDeg(longitude));
  }

  String toString() {
    return latitude.toString() + ", " + longitude.toString();
  }
}

enum _LineType {SEGMENT, SEMIINFINITE, INFINITE}

class _Arc {
  _LLPoint centerPoint = _LLPoint();              /**< The center of the arc */
  _LLPoint startPoint = _LLPoint();               /**< The start of the arc */
  double startAz = 0.0;                         /**< Azimuth at centerPoint of geodesic from centerPoint to startPoint */
  _LLPoint endPoint = _LLPoint();                 /**< The end of the arc */
  double endAz = 0.0;                           /**< Azimuth at centerPoint of geodesic from centerPoint to endPoint */
  double radius = 0.0;                          /**< The distance from the centerPoint to any point on the arc */
  _ArcDirection dir = _ArcDirection.CLOCKWISE;    /**< -1 => counterclockwise, +1 => clockwise */
  double subtendedAngle = 0.0;                  /**< Normalized difference betweeen startAz and endAz. If dir = CLOCKWISE, then subtendedAngle > 0 */

  _Arc();
}

enum _ArcDirection {CLOCKWISE, COUNTERCLOCKWISE}