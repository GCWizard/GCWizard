import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/triangles/incircle/logic/incircle.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

import '../../../../science_and_technology/euclidic_triangle/logic/triangle.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("triangle.calculateEllipsoidTriangleInCircle:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': Circle(LatLng(0, 0), double.nan)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': Circle(LatLng(0.9999999999999998, 1.0), double.nan)},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': Circle(LatLng(2.000230913866294, 1.9997718509421103), 36.123885632802704)},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': Circle(LatLng(1.0046174816311724, 0.9980456202311339), 111353.57026375427)},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': Circle(LatLng(40.03652421187081, 8.749413946238121), 21357.940802196772)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleInCircle(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        circleTest(_actual, elem['expectedOutput'] as Circle);
      });
    }
  });
}