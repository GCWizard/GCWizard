import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/geohash/logic/geohash.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.geohash.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'ö84nys2q8rm9j3', 'expectedOutput': {'format': CoordinateFormatKey.GEOHEX, 'coordinate': LatLng(12.394024736713618, -170.31180599005893)}},
      {'text': 'u84nys2q8rm9j3', 'expectedOutput': {'format': CoordinateFormatKey.GEOHEX, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': 'U84nys2q8rm9j3', 'expectedOutput': {'format': CoordinateFormatKey.GEOHEX, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = GeohashCoordinate.parse(elem['text'] as String)?.toLatLng();
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