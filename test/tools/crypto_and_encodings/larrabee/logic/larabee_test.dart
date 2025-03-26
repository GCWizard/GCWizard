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

      {'input' : ' A123456789123', 'key': 'MN', 'expectedOutput' : ' MDUNNPPRRTTVCPMOO'},

      {'input' : 'MOVE FORWARD IN FORCE', 'key': 'Jove', 'expectedOutput' : 'VCQI OCMAJFY MW TJVLS'},
      {'input' : 'SELL EVERYTHING', 'key': 'Hope"', 'expectedOutput' : 'ZSAP LJTVFHWMUU'},

      {'input' : 'REMIT3750DOLLARS', 'key': 'Hanover', 'expectedOutput' : 'YEZWOUUJGRXYSCSAEG'},
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

      {'input' : ' MDUNNPPRRTTVCPMOO', 'key': 'MN', 'expectedOutput' : ' A123456789123'},

      {'input' : 'VERLBGD HHKAMYCB', 'key': 'Decatur', 'expectedOutput' : 'SAPLIMM EDIATELY'},
      {'input' : 'EVH XCSVQOSQB ZFGMCGLB', 'key': 'Lodi', 'expectedOutput' : 'THE PRESIDENT ORDERSIT'},

      {'input' : 'VRCMXHSSQN', 'key': 'Hero', 'expectedOutput' : 'ONLY2500'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}', () {
        var _actual = decryptLarrabee(elem['input'] as String, elem['key'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
  
}