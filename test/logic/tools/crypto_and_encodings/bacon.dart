import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/logic/tools/crypto_and_encodings/bacon.dart';

void main() {
  group("Bacon.encodeBacon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'AZ', 'expectedOutput' : 'AAAAABABBB'},
      {'input' : 'Az', 'expectedOutput' : 'AAAAABABBB'},
      {'input' : 'UV', 'expectedOutput' : 'BAABBBAABB'},
      {'input' : 'IJ', 'expectedOutput' : 'ABAAAABAAA'},
      {'input' : ' A_12Z%', 'expectedOutput' : 'AAAAABABBB'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBacon(elem['input'], false, false);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Bacon.encodeBaconBinary:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'AZ', 'expectedOutput' : '0000010111'},
      {'input' : 'Az', 'expectedOutput' : '0000010111'},
      {'input' : 'UV', 'expectedOutput' : '1001110011'},
      {'input' : 'IJ', 'expectedOutput' : '0100001000'},
      {'input' : ' A_12Z%', 'expectedOutput' : '0000010111'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBacon(elem['input'], false, true);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Bacon.encodeBaconInverse:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'AZ', 'expectedOutput' : 'BBBBBABAAA'},
      {'input' : 'Az', 'expectedOutput' : 'BBBBBABAAA'},
      {'input' : 'UV', 'expectedOutput' : 'ABBAAABBAA'},
      {'input' : 'IJ', 'expectedOutput' : 'BABBBBABBB'},
      {'input' : ' A_12Z%', 'expectedOutput' : 'BBBBBABAAA'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBacon(elem['input'], true, false);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Bacon.encodeBaconInverseBinary:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'AZ', 'expectedOutput' : '1111101000'},
      {'input' : 'Az', 'expectedOutput' : '1111101000'},
      {'input' : 'UV', 'expectedOutput' : '0110001100'},
      {'input' : 'IJ', 'expectedOutput' : '1011110111'},
      {'input' : ' A_12Z%', 'expectedOutput' : '1111101000'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBacon(elem['input'], true, true);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Bacon.decodeBacon:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'AZ', 'input' : 'AAAAABABBB'},
      {'expectedOutput' : 'AZ', 'input' : 'AAAAABABBBA'},
      {'expectedOutput' : 'AZ', 'input' : 'AAAAABABBBAA'},
      {'expectedOutput' : 'AZ', 'input' : 'AAAAABABBBAAA'},
      {'expectedOutput' : 'AZ', 'input' : 'AAAAABABBBAAAA'},
      {'expectedOutput' : 'AZA', 'input' : 'AAAAABABBBAAAAA'},
      {'expectedOutput' : 'AZ', 'input' : 'zAAAaa BABBB2'},
      {'expectedOutput' : 'UU', 'input' : 'BAABBBAABB'},
      {'expectedOutput' : 'II', 'input' : 'ABAAAABAAA'},
      {'expectedOutput' : '', 'input' : 'BBBBB'},
      {'expectedOutput' : '', 'input' : 'BBBA'},
      {'expectedOutput' : '', 'input' : 'BBBBBbbbbbBBBA'},
      {'expectedOutput' : '', 'input' : 'BBBBB bbbbb BBBA'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBacon(elem['input'], false, false);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Bacon.decodeBaconBinary:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'AZ', 'input' : '0000010111ABABA'},
      {'expectedOutput' : 'AZ', 'input' : '00000101110ABABA'},
      {'expectedOutput' : 'AZ', 'input' : '000001011100'},
      {'expectedOutput' : 'AZ', 'input' : '0000010111000'},
      {'expectedOutput' : 'AZ', 'input' : '00000101110000'},
      {'expectedOutput' : 'AZA', 'input' : '000001011100000'},
      {'expectedOutput' : 'AZ', 'input' : 'z00000 101112'},
      {'expectedOutput' : 'UU', 'input' : '1001110011'},
      {'expectedOutput' : 'II', 'input' : '0100001000'},
      {'expectedOutput' : '', 'input' : '11111'},
      {'expectedOutput' : '', 'input' : '1110'},
      {'expectedOutput' : '', 'input' : '11111111111110'},
      {'expectedOutput' : '', 'input' : '11111 11111 1110'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBacon(elem['input'], false, true);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Bacon.decodeBaconInverse:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'AZ', 'input' : 'BBBBBABAAA'},
      {'expectedOutput' : 'AZ', 'input' : 'BBBBBABAAAB'},
      {'expectedOutput' : 'AZ', 'input' : 'BBBBBABAAABB'},
      {'expectedOutput' : 'AZ', 'input' : 'BBBBBABAAABBB'},
      {'expectedOutput' : 'AZ', 'input' : 'BBBBBABAAABBBB'},
      {'expectedOutput' : 'AZA', 'input' : 'BBBBBABAAABBBBB'},
      {'expectedOutput' : 'AZ', 'input' : 'zBBBBB ABAAA2'},
      {'expectedOutput' : 'UU', 'input' : 'ABBAAABBAA'},
      {'expectedOutput' : 'II', 'input' : 'BABBBBABBB'},
      {'expectedOutput' : '', 'input' : 'AAAAA'},
      {'expectedOutput' : '', 'input' : 'AAAB'},
      {'expectedOutput' : '', 'input' : 'AAAAAAAAAAAAAB'},
      {'expectedOutput' : '', 'input' : 'AAAAA AAAAA AAAB'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBacon(elem['input'], true, false);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Bacon.decodeBaconInverseBinary:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : 'AZ', 'input' : '1111101000ABABA'},
      {'expectedOutput' : 'AZ', 'input' : '11111010001ABABA'},
      {'expectedOutput' : 'AZ', 'input' : '111110100011'},
      {'expectedOutput' : 'AZ', 'input' : '1111101000111'},
      {'expectedOutput' : 'AZ', 'input' : '11111010001111'},
      {'expectedOutput' : 'AZA', 'input' : '111110100011111'},
      {'expectedOutput' : 'AZ', 'input' : 'z11111 010002'},
      {'expectedOutput' : 'UU', 'input' : '0110001100'},
      {'expectedOutput' : 'II', 'input' : '1011110111'},
      {'expectedOutput' : '', 'input' : '00000'},
      {'expectedOutput' : '', 'input' : '0001'},
      {'expectedOutput' : '', 'input' : '00000000000001'},
      {'expectedOutput' : '', 'input' : '00000 00000 0001'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBacon(elem['input'], true, true);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });


}
