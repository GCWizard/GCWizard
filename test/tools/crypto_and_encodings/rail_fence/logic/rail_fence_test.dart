import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/rail_fence/logic/rail_fence.dart';

void main() {
  group("RailFence.encrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': 4, 'expectedOutput' : ''},

      {'input' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'expectedOutput': 'DTEBAISEGHEOHFEIIEEMTCTSNIS'},
      {'input' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'offset': 2, 'expectedOutput': 'IEMCSSNGIESHDETIEEBTATIEHOF'},
      {'input' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'password': 'KLAR', 'expectedOutput': 'ISEGHEOHFEIIEEMTCTDTEBASNIS'},
      {'input' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'offset': 2, 'password': 'KLAR', 'expectedOutput': 'SSNGIESHDETIEEBTATIEMCIEHOF'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, offset: ${elem['offset']}, password: ${elem['password']}', () {
        String _actual;
        if (elem['offset'] == null) {
          if (elem['password'] == null) {
            _actual = encryptRailFence(elem['input'] as String, elem['key'] as int);
          } else {
            _actual = encryptRailFence(elem['input'] as String, elem['key'] as int, password: elem['password'] as String?);
          }
        } else {
          if (elem['password'] == null) {
            _actual = encryptRailFence(elem['input'] as String, elem['key'] as int, offset: elem['offset'] as int);
          } else {
            _actual = encryptRailFence(elem['input'] as String, elem['key'] as int, offset: elem['offset'] as int, password: elem['password'] as String?);
          }
        }
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("RailFence.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': 4, 'expectedOutput' : ''},

      {'expectedOutput' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'input': 'DTEBAISEGHEOHFEIIEEMTCTSNIS'},
      {'expectedOutput' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'offset': 2, 'input': 'IEMCSSNGIESHDETIEEBTATIEHOF'},
      {'expectedOutput' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'password': 'KLAR', 'input': 'ISEGHEOHFEIIEEMTCTDTEBASNIS'},
      {'expectedOutput' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'offset': 2, 'password': 'KLAR', 'input': 'SSNGIESHDETIEEBTATIEMCIEHOF'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, offset: ${elem['offset']}, password: ${elem['password']}', () {
        String _actual;
        if (elem['offset'] == null) {
          if (elem['password'] == null) {
            _actual = decryptRailFence(elem['input'] as String, elem['key'] as int);
          } else {
            _actual = decryptRailFence(elem['input'] as String, elem['key'] as int, password: elem['password'] as String?);
          }
        } else {
          if (elem['password'] == null) {
            _actual = decryptRailFence(elem['input'] as String, elem['key'] as int, offset: elem['offset'] as int);
          } else {
            _actual = decryptRailFence(elem['input'] as String, elem['key'] as int, offset: elem['offset'] as int, password: elem['password'] as String?);
          }
        }
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}