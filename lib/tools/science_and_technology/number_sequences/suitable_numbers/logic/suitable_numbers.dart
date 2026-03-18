
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class SuitableNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBase(check, expr, _suitable_numbers);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBase(digits, _suitable_numbers);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBase(start, stop, _suitable_numbers);
  }
}

const List<String> _suitable_numbers = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '12',
  '13',
  '15',
  '16',
  '18',
  '21',
  '22',
  '24',
  '25',
  '28',
  '30',
  '33',
  '37',
  '40',
  '42',
  '45',
  '48',
  '57',
  '58',
  '60',
  '70',
  '72',
  '78',
  '85',
  '88',
  '93',
  '102',
  '105',
  '112',
  '120',
  '130',
  '133',
  '165',
  '168',
  '177',
  '190',
  '210',
  '232',
  '240',
  '253',
  '273',
  '280',
  '312',
  '330',
  '345',
  '357',
  '385',
  '408',
  '462',
  '520',
  '760',
  '840',
  '1320',
  '1365',
  '1848',
];
