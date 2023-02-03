import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/amsco/logic/amsco.dart';

void main() {
  group("Amsco.encodeAmsco:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input': null, 'key': '', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': ''},
      {'input': '', 'key': '', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': ''},
      {'input': null, 'key': null, 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': ''},
      {'input': '', 'key': null, 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': ''},

      {'input': 'Beispielklartext', 'key': '52413', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'ITEILAELXSPRBEKT'},
      {'input': 'Beispielklartext', 'key': ' 52413 ', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'ITEILAELXSPRBEKT'},
      {'input': 'Beispielklartext', 'key': '524137', 'oneCharStart': false, 'errorcode': ErrorCode.Key, 'expectedOutput': ''},
      {'input': 'Beispielklartext', 'key': '52413A', 'oneCharStart': false, 'errorcode': ErrorCode.Key, 'expectedOutput': ''},
      {'input': 'Beispielklartext', 'key': '5243', 'oneCharStart': false, 'errorcode': ErrorCode.Key, 'expectedOutput': ''},
      {'input': 'Beispielklartext', 'key': '521431', 'oneCharStart': false, 'errorcode': ErrorCode.Key, 'expectedOutput': ''},
      {'input': 'Beispielklartext', 'key': '524136', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'IXIRELTSPTEBELAK'},
      {'input': 'Beispielklartext', 'key': '2413', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'SPLATBEELTEIRIKX'},
      {'input': 'Beispielklartext und noch mehr Text', 'key': '524136', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'IXMIROXELTUEHSPTECHTBELADNTEKNR'},
      {'input': 'Beispielklartext und noch mehr Text', 'key': '524136', 'oneCharStart': true, 'errorcode': ErrorCode.OK, 'expectedOutput': 'PIEXHMEIARNOEXETESTCTBLDTLKUNHR'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encryptAmsco(elem['input'], elem['key'], elem['oneCharStart']);
        expect(_actual.output, elem['expectedOutput']);
        expect(_actual.errorCode, elem['errorcode']);
      });
    });
  });


  group("Amsco.decodeAmsco:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input': null, 'key': '', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': ''},
      {'input': '', 'key': '', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': ''},
      {'input': null, 'key': null, 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': ''},
      {'input': '', 'key': null, 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': ''},

      {'input': 'iteilaelxsprBekt', 'key': '52413', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'BEISPIELKLARTEXT'},
      {'input': 'iteilaelxsprBekt', 'key': ' 52413 ', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'BEISPIELKLARTEXT'},
      {'input': 'Beispielklartext', 'key': '524137', 'oneCharStart': false, 'errorcode': ErrorCode.Key, 'expectedOutput': ''},
      {'input': 'Beispielklartext', 'key': '52413A', 'oneCharStart': false, 'errorcode': ErrorCode.Key, 'expectedOutput': ''},
      {'input': 'Beispielklartext', 'key': '5243', 'oneCharStart': false, 'errorcode': ErrorCode.Key, 'expectedOutput': ''},
      {'input': 'Beispielklartext', 'key': '521431', 'oneCharStart': false, 'errorcode': ErrorCode.Key, 'expectedOutput': ''},
      {'input': 'ixireltspteBelak', 'key': '524136', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'BEISPIELKLARTEXT'},
      {'input': 'splatBeelteirikx', 'key': '2413', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'BEISPIELKLARTEXT'},
      {'input': 'IXMIROXEL TUEHSP TECHTBEL ADNTEKNR', 'key': '524136', 'oneCharStart': false, 'errorcode': ErrorCode.OK, 'expectedOutput': 'BEISPIELKLARTEXTUNDNOCHMEHRTEXT'},
      {'input': 'PIEXHM EIARNOEXET ESTCTBLDTLKUNHR', 'key': '524136', 'oneCharStart': true, 'errorcode': ErrorCode.OK, 'expectedOutput': 'BEISPIELKLARTEXTUNDNOCHMEHRTEXT'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decryptAmsco(elem['input'], elem['key'], elem['oneCharStart']);
        expect(_actual.output, elem['expectedOutput']);
        expect(_actual.errorCode, elem['errorcode']);
      });
    });
  });
}
