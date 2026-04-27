import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
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
      {'a': const LatLng(42,21), 'b': const LatLng(42,21), 'expectedOutput': true},
      {'a': const LatLng(41,21), 'b': const LatLng(42,21), 'expectedOutput': false},
      {'a': const LatLng(42,21), 'b': const LatLng(42,22), 'expectedOutput': false},

      {'a': const LatLng(41.9999999999999999,22), 'b': const LatLng(42,22), 'expectedOutput': true},
      {'a': const LatLng(42,22), 'b': const LatLng(42,22.0000000000001), 'expectedOutput': true},

      {'a': const LatLng(90, 20), 'b': const LatLng(90, 20), 'expectedOutput': true},
      {'a': const LatLng(90, 20), 'b': const LatLng(90, 40), 'expectedOutput': true},
      {'a': const LatLng(-90, 20), 'b': const LatLng(90, 20), 'expectedOutput': false},
      {'a': const LatLng(-90, 20), 'b': const LatLng(-90, 20), 'expectedOutput': true},
      {'a': const LatLng(-90, 40), 'b': const LatLng(-90, 20), 'expectedOutput': true},
      {'a': const LatLng(-89.9999999999999, 40), 'b': const LatLng(-90, 20), 'expectedOutput': true},
      {'a': const LatLng(-89.9999999999999, 40), 'b': const LatLng(-89.9999999999999, 20), 'expectedOutput': true},
      {'a': const LatLng(90, 40), 'b': const LatLng(89.9999999999999, 20), 'expectedOutput': true},
      {'a': const LatLng(90, 40), 'b': const LatLng(89.99, 20), 'expectedOutput': false},

      {'a': const LatLng(60, 180), 'b': const LatLng(60, 180), 'expectedOutput': true},
      {'a': const LatLng(60, 180), 'b': const LatLng(60, -180), 'expectedOutput': true},
      {'a': const LatLng(60, 179.9999999999999), 'b': const LatLng(60, -179.9999999999999), 'expectedOutput': true},
      {'a': const LatLng(60, 178.9999999999999), 'b': const LatLng(60, -179.9999999999999), 'expectedOutput': false},
      {'a': const LatLng(60, 179.9999999999999), 'b': const LatLng(-60, -179.9999999999999), 'expectedOutput': false},

      {'a': const LatLng(60, 181), 'b': const LatLng(60, -179), 'expectedOutput': true},
      {'a': const LatLng(88, 1), 'b': const LatLng(92, -179), 'expectedOutput': true},

      {'a': const LatLng(90,0), 'b': const LatLng(90,0), 'expectedOutput': true},
      {'a': const LatLng(0,0), 'b': const LatLng(0,0), 'expectedOutput': true},
      {'a': const LatLng(-90,0), 'b': const LatLng(-90,0), 'expectedOutput': true},

      {'a': const LatLng(-90,180), 'b': const LatLng(-90,0), 'expectedOutput': true},
      {'a': const LatLng(-90,100), 'b': const LatLng(-90,0), 'expectedOutput': true},
      {'a': const LatLng(90,100), 'b': const LatLng(90,0), 'expectedOutput': true},
      {'a': const LatLng(0,180), 'b': const LatLng(0,-180), 'expectedOutput': true},
      {'a': const LatLng(10,180), 'b': const LatLng(10,-180), 'expectedOutput': true},
      {'a': const LatLng(-10,180), 'b': const LatLng(-10,-180), 'expectedOutput': true},

      {'a': const LatLng(-90,179), 'b': const LatLng(-90,-179), 'expectedOutput': true},
      {'a': const LatLng(-80,179), 'b': const LatLng(-80,-179), 'expectedOutput': false},

      {'a': const LatLng(52.0000000000001, 12.999999999999), 'b': LatLng(52,13), 'expectedOutput': true},
      {'a': const LatLng(52.000001, 12.999999), 'b': const LatLng(52,13), 'expectedOutput': false},
    ];

    for (var elem in _inputsToExpected) {
      test('a: ${elem['a']}, b:  ${elem['b']}', () {
        var _actual = equalsLatLng(elem['a'] as LatLng, elem['b'] as LatLng);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group('CoordinateUtils.equalsLatLngList:', () {
    List<Map<String, Object>> _inputsToExpected = [
      {'a': <LatLng>[], 'b': <LatLng>[], 'expectedOutput': true},
      {'a': <LatLng>[const LatLng(41,21)], 'b': <LatLng>[], 'expectedOutput': false},
      {'a': <LatLng>[], 'b': <LatLng>[const LatLng(41,21)], 'expectedOutput': false},

      {'a': <LatLng>[const LatLng(41,21)], 'b': <LatLng>[const LatLng(41,21)], 'expectedOutput': true},
      {'a': <LatLng>[const LatLng(41,21), const LatLng(42,22)], 'b': <LatLng>[const LatLng(41,21)], 'expectedOutput': false},
      {'a': <LatLng>[const LatLng(41,21), const LatLng(42,22)], 'b': <LatLng>[const LatLng(41,21), const LatLng(42,22)], 'expectedOutput': true},
      {'a': <LatLng>[const LatLng(41,21)], 'b': <LatLng>[const LatLng(41,21), const LatLng(42,22)], 'expectedOutput': false},    ];

    for (var elem in _inputsToExpected) {
      test('a: ${elem['a']}, b:  ${elem['b']}', () {
        var _actual = equalsLatLngList(elem['a'] as List<LatLng>, elem['b'] as List<LatLng>);
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

  group('CoordinateUtils.normalizedAngleBetweenBearings:', () {
    List<Map<String, double>> _inputsToExpected = [
      {'bearingA' : 0.0, 'bearingB': 0.0,'expectedOutput': 0.0},
      {'bearingA' : -0.0, 'bearingB': 0.0,'expectedOutput': 0.0},
      {'bearingA' : -0.0, 'bearingB': -0.0,'expectedOutput': 0.0},
      {'bearingA' : 0.0, 'bearingB': -0.0,'expectedOutput': -0.0},

      {'bearingA' : 360.0, 'bearingB': 0.0,'expectedOutput': -360.0},
      {'bearingA' : 0.0, 'bearingB': 360.0,'expectedOutput': 360.0},
      {'bearingA' : 350.0, 'bearingB': -10.0,'expectedOutput': -360.0},
      {'bearingA' : -10.0, 'bearingB': 350.0,'expectedOutput': 360.0},
      {'bearingA' : 370.0, 'bearingB': 10.0,'expectedOutput': -360.0},
      {'bearingA' : 10.0, 'bearingB': 370.0,'expectedOutput': 360.0},
      {'bearingA' : -10.0, 'bearingB': -10.0,'expectedOutput': 0.0},
      {'bearingA' : 370.0, 'bearingB': 370.0,'expectedOutput': 0.0},
      {'bearingA' : -370.0, 'bearingB': -370.0,'expectedOutput': 0.0},
      {'bearingA' : -370.0, 'bearingB': -10.0,'expectedOutput': 360.0},
      {'bearingA' : -10.0, 'bearingB': -370.0,'expectedOutput': -360.0},
      {'bearingA' : -360.0, 'bearingB': -360.0,'expectedOutput': 0.0},
      {'bearingA' : -360.0, 'bearingB': 0.0,'expectedOutput': 360.0},
      {'bearingA' : -360.0, 'bearingB': -0.0,'expectedOutput': 360.0},
      {'bearingA' : 0.0, 'bearingB': -360.0,'expectedOutput': -360.0},
      {'bearingA' : -0.0, 'bearingB': -360.0,'expectedOutput': -360.0},
      {'bearingA' : 360.0, 'bearingB': 720.0,'expectedOutput': 360.0},
      {'bearingA' : 720.0, 'bearingB': 360.0,'expectedOutput': -360.0},
      {'bearingA' : 730.0, 'bearingB': 360.0,'expectedOutput': -10.0},
      {'bearingA' : 730.0, 'bearingB': 370.0,'expectedOutput': -360.0},
      {'bearingA' : 370.0, 'bearingB': 730.0,'expectedOutput': 360.0},
      {'bearingA' : 710.0, 'bearingB': 350.0,'expectedOutput': -360.0},
      {'bearingA' : 350.0, 'bearingB': 710.0,'expectedOutput': 360.0},
      {'bearingA' : 710.0, 'bearingB': 710.0,'expectedOutput': 0.0},
      {'bearingA' : 730.0, 'bearingB': 730.0,'expectedOutput': 0.0},
      {'bearingA' : -730.0, 'bearingB': -730.0,'expectedOutput': 0.0},
      {'bearingA' : -730.0, 'bearingB': 0.0,'expectedOutput': 10.0},
      {'bearingA' : 730.0, 'bearingB': 0.0,'expectedOutput': -10.0},
      {'bearingA' : 0.0, 'bearingB': 730.0,'expectedOutput': 10.0},
      {'bearingA' : 0.0, 'bearingB': -730.0,'expectedOutput': -10.0},

      {'bearingA' : 10.0, 'bearingB': 5.0,'expectedOutput': -5.0},
      {'bearingA' : 5.0, 'bearingB': 10.0,'expectedOutput': 5.0},
      {'bearingA' : 10.0, 'bearingB': 350.0,'expectedOutput': 340.0},
      {'bearingA' : 350.0, 'bearingB': 10.0,'expectedOutput': -340.0},
    ];

    for (var elem in _inputsToExpected) {
      test('bearingA: ${elem['bearingA']}, bearingB: ${elem['bearingB']}', () {
        var _actual = normalizedAngleBetweenBearings(elem['bearingA'] as double, elem['bearingB'] as double);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group('CoordinateUtils.isOnGeodesic:', () {
    List<Map<String, Object>> _inputsToExpected = [
      {'point': LatLng(0,0), 'start': LatLng(0,0), 'end': LatLng(0,0), 'expectedOutput': true},
      {'point': LatLng(0,0), 'start': LatLng(90,0), 'end': LatLng(-90,0), 'expectedOutput': true},
      {'point': LatLng(90,0), 'start': LatLng(90,1), 'end': LatLng(90,2), 'expectedOutput': true},
      {'point': LatLng(0,0), 'start': LatLng(0,0), 'end': LatLng(0,0), 'expectedOutput': true},

      {'point': LatLng(2,2), 'start': LatLng(1,1), 'end': LatLng(3,3), 'expectedOutput': false},
      {'start': LatLng(70, 0), 'end': LatLng(13.56832726660199, 74.33418761525557), 'point': LatLng(38.59652460733987, 62.72751487512538), 'expectedOutput': false},
      {'point': LatLng(70, 0), 'start': LatLng(13.56832726660199, 74.33418761525557), 'end': LatLng(38.59652460733987, 62.72751487512538), 'expectedOutput': false},

      {'point': LatLng(68.36526802265838, 2.0716426033747704), 'start': LatLng(70, 0), 'end': LatLng(52, 13), 'expectedOutput': true},
      {'start': LatLng(68.36526802265838, 2.0716426033747704), 'point': LatLng(70, 0), 'end': LatLng(52, 13), 'expectedOutput': true},
      {'point': LatLng(68.36526802265838, 2.0716436033747704), 'start': LatLng(70, 0), 'end': LatLng(52, 13), 'expectedOutput': false},
    ];


    for (var elem in _inputsToExpected) {
      test('point: ${elem['point']}, start:  ${elem['start']}, end:  ${elem['end']}', () {
        var _actual = isOnGeodesic(elem['point'] as LatLng, elem['start'] as LatLng, elem['end'] as LatLng, Ellipsoid.WGS84);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group('CoordinateUtils.isOnSegment:', () {
    List<Map<String, Object>> _inputsToExpected = [
      {'point': LatLng(0,0), 'start': LatLng(0,0), 'end': LatLng(0,0), 'expectedOutput': true},
      {'point': LatLng(0,0), 'start': LatLng(90,0), 'end': LatLng(-90,0), 'expectedOutput': true},
      {'point': LatLng(90,0), 'start': LatLng(90,1), 'end': LatLng(90,2), 'expectedOutput': true},
      {'point': LatLng(0,0), 'start': LatLng(0,0), 'end': LatLng(0,0), 'expectedOutput': true},

      {'point': LatLng(2,2), 'start': LatLng(1,1), 'end': LatLng(3,3), 'expectedOutput': false},
      {'start': LatLng(70, 0), 'end': LatLng(13.56832726660199, 74.33418761525557), 'point': LatLng(38.59652460733987, 62.72751487512538), 'expectedOutput': false},
      {'point': LatLng(70, 0), 'start': LatLng(13.56832726660199, 74.33418761525557), 'end': LatLng(38.59652460733987, 62.72751487512538), 'expectedOutput': false},

      {'point': LatLng(68.36526802265838, 2.0716426033747704), 'start': LatLng(70, 0), 'end': LatLng(52, 13), 'expectedOutput': true},
      {'start': LatLng(68.36526802265838, 2.0716426033747704), 'point': LatLng(70, 0), 'end': LatLng(52, 13), 'expectedOutput': false},
      {'point': LatLng(68.36526802265838, 2.0716436033747704), 'start': LatLng(70, 0), 'end': LatLng(52, 13), 'expectedOutput': false},
    ];


    for (var elem in _inputsToExpected) {
      test('point: ${elem['point']}, start:  ${elem['start']}, end:  ${elem['end']}', () {
        var _actual = isOnSegment(elem['point'] as LatLng, elem['start'] as LatLng, elem['end'] as LatLng, Ellipsoid.WGS84);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group('CoordinateUtils.isAntipode:', () {
    List<Map<String, Object>> _inputsToExpected = [
      {'point': LatLng(0,0), 'pointToCheck': LatLng(180,0), 'expectedOutput': true},
      {'point': LatLng(0,0), 'pointToCheck': LatLng(-180,0), 'expectedOutput': true},
      {'point': LatLng(90,0), 'pointToCheck': LatLng(-90,0), 'expectedOutput': true},
      {'point': LatLng(90,10), 'pointToCheck': LatLng(-90,0), 'expectedOutput': true},
      {'point': LatLng(90,0), 'pointToCheck': LatLng(-90,-100), 'expectedOutput': true},
      {'point': LatLng(52,13), 'pointToCheck': LatLng(-52.0, -167.0), 'expectedOutput': true},

      {'point': LatLng(52,13), 'pointToCheck': LatLng(-52.0, -168.0), 'expectedOutput': false},
      {'point': LatLng(52,13), 'pointToCheck': LatLng(-53.0, -167.0), 'expectedOutput': false},
      {'point': LatLng(52,13), 'pointToCheck': LatLng(-52,-167.000000001), 'expectedOutput': false},
      {'point': LatLng(52,13), 'pointToCheck': LatLng(-51.9999999999,-167), 'expectedOutput': false},
    ];


    for (var elem in _inputsToExpected) {
      test('point: ${elem['point']}, pointToCheck:  ${elem['pointToCheck']}}', () {
        var _actual = isAntipode(elem['point'] as LatLng, elem['pointToCheck'] as LatLng);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group('CoordinateUtils.isNearPole:', () {
    List<Map<String, Object>> _inputsToExpected = [
      {'coord': LatLng(90,0), 'expectedOutput': true},
      {'coord': LatLng(90,180), 'expectedOutput': true},
      {'coord': LatLng(90,-180), 'expectedOutput': true},
      {'coord': LatLng(-90,-180), 'expectedOutput': true},
      {'coord': LatLng(-90,0), 'expectedOutput': true},

      {'coord': LatLng(89,0), 'expectedOutput': false},
      {'coord': LatLng(-89,0), 'expectedOutput': false},
      {'coord': LatLng(89.9,0), 'expectedOutput': false},
      {'coord': LatLng(-89.9,0), 'expectedOutput': false},
      {'coord': LatLng(-89.9,180), 'expectedOutput': false},
      {'coord': LatLng(-89.9,-180), 'expectedOutput': false},
      {'coord': LatLng(89.9,-180), 'expectedOutput': false},
      {'coord': LatLng(89.9,180), 'expectedOutput': false},

      {'coord': LatLng(89.99,0), 'expectedOutput': false},
      {'coord': LatLng(-89.99,0), 'expectedOutput': false},
      {'coord': LatLng(-89.99,180), 'expectedOutput': false},
      {'coord': LatLng(-89.99,-180), 'expectedOutput': false},
      {'coord': LatLng(89.99,-180), 'expectedOutput': false},
      {'coord': LatLng(89.99,180), 'expectedOutput': false},

      {'coord': LatLng(89.999,0), 'expectedOutput': true},
      {'coord': LatLng(89.999,180), 'expectedOutput': true},
      {'coord': LatLng(89.999,-180), 'expectedOutput': true},
      {'coord': LatLng(-89.999,0), 'expectedOutput': true},
      {'coord': LatLng(-89.999,180), 'expectedOutput': true},
      {'coord': LatLng(-89.999,-180), 'expectedOutput': true},
      {'coord': LatLng(-89.9999,-180), 'expectedOutput': true},
    ];


    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}', () {
        var _actual = isNearPole(elem['coord'] as LatLng);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}