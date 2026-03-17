
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class MemorablePrimesIndexesNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, memorable_primes_indexes);
  }


  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, memorable_primes_indexes);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return calculateRangeBase(start, stop, memorable_primes_indexes);
  }
}


const List<String> memorable_primes_indexes = [
  '10',
  '2446',
];

