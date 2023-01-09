import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/logic/tools/coords/data/coordinates.dart';
import 'package:gc_wizard/logic/tools/coords/data/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.swissgrid.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': '1989048.7411670878 278659.94052181806', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y: 1989048.7411670878 X: 278659.94052181806', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y:1989048.7411670878 X:278659.94052181806', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y:1989048.7411670878X:278659.94052181806', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y1989048.7411670878X278659.94052181806', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'y1989048.7411670878x278659.94052181806', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = SwissGrid.parse(elem['text'])?.toLatLng(ells: ells);
        if (_actual == null)
          expect(null, elem['expectedOutput']);
        else {
          expect((_actual.latitude - elem['expectedOutput']['coordinate'].latitude).abs() < 1e-8, true);
          expect((_actual.longitude - elem['expectedOutput']['coordinate'].longitude).abs() < 1e-8, true);
        }
      });
    });
  });

  group("Parser.swissgrid_plus.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': '3989048.741167088 1278659.9405218181', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y: 3989048.741167088 X: 1278659.9405218181', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y:3989048.741167088 X:1278659.9405218181', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y:3989048.741167088X:1278659.9405218181', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y3989048.741167088X1278659.9405218181', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'y3989048.741167088x1278659.9405218181', 'expectedOutput': {'format': keyCoordsSwissGrid, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = SwissGridPlus.parse(elem['text'])?.toLatLng(ells: ells);
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