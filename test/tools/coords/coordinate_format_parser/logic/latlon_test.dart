import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/coords/coordinate_format_parser/logic/latlon.dart';

import '../../format_converter/logic/dec_test.dart';
import '../../format_converter/logic/dmm_test.dart';
import '../../format_converter/logic/dms_test.dart';

void main() {

  group("Parser.latlon.parseLatLon:", () {
    List<Map<String, dynamic>> _inputsToExpected = inputsToExpectedDEC;
    _inputsToExpected.addAll(inputsToExpectedDMM);
    _inputsToExpected.addAll(inputsToExpectedDMS);

    _inputsToExpected
      .where((elem) => elem['expectedOutput'] != null)  // the NULL tests are only for the specific DEC/DEG/DMS tests
      .forEach((elem) {
        test('text: ${elem['text']}', () {
          var _actual = parseCoordinates(elem['text']);
          expect(_actual.elementAt(0).key, elem['expectedOutput']['format']);
          expect((_actual.elementAt(0).toLatLng().latitude - elem['expectedOutput']['coordinate'].latitude).abs() < 1e-8, true);
          expect((_actual.elementAt(0).toLatLng().longitude - elem['expectedOutput']['coordinate'].longitude).abs() < 1e-8, true);
        });
      });
  });
  
}