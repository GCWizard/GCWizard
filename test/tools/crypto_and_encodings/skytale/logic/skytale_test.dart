import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/skytale/logic/skytale.dart';

void main() {
  group("Skytale.encryptSkytale:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'countRows' : 1, 'countLettersPerCell': 1, 'expectedOutput' : ''},
      {'input' : 'ABC', 'countRows' : 0, 'countLettersPerCell': 1, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'countRows' : 1, 'countLettersPerCell': 0, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'countRows' : 1, 'countLettersPerCell': 1, 'expectedOutput' : 'ABC'},

      {'input' : 'ABC', 'countRows' : 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'countRows' : 3, 'countColumns': 2, 'countLettersPerCell': 1, 'expectedOutput' : 'ACB'},
      {'input' : 'ABCDE', 'countRows' : 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ACEBD'},
      {'input' : 'ABCDEFG', 'countRows' : 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ADGBECF'},
      {'input' : 'ABCD', 'countRows' : 3, 'countLettersPerCell': 5, 'expectedOutput' : 'ABCD'},
      {'input' : 'ABCD', 'countRows' : 3, 'countLettersPerCell': 4, 'expectedOutput' : 'ABCD'},
      {'input' : 'ABCD', 'countRows' : 3, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCD'},

      {'input' : 'ABC', 'countColumns' : 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'countColumns' : 3, 'countRows': 2, 'countLettersPerCell': 1, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'countColumns' : 1, 'countRows': 2, 'countLettersPerCell': 1, 'expectedOutput' : 'AB'},
      {'input' : 'ABCDE', 'countColumns' : 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ADBEC'},
      {'input' : 'ABCDEFG', 'countColumns' : 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ADGBECF'},
      {'input' : 'ABCD', 'countColumns' : 3, 'countLettersPerCell': 5, 'expectedOutput' : 'ABCD'},
      {'input' : 'ABCD', 'countColumns' : 3, 'countLettersPerCell': 4, 'expectedOutput' : 'ABCD'},
      {'input' : 'ABCD', 'countColumns' : 3, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCD'},

      {'input' : 'ABCDEFG', 'countRows' : 3, 'countColumns': 2, 'countLettersPerCell': 1, 'expectedOutput' : 'ACEBDF'},
      {'input' : 'ABCDEFG', 'countRows' : 3, 'countColumns': 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ADGBECF'},
      {'input' : 'ABCDEFG', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 1, 'expectedOutput' : 'AEBFCGD'},

      {'input' : 'ABCDEFG', 'countRows' : 2, 'countColumns': 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ADBECF'},
      {'input' : 'ABCDEFG', 'countRows' : 3, 'countColumns': 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ADGBECF'},
      {'input' : 'ABCDEFG', 'countRows' : 4, 'countColumns': 3, 'countLettersPerCell': 1, 'expectedOutput' : 'ADGBECF'},

      {'input' : 'ABCDEFGHIJKLMNO', 'countRows' : 3, 'countLettersPerCell': 2, 'expectedOutput' : 'ABGHMNCDIJOEFKL'},
      {'input' : 'ABCDEFGHIJKLMNO', 'countRows' : 3, 'countColumns': 2, 'countLettersPerCell': 2, 'expectedOutput' : 'ABEFIJCDGHKL'},
      {'input' : 'ABCDEFGHIJKLMNO', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 2, 'expectedOutput' : 'ABIJCDKLEFMNGHO'},

      {'input' : 'ABCDEFGHIJKLMNO', 'countRows' : 1, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCDEFGHIJKLMNO'},

      {'input' : 'ABCDEFGHIJKLMNO', 'countRows' : 5, 'countLettersPerCell': 1, 'expectedOutput' : 'ADGJMBEHKNCFILO'},
      {'input' : 'ABCDEFGHIJKLMN', 'countRows' : 5, 'countLettersPerCell': 1, 'expectedOutput' : 'ADGJMBEHKNCFIL'},
      {'input' : 'ABCDEFGHIJKLM', 'countRows' : 5, 'countLettersPerCell': 1, 'expectedOutput' : 'ADGJMBEHKCFIL'},
      {'input' : 'ABCDEFGHIJKLMNOP', 'countRows' : 5, 'countLettersPerCell': 1, 'expectedOutput' : 'AEIMBFJNCGKODHLP'},

      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVW', 'countRows' : 3, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCJKLSTUDEFMNOVWGHIPQR'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWX', 'countRows' : 3, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCJKLSTUDEFMNOVWXGHIPQR'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXY', 'countRows' : 3, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCJKLSTUDEFMNOVWXGHIPQRY'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZa', 'countRows' : 3, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCJKLSTUDEFMNOVWXGHIPQRYZa'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZab', 'countRows' : 3, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCMNOYZaDEFPQRbGHISTUJKLVWX'},

      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVW', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCMNODEFPQRGHISTUJKLVW'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWX', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCMNODEFPQRGHISTUJKLVWX'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXY', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCMNOYDEFPQRGHISTUJKLVWX'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZa', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCMNOYZaDEFPQRGHISTUJKLVWX'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZab', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'expectedOutput' : 'ABCMNOYZaDEFPQRbGHISTUJKLVWX'},

      {'input' : 'ABC', 'countRows' : 0, 'countColumns': 2, 'countLettersPerCell': 1, 'expectedOutput' : 'ACB'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, countRows: ${elem['countRows']}, countColumns: ${elem['countColumns']}, countLettersPerCell: ${elem['countLettersPerCell']}', () {
        var _actual = encryptSkytale(elem['input'] as String, countRows: elem['countRows'] as int?, countColumns: elem['countColumns'] as int?, countLettersPerCell: elem['countLettersPerCell'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Skytale.decryptSkytale:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'countRows' : 1, 'countLettersPerCell': 1, 'expectedOutput' : ''},
      {'input' : 'ABC', 'countRows' : 0, 'countLettersPerCell': 1, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'countRows' : 1, 'countLettersPerCell': 0, 'expectedOutput' : 'ABC'},
      {'input' : 'ABC', 'countRows' : 1, 'countLettersPerCell': 1, 'expectedOutput' : 'ABC'},

      {'expectedOutput' : 'ABC', 'countRows' : 3, 'countLettersPerCell': 1, 'input' : 'ABC'},
      {'expectedOutput' : 'ABC', 'countRows' : 3, 'countColumns': 2, 'countLettersPerCell': 1, 'input' : 'ACB'},
      {'expectedOutput' : 'ABCDE', 'countRows' : 3, 'countLettersPerCell': 1, 'input' : 'ACEBD'},
      {'expectedOutput' : 'ABCDEFG', 'countRows' : 3, 'countLettersPerCell': 1, 'input' : 'ADGBECF'},
      {'expectedOutput' : 'ABCD', 'countRows' : 3, 'countLettersPerCell': 5, 'input' : 'ABCD'},
      {'expectedOutput' : 'ABCD', 'countRows' : 3, 'countLettersPerCell': 4, 'input' : 'ABCD'},
      {'expectedOutput' : 'ABCD', 'countRows' : 3, 'countLettersPerCell': 3, 'input' : 'ABCD'},

      {'expectedOutput' : 'ABC', 'countColumns' : 3, 'countLettersPerCell': 1, 'input' : 'ABC'},
      {'expectedOutput' : 'ABC', 'countColumns' : 3, 'countRows': 2, 'countLettersPerCell': 1, 'input' : 'ABC'},
      {'expectedOutput' : 'ABCDE', 'countColumns' : 3, 'countLettersPerCell': 1, 'input' : 'ADBEC'},
      {'expectedOutput' : 'ABCDEFG', 'countColumns' : 3, 'countLettersPerCell': 1, 'input' : 'ADGBECF'},
      {'expectedOutput' : 'ABCD', 'countColumns' : 3, 'countLettersPerCell': 5, 'input' : 'ABCD'},
      {'expectedOutput' : 'ABCD', 'countColumns' : 3, 'countLettersPerCell': 4, 'input' : 'ABCD'},
      {'expectedOutput' : 'ABCD', 'countColumns' : 3, 'countLettersPerCell': 3, 'input' : 'ABCD'},

      {'expectedOutput' : 'ABCDEF', 'countRows' : 3, 'countColumns': 2, 'countLettersPerCell': 1, 'input' : 'ACEBDF'},
      {'expectedOutput' : 'ABCDEFG', 'countRows' : 3, 'countColumns': 3, 'countLettersPerCell': 1, 'input' : 'ADGBECF'},
      {'expectedOutput' : 'ABCDEFG', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 1, 'input' : 'AEBFCGD'},

      {'expectedOutput' : 'ABCDEF', 'countRows' : 2, 'countColumns': 3, 'countLettersPerCell': 1, 'input' : 'ADBECF'},
      {'expectedOutput' : 'ABCDEFG', 'countRows' : 3, 'countColumns': 3, 'countLettersPerCell': 1, 'input' : 'ADGBECF'},
      {'expectedOutput' : 'ABCDEFG', 'countRows' : 4, 'countColumns': 3, 'countLettersPerCell': 1, 'input' : 'ADGBECF'},

      {'expectedOutput' : 'ABCDEFGHIJKLMNO', 'countRows' : 3, 'countLettersPerCell': 2, 'input' : 'ABGHMNCDIJOEFKL'},
      {'expectedOutput' : 'ABCDEFGHIJKL', 'countRows' : 3, 'countColumns': 2, 'countLettersPerCell': 2, 'input' : 'ABEFIJCDGHKL'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNO', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 2, 'input' : 'ABIJCDKLEFMNGHO'},

      {'expectedOutput' : 'ABCDEFGHIJKLMNO', 'countRows' : 1, 'countLettersPerCell': 3, 'input' : 'ABCDEFGHIJKLMNO'},

      {'expectedOutput' : 'ABCDEFGHIJKLMNO', 'countRows' : 5, 'countLettersPerCell': 1, 'input' : 'ADGJMBEHKNCFILO'},
      {'expectedOutput' : 'ABCDEFGHIJKLMN', 'countRows' : 5, 'countLettersPerCell': 1, 'input' : 'ADGJMBEHKNCFIL'},
      {'expectedOutput' : 'ABCDEFGHIJKLM', 'countRows' : 5, 'countLettersPerCell': 1, 'input' : 'ADGJMBEHKCFIL'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOP', 'countRows' : 5, 'countLettersPerCell': 1, 'input' : 'AEIMBFJNCGKODHLP'},

      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVW', 'countRows' : 3, 'countLettersPerCell': 3, 'input' : 'ABCJKLSTUDEFMNOVWGHIPQR'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWX', 'countRows' : 3, 'countLettersPerCell': 3, 'input' : 'ABCJKLSTUDEFMNOVWXGHIPQR'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXY', 'countRows' : 3, 'countLettersPerCell': 3, 'input' : 'ABCJKLSTUDEFMNOVWXGHIPQRY'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZa', 'countRows' : 3, 'countLettersPerCell': 3, 'input' : 'ABCJKLSTUDEFMNOVWXGHIPQRYZa'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZab', 'countRows' : 3, 'countLettersPerCell': 3, 'input' : 'ABCMNOYZaDEFPQRbGHISTUJKLVWX'},

      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVW', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'input' : 'ABCMNODEFPQRGHISTUJKLVW'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWX', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'input' : 'ABCMNODEFPQRGHISTUJKLVWX'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXY', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'input' : 'ABCMNOYDEFPQRGHISTUJKLVWX'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZa', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'input' : 'ABCMNOYZaDEFPQRGHISTUJKLVWX'},
      {'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZab', 'countRows' : 3, 'countColumns': 4, 'countLettersPerCell': 3, 'input' : 'ABCMNOYZaDEFPQRbGHISTUJKLVWX'},

      {'expectedOutput' : 'ABC', 'countRows' : 0, 'countColumns': 2, 'countLettersPerCell': 1, 'input' : 'ACB'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, countRows: ${elem['countRows']}, countColumns: ${elem['countColumns']}, countLettersPerCell: ${elem['countLettersPerCell']}', () {
        var _actual = decryptSkytale(elem['input'] as String, countRows: elem['countRows'] as int?, countColumns: elem['countColumns'] as int?, countLettersPerCell: elem['countLettersPerCell'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}