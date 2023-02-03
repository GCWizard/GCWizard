import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/logic/beghilos.dart';

void main() {
  
  group("Beghilos.encodeBeghilos:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '7718', 'expectedOutput' : 'BILL'},
      {'input' : '7353', 'expectedOutput' : 'ESEL'},
      {'input' : '351073', 'expectedOutput' : 'ELOISE'},
      {'input' : '. 2507146938', 'expectedOutput' : 'BEGghILOSZ .'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBeghilos(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Beghilos.decodeBeghilos:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : 'BILL', 'expectedOutput' : '7718'},
      {'input' : 'ESEL', 'expectedOutput' : '7353'},
      {'input' : 'ELOISE', 'expectedOutput' : '351073'},

      {'input' : 'BEGghILOSZ .', 'expectedOutput' : '. 2507146938'},
      {'input' : 'beHilosz', 'expectedOutput' : '25071438'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBeghilos(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

}