import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/playfair/logic/playfair.dart';

void main() {
  group("Playfair.encodePlayfair:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : ''},
      {'input' : 'A', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CV'},

      {'input' : 'AX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CV'},
      {'input' : 'AA', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CV CV'},
      {'input' : 'AXA', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CV CV'},
      {'input' : 'X', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'VS'},
      {'input' : 'XQ', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'VS'},
      {'input' : 'XX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'VS VS'},
      {'input' : 'Q', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'SV'},
      {'input' : 'QX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'SV'},
      {'input' : 'QQ', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'SV SV'},

      {'input' : 'BAA', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CB CV'},
      {'input' : 'BAAA', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CB CV CV'},
      {'input' : 'BAAAD', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CB CV BE'},
      {'input' : 'AAA', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CV CV CV'},
      {'input' : 'AAAB', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'CV CV BC'},

      {'input' : 'Hide the gold in the tree stump', 'key': 'playfair example', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'BM OD ZB XD NA BE KU DM UI XM MO UV IF'},
      {'input' : 'Laboulaye lady will lead to Cibola temples of gold', 'key': 'DEATH', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : 'ME IK QO TX CQ TE ZX CO MW QC TE HN FB IK ME HA KR QC UN GI KM AV'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, mode: ${elem['mode']}', () {
        var _actual = encryptPlayfair(elem['input'] as String, elem['key'] as String, mode: elem['mode'] as AlphabetModificationMode);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Playfair.decodePlayfair:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : ''},
      {'expectedOutput' : 'AX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'CV'},

      {'expectedOutput' : 'AX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'CV'},
      {'expectedOutput' : 'AXAX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'CV CV'},
      {'expectedOutput' : 'XQ', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'VS'},
      {'expectedOutput' : 'XQXQ', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'VS VS'},
      {'expectedOutput' : 'QX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'SV'},
      {'expectedOutput' : 'QXQX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'SV SV'},

      {'expectedOutput' : 'BAAX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'CB CV'},
      {'expectedOutput' : 'BAAXAX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'CB CV CV'},
      {'expectedOutput' : 'BAAXAD', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'CB CV BE'},
      {'expectedOutput' : 'AXAXAX', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'CV CV CV'},
      {'expectedOutput' : 'AXAXAB', 'key': '', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'CV CV BC'},

      {'expectedOutput' : 'HIDETHEGOLDINTHETREXESTUMP', 'key': 'playfair example', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'BM OD ZB XD NA BE KU DM UI XM MO UV IF'},
      {'expectedOutput' : 'LABOULAYELADYWILLXLEADTOCIBOLATEMPLESOFGOLDX', 'key': 'DEATH', 'mode': AlphabetModificationMode.J_TO_I, 'input' : 'MEIKQOTXCQTEZXCOMWQCTEHNFBIKMEHAKRQCUNGIKMAV'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, mode: ${elem['mode']}', () {
        var _actual = decryptPlayfair(elem['input'] as String, elem['key'] as String, mode: elem['mode'] as AlphabetModificationMode);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}