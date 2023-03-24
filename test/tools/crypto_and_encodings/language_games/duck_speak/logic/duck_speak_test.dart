import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/language_games/duck_speak/logic/duck_speak.dart';

void main() {
  group("DuckSpeak.encodeDuckSpeak:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'Hallo Welt', 'expectedOutput' : 'Nak? Nak. Naknak Nanak Naknak naknak Naknak naknak Naknak naknaknak Nananak Nak nak? Naknaknak Naknak nak? Naknak naknak Naknaknak Nak?'},
      {'input' : 'N53°', 'expectedOutput' : 'Nak? nak. Nanananak nak? Nanananak Nanananak nanak Nak'},
      {'input' : 'äöü', 'expectedOutput' : 'nak. Nak? naknaknak Naknak naknaknak naknak'},
      {'input' : '123', 'expectedOutput' : 'Nanananak Nanak Nanananak Nananak Nanananak Nanananak'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeDuckSpeak(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("DuckSpeak.decodeDuckSpeak:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : '23', 'input' : 'NanananakNanak Nanananak Nanananak Nananak Nanananak Nanananak'},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'Hallo Welt', 'input' : 'Nak? Nak. Naknak Nanak Naknak naknak Naknak naknak Naknak naknaknak Nananak Nak nak? Naknaknak Naknak nak? Naknak naknak Naknaknak Nak?'},
      {'expectedOutput' : 'N53°', 'input' : 'Nak? nak. Nanananak nak? Nanananak Nanananak nanak Nak'},
      {'expectedOutput' : 'äöü', 'input' : 'nak. Nak? naknaknak Naknak naknaknak naknak'},
      {'expectedOutput' : '123', 'input' : 'Nanananak Nanak Nanananak Nananak Nanananak Nanananak'},
      {'expectedOutput' : '23', 'input' : 'NanananakNanak Nanananak Nanananak Nananak Nanananak Nanananak'},
      {'expectedOutput' : '23', 'input' : 'Nak Nanaknaknaknak Nanananak Nananak Nanananak Nanananak'},
      {'expectedOutput' : '', 'input' : 'keinnaklaut'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeDuckSpeak(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
