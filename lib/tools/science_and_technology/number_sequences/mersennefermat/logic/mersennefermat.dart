import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class MersenneFermatNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getMersenneFermat);
  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBaseFunction(digits, _getMersenneFermat);
  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }

  static BigInt _getMersenneFermat(int n) {
    return Two.pow(n) + One;
  }
}