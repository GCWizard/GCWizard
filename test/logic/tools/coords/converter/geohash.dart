import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/logic/tools/coords/converter/geohash.dart';
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:latlong/latlong.dart';

void main() {
  group("Parser.geohash.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'ö84nys2q8rm9j3', 'expectedOutput': null},
      {'text': 'u84nys2q8rm9j3', 'expectedOutput': {'format': keyCoordsGeoHex, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': 'U84nys2q8rm9j3', 'expectedOutput': {'format': keyCoordsGeoHex, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = geohashToLatLon(elem['text']);
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