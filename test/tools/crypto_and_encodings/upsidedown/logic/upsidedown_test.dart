import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/upsidedown/logic/upsidedown.dart';

void main() {
  group("upsidedown.encrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '0123456789', 'expectedOutput' : '68L9ဌ߈Ɛζ⇂0'},
      {'input' : 'abcdefghijklmnopqrstuvwxyz', 'expectedOutput' : 'zʎxʍʌnʇsɹbdouɯlʞſ̣!ɥᵷɟǝpɔqɐ'},
      {'input' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'expectedOutput' : 'Z⅄XMɅՈꞱSꓤꝹԀONꟽ⅂ꓘꓩIH⅁ℲEꓷƆꓭⱯ'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
          var _actual = encodeUpsideDownText(elem['input'] as String);
          expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("upsidedown.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : 'Z⅄XMɅՈꞱSꓤꝹԀONꟽ⅂ꓘꓩIH⅁ℲEꓷƆꓭⱯ', 'expectedOutput' : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'},
      {'input' : 'zʎxʍʌnʇsɹbdouɯlʞſ̣!ɥᵷɟǝpɔqɐ', 'expectedOutput' : 'abcdefghijklmnopqrstuvwxyz'},
      {'input' : '68L9ဌ߈Ɛζ⇂0', 'expectedOutput' : '0123456789'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
      var _actual = decodeUpsideDownText(elem['input'] as String);
      expect(_actual, elem['expectedOutput']);
      });
    }
  });
}