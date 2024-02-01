import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/logic/intersect_two_circles.dart';
import 'package:latlong2/latlong.dart';

//TODO: REFACTORING

class IntersectThreeCirclesJobData {
  final LatLng coord1;
  final double dist14;
  final LatLng coord2;
  final double dist24;
  final LatLng coord3;
  final double dist34;
  final double accuracy;
  final Ellipsoid ells;

  IntersectThreeCirclesJobData(
      {required this.coord1,
      this.dist14 = 0.0,
      required this.coord2,
      this.dist24 = 0.0,
      required this.coord3,
      this.dist34 = 0.0,
      this.accuracy = 0.0,
      required this.ells});
}

class Intersect {
  LatLng coords;
  double accuracy;

  Intersect({required this.coords, required this.accuracy});
}

List<Intersect> _distIntersection(
    LatLng coord1, double dist14, LatLng coord2, double dist24, LatLng coord3, double dist34, Ellipsoid ells) {
  List<LatLng> intersects = intersectTwoCircles(coord1, dist14, coord2, dist24, ells);

  if (intersects.isEmpty) {
    return [];
  }

  var distBear = distanceBearing(intersects[0], coord3, ells);

  var _output = [Intersect(coords: intersects[0], accuracy: (dist34 - distBear.distance).abs())];

  if (intersects.length == 2) {
    distBear = distanceBearing(intersects[1], coord3, ells);

    _output.add(Intersect(coords: intersects[1], accuracy: (dist34 - distBear.distance).abs()));
  }

  return _output;
}

Future<List<Intersect>> intersectThreeCirclesAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! IntersectThreeCirclesJobData) {
    throw Exception('Unexpected data for Intersect 3 Circles');
  }

  var data = jobData!.parameters as IntersectThreeCirclesJobData;

  var output = intersectThreeCircles(
      data.coord1, data.dist14, data.coord2, data.dist24, data.coord3, data.dist34, data.accuracy, data.ells);

  jobData.sendAsyncPort?.send(output);

  return output;
}

List<Intersect> intersectThreeCircles(LatLng coord1, double dist14, LatLng coord2, double dist24, LatLng coord3,
    double dist34, double accuracy, Ellipsoid ells) {
  List<Intersect> intersections = _distIntersection(coord1, dist14, coord2, dist24, coord3, dist34, ells);
  intersections.addAll(_distIntersection(coord1, dist14, coord3, dist34, coord2, dist24, ells));
  intersections.addAll(_distIntersection(coord2, dist24, coord3, dist34, coord1, dist14, ells));

  intersections.sort((a, b) {
    return a.accuracy.compareTo(b.accuracy);
  });

  return intersections;
}
