import 'dart:math';

import 'package:gc_wizard/utils/alphabets.dart';

int _getMaxValue(int wheelNo) {
  switch (wheelNo) {
    case 0:
      return 26;
    case 1:
      return 52;
    case 2:
      return 78;
    case 3:
      return 104;
    default:
      return 0;
  }
}

String encryptMexicanArmyCipherWheel(String input, List<int> keys) {
  input = input.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

  if (input.isEmpty) return '';

  return input.split('').map((character) {
    var value = alphabet_AZ[character] ?? 0;
    var tmpValue = value;

    int randomWheel;
    do {
      randomWheel = Random().nextInt(4);
      var maxValue = _getMaxValue(randomWheel);
      value = tmpValue + keys[randomWheel] - 1;
      if (value > maxValue) value -= 26;
    } while (randomWheel == 3 && value > 100);

    if (value == 100) value = 0;

    return (value.toString()).padLeft(2, '0');
  }).join();
}

String decryptMexicanArmyCipherWheel(String input, List<int> keys) {
  if (input.isEmpty) return '';

  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.length % 2 == 1) input = input.substring(0, input.length - 1);

  if (input.isEmpty) return '';

  int i = 0;
  var output = '';
  while (i < input.length) {
    var number = int.tryParse(input.substring(i, i + 2))!;
    if (number == 0) number = 100;

    if (number <= 26) {
      number -= keys[0] - 1;
    } else if (number <= 52) {
      number -= keys[1] - 1;
    } else if (number <= 78) {
      number -= keys[2] - 1;
    } else {
      number -= keys[3] - 1;
    }

    while (number > 26) {
      number -= 26;
    }
    while (number < 1) {
      number += 26;
    }

    output += alphabet_AZIndexes[number] ?? '';
    i += 2;
  }

  return output;
}
