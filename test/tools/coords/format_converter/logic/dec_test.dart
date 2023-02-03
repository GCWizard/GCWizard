import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/format_converter/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:latlong2/latlong.dart';

final List<Map<String, dynamic>> inputsToExpectedDEC = [
  {'text': '52.12312 N 20.12312 E', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312 S 20.12312 W', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '00.12312 S 000.12312 W', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-0.12312, -0.12312)}},
  {'text': '52.12312 N, 20.12312 E', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312 S, 20.12312 W', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52. 12312 N, 20 .12312 E', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52. 12312 S, 20 .12312 W', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52 . 12312 N, 20.12312 E', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52 . 12312 S, 20.12312 W', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52.12312N, 20.12312E', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312S, 20.12312W', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52.12312N 20.12312E', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312S 20.12312W', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52.12312Nord 20.12312East', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312Süd 20.12312West', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52.12312 north 20.12312 osten', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312 south 20.12312 westen', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.12312, -20.12312)}},
  {'text': '52 n 20 o', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52, 20)}},
  {'text': '52 s 20 w', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52, -20)}},

  {'text': 'N 52.12312 E 20.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'N 52.12312° E 20.12312°', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'N 52 .12312 E 20 .  12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'N 00.12312 E 000.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(0.12312, 0.12312)}},
  {'text': '52.12312 20.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52. 12312 20. 12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'N 2.12312 E 020.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(2.12312, 20.12312)}},
  {'text': '+2.12312 -020.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(2.12312, -20.12312)}},
  {'text': '-2.12312, 020.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-2.12312, 20.12312)}},
  {'text': 'S 2.12312 E 180.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-2.12312, -179.87688)}},
  {'text': 'N52.12312° E20.12312°', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'North 52.12312 East20.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'North 52,12312, East20,12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'North 52,12312, Ost20,12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': 'n 02.12312 w20.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(2.12312, -20.12312)}},
  {'text': 'n 02 w20', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(2.0, -20.0)}},
  {'text': 's 02.12312,W 20.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-2.12312, -20.12312)}},
  {'text': 's 02.12312, W20.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-2.12312, -20.12312)}},
  {'text': 's 02.12312, West 20.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-2.12312, -20.12312)}},
  {'text': ' south 52.2321 E101.12312', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52.2321, 101.12312)}},
  {'text': '92 Westen 0', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(88.0, 180.0)}},
  {'text': 'Süden 92 1', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-88.0, -179.0)}},

  {'text': '52.12312 N 20.12312 E', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52.12312Nord 20.12312East', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '52 s 20 w', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-52, -20)}},

  {'text': 'N 52.12312° E 20.12312° SomeText', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(52.12312, 20.12312)}},
  {'text': '-2.12312, 020.12312SomeMoreText', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(-2.12312, 20.12312)}},
  {'text': '92 Westen 0\nA: 1', 'expectedOutput': {'format': keyCoordsDEC, 'coordinate': LatLng(88.0, 180.0)}},
];


void main() {

  group("Converter.dec.parseDEC:", () {
    List<Map<String, dynamic>> _inputsToExpected = inputsToExpectedDEC;

    _inputsToExpected.forEach((elem) {
      test('text: ${elem['text']}', () {
        var _actual = DEC.parse(elem['text'])?.toLatLng();
        expect(_actual, elem['expectedOutput']['coordinate']);
      });
    });
  });

  group("Coordinate.normalizeDEC:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'coord' : DEC(10.0, 10.0), 'expectedOutput' : DEC(10.0, 10.0)},
      {'coord' : DEC(-10.0, -10.0), 'expectedOutput' : DEC(-10.0, -10.0)},

      {'coord' : DEC(90.0, 0.0), 'expectedOutput' : DEC(90.0, 0.0)},
      {'coord' : DEC(-90.0, 0.0), 'expectedOutput' : DEC(-90.0, 0.0)},
      {'coord' : DEC(0.0, 180.0), 'expectedOutput' : DEC(0.0, 180.0)},
      {'coord' : DEC(0.0, -180.0), 'expectedOutput' : DEC(0.0, -180.0)},

      {'coord' : DEC(91.0, 0.0), 'expectedOutput' : DEC(89.0, 180.0)},
      {'coord' : DEC(-91.0, 0.0), 'expectedOutput' : DEC(-89.0, 180.0)},
      {'coord' : DEC(91.0, 180.0), 'expectedOutput' : DEC(89.0, 0.0)},
      {'coord' : DEC(-91.0, 180.0), 'expectedOutput' : DEC(-89.0, 0.0)},
      {'coord' : DEC(91.0, -180.0), 'expectedOutput' : DEC(89.0, 0.0)},
      {'coord' : DEC(-91.0, -180.0), 'expectedOutput' : DEC(-89.0, 0.0)},

      {'coord' : DEC(0.0, 181.0), 'expectedOutput' : DEC(0.0, -179.0)},
      {'coord' : DEC(0.0, -181.0), 'expectedOutput' : DEC(0.0, 179.0)},

      {'coord' : DEC(180.0, 0.0), 'expectedOutput' : DEC(0.0, 180.0)},
      {'coord' : DEC(-180.0, 0.0), 'expectedOutput' : DEC(0.0, 180.0)},
      {'coord' : DEC(540.0, 0.0), 'expectedOutput' : DEC(0.0, 180.0)},
      {'coord' : DEC(-540.0, 0.0), 'expectedOutput' : DEC(0.0, 180.0)},

      {'coord' : DEC(0.0, 360.0), 'expectedOutput' : DEC(0.0, 0.0)},
      {'coord' : DEC(0.0, -360.0), 'expectedOutput' : DEC(0.0, 0.0)},
      {'coord' : DEC(0.0, 540.0), 'expectedOutput' : DEC(0.0, 180.0)},
      {'coord' : DEC(0.0, -540.0), 'expectedOutput' : DEC(0.0, -180.0)},
      {'coord' : DEC(0.0, 541.0), 'expectedOutput' : DEC(0.0, -179.0)},
      {'coord' : DEC(0.0, -541.0), 'expectedOutput' : DEC(0.0, 179.0)},

      {'coord' : DEC(200.0, 10.0), 'expectedOutput' : DEC(-20.0, -170.0)},
      {'coord' : DEC(300.0, 10.0), 'expectedOutput' : DEC(-60.0, 10.0)},
      {'coord' : DEC(660.0, 10.0), 'expectedOutput' : DEC(-60.0, 10.0)},

      {'coord' : DEC(200.0, 190.0), 'expectedOutput' : DEC(-20.0, 10.0)},
      {'coord' : DEC(300.0, 190.0), 'expectedOutput' : DEC(-60.0, -170.0)},
    ];

    _inputsToExpected.forEach((elem) {
      test('coord: ${elem['coord']}', () {
        var _actual = normalizeDEC(elem['coord']);
        expect((_actual.latitude - elem['expectedOutput'].latitude).abs() < 1e-10, true);
        expect((_actual.longitude - elem['expectedOutput'].longitude).abs() < 1e-10, true);
      });
    });
  });
}