
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class JacobsthalNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBaseFunction(check, maxIndex, getJacobsthal);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBaseFunction(digits, getJacobsthal);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBaseFunction(start, stop, getJacobsthal);
  }

  static BigInt getJacobsthal(int n) {
    return (BaseNumberSequence.Two.pow(n) - BigInt.from(-1).pow(n)) ~/ BaseNumberSequence.Three;
  }
}