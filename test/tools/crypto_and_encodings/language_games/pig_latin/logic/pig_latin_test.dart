import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/pig_latin/logic/pig_latin.dart';

void main() {
  group("PigLatin.encrypt:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'I have a secret now!', 'expectedOutput' : 'I-ay ave-hay a-ay ecret-say ow-nay!'},
      {'input' : 'loser', 'expectedOutput' : 'oser-lay'},
      {'input' : 'button', 'expectedOutput' : 'utton-bay'},
      {'input' : 'star', 'expectedOutput' : 'ar-stay'},
      {'input' : 'three', 'expectedOutput' : 'ee-thray'},
      {'input' : 'question', 'expectedOutput' : 'estion-quay'},
      {'input' : 'Question', 'expectedOutput' : 'Estion-quay'},
      {'input' : 'happy', 'expectedOutput' : 'appy-hay'},
      {'input' : 'Pig Latin', 'expectedOutput' : 'Ig-pay Atin-lay'},

      {'input' : 'eagle','expectedOutput' : 'eagle-ay'},
      {'input' : 'America', 'expectedOutput' : 'America-ay'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encryptPigLatin(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("PigLatin.decrypt:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'I have a secret now!', 'input' : 'I-ay ave-hay a-ay ecret-say ow-nay!'},
      {'expectedOutput' : 'loser', 'input' : 'oser-lay'},
      {'expectedOutput' : 'button', 'input' : 'utton-bay'},
      {'expectedOutput' : 'star', 'input' : 'ar-stay'},
      {'expectedOutput' : 'three', 'input' : 'ee-thray'},
      {'expectedOutput' : 'question', 'input' : 'estion-quay'},
      {'expectedOutput' : 'Question', 'input' : 'Estion-quay'},
      {'expectedOutput' : 'happy', 'input' : 'appy-hay'},
      {'expectedOutput' : 'Pig Latin', 'input' : 'Ig-pay Atin-lay'},

      {'expectedOutput' : 'eagle','input' : 'eagle-ay'},
      {'expectedOutput' : 'America', 'input' : 'America-ay'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decryptPigLatin(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}