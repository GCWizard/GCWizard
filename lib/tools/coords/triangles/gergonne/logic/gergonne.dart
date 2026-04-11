import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/intersect_lines/intersect_four_points/logic/intersect_four_points.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/triangles/incircle/logic/incircle.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

LatLng? calculateEllipsoidTriangleGergonnePoint(LatLng a, LatLng b, LatLng c, Ellipsoid ellipsoid){
  if (equalsLatLng(a, b) || equalsLatLng(b, c) || equalsLatLng(c, a)) {
    return null;
  }

  var inc = calculateEllipsoidTriangleIncircle(a, b, c, ellipsoid)!.center;
  var projA = orthogonalProjectionTwoPoints(inc, b, c, ellipsoid);
  var projB = orthogonalProjectionTwoPoints(inc, a, c, ellipsoid);

  return intersectFourPoints(a, projA, b, projB, ellipsoid);
}