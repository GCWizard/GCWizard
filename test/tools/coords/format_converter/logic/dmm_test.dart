import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinates.dart';
import 'package:gc_wizard/utils/coordinate_utils.dart';
import 'package:latlong2/latlong.dart';

final List<Map<String, Object?>> inputsToExpectedDMM = [
  {'text': '52° 12.312\' N 20° 12.312\' E', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '52° 12.312\' S 20° 12.312\' W', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': ' 52°12.312′N 122°12.312′W', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, -122.2052)}},
  {'text': '00° 12.312\' S 000° 12.312\' W', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-0.2052, -0.2052)}},
  {'text': '52° 12.312\' North 20° 12.312\' Ost', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '52° 12.312\' South 20° 12.312\' West', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '52° 12 .312\' North 20° 12. 312\' West', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, -20.2052)}},
  {'text': '52° 12 . 312\' South 20° 12  . 312\' West', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '52 12.312 North 20 12.312 East', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '52 12.312 Süden 20 12.312 Westen', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '52 12.312 N 20 12.312 E', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '52 6.312 S 20 6.312 W', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.1052, -20.1052)}},
  {'text': '52 06.312 S 20 06.312 W', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.1052, -20.1052)}},
  {'text': '52 06.312 S 20 06.312 W', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.1052, -20.1052)}},
  {'text': '52 12.312N 20 12.312East', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '52 12.312S 20 12.312West', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '52 12.312\'N 20°12.312\'East', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '52 12.312\'S 20°12.312\'West', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '052 12.312\'S 20°12.312\'West', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '52 12N, 20 12 East', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
  {'text': '52 12 N 20 12 E', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
  {'text': '52 06 S 20 6 W', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.1, -20.1)}},
  {'text': 'N 52°12.312’  E 004°06.312’', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 4.1052)}},

  {'text': 'N 52° 12.312\' E 20° 12.312\'', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': 'N 52°12.312\' E 20°12.312\'', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': 'N 52°12. 312\' E 20°12. 312\'', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': 'N 52° 12.312 E 20° 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': 'N 052° 12.312 E 20° 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': 'N 051° 39.688\' E 006° 27.336\'', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(51.66146666666667, 6.4556)}},
  {'text': 'N 152° 12.312 E 20° 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(27.79480000000001, -159.7948)}},
  {'text': 'Süd 52° 12.312 West20° 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': 'N 52 12.312 E 20 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '52 12.312 20 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '-52 12.312 -20 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '52 12.312, 20 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': '52 6.312, 20 06.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.1052, 20.1052)}},
  {'text': 'N52 12.312, E20 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': 'N2 12,312, E020 12,312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(2.2052, 20.2052)}},
  {'text': 'S2 12,312, W020 12,312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-2.2052, -20.2052)}},
  {'text': 'Nord 52 12.312, Ost 20 12.312', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': 'N52 12.15 E20 12.15', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2025, 20.2025)}},
  {'text': 'N52 12 E20 12', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
  {'text': 'N 52 12 E 20 12', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
  {'text': '52 12 20 12', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
  {'text': '52 6 20 06', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.1, 20.1)}},
  {'text': '-52 6 -20 06', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.1, -20.1)}},
  {'text': '-052 6 -20 06', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.1, -20.1)}},
  {'text': 'N 52° 30.123 5 12', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.50205, 5.2)}},

  {'text': '52 12.312S 20 12.312West SomeText', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '52° 12.312\' S 20° 12.312\' W SomeMoreText', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.2052, -20.2052)}},
  {'text': '52 12 N 20 12 E\nA: 1', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},

  {'text': 'N52 12.312, E20 12.312, SomeText', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2052)}},
  {'text': 'N52 12 E20 12\nA: 1, B: 2', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
  {'text': '-52 6 -20 06SomeMoreText', 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(-52.1, -20.1)}},

  {'text': 'N 12.312 E 20.123', 'expectedOutput': null},
  {'text': '12.312 20.123', 'expectedOutput': null},
  {'text': '12.312 N 20.123 E', 'expectedOutput': null},
];

void main() {
  group("Converter.dmm.parseDMM:", () {
    List<Map<String, Object?>> _inputsToExpected = inputsToExpectedDMM;

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = DMM.parse(elem['text'] as String)?.toLatLng();
        if (_actual == null) {
          expect(null, elem['expectedOutput']);
        } else {
          expect(equalsLatLng(_actual, (elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng), true);
        }
      });
    }
  });

  group("Converter.dmm.parseDMMWithLeftPadMilliminutes:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '52 12\'N 20°12\'East', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
      {'text': '52 12.3\'N 20°12.4\'East', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.205, 20.206666666666)}},
      {'text': '52 12.31\'N 20°12.45\'East', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.20516666666666, 20.2075)}},
      {'text': '52 12.312\'N 20°12.458\'East', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.20763333333333)}},
      {'text': '52 12.3127\'N 20°12.4589\'East', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.20521166666, 20.20764833333333)}},

      {'text': '52 6 20 06', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.1, 20.1)}},
      {'text': '52 6.3 20 06.4', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.105, 20.1066666666)}},
      {'text': '52 6.31 20 06.45', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.105166666666, 20.1075)}},
      {'text': '52 6.312 20 06.458', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.1052, 20.1076333333)}},
      {'text': '52 6.3127 20 06.4589', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.105211666666, 20.107648333333)}},

      {'text': 'N 52° 12\' E 20° 12\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
      {'text': 'N 52° 12.3\' E 20° 12.4\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.205, 20.206666666666)}},
      {'text': 'N 52° 12.31\' E 20° 12.45\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.20516666666666, 20.2075)}},
      {'text': 'N 52° 12.312\' E 20° 12.458\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.20763333333333)}},
      {'text': 'N 52° 12.3127\' E 20° 12.4589\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.20521166666, 20.20764833333333)}},

      {'text': 'N 52° 12\' E 20° 12.458\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.20763333333333)}},
      {'text': 'N 52° 12.312\' E 20° 12\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2)}},
      {'text': 'N 52° 12.31\' E 20° 12.4589\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.20516666666666, 20.20764833333333)}},

      {'text': 'N 52° 12.3189452\' E 20° 12.15846874\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.20531575333333, 20.202641145666668)}},
      {'text': 'N 52° 12.318945258\' E 20° 12.4584687489\'', 'leftPadMilliMinutes': false, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2053157543, 20.207641145815)}},

      {'text': '52 12\'N 20°12\'East', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
      {'text': '52 12.3\'N 20°12.4\'East', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.20005, 20.200066666666)}},
      {'text': '52 12.31\'N 20°12.45\'East', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.200516666666, 20.20075)}},
      {'text': '52 12.312\'N 20°12.458\'East', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.20763333333333)}},
      {'text': '52 12.3127\'N 20°12.4589\'East', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.25211666666666, 20.2764833333333)}},

      {'text': '52 6 20 06', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.1, 20.1)}},
      {'text': '52 6.3 20 06.4', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.10005, 20.100066666666)}},
      {'text': '52 6.31 20 06.45', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.100516666666, 20.10075)}},
      {'text': '52 6.312 20 06.458', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.1052, 20.10763333333333)}},
      {'text': '52 6.3127 20 06.4589', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.105211666666, 20.107648333333333)}},

      {'text': 'N 52° 12\' E 20° 12\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.2)}},
      {'text': 'N 52° 12.3\' E 20° 12.4\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.20005, 20.200066666666)}},
      {'text': 'N 52° 12.31\' E 20° 12.45\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.200516666666, 20.20075)}},
      {'text': 'N 52° 12.312\' E 20° 12.458\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.20763333333333)}},
      {'text': 'N 52° 12.3127\' E 20° 12.4589\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.205211666666666, 20.20764833333333)}},

      {'text': 'N 52° 12\' E 20° 12.458\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2, 20.20763333333333)}},
      {'text': 'N 52° 12.312\' E 20° 12\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2052, 20.2)}},
      {'text': 'N 52° 12.31\' E 20° 12.4589\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.200516666666665, 20.207648333333335)}},

      {'text': 'N 52° 12.3189452\' E 20° 12.15846874\'', 'leftPadMilliMinutes': true, 'expectedOutput': {'format': CoordinateFormatKey.DMM, 'coordinate': LatLng(52.2053157533, 20.2026411457)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}, leftPadMilliMinutes: ${elem['leftPadMilliMinutes']}', () {
        var _actual = DMM.parse(elem['text'] as String, leftPadMilliMinutes: elem['leftPadMilliMinutes'] as bool)?.toLatLng();
        expect((_actual!.latitude - (((elem['expectedOutput'] as Map<String, Object>)['coordinate']) as LatLng).latitude).abs() < 1e-8, true);
        expect((_actual.longitude - (((elem['expectedOutput'] as Map<String, Object>)['coordinate']) as LatLng).longitude).abs() < 1e-8, true);
      });
    }
  });
}