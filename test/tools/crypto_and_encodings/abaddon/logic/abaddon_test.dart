import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/abaddon/logic/abaddon.dart';

const _A = YEN + YEN + MY;
const _N = YEN + YEN + THORN;
const _Z = THORN + YEN + THORN;
const _SPACE = YEN + MY + MY;

void main() {
  group("AbaddonCode.encryptAbaddon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': null, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': <String, String>{}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {YEN: YEN}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {YEN: YEN, MY: MY, THORN: THORN}, 'expectedOutput' : ''},
  
      {'input' : 'A', 'expectedOutput' : _A},
      {'input' : 'N', 'expectedOutput' : _N},
      {'input' : 'Z', 'expectedOutput' : _Z},
  
      {'input' : 'ANZ', 'expectedOutput' : _A + _N + _Z},
      {'input' : 'A N Z', 'expectedOutput' : _A + _SPACE + _N + _SPACE + _Z},
      {'input' : ' A N Z ', 'expectedOutput' : _SPACE + _A + _SPACE + _N + _SPACE + _Z + _SPACE},
      
      {'input' : 'anz', 'expectedOutput' : _A + _N + _Z},
      {'input' : '1A  n §%/ z ', 'expectedOutput' : _A + _SPACE * 2 + _N + _SPACE * 2 + _Z + _SPACE},
      {'input' : YEN + MY + THORN, 'expectedOutput' : ''},
  
      {'input' : 'ANZ', 'replaceCharacters': {YEN: '0', MY: '1', THORN: '2'}, 'expectedOutput' : '001002202'},
      {'input' : 'ANZ', 'replaceCharacters': {YEN: 'a', MY: 'b', THORN: 'c'}, 'expectedOutput' : 'aabaaccac'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, replaceCharacter: ${elem['replaceCharacters']}', () {
        var _actual = encryptAbaddon(elem['input'] as String, elem['replaceCharacters'] as Map<String, String>?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("AbaddonCode.decryptAbaddon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': null, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': <String, String>{}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {YEN: '/'}, 'expectedOutput' : ''},
      {'input' : '', 'replaceCharacters': {YEN: YEN, MY: MY, THORN: THORN}, 'expectedOutput' : ''},

      {'input' : _A, 'replaceCharacters': {YEN: YEN, MY: MY, THORN: THORN}, 'expectedOutput' : 'A'},
      {'input' : _N, 'replaceCharacters': {YEN: YEN, MY: MY, THORN: THORN}, 'expectedOutput' : 'N'},
      {'input' : _Z, 'replaceCharacters': {YEN: YEN, MY: MY, THORN: THORN}, 'expectedOutput' : 'Z'},

      {'input' : ' $YEN $YEN $MY ', 'expectedOutput' : 'A'},
      {'input' : '123${YEN}412${YEN}6${MY}737', 'expectedOutput' : 'A'},

      {'input' : _A + _N + _Z, 'expectedOutput' : 'ANZ'},
      {'input' : _A + _SPACE + _N + _SPACE + _Z, 'expectedOutput' : 'A N Z'},
      {'input' : _SPACE + _A + _SPACE + _N + _SPACE + _Z + _SPACE, 'expectedOutput' : ' A N Z '},

      {'input' : YEN, 'expectedOutput' : ''},
      {'input' : MY, 'expectedOutput' : ''},
      {'input' : THORN, 'expectedOutput' : ''},
      {'input' : YEN + YEN, 'expectedOutput' : ''},

      {'input' : _A + _N + _Z, 'replaceCharacters': {YEN: '0', MY: '1', THORN: '2'}, 'expectedOutput' : 'ANZ'},

      {'input' : '001002202', 'replaceCharacters': {YEN: '0', MY: '1', THORN: '2'}, 'expectedOutput' : 'ANZ'},

      {'input' : '--\\--..-.', 'replaceCharacters': {YEN: '-', MY: '\\', THORN: '.'}, 'expectedOutput' : 'ANZ'},
      {'input' : ']][]]||]|', 'replaceCharacters': {YEN: ']', MY: '[', THORN: '|'}, 'expectedOutput' : 'ANZ'},

      {'input' : '001002202', 'replaceCharacters': {YEN: '', MY: '', THORN: ''}, 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, replaceCharacter: ${elem['replaceCharacters']}', () {
        var _actual = decryptAbaddon(elem['input'] as String, elem['replaceCharacters'] as Map<String, String>?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}