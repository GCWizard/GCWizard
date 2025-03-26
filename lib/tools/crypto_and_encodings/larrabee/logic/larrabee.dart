import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

String encryptLarrabee(String input, String key) {
  input = replaceNumbers(input);
  return encryptVigenere(input, key, false);
}

String decryptLarrabee(String input, String key) {
  var decodedText = restoreNumbers(input);
  return restoreNumbers(decodedText);
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

String replaceNumbers(String input) {
  var matches = RegExp(r'\d+').allMatches(input).toList();
  var numbers = switchMapKeyValue(_numbers);

  for (var match in matches.reversed) {
    var numbersCoded = match.toString().split('').mapIndexed((index, number) =>
        index < 10 ? numbers[number] : number).join();
    numbersCoded = _numberIdentifier +
        (numbersCoded.length < 10 ? numbers[numbersCoded.length.toString()] ?? '' : numbers[9.toString()] ?? '') +
        numbersCoded;
    input = input.replaceRange(match.start, match.end, numbersCoded);
  }
  return input;
}

String restoreNumbers(String input) {
  var matches = RegExp(r'['+ _numberIdentifier +']([A-I])([A-J]+)').allMatches(input).toList();

  for (var match in matches.reversed) {
    var count = (_numbers[match.group(1)] ?? '0') as int;

    if (count > 0 && match.group(2)!.length >= count) {
      var numbersDecoded = match.group(2).toString().split('').mapIndexed((index, number) =>
          index < count ? _numbers[number] : number).join();
      input = input.replaceRange(match.start, match.end, numbersDecoded);
    }
  }
  return input;
}
