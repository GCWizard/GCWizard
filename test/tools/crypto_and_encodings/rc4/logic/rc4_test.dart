import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/rc4/logic/rc4.dart';

void main() {
  group("rc4.cryptRC4:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : '', 'format' : InputFormat.AUTO, 'key' : '', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : '', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.OK},
      {'input' : '', 'format' : InputFormat.AUTO, 'key' : 'X', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : '', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.OK},

      {'input' : 'abcdefghijklmn', 'format' : InputFormat.TEXT, 'key' : '', "keyFormat" : InputFormat.TEXT, 'expectedOutput' : '', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.MISSING_KEY},
      {'input' : '02000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : 'FE', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : '', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.INPUT_FORMAT},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : '21111110', "keyFormat" : InputFormat.BINARY, 'expectedOutput' : '', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.KEY_FORMAT},


      {'input' : 'abcdefghijklmn', 'format' : InputFormat.AUTO, 'key' : 'xx', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : 'eÌU|¢v4¾g.(b0U', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.OK},
      {'input' : 'abcdefghijklmn', 'format' : InputFormat.AUTO, 'key' : 'xx', "keyFormat" : InputFormat.HEX, 'expectedOutput' : '', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.KEY_FORMAT},
      {'input' : 'abcdefghijklmn', 'format' : InputFormat.TEXT, 'key' : 'xx', "keyFormat" : InputFormat.TEXT, 'expectedOutput' : 'eÌU|¢v4¾g.(b0U', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.OK},
      {'input' : 'abcdefghijklmn', 'format' : InputFormat.HEX, 'key' : 'xx', "keyFormat" : InputFormat.TEXT, 'expectedOutput' : '', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.INPUT_FORMAT},

      {'input' : 'ABCDE', 'format' : InputFormat.AUTO, 'key' : 'FEDCBA', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : '볠', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.OK},
      {'input' : 'ABC', 'format' : InputFormat.AUTO, 'key' : '1234', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : 'AF4', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},

      {'input' : 'ABCDEF', 'format' : InputFormat.AUTO, 'key' : 'FEDCBA', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : 'ABCDD1', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : 'ABCDEF', 'format' : InputFormat.AUTO, 'key' : 'FE', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : 'ABCDDC', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : 'ABCDEF', 'format' : InputFormat.AUTO, 'key' : 'FE', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : '췜', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.OK},

      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.AUTO, 'key' : 'FE', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : '72 55 5C DD 7D 1E', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : 'FE', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : '72 55 5C DD 7D 1E', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : 'FE', "keyFormat" : InputFormat.BINARY, 'expectedOutput' : '', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.KEY_FORMAT},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : '11111110', "keyFormat" : InputFormat.AUTO, 'expectedOutput' : '72 55 5C DD 7D 1E', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : '11111110', "keyFormat" : InputFormat.BINARY, 'expectedOutput' : '72 55 5C DD 7D 1E', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : '11111110', "keyFormat" : InputFormat.HEX, 'expectedOutput' : '5A E4 71 74 1F 13', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : 'FE', "keyFormat" : InputFormat.HEX, 'expectedOutput' : '72 55 5C DD 7D 1E', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : 'FE', "keyFormat" : InputFormat.HEX, 'expectedOutput' : 'rU\\Ý}.', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : 'FE', "keyFormat" : InputFormat.HEX, 'expectedOutput' : 'rU\\Ý}.', 'outputFormat' : OutputFormat.TEXT, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : 'FE', "keyFormat" : InputFormat.HEX, 'expectedOutput' : '01110010 01010101 01011100 11011101 01111101 00011110', 'outputFormat' : OutputFormat.BINARY, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.BINARY, 'key' : 'FE', "keyFormat" : InputFormat.TEXT, 'expectedOutput' : '8A 26 66 96 1F 9B', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
      {'input' : '01000001 01000010 01000011 01000100 01000101 01000110', 'format' : InputFormat.HEX, 'key' : 'FE', "keyFormat" : InputFormat.TEXT, 'expectedOutput' : '10000CA 1000074 1000034 10001D2 100015B 10001CD', 'outputFormat' : OutputFormat.HEX, 'errorCode' : ErrorCode.OK},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = cryptRC4(elem['input'], elem['format'], elem['key'], elem['keyFormat'], elem['outputFormat']);
        expect(_actual.output, elem['expectedOutput']);
        expect(_actual.errorCode, elem['errorCode']);
      });
    });
  });

}