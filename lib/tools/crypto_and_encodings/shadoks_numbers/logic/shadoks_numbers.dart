import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/tools/science_and_technology/segment_display/_common/logic/segment_display.dart';

class ShadocksOutput extends Segments {
  List<int> numbers;
  BigInt quaternary;
  String shadoks;

  ShadocksOutput(List<List<String>> displays, this.numbers, this.quaternary, this.shadoks) : super(displays: displays);
}

const Map<int, List<String>> _numbersToSegments = {
  0: ['a'],
  1: ['b'],
  2: ['b', 'c'],
  3: ['b', 'c', 'd'],
};

const Map<String, String> _numberToWord = {
  '0': 'GA',
  '1': 'BU',
  '2': 'ZO',
  '3': 'MEU',
};

Segments encodeShadoksNumbers(int? input) {
  if (input == null) return Segments.Empty();

  var quaternary = convertBase(input.toString(), 10, 4);
  var result = quaternary.split('').map((digit) {
    return _numbersToSegments[int.tryParse(convertBase(digit, 4, 10)) ?? 0]!;
  }).toList();
  return Segments(displays: result);
}

ShadocksOutput decodeShadoksNumbers(List<String>? inputs) {
  if (inputs == null || inputs.isEmpty) {
    return ShadocksOutput([
      ['a']
    ], [
      0
    ], BigInt.zero, _numberToWord['0']!);
  }

  var displays = <List<String>>[];

  List<int> numbers = inputs.map((input) {
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

  return ShadocksOutput(displays, numbers, BigInt.tryParse(total) ?? BigInt.zero, _shadoks(numbers));
}

String _shadoks(List<int> numbers) {
  return numbers.join('').replaceAll('0', 'GA').replaceAll('1', 'BU').replaceAll('2', 'ZO').replaceAll('3', 'MEU');
}
