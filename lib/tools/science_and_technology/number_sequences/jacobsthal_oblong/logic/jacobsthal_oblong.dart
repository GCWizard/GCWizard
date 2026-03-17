import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/jacobsthal/logic/jacobsthal.dart';

class JacobsthalOblongNumberSequence extends BaseNumberSequence {
  const JacobsthalOblongNumberSequence();

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getJacobsthalOblong);
  }

  @override
  BigInt containsDigits(int n) {

  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBaseFunction(digits, _getJacobsthalOblong);
  }

  @override
  Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }

  @override
  static BigInt _getJacobsthalOblong(int n) {
    return JacobsthalNumberSequence.getJacobsthal(n) * JacobsthalNumberSequence.getJacobsthal(n + 1);
  }
}