
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/jacobsthal/logic/jacobsthal.dart';

class JacobsthalOblongNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getJacobsthalOblong);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBaseFunction(digits, _getJacobsthalOblong);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBaseFunction(start, stop, _getJacobsthalOblong);
  }

  static BigInt _getJacobsthalOblong(int n) {
    return JacobsthalNumberSequence.getJacobsthal(n) * JacobsthalNumberSequence.getJacobsthal(n + 1);
  }
}