import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.xyz.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'X: 3987428.547121 Y: 1910326.935629 Z: 4581509.856737', 'expectedOutput': {'format': keyCoordsXYZ, 'coordinate': LatLng(46.01873890823172, 25.598495717002137)}},
      {'text': 'X: 3987428.547121\nY: 1910326.935629\nZ: 4581509.856737', 'expectedOutput': {'format': keyCoordsXYZ, 'coordinate': LatLng(46.01873890823172, 25.598495717002137)}},
      {'text': 'X:3987428.547121Y:1910326.935629Z:4581509.856737', 'expectedOutput': {'format': keyCoordsXYZ, 'coordinate': LatLng(46.01873890823172, 25.598495717002137)}},
      {'text': 'X3987428.547121Y1910326.935629Z4581509.856737', 'expectedOutput': {'format': keyCoordsXYZ, 'coordinate': LatLng(46.01873890823172, 25.598495717002137)}},
      {'text': '3987428.547121 1910326.935629 4581509.856737', 'expectedOutput': {'format': keyCoordsXYZ, 'coordinate': LatLng(46.01873890823172, 25.598495717002137)}},
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = XYZ.parse(elem['text'])?.toLatLng(ells: ells);
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