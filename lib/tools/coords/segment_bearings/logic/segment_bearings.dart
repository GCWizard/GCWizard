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
  var _angle1 = normalizeBearing(angle1);
  var _angle2 = normalizeBearing(angle2);
  if (_angle1 >= _angle2) {
    _angle2 += 360.0;
  }

  angles.add(_angle1);
  angles.add(_angle2);

  var segmentAngle = (angles.last - angles.first) / countSegments;
  var points = <LatLng>[];

  var i = 0;
  while (i < countSegments - 1) {
    i++;
    points.add(projection(coord, (i * segmentAngle) + angles.first, distance, ells));
  }

  return SegmentedAngle(points, segmentAngle);
}

