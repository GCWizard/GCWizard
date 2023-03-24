import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/tap_code/logic/tap_code.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';

void main() {
  group("TapCode.encryptTapCode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABCIJK', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : '11 12 13 24 24 25'},
      {'input' : 'ABCIJK', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : '11 12 13 24 25 13'},

      {'input' : 'ABC123%&ijk', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : '11 12 13 24 25 13'},
     ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        if (elem['mode'] == null) {
          var _actual = encryptTapCode(elem['input'] as String);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = encryptTapCode(elem['input'] as String, mode: elem['mode'] as AlphabetModificationMode);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });

  group("TapCode.decryptTapCode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'ABCIK', 'mode': AlphabetModificationMode.J_TO_I, 'input' : '11 12 13 24 25'},
      {'expectedOutput' : 'ABKIJ', 'mode': AlphabetModificationMode.C_TO_K, 'input' : '11 12 13 24 25'},

      {'input' : '111 213', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'ABK'},
      {'input' : '111', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'A'},
      {'input' : '45 67', 'mode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : 'U'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        if (elem['mode'] == null) {
          var _actual = decryptTapCode(elem['input'] as String);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = decryptTapCode(elem['input'] as String, mode: elem['mode'] as AlphabetModificationMode);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });
}