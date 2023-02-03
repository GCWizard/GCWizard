import 'package:gc_wizard/tools/coords/intervals/logic/coordinate_cell.dart';
import 'package:gc_wizard/tools/coords/intervals/logic/interval_calculator.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

class IntersectTwoCirclesJobData {
  final LatLng coord1;
  final double radius1;
  final LatLng coord2;
  final double radius2;
  final Ellipsoid ells;

  IntersectTwoCirclesJobData(
      {this.coord1, this.radius1 = 0.0, this.coord2, this.radius2 = 0.0, this.ells});
}

class _IntersectTwoCirclesCalculator extends IntervalCalculator {
  _IntersectTwoCirclesCalculator(Map<String, dynamic> parameters, Ellipsoid ellipsoid) : super(parameters, ellipsoid);

  @override
  bool checkCell(CoordinateCell cell, Map<String, dynamic> parameters) {
    Interval distanceToCoord1 = cell.distanceTo(parameters['coord1']);
    Interval distanceToCoord2 = cell.distanceTo(parameters['coord2']);

    var r1 = parameters['radius1'];
    var r2 = parameters['radius2'];

    return (distanceToCoord1.a <= r1) &&
        (r1 <= distanceToCoord1.b) &&
        (distanceToCoord2.a <= r2) &&
        (r2 <= distanceToCoord2.b);
  }
}

Future<List<LatLng>> intersectTwoCirclesAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = intersectTwoCircles(jobData.parameters.coord1, jobData.parameters.radius1, jobData.parameters.coord2,
      jobData.parameters.radius2, jobData.parameters.ells);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

List<LatLng> intersectTwoCircles(LatLng coord1, double radius1, LatLng coord2, double radius2, Ellipsoid ellipsoid) {
  // same position
  if ((coord1.latitude == coord2.latitude) & (coord1.longitude == coord2.longitude)) return [];

  return _IntersectTwoCirclesCalculator(
          {'coord1': coord1, 'radius1': radius1, 'coord2': coord2, 'radius2': radius2}, ellipsoid)
      .check();
}
