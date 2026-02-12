import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/science_and_technology/euclidic_triangle/logic/triangle.dart';
import 'package:latlong2/latlong.dart';

import 'triangle.dart';

void main() {
  group("triangle.latLngToVec3:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': LatLng(0, 0),
        'expectedOutput': Vec3(1, 0, 0)},
      {'inputA': LatLng(180, 90),
        'expectedOutput': Vec3(-6.123233995736766e-17, -1.0, 1.2246467991473532e-16)},
      {'inputA': LatLng(-180, -90),
        'expectedOutput': Vec3(-6.123233995736766e-17, 1, -1.2246467991473532e-16)},
      {'inputA': LatLng(200, 200),
        'expectedOutput': Vec3(0.8830222215594891, 0.3213938048432696, -0.34202014332566866)},
      {'inputA': LatLng(40, 9),
        'expectedOutput': Vec3(0.7566131648463098, 0.11983575265635889, 0.6427876096865393)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['inputA']}', () {
        var _actual = latLngToVec3(elem['inputA'] as LatLng);
        vec3Test(_actual, elem['expectedOutput'] as Vec3);
      });
    }
  });

  group("triangle.vec3ToLatLng:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'inputA': Vec3(1, 0, 0),
        'expectedOutput': LatLng(0, 0)},
      {'inputA': Vec3(-6.123233995736766e-17, -1.0, 1.2246467991473532e-16),
        'expectedOutput': LatLng(0, -90)},
      {'inputA': Vec3(-6.123233995736766e-17, 1, -1.2246467991473532e-16),
        'expectedOutput': LatLng(0, 90)},
      {'inputA': Vec3(0.8830222215594891, 0.3213938048432696, -0.34202014332566866),
        'expectedOutput': LatLng(-20, 20)},
      {'inputA': Vec3(0.7566131648463098, 0.11983575265635889, 0.6427876096865393),
        'expectedOutput': LatLng(40, 9)},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${toString(elem['inputA'])}', () {
        var _actual = vec3ToLatLng(elem['inputA'] as Vec3);
        latLngTest(_actual, elem['expectedOutput'] as LatLng);
      });
    }
  });
}




// /// 3D-Einheitsvektor → LatLng
// LatLng vec3ToLatLng(Vec3 v) {
//   final lat = atan2(v.z, sqrt(v.x * v.x + v.y * v.y)) * 180 / pi;
//   final lng = atan2(v.y, v.x) * 180 / pi;
//   return LatLng(lat, lng);
// }



