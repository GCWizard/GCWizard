import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_waldmeister/logic/reverse_wherigo_waldmeister.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.reverseWherigoWaldmeister.fromLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coordinate': const LatLng(0.0, 0.0), 'text': ['000100', '009000', '005000']},
      {'coordinate': const LatLng(-87.08835, -179.80245), 'text': ['580497', '850012', '847837']},
      {'coordinate': const LatLng(11.01746, -178.2824), 'text': ['711326', '807210', '749148']},
      {'coordinate': const LatLng(65.11828, -98.00437), 'text': ['801385', '675004', '136829']},
      {'coordinate': const LatLng(37.75955, -40.888), 'text': ['587307', '303808', '507954']},
      {'coordinate': const LatLng(-6.86326, 66.11175), 'text': ['618266', '053101', '671326']},
      {'coordinate': const LatLng(1.93502, 97.3164), 'text': ['500162', '191310', '948307']},
      {'coordinate': const LatLng(-13.44442, 118.51471), 'text': ['254283', '115114', '470441']},
      {'coordinate': const LatLng(-18.86006, 176.54396), 'text': ['658268', '168413', '695007']},
      {'coordinate': const LatLng(89.67067, 179.13098), 'text': ['716199', '889310', '792067']},
    ];

    for (var elem in _inputsToExpected) {
      test('coordinate: ${elem['coordinate']}', () {
        var _actual = ReverseWherigoWaldmeisterCoordinate.fromLatLon(elem['coordinate'] as LatLng);
        expect(_actual.a, int.parse((elem['text'] as List<String>)[0]));
        expect(_actual.b, int.parse((elem['text'] as List<String>)[1]));
        expect(_actual.c, int.parse((elem['text'] as List<String>)[2]));
      });
    }
  });

  group("Converter.reverseWherigooWaldmeister.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coordinate': const LatLng(0.0, 0.0), 'text': ['000100', '009000', '005000']},
      {'coordinate': const LatLng(-87.08835, -179.80245), 'text': ['580497', '850012', '847837']},
      {'coordinate': const LatLng(11.01746, -178.2824), 'text': ['711326', '807210', '749148']},
      {'coordinate': const LatLng(65.11828, -98.00437), 'text': ['801385', '675004', '136829']},
      {'coordinate': const LatLng(37.75955, -40.888), 'text': ['587307', '303808', '507954']},
      {'coordinate': const LatLng(-6.86326, 66.11175), 'text': ['618266', '053101', '671326']},
      {'coordinate': const LatLng(1.93502, 97.3164), 'text': ['500162', '191310', '948307']},
      {'coordinate': const LatLng(-13.44442, 118.51471), 'text': ['254283', '115114', '470441']},
      {'coordinate': const LatLng(-18.86006, 176.54396), 'text': ['658268', '168413', '695007']},
      {'coordinate': const LatLng(89.67067, 179.13098), 'text': ['716199', '889310', '792067']},
      {'coordinate': const LatLng(50.65646, 10.99135), 'text': ['696100', '551901', '538641']},
      {'coordinate': const LatLng(50.6607, 10.98846), 'text': ['096100', '569808', '648071']},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigoWaldmeisterCoordinate.parse((elem['text'] as List<String>).join(' '))?.toLatLng();
        expect((_actual!.latitude - (elem['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
        expect((_actual.longitude - (elem['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
      });
    }
  });

  group("Converter.reverseWherigooWaldmeister.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'coordinate': null},
      {'text': '104181 924569 248105', 'coordinate': {'format': CoordinateFormatKey.REVERSE_WIG_WALDMEISTER, 'coordinate': const LatLng(46.21101, 025.59849)}},
      {'text': '104181\n924569\n248105', 'coordinate': {'format': CoordinateFormatKey.REVERSE_WIG_WALDMEISTER, 'coordinate': const LatLng(46.21101, 025.59849)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigoWaldmeisterCoordinate.parse(elem['text'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['coordinate']);
        } else {
          expect((_actual.latitude - ((elem['coordinate'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
          expect((_actual.longitude - ((elem['coordinate'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
        }
      });
    }
  });

  group("Converter.reverseWherigooWaldmeister.checkSumTest:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coordinate': null, 'text': ['580498', '850012', '847837']},
      {'coordinate': null, 'text': ['580597', '860012', '847837']},
      {'coordinate': null, 'text': ['580497', '851012', '847937']},
      {'coordinate': null, 'text': ['580497', '850013', '847837']},
      {'coordinate': null, 'text': ['580497', '850012', '857837']},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigoWaldmeisterCoordinate.parse((elem['text'] as List<String>).join(' '))?.toLatLng();
        expect(_actual, elem['coordinate']);
      });
    }
  });
}