
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class RecamanNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    int pn0 = 0;
    int number = 0;
    int index = 0;
    String numberString = '';
    List<int> recamanSequence = <int>[];

    maxIndex = 111111;
    recamanSequence.add(0);
    while (index <= maxIndex) {
      if (index == 0) {
        number = 0;
      } else if ((pn0 - index) > 0 && !recamanSequence.contains(pn0 - index)) {
        number = pn0 - index;
      } else {
        number = pn0 + index;
      }
      recamanSequence.add(number);
      pn0 = number;
      numberString = number.toString();
      if (expr.hasMatch(numberString)) {
        int j = 0;
        while (!numberString.substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(numberString, index + 1, j + 1);
      }
      index++;
    }
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];
    BigInt number;
    BigInt pn0 = BaseNumberSequence.Zero;
    List<BigInt> recamanSequence = <BigInt>[];

    for (int index = 0; index < 11111; index++) {
      if (index == 0) {
        number = BaseNumberSequence.Zero;
      } else if ((pn0 - BigInt.from(index)) > BaseNumberSequence.Zero && !recamanSequence.contains(pn0 - BigInt.from(index))) {
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

  @override
  List<BigInt> calculateRange(int start, int stop) {
    var numberList = <BigInt>[];
    List<BigInt> recamanSequence = <BigInt>[];
    BigInt number;
    BigInt pn0 = BaseNumberSequence.Zero;
    BigInt index = BaseNumberSequence.Zero;
    recamanSequence.add(BaseNumberSequence.Zero);
    index = BaseNumberSequence.Zero;

    while (index < BigInt.from(stop) + BaseNumberSequence.One) {
      if (index == BaseNumberSequence.Zero) {
        number = pn0;
      } else if ((pn0 - index) > BaseNumberSequence.Zero && !recamanSequence.contains(pn0 - index)) {
        number = pn0 - index;
      } else {
        number = pn0 + index;
      }
      recamanSequence.add(number);
      pn0 = number;
      if (index >= BigInt.from(start)) numberList.add(number);
      index = index + BaseNumberSequence.One;
    }
    return numberList;
  }
}