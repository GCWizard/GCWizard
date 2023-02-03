import 'dart:math';

import 'package:gc_wizard/utils/alphabets.dart';

class HomophoneOutput {
  final String output;
  final String grid;
  final HomophoneErrorCode errorCode;

  HomophoneOutput(this.output, this.grid, this.errorCode);
}

enum HomophoneErrorCode { OK, TABLE, CUSTOM_KEY_COUNT, CUSTOM_KEY_DUPLICATE }

HomophoneOutput encryptHomophoneWithKeyMap(String input, Map<String, List<int>> keyMap) {
  if (keyMap == null || keyMap.isEmpty) {
    return HomophoneOutput('', '', HomophoneErrorCode.CUSTOM_KEY_COUNT);
  }

  return _encryptHomophone(input, keyMap);
}

Map<String, List<int>> _keyListToKeyMap(Map<String, int> letterFrequencies, List<int> keyList) {
  var keyMap = <String, List<int>>{};

  var keyIndex = 0;
  letterFrequencies.forEach((letter, frequency) {
    keyMap.addAll({letter: <int>[]});
    for (int f = 0; f < frequency; f++) {
      keyMap[letter].add(keyList[keyIndex++]);
    }
  });

  return keyMap;
}

HomophoneOutput encryptHomophoneWithKeyList(String input, Alphabet alphabet, List<int> keyList) {
  if (keyList == null || keyList.length != 100) {
    return HomophoneOutput('', '', HomophoneErrorCode.CUSTOM_KEY_COUNT);
  }

  var letterFrequencies = getLetterFrequenciesFromAlphabet(alphabet);
  if (letterFrequencies == null) return HomophoneOutput('', '', HomophoneErrorCode.TABLE);
  var keyMap = _keyListToKeyMap(letterFrequencies, keyList);

  return _encryptHomophone(input, keyMap);
}

Map<String, List<int>> _generateKeyMap(Map<String, int> letterFrequencies, int rotation, int multiplier) {
  var keyMap = <String, List<int>>{};

  var counter = rotation * multiplier;

  letterFrequencies.forEach((letter, frequency) {
    keyMap.addAll({letter: <int>[]});
    for (int f = 0; f < frequency; f++) {
      keyMap[letter].add(counter % 100);
      counter += multiplier;
    }
  });

  return keyMap;
}

HomophoneOutput encryptHomophoneWithGeneratedKey(String input, Alphabet alphabet, int rotation, int multiplier) {
  var letterFrequencies = getLetterFrequenciesFromAlphabet(alphabet);
  if (letterFrequencies == null) return HomophoneOutput('', '', HomophoneErrorCode.TABLE);

  return _encryptHomophone(input, _generateKeyMap(letterFrequencies, rotation, multiplier));
}

HomophoneOutput _encryptHomophone(String input, Map<String, List<int>> keyMap) {
  if (input == null || input == '') return HomophoneOutput('', '', HomophoneErrorCode.OK);

  var error = HomophoneErrorCode.OK;
  if (_checkDoubleKey(keyMap)) {
    error = HomophoneErrorCode.CUSTOM_KEY_DUPLICATE;
  }

  input = input.toUpperCase();
  input = input.split('').map((character) => keyMap.containsKey(character) ? character : '').join();

  var output = input
      .toUpperCase()
      .split('')
      .map((character) => _charToNumber(character, keyMap).toString().padLeft(2, '0'))
      .join(' ');

  return HomophoneOutput(output, _keyMapToString(keyMap), error);
}

HomophoneOutput decryptHomophoneWithKeyMap(String input, Map<String, List<int>> keyMap) {
  if (keyMap == null || keyMap.isEmpty) {
    return HomophoneOutput('', '', HomophoneErrorCode.CUSTOM_KEY_COUNT);
  }

  return _decryptHomophone(input, keyMap);
}

HomophoneOutput decryptHomophoneWithKeyList(String input, Alphabet alphabet, List<int> keyList) {
  if (keyList == null || keyList.length != 100) {
    return HomophoneOutput('', '', HomophoneErrorCode.CUSTOM_KEY_COUNT);
  }

  var letterFrequencies = getLetterFrequenciesFromAlphabet(alphabet);
  if (letterFrequencies == null) return HomophoneOutput('', '', HomophoneErrorCode.TABLE);
  var keyMap = _keyListToKeyMap(letterFrequencies, keyList);

  return _decryptHomophone(input, keyMap);
}

HomophoneOutput decryptHomophoneWithGeneratedKey(String input, Alphabet alphabet, int rotation, int multiplier) {
  var letterFrequencies = getLetterFrequenciesFromAlphabet(alphabet);
  if (letterFrequencies == null) return HomophoneOutput('', '', HomophoneErrorCode.TABLE);

  return _decryptHomophone(input, _generateKeyMap(letterFrequencies, rotation, multiplier));
}

HomophoneOutput _decryptHomophone(String input, Map<String, List<int>> keyMap) {
  if (input == null || input == '') return HomophoneOutput('', '', HomophoneErrorCode.OK);

  var error = HomophoneErrorCode.OK;
  if (_checkDoubleKey(keyMap)) {
    error = HomophoneErrorCode.CUSTOM_KEY_DUPLICATE;
  }

  var output = input.split(' ').map((number) {
    return _numberToChar(number, keyMap);
  }).join();

  return HomophoneOutput(output, _keyMapToString(keyMap), error);
}

List<int> getMultipliers() {
  var multipliers = <int>[];

  for (int i = 1; i <= 99; i += 2) multipliers.add(i);

  for (int i = 5; i < 99; i += 10) multipliers.remove(i);

  return multipliers;
}

bool _checkDoubleKey(Map<String, List<int>> table) {
  var keyList = <int>[];
  table.values.forEach((element) {
    keyList.addAll(element);
  });
  return (keyList.length != keyList.toSet().length);
}

int _charToNumber(String character, Map<String, List<int>> table) {
  if (table.containsKey(character)) {
    var list = table[character];
    if (list.length == 0) return -1;
    var rnd = new Random();
    var index = rnd.nextInt(list.length);

    return list[index];
  }
  return -1;
}

String _numberToChar(String numberString, Map<String, List<int>> keyMap) {
  var number = int.tryParse(numberString);
  var output;

  if (number == null) return '';

  keyMap.forEach((key, numbers) {
    if (numbers.contains(number)) {
      output = key;
      return;
    }
  });
  return output;
}

String _keyMapToString(Map<String, List<int>> table) {
  var output = "";
  table.forEach((key, value) {
    output += key + " = ";
    value.forEach((item) {
      output += item.toString().padLeft(2, '0') + " ";
    });
    output = output.trim();
    output += "\n";
  });

  return output;
}
