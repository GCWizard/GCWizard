import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.mgrs.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'ÖD31365480657013431886', 'expectedOutput': null},
      {'text': '35T LM 91892.8208 18448.7408', 'expectedOutput': {'format': keyCoordsMGRS, 'coordinate': LatLng(46.04117356610081, 25.598809996225977)}},
      {'text': '35 T LM 91892.8208 18448.7408', 'expectedOutput': {'format': keyCoordsMGRS, 'coordinate': LatLng(46.04117356610081, 25.598809996225977)}},
      {'text': '35T LM 91892 18448', 'expectedOutput': {'format': keyCoordsMGRS, 'coordinate': LatLng(46.04116677326809, 25.59879952996897)}},
      {'text': '35T LM 9189218448', 'expectedOutput': {'format': keyCoordsMGRS, 'coordinate': LatLng(46.04116677326809, 25.59879952996897)}},
      {'text': '35TLM9189218448', 'expectedOutput': {'format': keyCoordsMGRS, 'coordinate': LatLng(46.04116677326809, 25.59879952996897)}},
      {'text': '35T LM 9189 1844', 'expectedOutput': {'format': keyCoordsMGRS, 'coordinate': LatLng(46.04109450354022, 25.598775440767994)}},
      {'text': '35T LM 918 184', 'expectedOutput': {'format': keyCoordsMGRS, 'coordinate': LatLng(46.0407204797636, 25.59761842865664)}},
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = MGRS.parse(elem['text'])?.toLatLng(ells: ells);
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