import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

final Map<int, List<String>> _numbersToSegments = {
  0: [],
  1: ['f'],
  2: ['f', 'g'],
  3: ['f', 'g', 'h'],
  4: ['f', 'g', 'h', 'i'],
  5: ['f', 'g', 'h', 'i', 'j'],
  6: ['f', 'g', 'h', 'i', 'j', 'k'],
  7: ['f', 'g', 'h', 'i', 'j', 'k', 'l'],
  8: ['f', 'g', 'h', 'i', 'j', 'k', 'l', 'm'],
  9: ['f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'],
  10: ['a'],
  11: ['a', 'f'],
  12: ['a', 'f', 'g'],
  13: ['a', 'f', 'g', 'h'],
  14: ['a', 'f', 'g', 'h', 'i'],
  15: ['a', 'f', 'g', 'h', 'i', 'j'],
  16: ['a', 'f', 'g', 'h', 'i', 'j', 'k'],
  17: ['a', 'f', 'g', 'h', 'i', 'j', 'k', 'l'],
  18: ['a', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm'],
  19: ['a', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'],
  20: ['a', 'b'],
  21: ['a', 'b', 'f'],
  22: ['a', 'b', 'f', 'g'],
  23: ['a', 'b', 'f', 'g', 'h'],
  24: ['a', 'b', 'f', 'g', 'h', 'i'],
  25: ['a', 'b', 'f', 'g', 'h', 'i', 'j'],
  26: ['a', 'b', 'f', 'g', 'h', 'i', 'j', 'k'],
  27: ['a', 'b', 'f', 'g', 'h', 'i', 'j', 'k', 'l'],
  28: ['a', 'b', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm'],
  29: ['a', 'b', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'],
  30: ['a', 'b', 'c'],
  31: ['a', 'b', 'c', 'f'],
  32: ['a', 'b', 'c', 'f', 'g'],
  33: ['a', 'b', 'c', 'f', 'g', 'h'],
  34: ['a', 'b', 'c', 'f', 'g', 'h', 'i'],
  35: ['a', 'b', 'c', 'f', 'g', 'h', 'i', 'j'],
  36: ['a', 'b', 'c', 'f', 'g', 'h', 'i', 'j', 'k'],
  37: ['a', 'b', 'c', 'f', 'g', 'h', 'i', 'j', 'k', 'l'],
  38: ['a', 'b', 'c', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm'],
  39: ['a', 'b', 'c', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'],
  40: ['a', 'b', 'c', 'd'],
  41: ['a', 'b', 'c', 'd', 'f'],
  42: ['a', 'b', 'c', 'd', 'f', 'g'],
  43: ['a', 'b', 'c', 'd', 'f', 'g', 'h'],
  44: ['a', 'b', 'c', 'd', 'f', 'g', 'h', 'i'],
  45: ['a', 'b', 'c', 'd', 'f', 'g', 'h', 'i', 'j'],
  46: ['a', 'b', 'c', 'd', 'f', 'g', 'h', 'i', 'j', 'k'],
  47: ['a', 'b', 'c', 'd', 'f', 'g', 'h', 'i', 'j', 'k', 'l'],
  48: ['a', 'b', 'c', 'd', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm'],
  49: ['a', 'b', 'c', 'd', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'],
  50: ['a', 'b', 'c', 'd', 'e'],
  51: ['a', 'b', 'c', 'd', 'e', 'f'],
  52: ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
  53: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
  54: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'],
  55: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'],
  56: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'],
  57: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l'],
  58: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm'],
  59: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'],
};

List<List<String>> encodeBabylonNumbers(int input) {
  if (input == null) return <List<String>>[];

  var sexagesimal = convertBase(input.toString(), 10, 60);
  return sexagesimal.split('').map((digit) {
    return _numbersToSegments[int.tryParse(convertBase(digit, 60, 10))];
  }).toList();
}

Map<String, dynamic> decodeBabylonNumbers(List<String> inputs) {
  if (inputs == null || inputs.length == 0)
    return {
      'displays': <List<String>>[],
      'numbers': [0],
      'sexagesimal': BigInt.zero
    };

  var oneCharacters = ['f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'];
  var tenCharacters = [
    'a',
    'b',
    'c',
    'd',
    'e',
  ];

  var displays = <List<String>>[];

  List<int> numbers = inputs.where((input) => input != null).map((input) {
    var number = 0;
    var display = <String>[];
    input.toLowerCase().split('').forEach((segment) {
      if (oneCharacters.contains(segment)) {
        number += 1;
        display.add(segment);
        return;
      }
      if (tenCharacters.contains(segment)) {
        number += 10;
        display.add(segment);
        return;
      }
      return;
    });

    displays.add(display);

    return number;
  }).toList();

  var total = convertBase(numbers.map((number) => convertBase(number.toString(), 10, 60)).join(), 60, 10);

  return {'displays': displays, 'numbers': numbers, 'sexagesimal': BigInt.tryParse(total)};
}
