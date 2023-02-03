import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/trifid/logic/trifid.dart';

void main() {



  group("Trifid.encryptTrifid:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      // empty Input
      {'input' : null, 'blockSize' : 2, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : ''},
      {'input' : '',   'blockSize' : 2, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : ''},

      //empty alphabet
      {'input' : 'Hallo', 'blockSize' : 2, 'mode': PolybiosMode.CUSTOM, 'alphabet': '', 'expectedOutput' : 'trifid_error_alphabet'},

      {'input' : 'Hallo', 'blockSize' : 4, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : 'BPBIO'},
      {'input' : 'Hello', 'blockSize' : 4, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : 'BQBRO'},
      {'input' : 'ALLEMEINEENTCHEN', 'blockSize' : 13, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : 'EDDFAEQNAZFNOBWN'},

      // https://kryptografie.de/kryptografie/chiffre/trifid.htm#:~:text=Trifid%20Chiffre%20%20%20Kategorisierung%3A%20%20%20Klassisch,Trifid%20Chiffre%20wurden%20von%20Felix%20Dela%20...%20
      {'input' : 'Beispielklartext', 'blockSize' : 4, 'mode': PolybiosMode.CUSTOM, 'alphabet': 'APFELSTRUDBCGHIJKMNOQVWXYZ+', 'expectedOutput' : 'BPHUEPHODRRBFRJT'},

      // https://en.wikipedia.org/wiki/Trifid_cipher#:~:text=The%20trifid%20cipher%20is%20a%20classical%20cipher,invented%20by%20F%C3%A9lix%20Delastelle%20and%20described%20in%201902.
      {'input' : 'aidetoilecieltaidera', 'blockSize' : 5, 'mode': PolybiosMode.CUSTOM, 'alphabet': 'FELIXMARDSTBCGHJKNOPQUVWYZ+', 'expectedOutput' : 'FMJFVOISSUFTFPUFEQQC'},

    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, blockSize: ${elem['blockSize']}, mode: ${elem['mode']}, alphabet: ${elem['alphabet']}', () {
        TrifidOutput _actual = encryptTrifid(elem['input'], elem['blockSize'], mode: elem['mode'], alphabet: elem['alphabet']);
        expect(_actual == null ? null : _actual.output, elem['expectedOutput']);
      });
    });
  });

  group("Trifid.decryptTrifid:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      // empty Input
      {'input' : null, 'blockSize' : 2, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : ''},
      {'input' : '',   'blockSize' : 2, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : ''},

      //empty alphabet
      {'input' : 'Hallo', 'blockSize' : 2, 'mode': PolybiosMode.CUSTOM, 'alphabet': '', 'expectedOutput' : 'trifid_error_alphabet'},

      {'expectedOutput' : 'HALLO', 'blockSize' : 4, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'input' : 'BPBIO'},
      {'expectedOutput' : 'HELLO', 'blockSize' : 4, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'input' : 'BQBRO'},
      {'expectedOutput' : 'ALLEMEINEENTCHEN', 'blockSize' : 13, 'mode': PolybiosMode.AZ09, 'alphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'input' : 'EDDFAEQNAZFNOBWN'},

      // https://kryptografie.de/kryptografie/chiffre/trifid.htm#:~:text=Trifid%20Chiffre%20%20%20Kategorisierung%3A%20%20%20Klassisch,Trifid%20Chiffre%20wurden%20von%20Felix%20Dela%20...%20
      {'expectedOutput' : 'BEISPIELKLARTEXT', 'blockSize' : 4, 'mode': PolybiosMode.CUSTOM, 'alphabet': 'APFELSTRUDBCGHIJKMNOQVWXYZ+', 'input' : 'BPHUEPHODRRBFRJT'},

      // https://en.wikipedia.org/wiki/Trifid_cipher#:~:text=The%20trifid%20cipher%20is%20a%20classical%20cipher,invented%20by%20F%C3%A9lix%20Delastelle%20and%20described%20in%201902.
      {'expectedOutput' : 'AIDETOILECIELTAIDERA', 'blockSize' : 5, 'mode': PolybiosMode.CUSTOM, 'alphabet': 'FELIXMARDSTBCGHJKNOPQUVWYZ+', 'input' : 'FMJFVOISSUFTFPUFEQQC'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, blockSize: ${elem['blockSize']}, mode: ${elem['mode']}, alphabet: ${elem['alphabet']}', () {
        TrifidOutput _actual = decryptTrifid(elem['input'], elem['blockSize'], mode: elem['mode'], alphabet: elem['alphabet']);
        expect(_actual == null ? null : _actual.output, elem['expectedOutput']);
      });
    });
  });
}