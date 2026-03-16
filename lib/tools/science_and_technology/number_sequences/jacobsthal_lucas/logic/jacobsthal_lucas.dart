import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class JacobsthalLocasNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getJacobsthalLucas);
  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBaseFunction(digits, _getJacobsthalLucas);
  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }

  static BigInt _getJacobsthalLucas(int n) {
    return Two.pow(n) + BigInt.from(-1).pow(n);
  }
}