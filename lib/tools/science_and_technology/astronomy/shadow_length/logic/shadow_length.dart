import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_position/logic/sun_position.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

class ShadowLength {
  final double length;
  final double bearing;
  final LatLng shadowEndPosition;
  final SunPosition sunPosition;

  ShadowLength(this.length, this.bearing, this.shadowEndPosition, this.sunPosition);
}

ShadowLength shadowLength(
  double objectHeight,
  LatLng coords,
  Ellipsoid ells,
  DateTimeTZ datetime,
) {
  var julianDate = JulianDate(datetime);
  var sunPosition = SunPosition(coords, julianDate, ells);
  var shadowLen =
      objectHeight * cos(degreesToRadian(sunPosition.altitude)) / sin(degreesToRadian(sunPosition.altitude));
  // Sun is in one Direction, so shadow is the opposite direction
  var shadowAzimuth = normalizeBearing(sunPosition.azimuth + 180.0);

  var _currentPosition = projection(coords, shadowAzimuth, shadowLen, ells);

  return ShadowLength(shadowLen, shadowAzimuth, _currentPosition, sunPosition);
}
