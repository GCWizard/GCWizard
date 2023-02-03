import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';

Map<String, dynamic> segmentLine(LatLng coord1, LatLng coord2, int countSegments, Ellipsoid ells) {
  if (countSegments < 2) return null;

  var distBear = distanceBearing(coord1, coord2, ells);

  var segmentDistance = distBear.distance / countSegments;
  var points = <LatLng>[];

  var i = 0;
  while (i < countSegments - 1) {
    i++;
    points.add(projection(coord1, distBear.bearingAToB, i * segmentDistance, ells));
  }

  return {'points': points, 'segmentDistance': segmentDistance};
}
