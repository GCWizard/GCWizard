import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/one_time_pad/logic/one_time_pad.dart';

void main() {
  group("OneTimePad.encrypt:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': null, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'key': '', 'expectedOutput' : 'ABC'},

      {'input' : 'A', 'key': 'A', 'expectedOutput' : 'B'},
      {'input' : 'A', 'key': 'A', 'keyOffset': -1, 'expectedOutput' : 'A'},
      {'input' : 'A', 'key': 'A', 'keyOffset': 1, 'expectedOutput' : 'C'},
      {'input' : 'A', 'key': 'A', 'keyOffset': 26, 'expectedOutput' : 'B'},

      {'input' : 'A', 'key': 'B', 'expectedOutput' : 'C'},
      {'input' : 'A', 'key': 'B', 'keyOffset': -1, 'expectedOutput' : 'B'},
      {'input' : 'A', 'key': 'B', 'keyOffset': 1, 'expectedOutput' : 'D'},
      {'input' : 'A', 'key': 'B', 'keyOffset': 26, 'expectedOutput' : 'C'},

      {'input' : 'AbcxyZ', 'key': 'abcdef', 'expectedOutput' : 'BDFBDF'},
      {'input' : 'AbcxyZ', 'key': 'huijkl', 'expectedOutput' : 'IWLHJL'},
      {'input' : 'AbcxyZ', 'key': 'abcdefgh', 'expectedOutput' : 'BDFBDF'},
      {'input' : 'AbcxyZ', 'key': 'abc', 'expectedOutput' : 'BDFXYZ'},

      {'input' : 'AbcxyZ', 'key': 'abcdef', 'keyOffset': -1, 'expectedOutput' : 'ACEACE'},
      {'input' : 'AbcxyZ', 'key': 'huijkl', 'keyOffset': -1,  'expectedOutput' : 'HVKGIK'},
      {'input' : 'AbcxyZ', 'key': 'abcdefgh', 'keyOffset': 1,  'expectedOutput' : 'CEGCEG'},
      {'input' : 'AbcxyZ', 'key': 'abc', 'keyOffset': 10,  'expectedOutput' : 'LNPXYZ'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, key: ${elem['key']}, keyOffset: ${elem['keyOffset']}', () {
        var _actual = encryptOneTimePad(elem['input'], elem['key'], keyOffset: elem['keyOffset']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("OneTimePad.decrypt:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': null, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'key': '', 'expectedOutput' : 'ABC'},

      {'expectedOutput' : 'A', 'key': 'A', 'input' : 'B'},
      {'expectedOutput' : 'A', 'key': 'A', 'keyOffset': -1, 'input' : 'A'},
      {'expectedOutput' : 'A', 'key': 'A', 'keyOffset': 1, 'input' : 'C'},
      {'expectedOutput' : 'A', 'key': 'A', 'keyOffset': 26, 'input' : 'B'},

      {'expectedOutput' : 'A', 'key': 'B', 'input' : 'C'},
      {'expectedOutput' : 'A', 'key': 'B', 'keyOffset': -1, 'input' : 'B'},
      {'expectedOutput' : 'A', 'key': 'B', 'keyOffset': 1, 'input' : 'D'},
      {'expectedOutput' : 'A', 'key': 'B', 'keyOffset': 26, 'input' : 'C'},

      {'expectedOutput' : 'ABCXYZ', 'key': 'abcdef', 'input' : 'bdfbdf'},
      {'expectedOutput' : 'ABCXYZ', 'key': 'huijkl', 'input' : 'IWLHJL'},
      {'expectedOutput' : 'ABCXYZ', 'key': 'abcdefgh', 'input' : 'BDFBDF'},
      {'expectedOutput' : 'ABCXYZ', 'key': 'abc', 'input' : 'BDFXYZ'},

      {'expectedOutput' : 'ABCXYZ', 'key': 'abcdef', 'keyOffset': -1, 'input' : 'ACEACE'},
      {'expectedOutput' : 'ABCXYZ', 'key': 'huijkl', 'keyOffset': -1,  'input' : 'HVKGIK'},
      {'expectedOutput' : 'ABCXYZ', 'key': 'abcdefgh', 'keyOffset': 1,  'input' : 'CegceG'},
      {'expectedOutput' : 'ABCXYZ', 'key': 'abc', 'keyOffset': 10,  'input' : 'LNPXYZ'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, key: ${elem['key']}, keyOffset: ${elem['keyOffset']}', () {
        var _actual = decryptOneTimePad(elem['input'], elem['key'], keyOffset: elem['keyOffset']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}