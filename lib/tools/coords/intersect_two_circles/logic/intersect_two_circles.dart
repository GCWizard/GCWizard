import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/coordinate_cell.dart';
import 'package:gc_wizard/tools/coords/_common/logic/intervals/interval_calculator.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

class IntersectTwoCirclesJobData {
  final LatLng coord1;
  final double radius1;
  final LatLng coord2;
  final double radius2;
  final Ellipsoid ells;

  IntersectTwoCirclesJobData(
      {required this.coord1, this.radius1 = 0.0, required this.coord2, this.radius2 = 0.0, required this.ells});
}

class _IntersectTwoCirclesCalculator extends IntervalCalculator {
  _IntersectTwoCirclesCalculator(IntersectTwoCirclesParameters parameters, Ellipsoid ellipsoid) : super(parameters, ellipsoid);

  @override
  bool checkCell(CoordinateCell cell, IntervalCalculatorParameters parameters) {
    var params = parameters as IntersectTwoCirclesParameters;

    Interval distanceToCoord1 = cell.distanceTo(params.coordinate1);
    Interval distanceToCoord2 = cell.distanceTo(params.coordinate2);

    var r1 = params.radius1;
    var r2 = params.radius2;

    return (distanceToCoord1.a <= r1) &&
        (r1 <= distanceToCoord1.b) &&
        (distanceToCoord2.a <= r2) &&
        (r2 <= distanceToCoord2.b);
  }
}

Future<List<LatLng>> intersectTwoCirclesAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! IntersectTwoCirclesJobData) {
    throw Exception('Unexpected data for Intersect Two Circles');
  }

  var data = jobData!.parameters as IntersectTwoCirclesJobData;
  var output = intersectTwoCircles(data.coord1, data.radius1, data.coord2,
      data.radius2, data.ells);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<LatLng> intersectTwoCircles(LatLng coord1, double radius1, LatLng coord2, double radius2, Ellipsoid ellipsoid) {
  // same position
  if ((coord1.latitude == coord2.latitude) & (coord1.longitude == coord2.longitude)) return [];

  return _IntersectTwoCirclesCalculator(
            IntersectTwoCirclesParameters(
                coord1, radius1, coord2, radius2
            ), ellipsoid)
      .check();
}

class IntersectTwoCirclesParameters extends IntervalCalculatorParameters {
  LatLng coordinate1;
  double radius1;
  LatLng coordinate2;
  double radius2;

  IntersectTwoCirclesParameters(this.coordinate1, this.radius1, this.coordinate2, this.radius2);
}
