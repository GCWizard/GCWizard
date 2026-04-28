import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/segment_line/logic/segment_line.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> calculateEllipsoidTriangleMedians(EllipsoidTriangle triangle, Ellipsoid ellipsoid) {
  if (!triangle.isValid) return [];

  List<LatLng> sidesMidPoint = [];

  sidesMidPoint.add(segmentLine(triangle.a, triangle.b, 2, ellipsoid).points[0]);
  sidesMidPoint.add(segmentLine(triangle.c, triangle.b, 2, ellipsoid).points[0]);
  sidesMidPoint.add(segmentLine(triangle.a, triangle.c, 2, ellipsoid).points[0]);

  return sidesMidPoint;
}