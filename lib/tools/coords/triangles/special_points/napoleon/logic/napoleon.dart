import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/centroid/centroid_center_of_gravity/logic/centroid_center_of_gravity.dart';
import 'package:gc_wizard/tools/coords/equilateral_triangle/logic/equilateral_triangle.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangle.dart';
import 'package:gc_wizard/tools/coords/triangles/_common/logic/ellipsoid_triangles.dart';
import 'package:latlong2/latlong.dart';

class _NapoleonLine {
  final LatLng start;
  final LatLng end;

  _NapoleonLine(this.start, this.end);
}

class _NapoleonLines {
  _NapoleonLine lineForPoint1;
  _NapoleonLine lineForPoint2;

  _NapoleonLines(this.lineForPoint1, this.lineForPoint2);
}

// First left, second right point
List<LatLng> _equilateralTriangle(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var equilateral = equilateralTriangle(a, b, ellipsoid);

  if (isPointRightOfSideAB(equilateral.first, a, b, c.latitude >= 0.0, ellipsoid)) {
    return [equilateral[1], equilateral[0]];
  } else {
    return [equilateral[0], equilateral[1]];
  }
}

_NapoleonLines _napoleonLinesForSideAB(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  List<LatLng> pointsForEquilateral = _equilateralTriangle(a, b, c, ellipsoid);

  var centerNapoleon1 = centroidCenterOfGravity([a, b, pointsForEquilateral.first]);
  var centerNapoleon2 = centroidCenterOfGravity([a, b, pointsForEquilateral.last]);

  return _NapoleonLines(
    _NapoleonLine(centerNapoleon1!, c),
    _NapoleonLine(centerNapoleon2!, c)
  );
}

SpecialPointsOfEllipsoidTriangle _intersections(_NapoleonLine a, _NapoleonLine b, _NapoleonLine c, Ellipsoid ellipsoid) {
  var intersectAB = intersectFourPoints(a.start, a.end, b.start, b.end, ellipsoid);
  var intersectBC = intersectFourPoints(b.start, b.end, c.start, c.end, ellipsoid);
  var intersectCA = intersectFourPoints(c.start, c.end, a.start, a.end, ellipsoid);

  return SpecialPointsOfEllipsoidTriangle([intersectAB, intersectBC, intersectCA], [
      SpecialPointConstructionLine(a.start, a.end),
      SpecialPointConstructionLine(b.start, b.end),
      SpecialPointConstructionLine(c.start, c.end)
    ], ellipsoid
  );
}

List<SpecialPointsOfEllipsoidTriangle> calculateEllipsoidTriangleNapoleonPoints(EllipsoidTriangle triangle, Ellipsoid ellipsoid) {
  if (!triangle.isValid) {
    return [];
  }

  var _triangle = triangle.getClockwised();

  var napoleonLinesForPointC = _napoleonLinesForSideAB(_triangle.a, _triangle.b, _triangle.c, ellipsoid);
  var napoleonLinesForPointB = _napoleonLinesForSideAB(_triangle.c, _triangle.a, _triangle.b, ellipsoid);
  var napoleonLinesForPointA = _napoleonLinesForSideAB(_triangle.b, _triangle.c, _triangle.a, ellipsoid);

  var intersectionsPoint1 = _intersections(
    napoleonLinesForPointA.lineForPoint1,
    napoleonLinesForPointB.lineForPoint1,
    napoleonLinesForPointC.lineForPoint1,
    ellipsoid
  );

  var intersectionsPoint2 = _intersections(
    napoleonLinesForPointA.lineForPoint2,
    napoleonLinesForPointB.lineForPoint2,
    napoleonLinesForPointC.lineForPoint2,
    ellipsoid
  );

  return [intersectionsPoint1, intersectionsPoint2];
}
