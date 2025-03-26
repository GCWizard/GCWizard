import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/larrabee/logic/larrabee.dart';

void main() {
  group("Larrabee.encrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'expectedOutput' : ''},
      {'input' : '', 'key': 'ABC', 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': '', 'expectedOutput' : 'ABC'},

      {'input' : 'ABC', 'key': 'MNO', 'expectedOutput' : 'MOQ'},
      {'input' : 'ABCDEF', 'key': 'MN', 'expectedOutput' : 'MOOQQS'},

      {'input' : 'Abc', 'key': 'mnO', 'expectedOutput' : 'Moq'},
      {'input' : 'AbCDeF', 'key': 'MN', 'expectedOutput' : 'MoOQqS'},

      {'input' : 'Ab12c', 'key': 'mnO', 'expectedOutput' : 'MoENNPo'},
      {'input' : ' A%67bC DeF_', 'key': 'MN', 'expectedOutput' : ' M%DNSSoO QqS_'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}', () {
        var _actual = encryptLarrabee(
            elem['input'] as String, elem['key'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
  

  group("Larrabee.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'MOQ', 'key': 'MNO', 'expectedOutput' : 'ABC'},

      {'input' : '', 'key': '', 'expectedOutput' : ''},
      {'input' : '', 'key': 'ABC', 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': '', 'expectedOutput' : 'ABC'},

      {'input' : 'MOQ', 'key': 'MNO', 'expectedOutput' : 'ABC'},
      {'input' : 'MOOQQS', 'key': 'MN', 'expectedOutput' : 'ABCDEF'},

      {'input' : 'Moq', 'key': 'mnO', 'expectedOutput' : 'Abc'},
      {'input' : 'MoOQqS', 'key': 'MN', 'expectedOutput' : 'AbCDeF'},

      {'input' : 'MoENNPo', 'key': 'mnO', 'expectedOutput' : 'Ab12c'},
      {'input' : ' M%DNSSoO QqS_', 'key': 'MN', 'expectedOutput' : ' A%67bC DeF_'},
      {'input' : ' M%dNSSoO QqS_', 'key': 'MN', 'expectedOutput' : ' A%67bC DeF_'},
      {'input' : ' M%DnSSoO QqS_', 'key': 'MN', 'expectedOutput' : ' A%67bC DeF_'},
      {'input' : ' M%DnsSoO QqS_', 'key': 'MN', 'expectedOutput' : ' A%67bC DeF_'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = decryptLarrabee(elem['input'] as String, elem['key'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
  
}