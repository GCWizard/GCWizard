import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/rail_fence/logic/rail_fence.dart';

void main() {
  group("RailFence.encrypt:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'expectedOutput': 'DTEBAISEGHEOHFEIIEEMTCTSNIS'},
      {'input' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'offset': 2, 'expectedOutput': 'IEMCSSNGIESHDETIEEBTATIEHOF'},
      {'input' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'password': 'KLAR', 'expectedOutput': 'ISEGHEOHFEIIEEMTCTDTEBASNIS'},
      {'input' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'offset': 2, 'password': 'KLAR', 'expectedOutput': 'SSNGIESHDETIEEBTATIEMCIEHOF'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, key: ${elem['key']}, offset: ${elem['offset']}, password: ${elem['password']}', () {
        var _actual;
        if (elem['offset'] == null) {
          if (elem['password'] == null)
            _actual = encryptRailFence(elem['input'], elem['key']);
          else
            _actual = encryptRailFence(elem['input'], elem['key'], password: elem['password']);
        } else {
          if (elem['password'] == null)
            _actual = encryptRailFence(elem['input'], elem['key'], offset: elem['offset']);
          else
            _actual = encryptRailFence(elem['input'], elem['key'], offset: elem['offset'], password: elem['password']);
        }
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("RailFence.decrypt:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'input': 'DTEBAISEGHEOHFEIIEEMTCTSNIS'},
      {'expectedOutput' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'offset': 2, 'input': 'IEMCSSNGIESHDETIEEBTATIEHOF'},
      {'expectedOutput' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'password': 'KLAR', 'input': 'ISEGHEOHFEIIEEMTCTDTEBASNIS'},
      {'expectedOutput' : 'DIESISTEINEGEHEIMEBOTSCHAFT', 'key': 4, 'offset': 2, 'password': 'KLAR', 'input': 'SSNGIESHDETIEEBTATIEMCIEHOF'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, key: ${elem['key']}, offset: ${elem['offset']}, password: ${elem['password']}', () {
        var _actual;
        if (elem['offset'] == null) {
          if (elem['password'] == null)
            _actual = decryptRailFence(elem['input'], elem['key']);
          else
            _actual = decryptRailFence(elem['input'], elem['key'], password: elem['password']);
        } else {
          if (elem['password'] == null)
            _actual = decryptRailFence(elem['input'], elem['key'], offset: elem['offset']);
          else
            _actual = decryptRailFence(elem['input'], elem['key'], offset: elem['offset'], password: elem['password']);
        }
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}