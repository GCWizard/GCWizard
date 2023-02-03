import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

final Map<int, List<String>> _numbersToSegments = {
  0: ['a'],
  1: ['b'],
  2: ['b', 'c'],
  3: ['b', 'c', 'd'],
};

final Map<String, String> _numberToWord = {
  '0': 'GA',
  '1': 'BU',
  '2': 'ZO',
  '3': 'MEU',
};

final _wordToNumber = switchMapKeyValue(_numberToWord);

List<List<String>> encodeShadoksNumbers(int input) {
  if (input == null) return [];

  var quaternary = convertBase(input.toString(), 10, 4);
  return quaternary.split('').map((digit) {
    return _numbersToSegments[int.tryParse(convertBase(digit, 4, 10))];
  }).toList();
}

Map<String, dynamic> decodeShadoksNumbers(List<String> inputs) {
  if (inputs == null || inputs.length == 0)
    return {
      'displays': [
        ['a']
      ],
      'numbers': [0],
      'quaternary': BigInt.zero,
      'shadoks': _numberToWord['0']
    };

  var displays = <List<String>>[];

  List<int> numbers = inputs.where((input) => input != null).map((input) {
    var number = 0;

    if (input == 'a') {
      displays.add(['a']);
      number = 0;
    } else {
      displays.add(input.split('').toList());
      number = input.length;
    }

    return number;
  }).toList();

  var total = convertBase(numbers.map((number) => convertBase(number.toString(), 10, 4)).join(), 4, 10);

  return {'displays': displays, 'numbers': numbers, 'quaternary': BigInt.tryParse(total), 'shadoks': _shadoks(numbers)};
}

String _shadoks(List<int> numbers) {
  return numbers.join('').replaceAll('0', 'GA').replaceAll('1', 'BU').replaceAll('2', 'ZO').replaceAll('3', 'MEU');
}
