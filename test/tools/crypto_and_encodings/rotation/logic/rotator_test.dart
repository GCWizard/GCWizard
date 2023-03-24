import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotator.dart';

void main() {
  group("Rotator.rotation:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'NOPQRSTUVWXYZABCDEFGHIJKLM'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key' : 26, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key' : 39, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'NOPQRSTUVWXYZABCDEFGHIJKLM'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key' : 0, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key' : -13, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'NOPQRSTUVWXYZABCDEFGHIJKLM'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key' : -26, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'key' : -39, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'NOPQRSTUVWXYZABCDEFGHIJKLM'},

      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'abcdefghijklmnopqrstuvwxyz', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'nopqrstuvwxyzabcdefghijklm'},

      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'abcdefghijklmnopqrstuvwxyz', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': false, 'expectedOutput' : 'abcdefghijklmnopqrstuvwxyz'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'abcdefghijklmNOPQRSTUVWXYZ', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': false, 'expectedOutput' : 'abcdefghijklmABCDEFGHIJKLM'},

      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : '123abcdefghijklm§NOPQRSTUVWXYZ&/()', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': false, 'expectedOutput' : '123abcdefghijklm§ABCDEFGHIJKLM&/()'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : '123abcdefghijklm§NOPQRSTUVWXYZ&/()', 'key' : 13, 'removeUnknownCharacters' : true, 'ignoreCase': true, 'expectedOutput' : 'nopqrstuvwxyzABCDEFGHIJKLM'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : '123abcdefghijklm§NOPQRSTUVWXYZ&/()', 'key' : 13, 'removeUnknownCharacters' : true, 'ignoreCase': false, 'expectedOutput' : 'ABCDEFGHIJKLM'},

      {'alphabet': 'BGH/&%ROla3v1', 'input' : 'Hj37&B1/ba', 'key' : 10, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : '1jO7G3AB3r'},
      {'alphabet': 'BGH/&%ROla3v1', 'input' : '1jO7G3aBbR', 'key' : 10, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'Aj&7VOr33/'},
      {'alphabet': 'BGH/&%ROla3v1', 'input' : 'Aj&7VOr33/', 'key' : -10, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : '1jO7G3aBBR'},
      {'alphabet': 'BGH/&%ROla3v1', 'input' : 'Hj37&b1/bA', 'key' : 10, 'removeUnknownCharacters' : true, 'ignoreCase': false, 'expectedOutput' : '1OGaB'},
      {'alphabet': 'BGH/&%ROla3v1', 'input' : 'Hj37&b1/bA', 'key' : 10, 'removeUnknownCharacters' : false, 'ignoreCase': false, 'expectedOutput' : '1jO7GbaBbA'},
      {'alphabet': 'BGH/&%ROla3v1', 'input' : 'Hj37&b1/bA', 'key' : 10, 'removeUnknownCharacters' : true, 'ignoreCase': true, 'expectedOutput' : '1OG3AB3R'},
      {'alphabet': 'BGH/&%ROla3v1', 'input' : '1jO7G3aBbR', 'key' : 10, 'removeUnknownCharacters' : false, 'ignoreCase': false, 'expectedOutput' : 'aj&7vOR3b/'},
      {'alphabet': 'BGH/&%ROla3v1', 'input' : 'aj&7vOR3b/', 'key' : -10, 'removeUnknownCharacters' : false, 'ignoreCase': false, 'expectedOutput' : '1jO7G3aBbR'},

      {'alphabet': null, 'input' : 'ABMNYZ', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'ABMNYZ'},
      {'alphabet': '', 'input' : 'ABMNYZ', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'ABMNYZ'},
      {'alphabet': null, 'input' : 'ABMNYZ', 'key' : 13, 'removeUnknownCharacters' : true, 'ignoreCase': true, 'expectedOutput' : ''},
      {'alphabet': '', 'input' : 'ABMNYZ', 'key' : 13, 'removeUnknownCharacters' : true, 'ignoreCase': true, 'expectedOutput' : ''},

      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : '', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': false, 'expectedOutput' : ''},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : '', 'key' : 13, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : ''},

      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABMNYZ', 'key' : null, 'removeUnknownCharacters' : false, 'ignoreCase': false, 'expectedOutput' : 'ABMNYZ'},
      {'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'input' : 'ABMNYZ', 'key' : null, 'removeUnknownCharacters' : false, 'ignoreCase': true, 'expectedOutput' : 'ABMNYZ'},
    ];

    for (var elem in _inputsToExpected) {
      test('alphabet: ${elem['alphabet']}, input: ${elem['input']}, key: ${elem['key']}, removeUnknownCharacters: ${elem['removeUnknownCharacters']}, ignoreCase: ${elem['ignoreCase']}', () {
        var _rotator = Rotator(alphabet: elem['alphabet'] as String?);

        var _actual = _rotator.rotate(elem['input'] as String, (elem['key'] ?? 0) as int, removeUnknownCharacters: elem['removeUnknownCharacters'] as bool, ignoreCase: elem['ignoreCase'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  /****************************/

  group("Rotator.rot13:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'expectedOutput' : 'NOPQRSTUVWXYZABCDEFGHIJKLM'},
      {'input' : 'abcdefghijklmnopqrstuvwxyz', 'expectedOutput' : 'nopqrstuvwxyzabcdefghijklm'},
      {'input' : 'XYZabc', 'expectedOutput' : 'KLMnop'},
      {'input' : 'nopqrstuvwxyzabcdefghijklm', 'expectedOutput' : 'abcdefghijklmnopqrstuvwxyz'},
      {'input' : 'ABC123&/%', 'expectedOutput' : 'NOP123&/%'},
    ];

    var _rotator = Rotator();

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = _rotator.rot13(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  /****************************/

  group("Rotator.rot5:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '0123456789', 'expectedOutput' : '5678901234'},
      {'input' : '789012', 'expectedOutput' : '234567'},
      {'input' : '234567', 'expectedOutput' : '789012'},
      {'input' : 'aBc123%!§', 'expectedOutput' : 'aBc678%!§'},
    ];

    var _rotator = Rotator();

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = _rotator.rot5(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  /****************************/

  group("Rotator.rot18:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 'expectedOutput' : 'NOPQRSTUVWXYZABCDEFGHIJKLM5678901234'},
      {'input' : '9876543210abcdefghijklmnopqrstuvwxyz', 'expectedOutput' : '4321098765nopqrstuvwxyzabcdefghijklm'},
      {'input' : 'ABCDEFGHIJKLMnopqrstuvwxyz', 'expectedOutput' : 'NOPQRSTUVWXYZabcdefghijklm'},
      {'input' : '789012', 'expectedOutput' : '234567'},
      {'input' : '234567', 'expectedOutput' : '789012'},
      {'input' : 'aBc123%!§', 'expectedOutput' : 'nOp678%!§'},
    ];

    var _rotator = Rotator();

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = _rotator.rot18(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  /****************************/

  group("Rotator.rot47:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '!"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~', 'expectedOutput' : 'PQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO'},
      {'input' : '9876543210abcdefghijklmnopqrstuvwxyz', 'expectedOutput' : 'hgfedcba`_23456789:;<=>?@ABCDEFGHIJK'},
      {'input' : 'ABCDEFGHIJKLMnopqrstuvwxyz', 'expectedOutput' : 'pqrstuvwxyz{|?@ABCDEFGHIJK'},
      {'input' : '789012', 'expectedOutput' : 'fgh_`a'},
      {'input' : '-', 'expectedOutput' : '\\'},
      {'input' : '\\', 'expectedOutput' : '-'},
      {'input' : '\'', 'expectedOutput' : 'V'},
      {'input' : '\\\'', 'expectedOutput' : '-V'},
      {'input' : '-V', 'expectedOutput' : '\\\''},
      {'input' : 'S', 'expectedOutput' : '\$'},
      {'input' : '\$', 'expectedOutput' : 'S'},
      {'input' : '§', 'expectedOutput' : '§'},
    ];

    var _rotator = Rotator();

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = _rotator.rot47(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
