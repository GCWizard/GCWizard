import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/triangles/napoleon/logic/napoleon.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

import '../../../../science_and_technology/euclidic_triangle/logic/triangle.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("triangle.calculateEllipsoidTriangleNapoleonPoints:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': [LatLng(double.nan, double.nan), LatLng(double.nan, double.nan)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': [LatLng(double.nan, double.nan), LatLng(double.nan, double.nan)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': [LatLng(1.8067181300927935, 2.191037609753793), LatLng(2.194009649931147, 1.8083808049015455)]},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': [LatLng(1.00176091013359, 0.923820236371675), LatLng(2.4197147005253923, 0.7585637973793522)]},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': [LatLng(39.98309716608685, 9.146750508939933), LatLng(40.1866389195436, 8.171521627780027)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleNapoleonPoints(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        latLngListTest(_actual, elem['expectedOutput'] as List<LatLng>);
      });
    }
  });
}