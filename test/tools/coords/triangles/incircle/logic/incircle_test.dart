import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';
import 'package:gc_wizard/tools/coords/triangles/incircle/logic/incircle.dart';
import 'package:latlong2/latlong.dart';

import '../../../../science_and_technology/euclidic_triangle/logic/triangle_test_utils.dart';
import '../../_common/triangles_test.dart';

void main() async {
  group("triangle.calculateEllipsoidTriangleInCircle:", () {
    List<Circle?> _expectedOutputs = [
      null, null, null, null, null, null, null, null,

      null, null, null, null, null, null,

      Circle(LatLng(38.59643143621918, 62.72726678931484), 23.959632024184646),
      Circle(LatLng(2.0002309138401166, 1.9997718509159168), 36.00285990172714),


    ];

    print(polygonArea([LatLng(80,0), LatLng(0,0), LatLng(-80, 0.00000001)], Ellipsoid.WGS84));

    // for (int i = 0; i < ellipsoidicTriangleTestInputs.length; i++) {
    //   var triangle = ellipsoidicTriangleTestInputs[i];
    //
    //   test('input: ${triangle['inputA']} ${triangle['inputB']} ${triangle['inputC']}', () {
    //     var _actual = calculateEllipsoidTriangleInCircle(triangle['inputA'] as LatLng, triangle['inputB'] as LatLng, triangle['inputC'] as LatLng, Ellipsoid.WGS84);
    //     print(polygonArea([triangle['inputA'] as LatLng, triangle['inputB'] as LatLng, triangle['inputC'] as LatLng], Ellipsoid.WGS84));
    //     if (_actual == null) {
    //       print((i + 1).toString() + ': null');
    //     } else {
    //       print((i + 1).toString() + ': ' + _actual.center.latitude.toString() + ', ' + _actual.center.longitude.toString() + ', ' + _actual.radius.toString());
    //     }
    //     print('...');
    //
    //
    //     // circleTest(_actual, elem['expectedOutput'] as Circle);
    //   });
    // }
  });
}