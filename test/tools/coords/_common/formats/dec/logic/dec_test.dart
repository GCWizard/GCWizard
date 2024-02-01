import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

final List<Map<String, Object?>> inputsToExpectedDEC = [
  {'text': '52.12312 N 20.12312 E', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312 S 20.12312 W', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '00.12312 S 000.12312 W', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-0.12312, -0.12312)}},
  {'text': '52.12312 N, 20.12312 E', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312 S, 20.12312 W', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52. 12312 N, 20 .12312 E', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52. 12312 S, 20 .12312 W', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52 . 12312 N, 20.12312 E', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52 . 12312 S, 20.12312 W', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52.12312N, 20.12312E', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312S, 20.12312W', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52.12312N 20.12312E', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312S 20.12312W', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52.12312Nord 20.12312East', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312Süd 20.12312West', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52.12312 north 20.12312 osten', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312 south 20.12312 westen', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52 n 20 o', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52, 20)}},
  {'text': '52 s 20 w', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52, -20)}},

  {'text': 'N 52.12312 E 20.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'N 52.12312° E 20.12312°', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'N 52 .12312 E 20 .  12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'N 00.12312 E 000.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(0.12312, 0.12312)}},
  {'text': '52.12312 20.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52. 12312 20. 12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'N 2.12312 E 020.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(2.12312, 20.12312)}},
  {'text': '+2.12312 -020.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(2.12312, -20.12312)}},
  {'text': '-2.12312, 020.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-2.12312, 20.12312)}},
  {'text': 'S 2.12312 E 180.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-2.12312, -179.87688)}},
  {'text': 'N52.12312° E20.12312°', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'North 52.12312 East20.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'North 52,12312, East20,12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'North 52,12312, Ost20,12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'n 02.12312 w20.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(2.12312, -20.12312)}},
  {'text': 'n 02 w20', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(2.0, -20.0)}},
  {'text': 's 02.12312,W 20.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-2.12312, -20.12312)}},
  {'text': 's 02.12312, W20.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-2.12312, -20.12312)}},
  {'text': 's 02.12312, West 20.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-2.12312, -20.12312)}},
  {'text': ' south 52.2321 E101.12312', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52.2321, 101.12312)}},
  {'text': '92 Westen 0', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(88.0, 180.0)}},
  {'text': 'Süden 92 1', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-88.0, -179.0)}},

  {'text': '52.12312 N 20.12312 E', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312Nord 20.12312East', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52 s 20 w', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-52, -20)}},

  {'text': 'N 52.12312° E 20.12312° SomeText', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '-2.12312, 020.12312SomeMoreText', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(-2.12312, 20.12312)}},
  {'text': '92 Westen 0\nA: 1', 'expectedOutput': {'format': CoordinateFormatKey.DEC, 'coordinate': LatLng(88.0, 180.0)}},
];


void main() {

  group("Converter.dec.parseDEC:", () {
    List<Map<String, Object?>> _inputsToExpected = inputsToExpectedDEC;

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = DECCoordinate.parse(elem['text'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect(equalsLatLng(_actual, (elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng), true);
        }
      });
    }
  });
}