import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_day1976/logic/reverse_wherigo_day1976.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.reverseWherigoDay1976.fromLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coordinate': const LatLng(-37.8228, 145.06348333333),      'text': ['jc3q3', 'u0220']},
      {'coordinate': const LatLng(-1.4939666667, -48.4277333333),  'text': ['7u509', 'p6666']},
      {'coordinate': const LatLng(48.8575166667, 2.3514166667),    'text': ['au8u9', 'mbbbb']},
      {'coordinate': const LatLng(40.5805833333, -073.9160166667), 'text': ['6b7dr', 'vnhhn']},
      {'coordinate': const LatLng(-33.8704166667, 151.1718833333), 'text': ['jp3tc',  'azddz']},
      {'coordinate': const LatLng(12.8974833333, 77.6074166667),   'text': ['fc654', 'jm44m']},
    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coordinate']}', () {
        var _actual = ReverseWherigoDay1976Coordinate.fromLatLon(elem['coordinate'] as LatLng);
        expect(_actual.s, (elem['text'] as List<String>)[0]);
        expect(_actual.t, (elem['text'] as List<String>)[1]);
      });
    }
  });

  group("Converter.reverseWherigooDay1976.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coordinate': const LatLng(-37.8228, 145.06348333333),      'text': ['jc3q3', 'u0220']},
      {'coordinate': const LatLng(-1.4939666667, -48.4277333333),  'text': ['7u509', 'p6666']},
      {'coordinate': const LatLng(48.8575166667, 2.3514166667),    'text': ['au8u9', 'mbbbb']},
      {'coordinate': const LatLng(40.5805833333, -073.9160166667), 'text': ['6b7dr', 'vnhhn']},
      {'coordinate': const LatLng(-33.8704166667, 151.1718833333), 'text': ['jp3tc',  'azddz']},
      {'coordinate': const LatLng(12.8974833333, 77.6074166667),   'text': ['fc654', 'jm44m']},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigoDay1976Coordinate.parse((elem['text'] as List<String>)[0] + " " + (elem['text'] as List<String>)[1])?.toLatLng();
        expect((_actual!.latitude - (elem['coordinate'] as LatLng).latitude).abs() < 1e-3, true);
        expect((_actual.longitude - (elem['coordinate'] as LatLng).longitude).abs() < 1e-3, true);
      });
    }
  });

  group("Converter.reverse_wherigo_day1976.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'coordinate': null},
      {'text': 'fc654 jm44m',  'coordinate': {'format': CoordinateFormatKey.REVERSE_WIG_DAY1976, 'coordinate': const LatLng(12.8974833333, 77.6074166667)}},
      {'text': 'fc654\njm44m', 'coordinate': {'format': CoordinateFormatKey.REVERSE_WIG_DAY1976, 'coordinate': const LatLng(12.8974833333, 77.6074166667)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigoDay1976Coordinate.parse(elem['text'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['coordinate']);
        } else {
          expect((_actual.latitude - ((elem['coordinate'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-3, true);
          expect((_actual.longitude - ((elem['coordinate'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-3, true);
        }
      });
    }
  });
}