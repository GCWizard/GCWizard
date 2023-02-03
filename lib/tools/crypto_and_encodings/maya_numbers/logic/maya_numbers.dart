import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

final Map<int, List<String>> _numbersToSegments = {
  0: [],
  1: ['d'],
  2: ['d', 'e'],
  3: ['d', 'e', 'f'],
  4: ['d', 'e', 'f', 'g'],
  5: ['c'],
  6: ['c', 'd'],
  7: ['c', 'd', 'e'],
  8: ['c', 'd', 'e', 'f'],
  9: ['c', 'd', 'e', 'f', 'g'],
  10: ['b', 'c'],
  11: ['b', 'c', 'd'],
  12: ['b', 'c', 'd', 'e'],
  13: ['b', 'c', 'd', 'e', 'f'],
  14: ['b', 'c', 'd', 'e', 'f', 'g'],
  15: ['a', 'b', 'c'],
  16: ['a', 'b', 'c', 'd'],
  17: ['a', 'b', 'c', 'd', 'e'],
  18: ['a', 'b', 'c', 'd', 'e', 'f'],
  19: ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
};

List<List<String>> encodeMayaNumbers(int input) {
  if (input == null) return <List<String>>[];

  var vigesimal = convertBase(input.toString(), 10, 20);
  return vigesimal.split('').map((digit) {
    return _numbersToSegments[int.tryParse(convertBase(digit, 20, 10))];
  }).toList();
}

Map<String, dynamic> decodeMayaNumbers(List<String> inputs) {
  if (inputs == null || inputs.length == 0)
    return {
      'displays': <List<String>>[],
      'numbers': [0],
      'vigesimal': BigInt.zero
    };

  var oneCharacters = ['d', 'e', 'f', 'g'];
  var fiveCharacters = ['a', 'b', 'c'];

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
      if (fiveCharacters.contains(segment)) {
        number += 5;
        display.add(segment);
        return;
      }
      return;
    });

    displays.add(display);

    return number;
  }).toList();

  var total = convertBase(numbers.map((number) => convertBase(number.toString(), 10, 20)).join(), 20, 10);

  return {'displays': displays, 'numbers': numbers, 'vigesimal': BigInt.tryParse(total)};
}
