import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/gausskrueger/logic/gauss_krueger.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.gauss_krueger.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': '9392110.611090261', 'expectedOutput': null},
      {'text': '9392110.611090261\n5120027.146589669', 'expectedOutput': {'format': CoordinateFormatKey.GAUSS_KRUEGER, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': '9392110.611090261, 5120027.146589669', 'expectedOutput': {'format': CoordinateFormatKey.GAUSS_KRUEGER, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': '9392110.611090261 5120027.146589669', 'expectedOutput': {'format': CoordinateFormatKey.GAUSS_KRUEGER, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': 'R: 9392110.611090261\nH: 5120027.146589669', 'expectedOutput': {'format': CoordinateFormatKey.GAUSS_KRUEGER, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': 'r: 9392110.611090261\nh: 5120027.146589669', 'expectedOutput': {'format': CoordinateFormatKey.GAUSS_KRUEGER, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': 'R:9392110.611090261\nH:5120027.146589669', 'expectedOutput': {'format': CoordinateFormatKey.GAUSS_KRUEGER, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': 'R 9392110.611090261\nH 5120027.146589669', 'expectedOutput': {'format': CoordinateFormatKey.GAUSS_KRUEGER, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
      {'text': 'R9392110.611090261\nH5120027.146589669', 'expectedOutput': {'format': CoordinateFormatKey.GAUSS_KRUEGER, 'coordinate': LatLng(46.211024251, 025.5985061856)}},
    ];

    var ells = getEllipsoidByName('coords_ellipsoid_earthsphere');

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = GaussKruegerCoordinate.parse(elem['text'] as String)?.toLatLng(ells: ells);
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