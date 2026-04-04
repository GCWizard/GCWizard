import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/segment_line/logic/segment_line.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> calculateEllipsoidTriangleSideMidPoints(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  List<LatLng> sidesMidPoint = [];

  sidesMidPoint.add(segmentLine(a, b, 2, ellipsoid).points[0]);
  sidesMidPoint.add(segmentLine(c, b, 2, ellipsoid).points[0]);
  sidesMidPoint.add(segmentLine(a, c, 2, ellipsoid).points[0]);

  return sidesMidPoint;
}