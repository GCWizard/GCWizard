import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('CoordinateUtils.equalsBearing:', () {
    List<Map<String, Object>> _inputsToExpected = [
      {'a' : 0.0, 'b': 0.0, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 360.0, 'b': 360.0, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 0.0, 'b': 360.0, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 360.0, 'b': 0.0, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 359.999, 'b': 0.001, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 0.001, 'b': 359.999, 'tolerance': 0.01, 'expectedOutput': true},

      {'a' : 0.001, 'b': 359.999, 'tolerance': 0.0001, 'expectedOutput': false},
      {'a' : 359.999, 'b': 0.001, 'tolerance': 0.0001, 'expectedOutput': false},

      {'a' : -0.001, 'b': 0.001, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 0.001, 'b': -0.001, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : -0.001, 'b': -0.001, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 360.001, 'b': -0.001, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 360.001, 'b': 0.001, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 720.001, 'b': 0.001, 'tolerance': 0.01, 'expectedOutput': true},
      {'a' : 360.001, 'b': -0.001, 'tolerance': 0.001, 'expectedOutput': false},

      {'a' : 176.0, 'b': 175.999, 'tolerance': 0.01, 'expectedOutput': true},
    ];

    for (var elem in _inputsToExpected) {
      test('a: ${elem['a']}, b:  ${elem['b']}, tolerance:  ${elem['tolerance']}', () {
        var _actual = equalsBearing(elem['a'] as double, elem['b'] as double, tolerance: elem['tolerance'] as double);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group('CoordinateUtils.equalsLatLng:', () {
    List<Map<String, Object>> _inputsToExpected = [
      {'a' : LatLng(42,21), 'b': LatLng(42,21), 'expectedOutput': true},
      {'a' : LatLng(41,21), 'b': LatLng(42,21), 'expectedOutput': false},
      {'a' : LatLng(42,21), 'b': LatLng(42,22), 'expectedOutput': false},

      {'a' : LatLng(41.9999999999999999,22), 'b': LatLng(42,22), 'expectedOutput': true},
      {'a' : LatLng(42,22), 'b': LatLng(42,22.0000000000001), 'expectedOutput': true},

      {'a' : LatLng(90, 20), 'b': LatLng(90, 20), 'expectedOutput': true},
      {'a' : LatLng(90, 20), 'b': LatLng(90, 40), 'expectedOutput': true},
      {'a' : LatLng(-90, 20), 'b': LatLng(90, 20), 'expectedOutput': false},
      {'a' : LatLng(-90, 20), 'b': LatLng(-90, 20), 'expectedOutput': true},
      {'a' : LatLng(-90, 40), 'b': LatLng(-90, 20), 'expectedOutput': true},
      {'a' : LatLng(-89.9999999999999, 40), 'b': LatLng(-90, 20), 'expectedOutput': true},
      {'a' : LatLng(-89.9999999999999, 40), 'b': LatLng(-89.9999999999999, 20), 'expectedOutput': true},
      {'a' : LatLng(90, 40), 'b': LatLng(89.9999999999999, 20), 'expectedOutput': true},
      {'a' : LatLng(90, 40), 'b': LatLng(89.99, 20), 'expectedOutput': false},

      {'a' : LatLng(60, 180), 'b': LatLng(60, 180), 'expectedOutput': true},
      {'a' : LatLng(60, 180), 'b': LatLng(60, -180), 'expectedOutput': true},
      {'a' : LatLng(60, 179.9999999999999), 'b': LatLng(60, -179.9999999999999), 'expectedOutput': true},
      {'a' : LatLng(60, 178.9999999999999), 'b': LatLng(60, -179.9999999999999), 'expectedOutput': false},
      {'a' : LatLng(60, 179.9999999999999), 'b': LatLng(-60, -179.9999999999999), 'expectedOutput': false},
    ];

    for (var elem in _inputsToExpected) {
      test('a: ${elem['a']}, b:  ${elem['b']}', () {
        var _actual = equalsLatLng(elem['a'] as LatLng, elem['b'] as LatLng);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group('CoordinateUtils.normalizeLatLon:', () {
    List<Map<String, double>> _inputsToExpected = [
      {'lat' : -89.0, 'expectedLat': -89.0, 'expectedLon': 10},
      {'lat' : -90.0, 'expectedLat': -90.0, 'expectedLon': 10},
      {'lat' : -91.0, 'expectedLat': -89.0, 'expectedLon': -170},
      {'lat' : -179.0, 'expectedLat': -1.0, 'expectedLon': -170},
      {'lat' : -180.0, 'expectedLat': 0.0, 'expectedLon': -170},
      {'lat' : -181.0, 'expectedLat': 1.0, 'expectedLon': -170},
      {'lat' : -269.0, 'expectedLat': 89.0, 'expectedLon': -170},
      {'lat' : -270.0, 'expectedLat': 90.0, 'expectedLon': -170},
      {'lat' : -271.0, 'expectedLat': 89.0, 'expectedLon': 10},
      {'lat' : -359.0, 'expectedLat': 1.0, 'expectedLon': 10},
      {'lat' : -360.0, 'expectedLat': 0.0, 'expectedLon': 10},
      {'lat' : -361.0, 'expectedLat': -1.0, 'expectedLon': 10},
      {'lat' : -449.0, 'expectedLat': -89.0, 'expectedLon': 10},
      {'lat' : -450.0, 'expectedLat': -90.0, 'expectedLon': 10},
      {'lat' : -451.0, 'expectedLat': -89.0, 'expectedLon': -170},
      {'lat' : -539.0, 'expectedLat': -1.0, 'expectedLon': -170},
      {'lat' : -540.0, 'expectedLat': 0.0, 'expectedLon': -170},
      {'lat' : -541.0, 'expectedLat': 1.0, 'expectedLon': -170},
      {'lat' : -629.0, 'expectedLat': 89.0, 'expectedLon': -170},
      {'lat' : -630.0, 'expectedLat': 90.0, 'expectedLon': -170},
      {'lat' : -631.0, 'expectedLat': 89.0, 'expectedLon': 10},
      {'lat' : -719.0, 'expectedLat': 1.0, 'expectedLon': 10},
      {'lat' : -720.0, 'expectedLat': 0.0, 'expectedLon': 10},
      {'lat' : -721.0, 'expectedLat': -1.0, 'expectedLon': 10},

      {'lat' : -1.0, 'expectedLat': -1.0, 'expectedLon': 10},
      {'lat' : 0.0, 'expectedLat': 0.0, 'expectedLon': 10},
      {'lat' : 1.0, 'expectedLat': 1.0, 'expectedLon': 10},
      {'lat' : 89.0, 'expectedLat': 89.0, 'expectedLon': 10},
      {'lat' : 90.0, 'expectedLat': 90.0, 'expectedLon': 10},
      {'lat' : 91.0, 'expectedLat': 89.0, 'expectedLon': -170},
      {'lat' : 179.0, 'expectedLat': 1.0, 'expectedLon': -170},
      {'lat' : 180.0, 'expectedLat': 0.0, 'expectedLon': -170},
      {'lat' : 181.0, 'expectedLat': -1.0, 'expectedLon': -170},
      {'lat' : 269.0, 'expectedLat': -89.0, 'expectedLon': -170},
      {'lat' : 270.0, 'expectedLat': -90.0, 'expectedLon': -170},
      {'lat' : 271.0, 'expectedLat': -89.0, 'expectedLon': 10},
      {'lat' : 359.0, 'expectedLat': -1.0, 'expectedLon': 10},
      {'lat' : 360.0, 'expectedLat': 0.0, 'expectedLon': 10},
      {'lat' : 361.0, 'expectedLat': 1.0, 'expectedLon': 10},
      {'lat' : 449.0, 'expectedLat': 89.0, 'expectedLon': 10},
      {'lat' : 450.0, 'expectedLat': 90.0, 'expectedLon': 10},
      {'lat' : 451.0, 'expectedLat': 89.0, 'expectedLon': -170},
      {'lat' : 539.0, 'expectedLat': 1.0, 'expectedLon': -170},
      {'lat' : 540.0, 'expectedLat': 0.0, 'expectedLon': -170},
      {'lat' : 541.0, 'expectedLat': -1.0, 'expectedLon': -170},
      {'lat' : 629.0, 'expectedLat': -89.0, 'expectedLon': -170},
      {'lat' : 630.0, 'expectedLat': -90.0, 'expectedLon': -170},
      {'lat' : 631.0, 'expectedLat': -89.0, 'expectedLon': 10},
      {'lat' : 719.0, 'expectedLat': -1.0, 'expectedLon': 10},
      {'lat' : 720.0, 'expectedLat': 0.0, 'expectedLon': 10},
      {'lat' : 721.0, 'expectedLat': 1.0, 'expectedLon': 10},
    ];

    for (var elem in _inputsToExpected) {
      test('lat: ${elem['lat']}', () {
        var _actual = normalizeLatLon(elem['lat']!, 10);
        expect(_actual, LatLng(elem['expectedLat']!, elem['expectedLon']!));
      });
    }
  });

  group('CoordinateUtils.normalizeLon:', () {
    List<Map<String, double>> _inputsToExpected = [
      {'lon' : -89.0, 'expectedOutput': -89.0},
      {'lon' : -90.0, 'expectedOutput': -90.0},
      {'lon' : -91.0, 'expectedOutput': -91.0},
      {'lon' : -179.0, 'expectedOutput': -179.0},
      {'lon' : -180.0, 'expectedOutput': 180.0},
      {'lon' : -181.0, 'expectedOutput': 179.0},
      {'lon' : -269.0, 'expectedOutput': 91.0},
      {'lon' : -270.0, 'expectedOutput': 90.0},
      {'lon' : -271.0, 'expectedOutput': 89.0},
      {'lon' : -359.0, 'expectedOutput': 1.0},
      {'lon' : -360.0, 'expectedOutput': 0.0},
      {'lon' : -361.0, 'expectedOutput': -1.0},
      {'lon' : -449.0, 'expectedOutput': -89.0},
      {'lon' : -450.0, 'expectedOutput': -90.0},
      {'lon' : -451.0, 'expectedOutput': -91.0},
      {'lon' : -539.0, 'expectedOutput': -179.0},
      {'lon' : -540.0, 'expectedOutput': 180.0},
      {'lon' : -541.0, 'expectedOutput': 179.0},
      {'lon' : -629.0, 'expectedOutput': 91.0},
      {'lon' : -630.0, 'expectedOutput': 90.0},
      {'lon' : -631.0, 'expectedOutput': 89.0},
      {'lon' : -719.0, 'expectedOutput': 1.0},
      {'lon' : -720.0, 'expectedOutput': 0.0},
      {'lon' : -721.0, 'expectedOutput': -1.0},

      {'lon' : -1.0, 'expectedOutput': -1.0},
      {'lon' : 0.0, 'expectedOutput': 0.0},
      {'lon' : 1.0, 'expectedOutput': 1.0},
      {'lon' : 89.0, 'expectedOutput': 89.0},
      {'lon' : 90.0, 'expectedOutput': 90.0},
      {'lon' : 91.0, 'expectedOutput': 91.0},
      {'lon' : 179.0, 'expectedOutput': 179.0},
      {'lon' : 180.0, 'expectedOutput': 180.0},
      {'lon' : 181.0, 'expectedOutput': -179.0},
      {'lon' : 269.0, 'expectedOutput': -91.0},
      {'lon' : 270.0, 'expectedOutput': -90.0},
      {'lon' : 271.0, 'expectedOutput': -89.0},
      {'lon' : 359.0, 'expectedOutput': -1.0},
      {'lon' : 360.0, 'expectedOutput': 0.0},
      {'lon' : 361.0, 'expectedOutput': 1.0},
      {'lon' : 449.0, 'expectedOutput': 89.0},
      {'lon' : 450.0, 'expectedOutput': 90.0},
      {'lon' : 451.0, 'expectedOutput': 91.0},
      {'lon' : 539.0, 'expectedOutput': 179.0},
      {'lon' : 540.0, 'expectedOutput': 180.0},
      {'lon' : 541.0, 'expectedOutput': -179.0},
      {'lon' : 629.0, 'expectedOutput': -91.0},
      {'lon' : 630.0, 'expectedOutput': -90.0},
      {'lon' : 631.0, 'expectedOutput': -89.0},
      {'lon' : 719.0, 'expectedOutput': -1.0},
      {'lon' : 720.0, 'expectedOutput': 0.0},
      {'lon' : 721.0, 'expectedOutput': 1.0},
    ];

    for (var elem in _inputsToExpected) {
      test('lon: ${elem['lon']}', () {
        var _actual = normalizeLon(elem['lon']!);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}