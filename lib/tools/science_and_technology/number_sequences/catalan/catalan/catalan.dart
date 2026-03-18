
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class CatalanNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBaseFunction(check, maxIndex, _getCatalan);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBaseFunction(digits, _getCatalan);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBaseFunction(start, stop, _getCatalan);
  }

  static BigInt _getCatalan(int n) {
    if (n == 0) return BaseNumberSequence.One;

    try {
      return _getBinomialCoefficient(2 * n, n) ~/ (BigInt.from(n) + BaseNumberSequence.One);
    } catch (e) {
      return BigInt.from(-1);
    }
  }

  static BigInt _getBinomialCoefficient(int n, int k) {
    if (n == k) {
      return BaseNumberSequence.Zero;
    } else {
      return _getfactorial(n) ~/ _getfactorial(k) ~/ _getfactorial(n - k);
    }
  }

  static BigInt _getfactorial(int n) {
    if (n > 0) {
      return n <= 1 ? BaseNumberSequence.One : BigInt.from(n) * _getfactorial(n - 1);
    } else {
      return BaseNumberSequence.One;
    }
  }
}

