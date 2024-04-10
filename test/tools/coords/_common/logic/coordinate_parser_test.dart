import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/formats/dec/logic/dec.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:latlong2/latlong.dart';

import '../formats/dec/logic/dec_test.dart';
import '../formats/dmm/logic/dmm_test.dart';
import '../formats/dms/logic/dms_test.dart';

void main() {

  group("Coordinates.parseCoordinates:", () {
    List<Map<String, Object?>> _inputsToExpected = inputsToExpectedDEC;
    _inputsToExpected.addAll(inputsToExpectedDMM);
    _inputsToExpected.addAll(inputsToExpectedDMS);

    _inputsToExpected
      .where((elem) => elem['expectedOutput'] != null)  // the NULL tests are only for the specific DEC/DEG/DMS tests
      .forEach((elem) {
        test('text: ${elem['text']}', () {
          var _actual = parseCoordinates(elem['text'] as String);
          expect(_actual.first.format.type, (elem['expectedOutput'] as Map<String, Object>)['format']);
          expect((_actual.first.toLatLng()!.latitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
          expect((_actual.first.toLatLng()!.longitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
          expect(_actual.where((coords) => standardCoordinateFormatDefinitions.map((e) => e.type).contains(coords.format.type)).length, 1);
        });
      });
  });


  group("Coordinates.parseStandardFormats", ()  {

    List<Map<String, Object?>> _inputsToExpected = [

      {'input': "N 50° 59.403' E 011° 02.693", 'expectedOutput': DMMCoordinate},
      {'input': "500162 191310 948307", 'expectedOutput': null},
      {'input': "52.12312 N 20.12312 E", 'expectedOutput': DECCoordinate},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = parseStandardFormats(elem['input'] as String);

        expect(_actual?.runtimeType, elem['expectedOutput']);
      });
    }
  });
  
}