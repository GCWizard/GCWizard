import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:latlong2/latlong.dart';

import '../formats/dec/logic/dec_test.dart';
import '../formats/dmm/logic/dmm_test.dart';
import '../formats/dms/logic/dms_test.dart';

void main() {

  group("Parser.latlon.parseLatLon:", () {
    List<Map<String, Object?>> _inputsToExpected = inputsToExpectedDEC;
    _inputsToExpected.addAll(inputsToExpectedDMM);
    _inputsToExpected.addAll(inputsToExpectedDMS);

    _inputsToExpected
      .where((elem) => elem['expectedOutput'] != null)  // the NULL tests are only for the specific DEC/DEG/DMS tests
      .forEach((elem) {
        test('text: ${elem['text']}', () {
          var _actual = parseCoordinates(elem['text'] as String);
          expect(_actual.elementAt(0).format.type, (elem['expectedOutput'] as Map<String, Object>)['format']);
          expect((_actual.elementAt(0).toLatLng()!.latitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).latitude).abs() < 1e-8, true);
          expect((_actual.elementAt(0).toLatLng()!.longitude - ((elem['expectedOutput'] as Map<String, Object>)['coordinate'] as LatLng).longitude).abs() < 1e-8, true);
        });
      });
  });
  
}