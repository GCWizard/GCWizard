
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class PrimaryPseudoPerfectNumbersNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBase(check, expr, _primary_pseudo_perfect_numbers);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBase(digits, _primary_pseudo_perfect_numbers);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBase(start, stop, _primary_pseudo_perfect_numbers);
  }
}

const List<String> _primary_pseudo_perfect_numbers = [
  '2',
  '6',
  '42',
  '1806',
  '47058',
  '2214502422',
  '52495396602',
  '8490421583559688410706771261086'
];
