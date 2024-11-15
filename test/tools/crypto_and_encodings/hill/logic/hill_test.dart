import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/hill/logic/hill.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
//https://cs.widener.edu/~yanako/html/courses/Spring23/csci391/quizHillCipher.html
//https://u-next.com/blogs/cyber-security/overview-hill-cipher-encryption-and-decryption-with-examples/
//https://massey.limfinity.com/207/hillcipher.pdf
//https://legacy.cryptool.org/en/cto/hill
void main() {
  group("Hill.encrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key' : '', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('KeyEmpty', '')},
      {'input' : 'ACT', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'POH')},
      {'input' : 'GFG', 'key' : 'HILLMAGIC', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'SWK')},

      {'input' : 'short example', 'key' : 'hill', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'APADJTFTWLFJ')},
      {'input' : 'retreat now', 'key' : 'BACK UP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'DPQRQEVKPQ')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} key: ${elem['key']} matrixSize: ${elem['matrixSize']}', () {
        var _actual = encryptText(elem['input'] as String, elem['key'] as String, elem['matrixSize'] as int, (elem['alphabet'] as Alphabet).alphabet);
        expect(_actual.text, (elem['expectedOutput'] as StringText).text);
        expect(_actual.value, (elem['expectedOutput'] as StringText).value);
      });
    }
  });

  group("Hill.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'SYICHOLER', 'key' : 'alphabet', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'WEARESAFE')},
      {'input' : '', 'key' : '', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('KeyEmpty', '')},

      {'input' : 'POH', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'ACT')},


      {'input' : 'POH', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'ACT')},
      {'input' : 'SWK', 'key' : 'HILLMAGIC', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'GFG')},

      {'input' : 'APADJTFTWLFJ', 'key' : 'hill', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'SHORT EXAMPLE')},
      {'input' : 'DPQRQEVKPQ', 'key' : 'BACK UP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'RETREAT NOW')},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} key: ${elem['key']} matrixSize: ${elem['matrixSize']}', () {
        var _actual = decryptText(elem['input'] as String, elem['key'] as String, elem['matrixSize'] as int, (elem['alphabet'] as Alphabet).alphabet);
        expect(_actual.text, (elem['expectedOutput'] as StringText).text);
        expect(_actual.value, (elem['expectedOutput'] as StringText).value);
      });
    }
  });
}