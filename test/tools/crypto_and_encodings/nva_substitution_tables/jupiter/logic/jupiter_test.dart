import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/jupiter/logic/jupiter.dart';

void main() {
  group("Jupiter.encryptJupiter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'aeinrs', 'expectedOutput' : '01234 59090'},
      {'input' : 'nord 453', 'expectedOutput' : '38147 38944 45553 33899 09090'},
      {'input' : 'nachricht negativ', 'expectedOutput' : '65966 61390'},

      // https://scz.bplaced.net/m.html#kurras
      {'input' : 'BITTE VORSICHT BEI ORIGINAL Material. KEINE ORIGINALE SCHICKEN. NUR INHALT.', 'expectedOutput' : '71286 86195 81452 72768 67112 81427 52307 96541 90781 23181 42752 30791 57276 27278 13903 87423 76079 86909 09090'},

      ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = encryptJupiter(elem['input'] as String, elem['keyOneTimePad'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Jupiter.decryptJupiter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'AEINRS..', 'input' : '01234 59090'},
      {'expectedOutput' : 'NORD453...', 'input' : '38147 38944 45553 33899 09090'},
      {'expectedOutput' : 'NACHRICHTNEGATIV.', 'input' : '65966 61390'},

      // https://scz.bplaced.net/m.html#kurras
      {'input' : '71286 86195 81452 72768 67112 81427 52307 96541 90781 23181 42752 30791 57276 27278 13903 87423 76079 86909 09090', 'expectedOutput' : 'BITTEVORSICHTBEIORIGINALMATERIAL.KEINEORIGINALESCHICKEN.NURINHALT....'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, keyOneTimePad: ${elem['keyOneTimePad']}', () {
        var _actual = decryptJupiter(elem['input'] as String, elem['keyOneTimePad'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}