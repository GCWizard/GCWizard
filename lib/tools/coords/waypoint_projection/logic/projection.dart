import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/pkohut.geoformulas/geoformulas.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/coordinate_cell.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/interval_calculator.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;
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
  _ReverseProjectionCalculator(_ReverseProjectionEvolutionalParameters parameters, Ellipsoid ells) : super(parameters, ells) {
    eps = 1e-10;
  }

  @override
  bool checkCell(CoordinateCell cell, IntervalCalculatorParameters parameters) {
    var params = parameters as _ReverseProjectionEvolutionalParameters;

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

// Note (MAL 01/2025): Due to limitation in Karneys approach
//     This old, incredibly not performant and not deterministic approach is still
//     available to catch the edge cases. Combined together the both approaches
//     give a good, but not perfect result.
List<LatLng> _reverseProjectionEvolutional(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  bearing = normalizeBearing(bearing);

  return _ReverseProjectionCalculator(_ReverseProjectionEvolutionalParameters(coord, bearing, distance), ellipsoid).check();
}

class _ReverseProjectionEvolutionalParameters extends IntervalCalculatorParameters {
  LatLng coordinate;
  double bearing;
  double distance;

  _ReverseProjectionEvolutionalParameters(this.coordinate, this.bearing, this.distance);
}

LatLng? reverseProjection(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  bearing = utils.normalizeBearing(bearing);

  if (distance == 0.0) {
    return coord;
  }

  if (bearing == 0 || bearing == 180) {
    bearing = utils.normalizeBearing(bearing - 180);
    return projection(coord, bearing, distance, ellipsoid);
  }

  LatLng? projected;
  List<LatLng> projectedEvolutional = [];

  try {
    // Try Karney's Newton approach
    projected = reverseAzimuthalProjection(coord, bearing, distance, ellipsoid);
    var start = projection(projected, bearing, distance, ellipsoid);

    if (!utils.equalsLatLng(coord, start, tolerance: 1e-5)) {
      throw Exception();
    }
  } catch (e) {
    // Otherwise try evolutional

    projected = null;

    var projectedEvolutional = _reverseProjectionEvolutional(coord, bearing, distance, ellipsoid);
    for (LatLng ll in projectedEvolutional) {
      var x = projection(ll, bearing, distance, ellipsoid);
      if (utils.equalsLatLng(coord, x, tolerance: 1e-5)) {
        projected = x;
        break;
      }
    }
  }

  return projected;
}


