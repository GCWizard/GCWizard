import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/slippymap/logic/slippy_map.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.slippy_map.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': '584.813499 363.434344', 'expectedOutput': {'format': CoordinateFormatKey.SLIPPY_MAP, 'coordinate': LatLng(46.211017406, 025.5984957422)}},
      {'text': 'X: 584.813499 Y: 363.434344', 'expectedOutput': {'format': CoordinateFormatKey.SLIPPY_MAP, 'coordinate': LatLng(46.211017406, 025.5984957422)}},
      {'text': 'X:584.813499 Y:363.434344', 'expectedOutput': {'format': CoordinateFormatKey.SLIPPY_MAP, 'coordinate': LatLng(46.211017406, 025.5984957422)}},
      {'text': 'X:584.813499 Y:363.434344', 'expectedOutput': {'format': CoordinateFormatKey.SLIPPY_MAP, 'coordinate': LatLng(46.211017406, 025.5984957422)}},
      {'text': 'X584.813499Y363.434344', 'expectedOutput': {'format': CoordinateFormatKey.SLIPPY_MAP, 'coordinate': LatLng(46.211017406, 025.5984957422)}},
      {'text': 'x584.813499y363.434344', 'expectedOutput': {'format': CoordinateFormatKey.SLIPPY_MAP, 'coordinate': LatLng(46.211017406, 025.5984957422)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = SlippyMapCoordinate.parse(elem['text'] as String)?.toLatLng();
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