import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';

Map<String, dynamic> segmentBearings(
    LatLng coord, double angle1, double angle2, double distance, int countSegments, Ellipsoid ells) {
  if (countSegments < 2) return null;

  var angles = <double>[];
  if (angle1 != null) angles.add(angle1);
  if (angle2 != null) {
    if (angle1 == null || angle1 != angle2) angles.add(angle2);
  }
  angles.sort();

  if (angles.length == 0) angles.add(0.0);
  if (angles.length == 1) angles.add(angles.first + 360.0);

  var segmentAngle = (angles.last - angles.first) / countSegments;
  var points = <LatLng>[];

  var i = 0;
  while (i < countSegments - 1) {
    i++;
    points.add(projection(coord, (i * segmentAngle) + angles.first, distance, ells));
  }

  return {'points': points, 'segmentAngle': segmentAngle};
}
