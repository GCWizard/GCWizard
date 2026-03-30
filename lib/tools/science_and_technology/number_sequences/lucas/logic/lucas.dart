
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class LucasNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    BigInt pn0 = BaseNumberSequence.Two;
    BigInt pn1 = BaseNumberSequence.One;
    BigInt number = BaseNumberSequence.Three;
    int index = 1;
    String numberString = '';

    if (check == BaseNumberSequence.Two.toString()) {
      return PositionOfSequenceOutput('2', 0, 1);
    } else if (check == BaseNumberSequence.One.toString()) {
      return PositionOfSequenceOutput('1', 1, 1);
    } else {
      while (index <= maxIndex) {
        numberString = number.toString();
        if (expr.hasMatch(numberString)) {
          int j = 0;
          while (!numberString.substring(j).startsWith(check)) {
            j++;
          }
          return PositionOfSequenceOutput(numberString, index + 1, j + 1);
        }
        index++;
        number = pn1 + pn0;
        pn0 = pn1;
        pn1 = number;
      }
    }
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];
    BigInt number;
    BigInt pn0 = BaseNumberSequence.Two;
    BigInt pn1 = BaseNumberSequence.One;

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

  @override
  List<BigInt> calculateRange(int start, int stop) {
    var numberList = <BigInt>[];
    BigInt number;
    BigInt pn0 = BaseNumberSequence.Two;
    BigInt pn1 = BaseNumberSequence.One;
    int index = 0;

    while (index <= stop) {
      if (index == 0) {
        number = pn0;
      } else if (index == 1) {
        number = pn1;
      } else {
        number = pn0 + pn1;
        pn0 = pn1;
        pn1 = number;
      }
      if (index >= start) numberList.add(number);
      index = index + 1;
    }
    return numberList;
  }
}