import 'package:exif/exif.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/images_and_files/exif_reader/logic/exif_reader.dart';

void main() {
  group("exif.getCoordDecFromText:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      // ok tests
      {
        'values': [Ratio(49, 1), Ratio(10, 1), Ratio(42417, 1250)],
        'ref': 'N',
        'isLat': true,
        'expectedOutput': 49.17609266666666,
      },
      {
        'values': [Ratio(6, 1), Ratio(6, 1), Ratio(54867, 1250)],
        'ref': 'E',
        'isLat': false,
        'expectedOutput': 6.112192666666666,
      },
      // deg == 90 and minutes == 1 ; ok we are above 90
      {
        'values': [Ratio(90, 1), Ratio(0, 1), Ratio(1, 1)],
        'ref': 'N',
        'isLat': true,
        'expectedOutput': 90.00027777777778,
      },
      // deg == 90 and minutes>60
      {
        'values': [Ratio(10, 1), Ratio(70, 1), Ratio(1, 1)],
        'ref': 'N',
        'isLat': true,
        'expectedOutput': 11.166944444444443,
      },
    ];

    _inputsToExpected.forEach((elem) {
      test('values: ${elem['values']}, ref: ${elem['ref']}, isLat : ${elem['isLat']}', () {
        var _actual = getCoordDecFromText(elem['values'], elem['ref'], elem['isLat']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}
