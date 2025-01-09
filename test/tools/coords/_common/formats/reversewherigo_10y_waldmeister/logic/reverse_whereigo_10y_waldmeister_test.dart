import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/reversewherigo_10y_waldmeister/logic/reverse_wherigo_10y_waldmeister.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group("Converter.reverseWherigo10YWaldmeister.fromLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coordinate': const LatLng(0.0, 0.0), 'text': ['123556', '784012', '344678']},
      {'coordinate': const LatLng(52.78956, 14.03168), 'text': ['720598', '545963', '823979']},
      {'coordinate': const LatLng(50.83091, 10.74893), 'text': ['128537', '874302', '720371']},
      {'coordinate': const LatLng(53.23521, 14.013), 'text': ['628587', '886336', '460608']},
      {'coordinate': const LatLng(52.35191, 9.76738), 'text': ['228527', '717501', '976396']},

    ];

    for (var elem in _inputsToExpected) {
      test('coordinate: ${elem['coordinate']}', () {
        var _actual = ReverseWherigo10YWaldmeisterCoordinate.fromLatLon(elem['coordinate'] as LatLng);
        expect(_actual.a, int.parse((elem['text'] as List<String>)[0]));
        expect(_actual.b, int.parse((elem['text'] as List<String>)[1]));
        expect(_actual.c, int.parse((elem['text'] as List<String>)[2]));
      });
    }
  });

  group("Converter.reverseWherigo10YWaldmeister.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'coordinate': const LatLng(0.0, 0.0), 'text': ['123556', '784012', '344678']},
      {'coordinate': const LatLng(52.78956, 14.03168), 'text': ['720598', '545963', '823979']},
      {'coordinate': const LatLng(50.83091, 10.74893), 'text': ['128537', '874302', '720371']},
      {'coordinate': const LatLng(53.23521, 14.013), 'text': ['628587', '886336', '460608']},
      {'coordinate': const LatLng(52.35191, 9.76738), 'text': ['228527', '717501', '976396']},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = ReverseWherigo10YWaldmeisterCoordinate.parse((elem['text'] as List<String>).join(' '))?.toLatLng();
        expect((_actual!.latitude - (elem['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
        expect((_actual.longitude - (elem['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
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