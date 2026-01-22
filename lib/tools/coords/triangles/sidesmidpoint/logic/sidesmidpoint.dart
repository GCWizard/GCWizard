
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';
import 'package:gc_wizard/tools/coords/segment_line/logic/segment_line.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> calculateEllipsoidTriangleSideMidPoints(LatLng A, LatLng B, LatLng C) {
  List<LatLng> sidesMidPoint = [];

  sidesMidPoint.add(segmentLine(A, B, 2, defaultEllipsoid).points[0]);
  sidesMidPoint.add(segmentLine(C, B, 2, defaultEllipsoid).points[0]);
  sidesMidPoint.add(segmentLine(A, C, 2, defaultEllipsoid).points[0]);

  return sidesMidPoint;
}