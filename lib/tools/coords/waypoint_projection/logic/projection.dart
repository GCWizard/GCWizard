import 'package:gc_wizard/tools/coords/_common/logic/intervals/coordinate_cell.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/interval_calculator.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/vincenty/projection_vincenty.dart';
import 'package:latlong2/latlong.dart';

LatLng projection(LatLng coord, double bearingDeg, double distance, Ellipsoid ellipsoid) {
  if (distance == 0.0) return coord;

  bearingDeg = normalizeBearing(bearingDeg);

  GeodesicData projected =
      Geodesic(ellipsoid.a, ellipsoid.f).direct(coord.latitude, coord.longitude, bearingDeg, distance);

  return LatLng(projected.lat2, projected.lon2);
}

LatLng projectionRadian(LatLng coord, double bearingRad, double distance, Ellipsoid ellipsoid) {
  return projection(coord, radianToDeg(bearingRad), distance, ellipsoid);
}

/// A bit less accurate... Used for Map Polylines
LatLng projectionVincenty(LatLng coord, double bearing, double distance, Ellipsoid ellipsoid) {
  if (distance == 0.0) return coord;

  bearing = normalizeBearing(bearing);

  return vincentyDirect(coord, degToRadian(bearing), distance, ellipsoid);
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
