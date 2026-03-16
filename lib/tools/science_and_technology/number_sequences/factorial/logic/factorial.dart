
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class FactorialNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {

  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];
    BigInt number;

    BigInt index = BigInt.from(4);
    if (digits == 1) {
      numberList.add(One);
      numberList.add(Two);
      numberList.add(BigInt.from(6));
    }
    number = BigInt.from(6);
    while (number.toString().length < digits + 1) {
      number = number * index;
      if (number.toString().length == digits) numberList.add(number);
      index = index + One;
    }
    return numberList;
  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}