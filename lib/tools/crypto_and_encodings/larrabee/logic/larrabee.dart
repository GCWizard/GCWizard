import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

String encryptLarrabee(String input, String key) {
  input = _replaceNumbers(input);
  return encryptVigenere(input, key, false);
}

String decryptLarrabee(String input, String key) {
  var decodedText = decryptVigenere(input, key, false);
  return _restoreNumbers(decodedText);
}

const String _numberIdentifier = 'Q';
const Map<String, String> _numbers = {
  'A': '1',
  'B': '2',
  'C': '3',
  'D': '4',
  'E': '5',
  'F': '6',
  'G': '7',
  'H': '8',
  'I': '9',
  'J': '0',
};

String _replaceNumbers(String input) {
  var matches = RegExp(r'\d+').allMatches(input).toList();
  var numbers = switchMapKeyValue(_numbers);

  for (var match in matches.reversed) {
    var numbersCoded = '';

    for (var i = 0; i < match.group(0)!.length; i+=9) {
      var numberBlock = match.group(0)!.substring(i, min(i+9, match.group(0)!.length));
      numbersCoded += _numberIdentifier +
          (numbers[numberBlock.length.toString()] ?? '') +
          numberBlock.split('').map((number) => numbers[number]).join();
    }
    input = input.replaceRange(match.start, match.end, numbersCoded);
  }
  return input;
}

String _restoreNumbers(String input) {
  var matches = RegExp(r'['+ _numberIdentifier + ']([A-I])([A-J]+)',caseSensitive: false).allMatches(input).toList();

  for (var match in matches.reversed) {
    var count = int.parse(_numbers[match.group(1)!.toUpperCase()] ?? '0');

    if (count > 0 && match.group(2)!.length >= count) {
      var numbersDecoded = match.group(2).toString().split('').mapIndexed((index, number) =>
          index < count ? _numbers[number.toUpperCase()] : number).join();
      input = input.replaceRange(match.start, match.end, numbersDecoded);
    }
  }
  return input;
}
