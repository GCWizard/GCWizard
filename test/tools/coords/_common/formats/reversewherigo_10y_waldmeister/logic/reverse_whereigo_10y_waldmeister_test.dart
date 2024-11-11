import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_10y_waldmeister/logic/reverse_wherigo_10y_waldmeister.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.reverseWherigo10YWaldmeister.latlonTo10YWaldmeister:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coord': const LatLng(0.0, 0.0), 'expectedOutput': ['123556', '784012', '344678']},
      {'coord': const LatLng(52.78956, 14.03168), 'expectedOutput': ['720598', '545963', '823979']},
      {'coord': const LatLng(50.83091, 10.74893), 'expectedOutput': ['128537', '874302', '720371']},
      {'coord': const LatLng(53.23521, 14.013), 'expectedOutput': ['628587', '886336', '460608']},
      {'coord': const LatLng(52.35191, 9.76738), 'expectedOutput': ['228527', '717501', '976396']},

    ];

    for (var elem in _inputsToExpected) {
      test('coord: ${elem['coord']}', () {
        var _actual = ReverseWherigo10YWaldmeisterCoordinate.fromLatLon(elem['coord'] as LatLng);
        expect(_actual.a, int.parse((elem['expectedOutput'] as List<String>)[0]));
        expect(_actual.b, int.parse((elem['expectedOutput'] as List<String>)[1]));
        expect(_actual.c, int.parse((elem['expectedOutput'] as List<String>)[2]));
      });
    }
  });

  group("Converter.reverseWherigo10YWaldmeister.10YwaldmeisterToLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput': const LatLng(0.0, 0.0), 'input': ['123556', '784012', '344678']},
      {'expectedOutput': const LatLng(52.78956, 14.03168), 'input': ['720598', '545963', '823979']},
      {'expectedOutput': const LatLng(50.83091, 10.74893), 'input': ['128537', '874302', '720371']},
      {'expectedOutput': const LatLng(53.23521, 14.013), 'input': ['628587', '886336', '460608']},
      {'expectedOutput': const LatLng(52.35191, 9.76738), 'input': ['228527', '717501', '976396']},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = ReverseWherigo10YWaldmeisterCoordinate.parse((elem['input'] as List<String>).join(' '))?.toLatLng();
        expect((_actual!.latitude - (elem['expectedOutput'] as LatLng).latitude).abs() < 1e-8, true);
        expect((_actual.longitude - (elem['expectedOutput'] as LatLng).longitude).abs() < 1e-8, true);
      });
    }
  });

  group("Converter.reverseWherigo10YWaldmeister.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': null},
      {'text': '720598 545963 823979', 'expectedOutput': {'format': CoordinateFormatKey.REVERSE_WIG_10Y_WALDMEISTER, 'coordinate': const LatLng(52.78956, 14.03168)}},
      {'text': '720598\n545963\n823979', 'expectedOutput': {'format': CoordinateFormatKey.REVERSE_WIG_10Y_WALDMEISTER, 'coordinate': const LatLng(52.78956, 14.03168)}},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigo10YWaldmeisterCoordinate.parse(elem['text'] as String)?.toLatLng();
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