import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';

void main() {
  group("Reverse.reverseAll:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC%&/6789abcÄ', 'expectedOutput' : 'Äcba9876/&%CBA'},
      {'input' : '123 456 7890', 'expectedOutput' : '0987 654 321'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = reverseAll(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Reverse.reverseBlocks:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC%&/6789abcÄ', 'expectedOutput' : 'ABC%&/6789abcÄ'},
      {'input' : '123 456 7890', 'expectedOutput' : '7890 456 123'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = reverseBlocks(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Reverse.reverseBlocksWithDelimiter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'delimiter': '', 'expectedOutput' : ''},
      {'input' : '', 'delimiter': ' ', 'expectedOutput' : ''},

      {'input' : 'ABC%&/6789abcÄ', 'delimiter': ' ', 'expectedOutput' : 'ABC%&/6789abcÄ'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '', 'expectedOutput' : 'ABC%&/6789abcÄ'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '6', 'expectedOutput' : '789abcÄ6ABC%&/'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '6 ', 'expectedOutput' : '789abcÄ6ABC%&/'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '69', 'expectedOutput' : 'abcÄ6789ABC%&/'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '6 9', 'expectedOutput' : 'abcÄ6789ABC%&/'},

      {'input' : '123 456 7890', 'delimiter': '', 'expectedOutput' : '123 456 7890'},
      {'input' : '123 456 7890', 'delimiter': ' ', 'expectedOutput' : '7890 456 123'},
      {'input' : '123 456 7890', 'delimiter': ',', 'expectedOutput' : '123 456 7890'},
      {'input' : '123,456,7890', 'delimiter': ',', 'expectedOutput' : '7890,456,123'},
      {'input' : '123,456;7890', 'delimiter': ',;', 'expectedOutput' : '7890,456;123'},
      {'input' : '123;456,7890', 'delimiter': ',;', 'expectedOutput' : '7890;456,123'},

      {'input' : '123;;456,7890', 'delimiter': ',;', 'expectedOutput' : '7890;456;,123'},
      {'input' : '123;,456,7890', 'delimiter': ',;', 'expectedOutput' : '7890;456,,123'},
      {'input' : ',,123;,456,7890', 'delimiter': ',;', 'expectedOutput' : '7890,456,;123,,'},
      {'input' : ',,123;,456,7890;,;', 'delimiter': ',;', 'expectedOutput' : ',,;7890,456,;123,;'},

      {'input' : ',', 'delimiter': ',;', 'expectedOutput' : ','},
      {'input' : ',,;', 'delimiter': ',;', 'expectedOutput' : ',,;'},
      {'input' : ',,;a', 'delimiter': ',;', 'expectedOutput' : 'a,,;'},
      {'input' : ',,;', 'delimiter': ';', 'expectedOutput' : ';,,'},
      {'input' : ',,;,', 'delimiter': ';', 'expectedOutput' : ',;,,'},
      {'input' : ',,;', 'delimiter': ',', 'expectedOutput' : ';,,'},
      {'input' : ',,;,', 'delimiter': ',', 'expectedOutput' : ',;,,'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, delimiter: ${elem['delimiter']}', () {
        var _actual = reverseBlocks(elem['input'] as String, blockDelimiters: elem['delimiter'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Reverse.reverseKeepBlockOrder:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'ABC%&/6789abcÄ', 'expectedOutput' : 'Äcba9876/&%CBA'},
      {'input' : '123 456 7890', 'expectedOutput' : '321 654 0987'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = reverseKeepBlockOrder(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Reverse.reverseKeepBlockOrderWithDelimiter:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'delimiter': '', 'expectedOutput' : ''},
      {'input' : '', 'delimiter': ' ', 'expectedOutput' : ''},

      {'input' : 'ABC%&/6789abcÄ', 'delimiter': ' ', 'expectedOutput' : 'Äcba9876/&%CBA'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '', 'expectedOutput' : 'Äcba9876/&%CBA'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '6', 'expectedOutput' : '/&%CBA6Äcba987'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '6 ', 'expectedOutput' : '/&%CBA6Äcba987'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '69', 'expectedOutput' : '/&%CBA6879Äcba'},
      {'input' : 'ABC%&/6789abcÄ', 'delimiter': '6 9', 'expectedOutput' : '/&%CBA6879Äcba'},

      {'input' : '123 456 7890', 'delimiter': '', 'expectedOutput' : '0987 654 321'},
      {'input' : '123 456 7890', 'delimiter': ' ', 'expectedOutput' : '321 654 0987'},
      {'input' : '123 456 7890', 'delimiter': ',', 'expectedOutput' : '0987 654 321'},
      {'input' : '123,456,7890', 'delimiter': ',', 'expectedOutput' : '321,654,0987'},
      {'input' : '123,456;7890', 'delimiter': ',;', 'expectedOutput' : '321,654;0987'},
      {'input' : '123;456,7890', 'delimiter': ',;', 'expectedOutput' : '321;654,0987'},

      {'input' : '123;;456,7890', 'delimiter': ',;', 'expectedOutput' : '321;;654,0987'},
      {'input' : '123;,456,7890', 'delimiter': ',;', 'expectedOutput' : '321;,654,0987'},
      {'input' : ',,123;,456,7890', 'delimiter': ',;', 'expectedOutput' : ',,321;,654,0987'},
      {'input' : ',,123;,456,7890;,;', 'delimiter': ',;', 'expectedOutput' : ',,321;,654,0987;,;'},

      {'input' : ',', 'delimiter': ',;', 'expectedOutput' : ','},
      {'input' : ',,;', 'delimiter': ',;', 'expectedOutput' : ',,;'},
      {'input' : ',,;a', 'delimiter': ',;', 'expectedOutput' : ',,;a'},
      {'input' : ',,;ab', 'delimiter': ',;', 'expectedOutput' : ',,;ba'},
      {'input' : ',,;', 'delimiter': ';', 'expectedOutput' : ',,;'},
      {'input' : ',,;,', 'delimiter': ';', 'expectedOutput' : ',,;,'},
      {'input' : ',,;', 'delimiter': ',', 'expectedOutput' : ',,;'},
      {'input' : ',,;,', 'delimiter': ',', 'expectedOutput' : ',,;,'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, delimiter: ${elem['delimiter']}', () {
        var _actual = reverseKeepBlockOrder(elem['input'] as String, blockDelimiters: elem['delimiter'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}