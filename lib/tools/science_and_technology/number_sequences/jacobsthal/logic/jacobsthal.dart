
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class JacobsthalNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBaseFunction(check, maxIndex, getJacobsthal);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBaseFunction(digits, getJacobsthal);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return calculateRangeBaseFunction(start, stop, getJacobsthal);
  }

  static BigInt getJacobsthal(int n) {
    return (Two.pow(n) - BigInt.from(-1).pow(n)) ~/ Three;
  }
}