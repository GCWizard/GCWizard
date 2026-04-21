import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';
import 'package:gc_wizard/tools/coords/triangles/circles/_common/logic/circles.dart';

SpecialPointsOfEllipsoidTriangle calculateEllipsoidTriangleGergonnePoint(ELlipsoidTriangle triangle, Ellipsoid ellipsoid){
  if (!triangle.isValid) {
    return SpecialPointsOfEllipsoidTriangle([], ellipsoid);
  }

  var _triangle = triangle.getClockwised();

  var inc = calculateEllipsoidTriangleIncircle(_triangle, ellipsoid)!.circle.center;
  var projA = orthogonalProjectionBearing(inc, _triangle.b, _triangle.bearingBC, ellipsoid);
  var projB = orthogonalProjectionBearing(inc, _triangle.c, _triangle.bearingCA, ellipsoid);
  var projC = orthogonalProjectionBearing(inc, _triangle.a, _triangle.bearingAB, ellipsoid);

  var intersectAB = intersectFourPoints(projA, _triangle.a, projB, _triangle.b, ellipsoid);
  var intersectBC = intersectFourPoints(projB, _triangle.b, projC, _triangle.c, ellipsoid);
  var intersectAC = intersectFourPoints(projC, _triangle.c, projA, _triangle.a, ellipsoid);

  return SpecialPointsOfEllipsoidTriangle([intersectAB, intersectBC, intersectAC], ellipsoid);
}