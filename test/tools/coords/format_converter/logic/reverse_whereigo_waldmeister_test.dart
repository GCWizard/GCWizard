import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.reverseWherigoWaldmeister.latlonToWaldmeister:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'coord': LatLng(0.0, 0.0), 'expectedOutput': ['000100', '009000', '005000']},
      {'coord': LatLng(-87.08835, -179.80245), 'expectedOutput': ['580497', '850012', '847837']},
      {'coord': LatLng(11.01746, -178.2824), 'expectedOutput': ['711326', '807210', '749148']},
      {'coord': LatLng(65.11828, -98.00437), 'expectedOutput': ['801385', '675004', '136829']},
      {'coord': LatLng(37.75955, -40.888), 'expectedOutput': ['587307', '303808', '507954']},
      {'coord': LatLng(-6.86326, 66.11175), 'expectedOutput': ['618266', '053101', '671326']},
      {'coord': LatLng(1.93502, 97.3164), 'expectedOutput': ['500162', '191310', '948307']},
      {'coord': LatLng(-13.44442, 118.51471), 'expectedOutput': ['254283', '115114', '470441']},
      {'coord': LatLng(-18.86006, 176.54396), 'expectedOutput': ['658268', '168413', '695007']},
      {'coord': LatLng(89.67067, 179.13098), 'expectedOutput': ['716199', '889310', '792067']},
    ];

    _inputsToExpected.forEach((elem) {
      test('coord: ${elem['coord']}', () {
        var _actual = ReverseWherigoWaldmeister.fromLatLon(elem['coord']);
        expect(_actual.a, elem['expectedOutput'][0]);
        expect(_actual.b, elem['expectedOutput'][1]);
        expect(_actual.c, elem['expectedOutput'][2]);
      });
    });
  });

  group("Converter.reverseWherigooWaldmeister.waldmeisterToLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'expectedOutput': LatLng(0.0, 0.0), 'input': ['000100', '009000', '005000']},
      {'expectedOutput': LatLng(-87.08835, -179.80245), 'input': ['580497', '850012', '847837']},
      {'expectedOutput': LatLng(11.01746, -178.2824), 'input': ['711326', '807210', '749148']},
      {'expectedOutput': LatLng(65.11828, -98.00437), 'input': ['801385', '675004', '136829']},
      {'expectedOutput': LatLng(37.75955, -40.888), 'input': ['587307', '303808', '507954']},
      {'expectedOutput': LatLng(-6.86326, 66.11175), 'input': ['618266', '053101', '671326']},
      {'expectedOutput': LatLng(1.93502, 97.3164), 'input': ['500162', '191310', '948307']},
      {'expectedOutput': LatLng(-13.44442, 118.51471), 'input': ['254283', '115114', '470441']},
      {'expectedOutput': LatLng(-18.86006, 176.54396), 'input': ['658268', '168413', '695007']},
      {'expectedOutput': LatLng(89.67067, 179.13098), 'input': ['716199', '889310', '792067']},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var a = int.tryParse(elem['input'][0]);
        var b = int.tryParse(elem['input'][1]);
        var c = int.tryParse(elem['input'][2]);

        var _actual = ReverseWherigoWaldmeister.parse(elem['input'][0] + " " + elem['input'][1] + " " + elem['input'][2])?.toLatLng();
        expect((_actual.latitude - elem['expectedOutput'].latitude).abs() < 1e-8, true);
        expect((_actual.longitude - elem['expectedOutput'].longitude).abs() < 1e-8, true);
      });
    });
  });

  group("Converter.reverse_wherigo_waldmeister.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': '104181 924569 248105', 'expectedOutput': {'format': keyCoordsReverseWherigoWaldmeister, 'coordinate': LatLng(46.21101, 025.59849)}},
      {'text': '104181\n924569\n248105', 'expectedOutput': {'format': keyCoordsReverseWherigoWaldmeister, 'coordinate': LatLng(46.21101, 025.59849)}},
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigoWaldmeister.parse(elem['text'])?.toLatLng();
        if (_actual == null)
          expect(null, elem['expectedOutput']);
        else {
          expect((_actual.latitude - elem['expectedOutput']['coordinate'].latitude).abs() < 1e-8, true);
          expect((_actual.longitude - elem['expectedOutput']['coordinate'].longitude).abs() < 1e-8, true);
        }
      });
    });
  });
}