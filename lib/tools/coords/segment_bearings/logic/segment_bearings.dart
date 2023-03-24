import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:latlong2/latlong.dart';

class SegmentedAngle {
  final List<LatLng> points;
  final double segmentAngle;

  SegmentedAngle(this.points, this.segmentAngle);
}

SegmentedAngle segmentBearings(
    LatLng coord, double angle1, double angle2, double distance, int countSegments, Ellipsoid ells) {
  if (countSegments < 1) {
    countSegments = 1;
  }

  var angles = <double>[];
  angles.add(angle1);
  if (angle1 != angle2) angles.add(angle2);

  angles.sort();

  if (angles.isEmpty) angles.add(0.0);
  if (angles.length == 1) angles.add(angles.first + 360.0);

  var segmentAngle = (angles.last - angles.first) / countSegments;
  var points = <LatLng>[];

  var i = 0;
  while (i < countSegments - 1) {
    i++;
    points.add(projection(coord, (i * segmentAngle) + angles.first, distance, ells));
  }

  return SegmentedAngle(points, segmentAngle);
}
