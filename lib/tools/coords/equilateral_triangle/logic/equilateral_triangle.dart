import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/logic/intersect_two_circles.dart';
import 'package:latlong2/latlong.dart';

class EquilateralTriangleJobData {
  final LatLng coord1;
  final LatLng coord2;
  final Ellipsoid ells;

  EquilateralTriangleJobData({required this.coord1, required this.coord2, required this.ells});
}

Future<List<LatLng>> equilateralTriangleAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! EquilateralTriangleJobData) {
    throw Exception('Unexpected data for Equilateral Triangle');
  }

  var data = jobData!.parameters as EquilateralTriangleJobData;
  var output = equilateralTriangle(data.coord1, data.coord2, data.ells);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<LatLng> equilateralTriangle(LatLng coord1, LatLng coord2, Ellipsoid ells) {
  var distance = distanceBearing(coord1, coord2, ells).distance;

  return intersectTwoCircles(coord1, distance, coord2, distance, ells);
}
