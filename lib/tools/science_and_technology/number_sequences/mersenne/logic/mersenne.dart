
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class MersenneNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getMersenne);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBaseFunction(digits, _getMersenne);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBaseFunction(start, stop, _getMersenne);
  }

  static BigInt _getMersenne(int n) {
    return BaseNumberSequence.Two.pow(n) - BaseNumberSequence.One;
  }
}