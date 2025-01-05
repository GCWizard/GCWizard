import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centerpoint/logic/centerpoint_distance.dart';
import 'package:gc_wizard/tools/coords/segment_line/logic/segment_line.dart';
import 'package:latlong2/latlong.dart';

CenterPointDistance centerPointTwoPoints(LatLng coord1, LatLng coord2, Ellipsoid ells) {
  var segments = segmentLine(coord1, coord2, 2, ells);

  return CenterPointDistance(segments.points.first, segments.segmentLength);
}