import 'dart:typed_data';

import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/rabbit/logic/rabbit.dart';

void main() {
  group("rabbit.keyStreamBytes:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'key' : null, 'iv' : null, 'expectedOutput' : null},
      {'key' : Uint8List.fromList([]), 'iv' : null, 'expectedOutput' : null},
      {'key' : Uint8List.fromList([]), 'iv' : Uint8List.fromList([]), 'expectedOutput' : null},

      {'key' : Uint8List.fromList([00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]),
        'iv' : null,
        'expectedOutput' : Uint8List.fromList([0x02, 0xF7, 0x4A, 0x1C, 0x26, 0x45, 0x6B, 0xF5, 0xEC, 0xD6, 0xA5, 0x36, 0xF0, 0x54, 0x57, 0xB1,
          0xA7, 0x8A, 0xC6, 0x89, 0x47, 0x6C, 0x69, 0x7B, 0x39, 0x0C, 0x9C, 0xC5, 0x15, 0xD8, 0xE8, 0x88,
          0x96, 0xD6, 0x73, 0x16, 0x88, 0xD1, 0x68, 0xDA, 0x51, 0xD4, 0x0C, 0x70, 0xC3, 0xA1, 0x16, 0xF4])},
      {'key' : Uint8List.fromList([0xAC, 0xC3, 0x51, 0xDC, 0xF1, 0x62, 0xFC, 0x3B, 0xFE, 0x36, 0x3D, 0x2E, 0x29, 0x13, 0x28, 0x91]),
        'iv' : null,
        'expectedOutput' : Uint8List.fromList([0x9C, 0x51, 0xE2, 0x87, 0x84, 0xC3, 0x7F, 0xE9, 0xA1, 0x27, 0xF6, 0x3E, 0xC8, 0xF3, 0x2D, 0x3D,
          0x19, 0xFC, 0x54, 0x85, 0xAA, 0x53, 0xBF, 0x96, 0x88, 0x5B, 0x40, 0xF4, 0x61, 0xCD, 0x76, 0xF5,
          0x5E, 0x4C, 0x4D, 0x20, 0x20, 0x3B, 0xE5, 0x8A, 0x50, 0x43, 0xDB, 0xFB, 0x73, 0x74, 0x54, 0xE5])},
      {'key' : Uint8List.fromList([0x43, 0x00, 0x9B, 0xC0, 0x01, 0xAB, 0xE9, 0xE9, 0x33, 0xC7, 0xE0, 0x87, 0x15, 0x74, 0x95, 0x83]),
        'iv' : null,
        'expectedOutput' : Uint8List.fromList([0x9B, 0x60, 0xD0, 0x02, 0xFD, 0x5C, 0xEB, 0x32, 0xAC, 0xCD, 0x41, 0xA0, 0xCD, 0x0D, 0xB1, 0x0C,
          0xAD, 0x3E, 0xFF, 0x4C, 0x11, 0x92, 0x70, 0x7B, 0x5A, 0x01, 0x17, 0x0F, 0xCA, 0x9F, 0xFC, 0x95,
          0x28, 0x74, 0x94, 0x3A, 0xAD, 0x47, 0x41, 0x92, 0x3F, 0x7F, 0xFC, 0x8B, 0xDE, 0xE5, 0x49, 0x96])},
      {'key' : Uint8List.fromList([00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]),
        'iv' : Uint8List.fromList([00, 00, 00, 00, 00, 00, 00, 00]),
        'expectedOutput' : Uint8List.fromList([0xED, 0xB7, 0x05, 0x67, 0x37, 0x5D, 0xCD, 0x7C, 0xD8, 0x95, 0x54, 0xF8, 0x5E, 0x27, 0xA7, 0xC6,
          0x8D, 0x4A, 0xDC, 0x70, 0x32, 0x29, 0x8F, 0x7B, 0xD4, 0xEF, 0xF5, 0x04, 0xAC, 0xA6, 0x29, 0x5F,
          0x66, 0x8F, 0xBF, 0x47, 0x8A, 0xDB, 0x2B, 0xE5, 0x1E, 0x6C, 0xDE, 0x29, 0x2B, 0x82, 0xDE, 0x2A])},
      {'key' : Uint8List.fromList([00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]),
        'iv' : Uint8List.fromList([0x59, 0x7E, 0x26, 0xC1, 0x75, 0xF5, 0x73, 0xC3]),
        'expectedOutput' : Uint8List.fromList([0x6D, 0x7D, 0x01, 0x22, 0x92, 0xCC, 0xDC, 0xE0, 0xE2, 0x12, 0x00, 0x58, 0xB9, 0x4E, 0xCD, 0x1F,
          0x2E, 0x6F, 0x93, 0xED, 0xFF, 0x99, 0x24, 0x7B, 0x01, 0x25, 0x21, 0xD1, 0x10, 0x4E, 0x5F, 0xA7,
          0xA7, 0x9B, 0x02, 0x12, 0xD0, 0xBD, 0x56, 0x23, 0x39, 0x38, 0xE7, 0x93, 0xC3, 0x12, 0xC1, 0xEB])},
      {'key' : Uint8List.fromList([00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00]),
        'iv' : Uint8List.fromList([ 0x27, 0x17, 0xF4, 0xD2, 0x1A, 0x56, 0xEB, 0xA6]),
        'expectedOutput' : Uint8List.fromList([0x4D, 0x10, 0x51, 0xA1, 0x23, 0xAF, 0xB6, 0x70, 0xBF, 0x8D, 0x85, 0x05, 0xC8, 0xD8, 0x5A, 0x44,
          0x03, 0x5B, 0xC3, 0xAC, 0xC6, 0x67, 0xAE, 0xAE, 0x5B, 0x2C, 0xF4, 0x47, 0x79, 0xF2, 0xC8, 0x96,
          0xCB, 0x51, 0x15, 0xF0, 0x34, 0xF0, 0x3D, 0x31, 0x17, 0x1C, 0xA7, 0x5F, 0x89, 0xFC, 0xCB, 0x9F])},
    ];

    _inputsToExpected.forEach((elem) {
      test('key: ${elem['key']} iv: ${elem['iv']}', () {
        var _actual = Rabbit(elem['key'], elem['iv'])
            ?.keyStreamBytes(elem['expectedOutput']?.length);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("rabbit.cryptRabbit:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input': null, 'inputFormat': null, 'key': null, 'keyFormat': null, 'iv': null, 'ivFormat': null, 'outputFormat': null,
        'expectedOutput': RabbitOutput('', null, null, ErrorCode.OK)
      },
      {'input': '', 'inputFormat': null, 'key': null, 'keyFormat': null, 'iv': null, 'ivFormat': null, 'outputFormat': null,
        'expectedOutput': RabbitOutput('', null, null, ErrorCode.OK)
      },
      {'input': '00 00 00 00 00 00 00 00', 'inputFormat': InputFormat.HEX, 'key': '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', 'keyFormat': InputFormat.HEX, 'iv': '00 00 00 00', 'ivFormat': InputFormat.HEX, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('AE 27 4F 26 F4 13 B7 CB', '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', '00 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': '00 00 00 00 00 00 00 00', 'inputFormat': InputFormat.HEX, 'key': '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', 'keyFormat': InputFormat.HEX, 'iv': '10 00 00 00', 'ivFormat': InputFormat.HEX, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('EC E2 13 19 25 79 08 02', '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', '10 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': '10 00 00 00 00 00 00 00', 'inputFormat': InputFormat.HEX, 'key': '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', 'keyFormat': InputFormat.HEX, 'iv': '10 00 00 00', 'ivFormat': InputFormat.HEX, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('FC E2 13 19 25 79 08 02', '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', '10 00 00 00 00 00 00 00', ErrorCode.OK)
      },

      {'input': '1A 1B 00 00 00 00 00 01', 'inputFormat': InputFormat.HEX, 'key': '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', 'keyFormat': InputFormat.HEX, 'iv': '10 00 00 00', 'ivFormat': InputFormat.HEX, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('F6 F9 13 19 25 79 08 03', '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', '10 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': '1A 1B 00 00 00 00 00 01', 'inputFormat': InputFormat.HEX, 'key': '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', 'keyFormat': InputFormat.HEX, 'iv': null, 'ivFormat': InputFormat.HEX, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('B4 3C 4F 26 F4 13 B7 CA', '10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', '00 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': 'Test', 'inputFormat': InputFormat.TEXT, 'key': 'Test', 'keyFormat': InputFormat.TEXT, 'iv': null, 'ivFormat': InputFormat.TEXT, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('02 6C DB CD', '54 65 73 74 00 00 00 00 00 00 00 00 00 00 00 00', '00 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': 'Test', 'inputFormat': InputFormat.AUTO, 'key': 'Test', 'keyFormat': InputFormat.AUTO, 'iv': null, 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('02 6C DB CD', '54 65 73 74 00 00 00 00 00 00 00 00 00 00 00 00', '00 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': '02 6C DB CD', 'inputFormat': InputFormat.AUTO, 'key': 'Test', 'keyFormat': InputFormat.AUTO, 'iv': null, 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.TEXT,
        'expectedOutput': RabbitOutput('Test', '54 65 73 74 00 00 00 00 00 00 00 00 00 00 00 00', '00 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': 'Test', 'inputFormat': InputFormat.TEXT, 'key': 'TestTestTestTest', 'keyFormat': InputFormat.TEXT, 'iv': '0000000000000000', 'ivFormat': InputFormat.HEX, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('1E DD 30 D4', '54 65 73 74 54 65 73 74 54 65 73 74 54 65 73 74', '00 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': '02 6C DB CD', 'inputFormat': InputFormat.AUTO, 'key': 'Test', 'keyFormat': InputFormat.AUTO, 'iv': null, 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.BINARY,
        'expectedOutput': RabbitOutput('01010100 01100101 01110011 01110100', '54 65 73 74 00 00 00 00 00 00 00 00 00 00 00 00', '00 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': '1010100 1100101 1110011 1110100', 'inputFormat': InputFormat.AUTO, 'key': 'Test', 'keyFormat': InputFormat.AUTO, 'iv': null, 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('02 6C DB CD', '54 65 73 74 00 00 00 00 00 00 00 00 00 00 00 00', '00 00 00 00 00 00 00 00', ErrorCode.OK)
      },
      {'input': 'Test', 'inputFormat': InputFormat.AUTO, 'key': 'Test', 'keyFormat': InputFormat.AUTO, 'iv': 'Test', 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('64 CE 79 3E', '54 65 73 74 00 00 00 00 00 00 00 00 00 00 00 00', '54 65 73 74 00 00 00 00', ErrorCode.OK)
      },
      {'input': 'Test', 'inputFormat': InputFormat.AUTO, 'key': 'TestTestTestTestTestTest', 'keyFormat': InputFormat.AUTO, 'iv': 'TestTestTestTest', 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('E0 16 3B 59', '54 65 73 74 54 65 73 74 54 65 73 74 54 65 73 74', '54 65 73 74 54 65 73 74', ErrorCode.OK)
      },

      {'input': 'Test', 'inputFormat': InputFormat.BINARY, 'key': 'Test', 'keyFormat': InputFormat.AUTO, 'iv': null, 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('', null, null, ErrorCode.INPUT_FORMAT)
      },
      {'input': '1010100 1100101 1110011 1110100', 'inputFormat': InputFormat.AUTO, 'key': '', 'keyFormat': InputFormat.AUTO, 'iv': null, 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('', null, null, ErrorCode.MISSING_KEY)
      },
      {'input': '1010100 1100101 1110011 1110100', 'inputFormat': InputFormat.AUTO, 'key': 'Test', 'keyFormat': InputFormat.BINARY, 'iv': null, 'ivFormat': InputFormat.AUTO, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('', null, null, ErrorCode.KEY_FORMAT)
      },
      {'input': 'Test', 'inputFormat': InputFormat.TEXT, 'key': 'Test', 'keyFormat': InputFormat.TEXT, 'iv': 'Test', 'ivFormat': InputFormat.HEX, 'outputFormat': OutputFormat.HEX,
        'expectedOutput': RabbitOutput('', null, null, ErrorCode.IV_FORMAT)
      },
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']} key: ${elem['key']} iv: ${elem['iv']} iv: ${elem['iv']} outputFormat: ${elem['outputFormat']}', () {
        var _actual = cryptRabbit(elem['input'], elem['inputFormat'], elem['key'], elem['keyFormat'], elem['iv'], elem['ivFormat'], elem['outputFormat']);
        expect(_actual?.output, elem['expectedOutput']?.output);
        expect(_actual?.keyHexFormat, elem['expectedOutput']?.keyHexFormat);
        expect(_actual?.ivHexFormat, elem['expectedOutput']?.ivHexFormat);
        expect(_actual?.errorCode, elem['expectedOutput']?.errorCode);
      });
    });
  });
}
