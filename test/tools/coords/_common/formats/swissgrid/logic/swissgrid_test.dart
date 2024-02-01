import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/swissgrid/logic/swissgrid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.swissgrid.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': '1989048.7411670878 278659.94052181806', 'expectedOutput': {'format': CoordinateFormatKey.SWISS_GRID, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y: 1989048.7411670878 X: 278659.94052181806', 'expectedOutput': {'format': CoordinateFormatKey.SWISS_GRID, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y:1989048.7411670878 X:278659.94052181806', 'expectedOutput': {'format': CoordinateFormatKey.SWISS_GRID, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y:1989048.7411670878X:278659.94052181806', 'expectedOutput': {'format': CoordinateFormatKey.SWISS_GRID, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'Y1989048.7411670878X278659.94052181806', 'expectedOutput': {'format': CoordinateFormatKey.SWISS_GRID, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
      {'text': 'y1989048.7411670878x278659.94052181806', 'expectedOutput': {'format': CoordinateFormatKey.SWISS_GRID, 'coordinate': LatLng(46.2110174566, 025.598495717)}},
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = SwissGridCoordinate.parse(elem['text'] as String)?.toLatLng(ells: ells);
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect((_actual.latitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
          expect((_actual.longitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
        }
      });
    }
  });
}