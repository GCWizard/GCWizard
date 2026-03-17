import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class MersenneNumberSequence extends BaseNumberSequence {
  const MersenneNumberSequence();

  @override
  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getMersenne);
  }

  @override
  static BigInt containsDigits(int n) {

  }

  @override
  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBaseFunction(digits, _getMersenne);
  }

  @override
  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }

  static BigInt _getMersenne(int n) {
    return Two.pow(n) - One;
  }
}