import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/dms/logic/dms.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

final List<Map<String, Object?>> inputsToExpectedDMS = [
  {'text': '52° 12\' 30.15" N 20° 12\' 30.15" E', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52° 12\' 30.15" N, 20° 12\' 30.15" E', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52° 12\' 30.15" S 20° 12\' 30.15" W', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, -20.208375)}},
  {'text': '52° 12\' 30.15" S, 20° 12\' 30.15" W', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, -20.208375)}},
  {'text': '52 12 30.15 S, 20 12 30.15 W', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, -20.208375)}},
  {'text': '52 12 30 .15 S, 20 12 30. 15 E', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, 20.208375)}},
  {'text': '52 12 30.15S, 20 12 30.15W', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, -20.208375)}},
  {'text': '52 12 45 S, 20 12 45 W', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.2125, -20.2125)}},
  {'text': '52 12 45 S, 20 12 45 W', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.2125, -20.2125)}},
  {'text': '52°12\'30.15"N 020°12\'30.15"E', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52°12\'30.15"S 000°12\'30.15"W', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, -0.208375)}},
  {'text': '52°12\'30.15"North, 20°12\'30.15"O', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52°12\'30.15" North, 20°12\'30.15"O', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52°12\'30.15" Süden 20°12\'30.15" Westen', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, -20.208375)}},
  {'text': '052°12\'30.15" Süden 20°12\'30.15" Westen', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, -20.208375)}},
  {'text': '52° 12′ 30″ N, 20°12′ 31″ O', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.2083333333, 020.2086111111)}},
  {'text': '52° 12′ 30“ N, 20°12′ 31” O', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.2083333333, 020.2086111111)}},

  {'text': 'N 52° 12\' 30.15" E 20° 12\' 30.15"', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': 'N 52° 12′ 30″,O 20°12′ 31″', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.2083333333, 020.2086111111)}},
  {'text': 'N 52°12\'30.15" E 20°12\'30.15"', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52°12\'30.15" 20°12\'30.15"', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': 'N 52 12 30.15 E 20 12 30.15', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52 12 30.15 20 12 30.15', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52 12 30.15, 20 12 30.15', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': 'N52 12 30.15, E20 12 30.15', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': 'N52 12 30,15, E20 12 30,15', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': 'North 52 12 30.15, East 20 12 30.15', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': 'North 52 6 30.15, East 20 06 30.15', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.108375, 20.108375)}},
  {'text': 'North 52 12 30 .15, East 20 12 30. 15', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': 'N 52 12 45 E 20 12 45', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.2125, 20.2125)}},
  {'text': '52 12 45 20 12 45', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.2125, 20.2125)}},
  {'text': '52 12 9 20 12 09', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.2025, 20.2025)}},
  {'text': '52 6 9 20 6 9', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.1025, 20.1025)}},
  {'text': '52 6 0 20 6 9.0', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.1, 20.1025)}},
  {'text': '052 6 0 20 6 9.0', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.1, 20.1025)}},

  {'text': '52 12 45 S, 20 12 45 W SomeText', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.2125, -20.2125)}},
  {'text': '52° 12\' 30.15" N 20° 12\' 30.15" E SomeMoreText', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52°12\'30.15" Süden 20°12\'30.15" Westen\nA: 42', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(-52.208375, -20.208375)}},

  {'text': 'N 52 12 30.15 E 20 12 30.15 SomeText', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': 'North 52 12 30.15, East 20 12 30.15SomeText', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.208375, 20.208375)}},
  {'text': '52 6 0 20 6 9.0ABC', 'expectedOutput': {'format': CoordinateFormatKey.DMS, 'coordinate': const LatLng(52.1, 20.1025)}},

  {'text': 'N 52 12 E 20 12', 'expectedOutput': null},
  {'text': '52 12 N 20 12 E', 'expectedOutput': null},
  {'text': '52 12 20 12', 'expectedOutput': null},
  {'text': 'N 12.312 E 20.123', 'expectedOutput': null},
  {'text': '12.312 N 20.123 E', 'expectedOutput': null},
  {'text': '12.312 20.123', 'expectedOutput': null},
  {'text': '52 12.312 20 12.312', 'expectedOutput': null},
  {'text': 'N 52 12.312 E 20 12.312', 'expectedOutput': null},
  {'text': '52 12.312 N 20 12.312 E', 'expectedOutput': null},
];


void main() {

  group("Converter.dms.parseDMS:", () {
    List<Map<String, Object?>> _inputsToExpected = inputsToExpectedDMS;

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = DMSCoordinate.parse(elem['text'] as String)?.toLatLng();
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