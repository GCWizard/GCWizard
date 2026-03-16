import 'dart:isolate';
import 'dart:math';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class CatalanNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getCatalan);
  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBaseFunction(digits, _getCatalan);
  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }

  static BigInt _getCatalan(int n) {
    if (n == 0) return BigInt.one;

    try {
      return _getBinomialCoefficient(2 * n, n) ~/ (BigInt.from(n) + One);
    } catch (e) {
      return BigInt.from(-1);
    }
  }

  static BigInt _getBinomialCoefficient(int n, int k) {
    if (n == k) {
      return Zero;
    } else {
      return _getfactorial(n) ~/ _getfactorial(k) ~/ _getfactorial(n - k);
    }
  }

  static BigInt _getfactorial(int n) {
    if (n > 0) {
      return n <= 1 ? One : BigInt.from(n) * _getfactorial(n - 1);
    } else {
      return One;
    }
  }
}

