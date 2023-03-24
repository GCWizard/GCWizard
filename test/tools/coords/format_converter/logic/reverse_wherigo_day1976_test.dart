import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.reverseWherigoDay1976.latlonToDay1976:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord': LatLng(-37.8228, 145.06348333333),      'expectedOutput': ['jc3q3', 'u0220']},
      {'coord': LatLng(-1.4939666667, -48.4277333333),  'expectedOutput': ['7u509', 'p6666']},
      {'coord': LatLng(48.8575166667, 2.3514166667),    'expectedOutput': ['au8u9', 'mbbbb']},
      {'coord': LatLng(40.5805833333, -073.9160166667), 'expectedOutput': ['6b7dr', 'vnhhn']},
      {'coord': LatLng(-33.8704166667, 151.1718833333), 'expectedOutput': ['jp3tc',  'azddz']},
      {'coord': LatLng(12.8974833333, 77.6074166667),   'expectedOutput': ['fc654', 'jm44m']},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}', () {
        var _actual = ReverseWherigoDay1976.fromLatLon(elem['coord'] as LatLng);
        expect(_actual.s, (elem['expectedOutput'] as List<String>)[0]);
        expect(_actual.t, (elem['expectedOutput'] as List<String>)[1]);
      });
    }
  });

  group("Converter.reverseWherigooDay1976.day1976ToLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput': LatLng(-37.8228, 145.06348333333),      'input': ['jc3q3', 'u0220']},
      {'expectedOutput': LatLng(-1.4939666667, -48.4277333333),  'input': ['7u509', 'p6666']},
      {'expectedOutput': LatLng(48.8575166667, 2.3514166667),    'input': ['au8u9', 'mbbbb']},
      {'expectedOutput': LatLng(40.5805833333, -073.9160166667), 'input': ['6b7dr', 'vnhhn']},
      {'expectedOutput': LatLng(-33.8704166667, 151.1718833333), 'input': ['jp3tc',  'azddz']},
      {'expectedOutput': LatLng(12.8974833333, 77.6074166667),   'input': ['fc654', 'jm44m']},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = ReverseWherigoDay1976.parse((elem['input'] as List<String>)[0] + " " + (elem['input'] as List<String>)[1])?.toLatLng();
        expect((_actual!.latitude - (elem['expectedOutput'] as LatLng).latitude).abs() < 1e-3, true);
        expect((_actual.longitude - (elem['expectedOutput'] as LatLng).longitude).abs() < 1e-3, true);
      });
    }
  });

  group("Converter.reverse_wherigo_day1976.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'fc654 jm44m',  'expectedOutput': {'format': CoordinateFormatKey.REVERSE_WIG_DAY1976, 'coordinate': LatLng(12.8974833333, 77.6074166667)}},
      {'text': 'fc654\njm44m', 'expectedOutput': {'format': CoordinateFormatKey.REVERSE_WIG_DAY1976, 'coordinate': LatLng(12.8974833333, 77.6074166667)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigoDay1976.parse(elem['text'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect((_actual.latitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-3, true);
          expect((_actual.longitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-3, true);
        }
      });
    }
  });
}