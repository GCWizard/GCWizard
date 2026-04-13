import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/circles.dart';
import 'package:latlong2/latlong.dart';

LatLng? calculateEllipsoidTriangleGergonnePoint(ELlipsoidTriangle triangle, Ellipsoid ellipsoid){
  if (!triangle.isValid) {
    return null;
  }

  var inc = calculateEllipsoidTriangleIncircle(triangle, ellipsoid)!.center;
  var projA = orthogonalProjectionTwoPoints(inc, triangle.b, triangle.c, ellipsoid);
  var projB = orthogonalProjectionTwoPoints(inc, triangle.a, triangle.c, ellipsoid);

  return intersectFourPoints(triangle.a, projA, triangle.b, projB, ellipsoid);
}