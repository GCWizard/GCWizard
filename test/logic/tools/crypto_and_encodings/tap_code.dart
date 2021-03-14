import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/logic/tools/crypto_and_encodings/tap_code.dart';
import 'package:gc_wizard/utils/constants.dart';

void main() {
  group("TapCode.encryptTapCode:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABCIJK', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : '11 12 13 24 24 25'},
      {'input' : 'ABCIJK', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : '11 12 13 24 25 13'},

      {'input' : 'ABC123%&ijk', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : '11 12 13 24 25 13'},
     ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = encryptTapCode(elem['input'], mode: elem['mode']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("TapCode.decryptTapCode:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'ABCIK', 'mode': AlphabetModificationMode.J_TO_I, 'input' : '11 12 13 24 25'},
      {'expectedOutput' : 'ABKIJ', 'mode': AlphabetModificationMode.C_TO_K, 'input' : '11 12 13 24 25'},

      {'input' : '111 213', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'ABK'},
      {'input' : '111', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'A'},
      {'input' : '45 67', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'U'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = decryptTapCode(elem['input'], mode: elem['mode']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}