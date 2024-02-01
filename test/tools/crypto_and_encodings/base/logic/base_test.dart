import 'dart:io' as io;
import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/images_and_files/hexstring2file/logic/hexstring2file.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:path/path.dart' as path;

void main() {

  group("Base16.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '3429289555', 'expectedOutput' : '33343239323839353535'},
      {'input' : 'hallo', 'expectedOutput' : '68616c6c6f'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase16(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base16.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : '', 'input' : ''},
      {'expectedOutput' : '3429289555', 'input' : '33343239323839353535'},
      {'expectedOutput' : 'hallo', 'input' : '68616c6c6f'},
      {'expectedOutput' : '', 'input' : 'h'},
      {'expectedOutput' : '', 'input' : 'ha'},
      {'expectedOutput' : '', 'input' : 'kl'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase16(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base58.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '3429289555', 'expectedOutput' : '6e31iZ'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase58(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base58.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '6e31iZ', 'expectedOutput' : '3429289555'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase58(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base85.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'cache bei 12.345 09.768', 'expectedOutput' : '<~@prk\\AKYGnBco,c/i,=A+>>f.2`<V~>'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase85(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base64.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'cache bei 12.345 09.768', 'expectedOutput' : 'Y2FjaGUgYmVpIDEyLjM0NSAwOS43Njg='},
      {'input' : 'cache liegt über dem Sims', 'expectedOutput' : 'Y2FjaGUgbGllZ3Qg/GJlciBkZW0gU2ltcw=='},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase64(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base64.decode:", () {

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'Y2FjaGUgYmVpIDEyLjM0NSAwOS43Njg=', 'expectedOutput' : 'cache bei 12.345 09.768'},
      {'input' : "'*<%>y<p; %F'4(Ay<p;Y *4& n?y8& z<' r<!8% '4o8y?rAx4y>(?nGvB! t8z4p;' *8%7rA >nA![ F\":nE 8vA E\"Gab <&G @Ö:y<p;[ &Bq8y8Y u<rE A(A 7v8 >\"B%7vAnGrAY q<r w4 9ÜE 7nF 9vAq8! rEsB%7rEy<p; FvAqg A\"Eq -Jr<(Asü!9-<t tEn7 ^`[e_^ (Aq \"F' r?s tEn7 ][eaa[", 'expectedOutput' : ''},
      {'input' : 'Y2FjaGUgbGllZ3Qg/GJlciBkZW0gU2ltcw==', 'expectedOutput' : 'cache liegt über dem Sims'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase64(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base64.graphic.decode:", () {

    var testDirPath = 'test/tools/crypto_and_encodings/base/resources/';

    Uint8List _getFileData(String name) {
      io.File file = io.File(path.join(testDirPath, name));
      return file.readAsBytesSync();
    }

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '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',
        'expectedOutput' : 'img_base64.png'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = hexstring2file(asciiToHexString(decodeBase64(elem['input'] as String)));
        expect(_actual, _getFileData(elem['expectedOutput'] as String));
      });
    }
  });

  group("Base85.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '<~@prk\\AKYGnBco,c/i,=A+>>f.2`<V~>', 'expectedOutput' : 'cache bei 12.345 09.768'},
      {'input' : "'*<%>y<p; %F'4(Ay<p;Y *4& n?y8& z<' r<!8% '4o8y?rAx4y>(?nGvB! t8z4p;' *8%7rA >nA![ F\":nE 8vA E\"Gab <&G @Ö:y<p;[ &Bq8y8Y u<rE A(A 7v8 >\"B%7vAnGrAY q<r w4 9ÜE 7nF 9vAq8! rEsB%7rEy<p; FvAqg A\"Eq -Jr<(Asü!9-<t tEn7 ^`[e_^ (Aq \"F' r?s tEn7 ][eaa[", 'expectedOutput' : UNKNOWN_ELEMENT},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase85(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base91.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'This is an encoded string', 'expectedOutput' : 'nX,<:WRT%yV%!5:maref3+1RrUb64^M'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase91(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base91.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'nX,<:WRT%yV%!5:maref3+1RrUb64^M', 'expectedOutput' : 'This is an encoded string'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase91(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base122.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'GC Wizard', 'expectedOutput' : '#Pd;%ta9ހ'},
      {'input' : 'cache bei nord 123 ost 567', 'expectedOutput' : '1X,6C\x14@b2Z\$\x06s=dd\x10\fң\x19\x01^s:\b\x06S1ߜ'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBase122(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Base122.decode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '#Pd;%ta9ހ', 'expectedOutput' : 'GC Wizard'},
      {'input' : '1X,6C\x14@b2Z\$\x06s=dd\x10\fң\x19\x01^s:\b\x06S1ߜ', 'expectedOutput' : 'cache bei nord 123 ost 567'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBase122(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}