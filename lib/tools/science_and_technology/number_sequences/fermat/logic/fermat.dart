
import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class FermatNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getFermat);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBaseFunction(digits, _getFermat);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBaseFunction(start, stop, _getFermat);
  }

  static BigInt _getFermat(int n) {
    return BaseNumberSequence.Two.pow(pow(2, n) as int) + BaseNumberSequence.One;
  }
}