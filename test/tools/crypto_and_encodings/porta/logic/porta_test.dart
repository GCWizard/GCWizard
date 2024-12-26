import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/porta/logic/porta.dart';

void main() {
  group("Porta: togglePorta:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'key': '', 'version': PortaTableVersion.ORIGINAL, 'classic': false, 'expectedOutput': ''},
      {
        'input': 'The quick brown fox jumps.',
        'key': 'foxbrown',
        'version': PortaTableVersion.ORIGINAL,
        'classic': true,
        'expectedOutput': 'INRDNTTGIASLEREB'
      },
      {
        'input': 'INRDNTTGIASLEREB',
        'key': 'foxbrown',
        'version': PortaTableVersion.ORIGINAL,
        'classic': true,
        'expectedOutput': 'THEQICBRONFOXMPS'
      },
      {
        'input': 'Defend the eastwall of the castle',
        'key': 'kingarthur',
        'version': PortaTableVersion.REVERSE,
        'classic': false,
        'expectedOutput': 'VVYUAYKXOZSBAGNTULPLZVVQFLUU'
      },
      {
        'input': 'VVYUAYKXOZSBAGNTULPLZVVQFLUU',
        'key': 'kingarthur',
        'version': PortaTableVersion.REVERSE,
        'classic': false,
        'expectedOutput': 'DEFENDTHEEASTWALLOFTHECASTLE'
      },
      {
        'input': 'chiffredeporta',
        'key': 'acier',
        'version': PortaTableVersion.ORIGINAL,
        'classic': false,
        'expectedOutput': 'PTRQXEQZPKBFKY'
      },
      {
        'input': 'ABCDEFG',
        'key': 'ABCDEFG',
        'version': PortaTableVersion.ORIGINAL,
        'classic': false,
        'expectedOutput': 'NOOPPQQ'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = togglePorta(
            elem['input'] as String, elem['key'] as String,
            version: elem['version'] as PortaTableVersion, classic: elem['classic'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}