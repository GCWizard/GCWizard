
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class PermutablePrimesNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBase(check, expr, _permutable_primes);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBase(digits, _permutable_primes);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBase(start, stop, _permutable_primes);
  }
}

final List<String> _permutable_primes = [
  '2',
  '3',
  '5',
  '7',
  '11',
  '13',
  '17',
  '31',
  '71',
  '73',
  '79',
  '97',
  '113',
  '131',
  '199',
  '311',
  '337',
  '373',
  '733',
  '919',
  '991',
  '1111111111111111111',
  '11111111111111111111111',
  '1' * 317,
  '1' * 1031,
];
