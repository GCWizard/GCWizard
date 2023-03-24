import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/geoarc_intercept.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';

class IntersectGeodeticAndCircleJobData {
  final LatLng startGeodetic;
  final double bearingGeodetic;
  final LatLng centerPoint;
  final double radiusCircle;
  final Ellipsoid ells;

  IntersectGeodeticAndCircleJobData(
      {required this.startGeodetic,
      this.bearingGeodetic = 0.0,
      required this.centerPoint,
      this.radiusCircle = 0.0,
      required this.ells});
}

Future<List<LatLng>> intersectGeodeticAndCircleAsync(dynamic jobData) async {
  if (jobData?.parameters is! IntersectGeodeticAndCircleJobData) {
    throw Exception('Unexpected data for Intersectopm Geodetic and Circle');
  }

  var data = jobData!.parameters as IntersectGeodeticAndCircleJobData;

  var output = intersectGeodeticAndCircle(data.startGeodetic, data.bearingGeodetic,
      data.centerPoint, data.radiusCircle, data.ells);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<LatLng> intersectGeodeticAndCircle(
    LatLng startGeodetic, double bearingGeodetic, LatLng centerPoint, double radiusCircle, Ellipsoid ells) {
  bearingGeodetic = normalizeBearing(bearingGeodetic);

  var help = distanceBearing(startGeodetic, centerPoint, ells);

  // If start point is in circle, move it out
  bool isInCircle = false;
  if (help.distance < radiusCircle) {
    isInCircle = true;
    LatLng pointOut = projection(startGeodetic, bearingGeodetic, radiusCircle * 2.1, ells);
    help = distanceBearing(startGeodetic, pointOut, ells);
    startGeodetic = pointOut;
    bearingGeodetic = help.bearingBToA;
  }

  List<LatLng> output =
      geodesicArcIntercept(startGeodetic, degToRadian(bearingGeodetic), centerPoint, radiusCircle, ells);

  if (isInCircle) {
    help = distanceBearing(startGeodetic, output[0], ells);
    if (help.distance > radiusCircle * 2.1) {
      output[0] = output[1];
    }

    output.removeLast();
  }

  return output;
}
