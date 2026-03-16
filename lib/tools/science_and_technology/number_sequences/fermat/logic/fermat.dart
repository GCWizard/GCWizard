import 'dart:isolate';
import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class FermatNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getFermat);
  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBaseFunction(digits, _getFermat);
  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }

  static BigInt _getFermat(int n) {
    return Two.pow(pow(2, n) as int) + One;
  }
}