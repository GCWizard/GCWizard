import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/logic/intersect_two_circles.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

class EquilateralTriangleJobData {
  final LatLng coord1;
  final LatLng coord2;
  final Ellipsoid ells;

  EquilateralTriangleJobData({this.coord1, this.coord2, this.ells});
}

Future<List<LatLng>> equilateralTriangleAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = equilateralTriangle(jobData.parameters.coord1, jobData.parameters.coord2, jobData.parameters.ells);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

List<LatLng> equilateralTriangle(LatLng coord1, LatLng coord2, Ellipsoid ells) {
  var distance = distanceBearing(coord1, coord2, ells).distance;

  return intersectTwoCircles(coord1, distance, coord2, distance, ells);
}
