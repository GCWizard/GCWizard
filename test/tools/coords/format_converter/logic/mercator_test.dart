import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.mercator.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'Y: 5814230.730194772 X: 2849612.661492129', 'expectedOutput': {'format': keyCoordsMercator, 'coordinate': LatLng(46.25149839125229, 25.62718234979449)}},
      {'text': 'Y:5814230.730194772X:2849612.661492129', 'expectedOutput': {'format': keyCoordsMercator, 'coordinate': LatLng(46.25149839125229, 25.62718234979449)}},
      {'text': 'Y5814230.730194772X2849612.661492129', 'expectedOutput': {'format': keyCoordsMercator, 'coordinate': LatLng(46.25149839125229, 25.62718234979449)}},
      {'text': '5814230.730194772 2849612.661492129', 'expectedOutput': {'format': keyCoordsMercator, 'coordinate': LatLng(46.25149839125229, 25.62718234979449)}},
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = Mercator.parse(elem['text'])?.toLatLng(ells: ells);
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