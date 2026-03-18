
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class SuperPerfectNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBase(check, expr, _superperfect_numbers);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBase(digits, _superperfect_numbers);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBase(start, stop, _superperfect_numbers);
  }
}

const List<String> _superperfect_numbers = [
  '2',
  '4',
  '16',
  '64',
  '4096',
  '65536',
  '262144',
  '1073741824',
  '1152921504606846976'
];
