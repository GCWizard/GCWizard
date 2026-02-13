import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/triangles/sidesmidpoint/logic/sidesmidpoint.dart';
import 'package:latlong2/latlong.dart';
import 'package:prefs/prefs.dart';

import '../../../../science_and_technology/euclidic_triangle/logic/triangle.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await Prefs.init();

  group("triangle.calculateEllipsoidTriangleSideMidPoints:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 0), 'inputC': LatLng(0, 0),
        'expectedOutput': [LatLng(0, 0), LatLng(0, 0), LatLng(0, 0)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(1, 1), 'inputC': LatLng(1, 1),
        'expectedOutput': [LatLng(1, 1), LatLng(1, 1), LatLng(1, 1)]},
      {'inputA': LatLng(1, 1), 'inputB': LatLng(2, 2), 'inputC': LatLng(3, 3),
        'expectedOutput': [LatLng(1.5000586225465693, 1.4998865008673827), LatLng(2.500097624104694, 2.4998107563440044), LatLng(2.0003125707038807, 1.9993944677402233)]},
      {'inputA': LatLng(0, 0), 'inputB': LatLng(0, 3), 'inputC': LatLng(4, 0),
        'expectedOutput': [LatLng(0.0, 1.5000000000000002), LatLng(2.000714087234115, 1.5018173974963898), LatLng(2.0000244413426267, 0.0)]},
      {'inputA': LatLng(40, 9), 'inputB': LatLng(42, 9), 'inputC': LatLng(38, 8),
        'expectedOutput': [LatLng(41.000087018378245, 9.0), LatLng(40.00142361541297, 8.485406198746787), LatLng(39.00115707578199, 8.492961037465818)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']} ${elem['inputB']} ${elem['inputC']}', () {
        var _actual = calculateEllipsoidTriangleSideMidPoints(elem['inputA'] as LatLng, elem['inputB'] as LatLng, elem['inputC'] as LatLng);
        latLngListTest(_actual, elem['expectedOutput'] as List<LatLng>);
      });
    }
  });
}