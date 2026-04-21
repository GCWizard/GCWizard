import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/ellipsoid_triangles.dart';

SpecialPointsOfEllipsoidTriangle calculateEllipsoidTriangleOrthocenter(ELlipsoidTriangle triangle, Ellipsoid ellipsoid) {
  var _triangle = triangle.getClockwised();

  var projA = orthogonalProjectionBearing(_triangle.a, _triangle.b, _triangle.bearingBC, ellipsoid);
  var projB = orthogonalProjectionBearing(_triangle.b, _triangle.c, _triangle.bearingCA, ellipsoid);
  var projC = orthogonalProjectionBearing(_triangle.c, _triangle.a, _triangle.bearingAB, ellipsoid);

  var intersectionAB = intersectFourPoints(_triangle.a, projA, _triangle.b, projB, ellipsoid);
  var intersectionBC = intersectFourPoints(_triangle.b, projB, _triangle.c, projC, ellipsoid);
  var intersectionCA = intersectFourPoints(_triangle.c, projC, _triangle.a, projA, ellipsoid);

  return SpecialPointsOfEllipsoidTriangle([intersectionAB, intersectionBC, intersectionCA], ellipsoid);
}