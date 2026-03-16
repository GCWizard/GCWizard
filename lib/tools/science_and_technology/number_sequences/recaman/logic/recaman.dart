
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class RecamanNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {

  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];
    BigInt number;

    BigInt pn0 = Zero;
    List<BigInt> recamanSequence = <BigInt>[];
    for (int index = 0; index < 11111; index++) {
      if (index == 0) {
        number = Zero;
      } else if ((pn0 - BigInt.from(index)) > Zero && !recamanSequence.contains(pn0 - BigInt.from(index))) {
        number = pn0 - BigInt.from(index);
      } else {
        number = pn0 + BigInt.from(index);
      }
      recamanSequence.add(number);
      pn0 = number;
      if (number.toString().length == digits) numberList.add(number);
    }
    return numberList;
  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}