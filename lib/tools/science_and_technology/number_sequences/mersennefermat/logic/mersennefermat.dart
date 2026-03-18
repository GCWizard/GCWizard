
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class MersenneFermatNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getMersenneFermat);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBaseFunction(digits, _getMersenneFermat);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBaseFunction(start, stop, _getMersenneFermat);
  }

  static BigInt _getMersenneFermat(int n) {
    return BaseNumberSequence.Two.pow(n) + BaseNumberSequence.One;
  }
}