import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/judoon/logic/judoon.dart';
import 'package:gc_wizard/utils/constants.dart';

void main() {
  group("Judoon.encryptJudoon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'quick! brown fox ("jumps").', 'expectedOutput' : 'qwo tro kro co kno sco sho bo ro plo wo no sho fo plo xo sho pra cho jo tro mo po so cho pla bla'},
      {'input' : '1234567890', 'expectedOutput' : 'ha ta tra fa fla sa schla ga na za'},
      {'input' : 'QUICK BROWN FOX äöüß', 'key': 8, 'expectedOutput' : 'qwo tro kro co kno sho bo ro plo wo no sho fo plo xo sho $UNKNOWN_ELEMENT $UNKNOWN_ELEMENT $UNKNOWN_ELEMENT $UNKNOWN_ELEMENT'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encryptJudoon(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Judoon.decryptJudoon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : '', 'input' : ''},

      {'expectedOutput' : 'quick! brown fox ("jumps").\\$UNKNOWN_ELEMENT', 'input' : 'qwo tro kro co kno sco sho bo ro plo wo no sho fo plo xo sho pra cho jo tro mo po so cho pla bla gra klo'},
      {'expectedOutput' : '1234567890', 'input' : 'ha ta tra fa fla sa schla ga na za'},
      {'expectedOutput' : 'quick brown fox ', 'input' : 'qwo tro kro co kno sho bo ro plo wo no sho fo plo xo sho'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decryptJudoon(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}