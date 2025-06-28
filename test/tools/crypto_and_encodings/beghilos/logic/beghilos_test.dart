import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/beghilos/logic/beghilos.dart';

void main() {
  
  group("Beghilos.encodeBeghilos:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '7718', 'expectedOutput' : 'BILL', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '7353', 'expectedOutput' : 'ESEL', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '351073', 'expectedOutput' : 'ELOISE', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '. 2507146938', 'expectedOutput' : 'BEGghILOSZ .', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '9', 'expectedOutput' : 'G', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '6', 'expectedOutput' : 'g', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'g', 'expectedOutput' : '', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'G', 'expectedOutput' : '', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '96', 'expectedOutput' : 'gG', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '96Gg', 'expectedOutput' : 'gG', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '9', 'expectedOutput' : '6', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : '6', 'expectedOutput' : '9', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : 'g', 'expectedOutput' : '', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : 'G', 'expectedOutput' : '', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : '96', 'expectedOutput' : '96', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : '96Gg', 'expectedOutput' : '96', 'type': BeghilosType.NINE_TO_SIX},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, ${elem['type'] as BeghilosType}', () {
        var _actual = encodeBeghilos(elem['input'] as String, elem['type'] as BeghilosType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Beghilos.decodeBeghilos:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'BILL', 'expectedOutput' : '7718', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'ESEL', 'expectedOutput' : '7353', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'ELOISE', 'expectedOutput' : '351073', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'BEGghILOSZ .', 'expectedOutput' : '. 2507146938', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'beHilosz', 'expectedOutput' : '25071438', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'G', 'expectedOutput' : '9', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'g', 'expectedOutput' : '6', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '6', 'expectedOutput' : '', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '9', 'expectedOutput' : '', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'gG', 'expectedOutput' : '96', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : 'gG96', 'expectedOutput' : '96', 'type': BeghilosType.LOWER_G_TO_SIX},
      {'input' : '6', 'expectedOutput' : '9', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : '9', 'expectedOutput' : '6', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : 'g', 'expectedOutput' : '6', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : 'G', 'expectedOutput' : '9', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : '96', 'expectedOutput' : '96', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : 'gG', 'expectedOutput' : '96', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : '96Gg', 'expectedOutput' : '6996', 'type': BeghilosType.NINE_TO_SIX},
      {'input' : '6996', 'expectedOutput' : '9669', 'type': BeghilosType.NINE_TO_SIX},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, ${elem['type'] as BeghilosType}', () {
        var _actual = decodeBeghilos(elem['input'] as String, elem['type'] as BeghilosType);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}