import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/distance_and_bearing/logic/distance_and_bearing.dart';
import 'package:gc_wizard/tools/coords/orthogonal_projection/logic/orthogonal_projection.dart';
import 'package:gc_wizard/tools/coords/triangles/incircle/logic/incircle.dart';
import 'package:latlong2/latlong.dart';

import '../../_common/ellipsoid_triangles_test_utils.dart';

void main() async {
  group("triangle.calculateEllipsoidTriangleInCircle:", () {
    for (int i = 0; i < validEllipsoidTrianglesForTests.length; i++) {
      var triangle = validEllipsoidTrianglesForTests[i];

      var a = triangle['inputA'] as LatLng;
      var b = triangle['inputB'] as LatLng;
      var c = triangle['inputC'] as LatLng;

      test('input: $a $b $c', () {

        var _actual = calculateEllipsoidTriangleInCircle(a, b, c, Ellipsoid.WGS84);
        expect(_actual != null, true);

        var projPToAB = orthogonalProjectionTwoPoints(_actual!.center, a, b, Ellipsoid.WGS84);
        var projPToBC = orthogonalProjectionTwoPoints(_actual.center, b, c, Ellipsoid.WGS84);
        var projPToAC = orthogonalProjectionTwoPoints(_actual.center, a, c, Ellipsoid.WGS84);
        var distAB = distanceBearing(_actual.center, projPToAB, Ellipsoid.WGS84).distance;
        var distBC = distanceBearing(_actual.center, projPToBC, Ellipsoid.WGS84).distance;
        var distAC = distanceBearing(_actual.center, projPToAC, Ellipsoid.WGS84).distance;

        var dists = [distAB, distBC, distAC];
        dists.sort();

        // print(_actual.center.latitude.toString() + ", " + _actual.center.longitude.toString() + ", " + _actual.radius.toString());
        // print(dists);

        expect(dists[2] - dists[0] < 1e-5, true);
        expect(dists[2] - _actual.radius < 1e-5, true);
      });
    }
  });
}