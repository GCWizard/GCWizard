import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/logic/beghilos.dart';

void main() {
  
  group("Beghilos.encodeBeghilos:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '7718', 'expectedOutput' : 'BILL'},
      {'input' : '7353', 'expectedOutput' : 'ESEL'},
      {'input' : '351073', 'expectedOutput' : 'ELOISE'},
      {'input' : '. 2507146938', 'expectedOutput' : 'BEGghILOSZ .'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBeghilos(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Beghilos.decodeBeghilos:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'BILL', 'expectedOutput' : '7718'},
      {'input' : 'ESEL', 'expectedOutput' : '7353'},
      {'input' : 'ELOISE', 'expectedOutput' : '351073'},

      {'input' : 'BEGghILOSZ .', 'expectedOutput' : '. 2507146938'},
      {'input' : 'beHilosz', 'expectedOutput' : '25071438'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBeghilos(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}