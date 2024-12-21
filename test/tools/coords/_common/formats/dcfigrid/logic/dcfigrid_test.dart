import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/dcfigrid/logic/dcfigrid.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Parser.dcfigrid.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'text': '', 'expectedOutput': null},
      {'text': 'HG00E7.3', 'expectedOutput': {'format': CoordinateFormatKey.DCFIGRID, 'coordinate': const LatLng(46, 3)}},
      {'text': 'HG00D7.4', 'expectedOutput': {'format': CoordinateFormatKey.DCFIGRID, 'coordinate': const LatLng(46.0181666667, 3.7170833333)}}
    ];
    // Lambert NTF
    //{'text': 'X: 706898.197 Y: 2114044.191', 'expectedOutput': {'format': CoordinateFormatKey.DCFIGRID, 'coordinate': const LatLng(46.0181666667, 3.7170833333)}}

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {

        var _actual = parseDFCI(elem['text'] as String, null);
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