import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/intersect_two_circles/logic/intersect_two_circles.dart';
import 'package:latlong2/latlong.dart';

class CircleIntersection {
  LatLng coords;
  double accuracy;

  CircleIntersection({required this.coords, required this.accuracy});
}

List<CircleIntersection> _distIntersection(
    LatLng coord1, double dist14, LatLng coord2, double dist24, LatLng coord3, double dist34, Ellipsoid ells) {
  List<LatLng> intersects = intersectTwoCircles(coord1, dist14, coord2, dist24, ells);

  if (intersects.isEmpty) {
    return [];
  }

  var distBear = distanceBearing(intersects[0], coord3, ells);

  var _output = [CircleIntersection(coords: intersects[0], accuracy: (dist34 - distBear.distance).abs())];

  if (intersects.length == 2) {
    distBear = distanceBearing(intersects[1], coord3, ells);

    _output.add(CircleIntersection(coords: intersects[1], accuracy: (dist34 - distBear.distance).abs()));
  }

  return _output;
}

List<CircleIntersection> intersectThreeCircles(LatLng coord1, double dist14, LatLng coord2, double dist24, LatLng coord3,
    double dist34, double accuracy, Ellipsoid ells) {
  List<CircleIntersection> intersections = _distIntersection(coord1, dist14, coord2, dist24, coord3, dist34, ells);
  intersections.addAll(_distIntersection(coord1, dist14, coord3, dist34, coord2, dist24, ells));
  intersections.addAll(_distIntersection(coord2, dist24, coord3, dist34, coord1, dist14, ells));

  intersections.sort((a, b) {
    return a.accuracy.compareTo(b.accuracy);
  });

  return intersections;
}
