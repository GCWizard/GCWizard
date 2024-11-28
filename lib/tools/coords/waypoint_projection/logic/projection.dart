import 'dart:math';

import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/coordinate_cell.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/interval_calculator.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:latlong2/latlong.dart';

LatLng projection(LatLng coord, double bearingDeg, double distance, Ellipsoid ellipsoid) {
  if (distance == 0.0) return coord;

  bearingDeg = normalizeBearing(bearingDeg);

  GeodesicData projected = geodeticDirect(coord, bearingDeg, distance, ellipsoid);

  return LatLng(projected.lat2, projected.lon2);
}

LatLng projectionRadian(LatLng coord, double bearingRad, double distance, Ellipsoid ellipsoid) {
  return projection(coord, radianToDeg(bearingRad), distance, ellipsoid);
}

/// A bit less accurate... Used for Map Polylines
LatLng projectionVincenty(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  if (distance == 0.0) return coord;

  bearing = normalizeBearing(bearing);

  return vincentyDirect(coord, bearing, distance, ellipsoid);
}

class _ReverseProjectionCalculator extends IntervalCalculator {
  _ReverseProjectionCalculator(ReverseProjectionParameters parameters, Ellipsoid ells) : super(parameters, ells) {
    eps = 1e-10;
  }

  @override
  bool checkCell(CoordinateCell cell, IntervalCalculatorParameters parameters) {
    var params = parameters as ReverseProjectionParameters;

    Interval distanceToCoord = cell.distanceTo(params.coordinate);
    Interval bearingToCoord = cell.bearingTo(params.coordinate);

    var distance = parameters.distance;
    var bearing = parameters.bearing;

    if ((distanceToCoord.a <= distance) &&
        (distance <= distanceToCoord.b) &&
        ((bearingToCoord.a <= bearing) && (bearing <= bearingToCoord.b) ||
            (bearingToCoord.a <= bearing + 360.0) && (bearing + 360.0 <= bearingToCoord.b))) {}

    return (distanceToCoord.a <= distance) &&
        (distance <= distanceToCoord.b) &&
        ((bearingToCoord.a <= bearing) && (bearing <= bearingToCoord.b) ||
            (bearingToCoord.a <= bearing + 360.0) && (bearing + 360.0 <= bearingToCoord.b));
  }
}

List<LatLng> reverseProjection(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  bearing = normalizeBearing(bearing);

  return _ReverseProjectionCalculator(ReverseProjectionParameters(coord, bearing, distance), ellipsoid).check();
}

class ReverseProjectionParameters extends IntervalCalculatorParameters {
  LatLng coordinate;
  double bearing;
  double distance;

  ReverseProjectionParameters(this.coordinate, this.bearing, this.distance);
}

// [1] Karney sketch retro-azimuthal projection: https://gis.stackexchange.com/questions/131628/direct-geodesic-with-point-2-azimuth/131695#131695
// [2] Karney explanation: https://gis.stackexchange.com/questions/487848/algorithm-for-retro-azimuthal-projection?noredirect=1#comment795761_487848
// [3] Spherical solution: https://en.wikipedia.org/wiki/Solution_of_triangles#Two_sides_and_non-included_angle_given_(spherical_SSA)
// [4] Theoretical basis/Newton equation; Karney (2011): http://arxiv.org/abs/1102.1215
List<LatLng> reverseProjectionNew(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  bearing = normalizeBearing(bearing);

  if (bearing == 0 || bearing == 180) {
    return [projection(coord, bearing - 180, distance, ellipsoid)];
  }

  var betaDeg = bearing;
  if (betaDeg > 180) {
    betaDeg = 360 - betaDeg;
  }

  var northPole = const LatLng(90, 0);

  // Step 1: Initial value, solve for sphere ([3])
  var beta = degToRadian(betaDeg);
  var b = distanceBearing(northPole, coord, ellipsoid).distance;
  var c = distance;

  //acc. to [1], a solution exists if b > arcsin(sin(c) * sin(beta))
  if (b <= asin(sin(c) * sin(beta))) {
    return [];
  }

  var gamma = asin((sin(c) * sin(beta))/sin(b));

  var alpha = 2 * 1 / tan(tan(0.5 * (beta - gamma) * (sin(0.5 * (b + c)) / sin(0.5 * (b - c)))));

  var latLonDest = projectionRadian(coord, alpha, distance, ellipsoid);
  var a = distanceBearing(northPole, latLonDest, ellipsoid);
  // end step 1

  // Step 2: Newton's method, [4] with [1] and [2]
  //


  // psi^(i + 1) = psi^(i) - (theta^(i) - theta) * D)
  // psi = alpha_1
  // theta = s_12

  // m_12 by GeographicLib
  //

  // Equation (79), Karney 2011
  var D = m_12 * tan(alpha_2) - (a * w_2) / (tan(alpha_1) * tan(beta_2) * cos(alpha_2));

  // end step 2

  return [];
}


