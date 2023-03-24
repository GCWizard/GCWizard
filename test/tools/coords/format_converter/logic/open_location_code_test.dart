import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.open_location_code.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': 'AGR76H6X+C95QFH', 'expectedOutput': null},
      {'text': '1GR76H6X+C95QFH', 'expectedOutput': null},
      {'text': '8GR76H6X+C95QFH', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(46.2110175, 025.5984958496)}},

      {'text': '9F28', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.5, 6.5)}},
      {'text': '9F28+', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.5, 6.5)}},
      {'text': '9F28WX', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.925, 6.9750000000000005)}},
      {'text': '9F28WX+', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.925, 6.9750000000000005)}},
      {'text': '9F28WXR4', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.94125, 6.95625)}},
      {'text': '9F28WXR4+', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.94125, 6.95625)}},
      {'text': '9F28WXR4FW', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.9411875, 6.9573125000000005)}},
      {'text': '9F28WXR4+FW', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.9411875, 6.9573125000000005)}},
      {'text': '9F28WXR4FW2', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.941137499999996, 6.957265625)}},
      {'text': '9F28WXR4+FW2', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.941137499999996, 6.957265625)}},
      {'text': '9F28WXR4FW2X', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.9411475, 6.95727734375)}},
      {'text': '9F28WXR4+FW2X', 'expectedOutput': {'format': CoordinateFormatKey.OPEN_LOCATION_CODE, 'coordinate': LatLng(50.9411475, 6.95727734375)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = OpenLocationCode.parse(elem['text'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect((_actual.latitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
          expect((_actual.longitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
        }
      });
    }
  });}