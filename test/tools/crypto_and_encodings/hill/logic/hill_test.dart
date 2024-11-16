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
      {'input' : 'ACTX', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('InvalidFillCharacter', ''), 'fillChar' : 'xx'},

      {'input' : '', 'key' : 'hill', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', '')},
      {'input' : '!', 'key' : 'hill', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', '!')},
      {'input' : 'short example', 'key' : 'hill', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'APADJ TFTWLFJ')},

      {'input' : 'ACT', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'POH')},
      {'input' : 'ACT', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'POH'), 'fillChar' : ''},
      {'input' : 'GFG', 'key' : 'HILLMAGIC', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('InvalidKey', 'SWK')},
      {'input' : 'retreat now', 'key' : 'BACK UP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'DPQRQEV KPQLR')},

      {'input' : 'retreat now', 'key' : 'BACK UP', 'matrixSize' : 4, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('InvalidKey', 'RBZTQPT HEJPF')},
      {'input' : 'retreat now', 'key' : 'BACK UPB', 'matrixSize' : 4, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('InvalidKey', 'RDUOQVJ XEJLB')},
      {'input' : 'TREFFE KONTAKTPERSON UM DREI UHR IM STADTPARK', 'key' : 'UCBVQLZUOSHMZWXE', 'matrixSize' : 4, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'DPKZWE QFOTUDRZODPXD TJ CZTS FXL DY GSCCDRHNCU')},
      {'input' : 'TREFFE KONTAKTPERSON UM DREI UHR IM STADTPARK', 'key' : 'UCBVQLZUOSHMZWXE', 'matrixSize' : 4, 'alphabet' : alphabetAZ09, 'expectedOutput' : StringText('', 'THMZQG U5EF61PJM33PH VX K3RY 9FF ZK 8SQQHXX7EM')},

      {'input' : 'retreat now!', 'key' : 'BACK UP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'DPQRQEV KPQ!LR')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} key: ${elem['key']} matrixSize: ${elem['matrixSize']}', () {
        StringText _actual;
        if (elem['fillChar'] == null) {
          _actual = encryptText(elem['input'] as String, elem['key'] as String, elem['matrixSize'] as int, (elem['alphabet'] as Alphabet).alphabet);
        } else {
          _actual = encryptText(elem['input'] as String, elem['key'] as String, elem['matrixSize'] as int, (elem['alphabet'] as Alphabet).alphabet, elem['fillChar'] as String);
        }
        expect(_actual.text, (elem['expectedOutput'] as StringText).text);
        expect(_actual.value, (elem['expectedOutput'] as StringText).value);
      });
    }
  });

  group("Hill.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key' : '', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('KeyEmpty', '')},
      {'input' : 'SWK', 'key' : 'HILLMAGIC', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('InvalidKey', '')},
      {'input' : 'POHX', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('InvalidFillCharacter', ''), 'fillChar' : 'xx'},

      {'input' : '', 'key' : 'hill', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', '')},
      {'input' : '!', 'key' : 'hill', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', '!')},
      {'input' : 'APADJ TFTWLFJ', 'key' : 'hill', 'matrixSize' : 2, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'SHORT EXAMPLE')},

      {'input' : 'POH', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'ACT')},
      {'input' : 'POH', 'key' : 'GYBNQKURP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'ACT'), 'fillChar' : ''},
      {'input' : 'SYICHOLER', 'key' : 'alphabet', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'WEARESAFE')},
      {'input' : 'DPQRQEV KPQLR', 'key' : 'BACK UP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'RETREAT NOWXX')},

      {'input' : 'DPKZWE QFOTUDRZODPXD TJ CZTS FXL DY GSCCDRHNCU', 'key' : 'UCBVQLZUOSHMZWXE', 'matrixSize' : 4, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'TREFFE KONTAKTPERSON UM DREI UHR IM STADTPARKX')},
      {'input' : 'THMZQG U5EF61PJM33PH VX K3RY 9FF ZK 8SQQHXX7EM', 'key' : 'UCBVQLZUOSHMZWXE', 'matrixSize' : 4, 'alphabet' : alphabetAZ09, 'expectedOutput' : StringText('', 'TREFFE KONTAKTPERSON UM DREI UHR IM STADTPARKX')},

      {'input' : 'DPQRQEV KPQ!LR', 'key' : 'BACK UP', 'matrixSize' : 3, 'alphabet' : alphabetAZ0, 'expectedOutput' : StringText('', 'RETREAT NOW!XX')},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} key: ${elem['key']} matrixSize: ${elem['matrixSize']}', () {
        StringText _actual;
        if (elem['fillChar'] == null) {
          _actual = decryptText(elem['input'] as String, elem['key'] as String, elem['matrixSize'] as int, (elem['alphabet'] as Alphabet).alphabet);
        } else {
          _actual = decryptText(elem['input'] as String, elem['key'] as String, elem['matrixSize'] as int, (elem['alphabet'] as Alphabet).alphabet, elem['fillChar'] as String);
        }

        expect(_actual.text, (elem['expectedOutput'] as StringText).text);
        expect(_actual.value, (elem['expectedOutput'] as StringText).value);
      });
    }
  });
}