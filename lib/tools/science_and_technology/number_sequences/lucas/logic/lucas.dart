
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class LucasNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {

  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];
    BigInt number;

    BigInt pn0 = Two;
    BigInt pn1 = One;
    if (digits == 1) {
      numberList.add(pn0);
      numberList.add(pn1);
    }
    number = pn1;
    while (number.toString().length < digits + 1) {
      number = pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
      if (number.toString().length == digits) numberList.add(number);
    }
    return numberList;
  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}