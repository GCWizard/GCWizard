import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.quadtree.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': '1203203022132122220122000301310333201333', 'expectedOutput': {'format': keyCoordsQuadtree, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': '41203203022132122220122000301310333201333', 'expectedOutput': null},
      {'text': 'A1203203022132122220122000301310333201333', 'expectedOutput': null},
      {'text': '1202210112112003133223132030211230100013', 'expectedOutput': {'format': keyCoordsQuadtree, 'coordinate': LatLng(48.65653333340585, 8.008499999814376)}},
    ];

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = Quadtree.parse(elem['text'])?.toLatLng();
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