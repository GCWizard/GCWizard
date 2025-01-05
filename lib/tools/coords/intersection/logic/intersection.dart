import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/coords/_common/logic/distance_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_bearings/logic/intersect_bearing.dart';
import 'package:latlong2/latlong.dart';

class IntersectionJobData {
  final LatLng coord1;
  final double alpha;
  final LatLng coord2;
  final double beta;
  final Ellipsoid ells;

  IntersectionJobData(
      {required this.coord1, this.alpha = 0.0, required this.coord2, this.beta = 0.0, required this.ells});
}

Future<List<LatLng?>> intersectionAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! IntersectionJobData) {
    throw Exception('Unexpected data for Intersection');
  }

  var data = jobData!.parameters as IntersectionJobData;
  var output = intersection(data.coord1, data.alpha, data.coord2, data.beta, data.ells);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<LatLng?> intersection(LatLng coord1, double alpha, LatLng coord2, double beta, Ellipsoid ells) {
  DistanceBearingData crs = distanceBearing(coord1, coord2, ells);

  LatLng? i1 = intersectBearings(coord1, crs.bearingAToB + alpha, coord2, crs.bearingBToA - beta, ells);
  LatLng? i2 = intersectBearings(coord1, crs.bearingAToB - alpha, coord2, crs.bearingBToA + beta, ells);

  return [i1, i2];
}
