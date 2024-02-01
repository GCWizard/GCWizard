import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/atbash/logic/atbash.dart';

void main() {
  group("Atbash.atbash:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABCXYZ', 'expectedOutput' : 'ZYXCBA'},
      {'input' : 'AbcxyZ', 'expectedOutput' : 'ZYXCBA'},
      {'input' : 'ABC123XYZ', 'expectedOutput' : 'ZYX123CBA'},
      {'input' : [196,214,220,230,223].map((charCode) => String.fromCharCode(charCode)).join(), 'expectedOutput' : 'ZVLVFVZVHH'}, //ÄÖÜæß -> AEOEUEAESS
      {'input' : [225,114,118,237,122,116,369,114,337,116,252,107,246,114,102,250,114,243,103,233,112].map((charCode) => String.fromCharCode(charCode)).join(), 'expectedOutput' : 'ZIERAGFILGFVPLVIUFILTVK'}, //árvíztűrőtükörfúrógép
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = atbash(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Atbash.atbash.historic:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'BTTRGTTK', 'expectedOutput' : 'S(A|N)(A|N)GR(A|N)(A|N)L'},
      {'input' : 'SANGRAAL', 'expectedOutput' : 'BTTRGTTK'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = atbash(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}