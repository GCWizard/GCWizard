import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/waypoint_projection/logic/projection.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart' as utils;
import 'package:latlong2/latlong.dart';

class SegmentedAngle {
  final List<LatLng> points;
  final double segmentAngle;

  SegmentedAngle(this.points, this.segmentAngle);
}

SegmentedAngle segmentBearings(
    LatLng coord, double bearing1, double bearing2, double distance, int countSegments, Ellipsoid ells) {
  if (countSegments < 1) {
    countSegments = 1;
  }

  var bearings = <double>[];
  var _bearing1 = utils.normalizeBearing(bearing1);
  var _bearing2 = utils.normalizeBearing(bearing2);
  if (_bearing1 >= _bearing2) {
    _bearing2 += 360.0;
  }

  bearings.add(_bearing1);
  bearings.add(_bearing2);

  var segmentAngle = (bearings.last - bearings.first) / countSegments;
  var points = <LatLng>[];

  var i = 0;
  while (i < countSegments - 1) {
    i++;
    points.add(projection(coord, (i * segmentAngle) + bearings.first, distance, ells));
  }

  return SegmentedAngle(points, segmentAngle);
}

