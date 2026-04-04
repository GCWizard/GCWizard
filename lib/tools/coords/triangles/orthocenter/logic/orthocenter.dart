import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:latlong2/latlong.dart';

LatLng calculateEllipsoidTriangleOrthocenter(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid) {
  var projA = orthogonalProjectionTwoPoints(a, b, c, ellipsoid);
  var projB = orthogonalProjectionTwoPoints(b, a, c, ellipsoid);

  return intersectFourPoints(a, projA, b, projB, ellipsoid);
}