import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/xyz/logic/xyz.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.xyz.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'X: 3987428.547121 Y: 1910326.935629 Z: 4581509.856737', 'expectedOutput': {'format': CoordinateFormatKey.XYZ, 'coordinate': const LatLng(46.01873890823172, 25.598495717002137)}},
      {'text': 'X: 3987428.547121\nY: 1910326.935629\nZ: 4581509.856737', 'expectedOutput': {'format': CoordinateFormatKey.XYZ, 'coordinate': const LatLng(46.01873890823172, 25.598495717002137)}},
      {'text': 'X:3987428.547121Y:1910326.935629Z:4581509.856737', 'expectedOutput': {'format': CoordinateFormatKey.XYZ, 'coordinate': const LatLng(46.01873890823172, 25.598495717002137)}},
      {'text': 'X3987428.547121Y1910326.935629Z4581509.856737', 'expectedOutput': {'format': CoordinateFormatKey.XYZ, 'coordinate': const LatLng(46.01873890823172, 25.598495717002137)}},
      {'text': '3987428.547121 1910326.935629 4581509.856737', 'expectedOutput': {'format': CoordinateFormatKey.XYZ, 'coordinate': const LatLng(46.01873890823172, 25.598495717002137)}},
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = XYZCoordinate.parse(elem['text'] as String)?.toLatLng(ells: ells);
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