import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/coord_format_getter.dart' as coordUtils;
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/_common/logic/julian_date.dart';
import 'package:gc_wizard/tools/science_and_technology/astronomy/sun_position/logic/sun_position.dart';
import 'package:gc_wizard/utils/math_utils.dart';
import 'package:latlong2/latlong.dart';

class ShadowLength {
  final double length;
  final LatLng shadowEndPosition;
  final SunPosition sunPosition;

  ShadowLength(this.length, this.shadowEndPosition, this.sunPosition);
}

ShadowLength shadowLength(
  double objectHeight,
  LatLng coords,
  Ellipsoid ells,
  DateTime datetime,
  Duration timezone,
) {
  var julianDate = JulianDate(datetime, timezone);
  var sunPosition = SunPosition(coords, julianDate, ells);
  var shadowLen =
      objectHeight * cos(degreesToRadian(sunPosition.altitude)) / sin(degreesToRadian(sunPosition.altitude));
  // Sun is in one Direction, so shadow is the opposite direction
  var sunAzimuth = coordUtils.normalizeBearing(sunPosition.azimuth + 180.0);

  var _currentPosition = projection(coords, sunAzimuth, shadowLen, ells);

  return ShadowLength(shadowLen, _currentPosition, sunPosition);
}
