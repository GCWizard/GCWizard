
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class FactorialNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    BigInt number = BaseNumberSequence.One;
    int index = 2;
    String numberString = '';

    if (check == BaseNumberSequence.Zero.toString()) {
      return PositionOfSequenceOutput('0', 0, 1);
    } else if (check == BaseNumberSequence.One.toString()) {
      return PositionOfSequenceOutput('1', 1, 1);
    } else {
      while (index <= maxIndex) {
        number = number * BigInt.from(index);
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
    }
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];
    BigInt number;
    BigInt index = BigInt.from(4);

    if (digits == 1) {
      numberList.add(BaseNumberSequence.One);
      numberList.add(BaseNumberSequence.Two);
      numberList.add(BigInt.from(6));
    }
    number = BigInt.from(6);
    while (number.toString().length < digits + 1) {
      number = number * index;
      if (number.toString().length == digits) numberList.add(number);
      index = index + BaseNumberSequence.One;
    }
    return numberList;
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    var numberList = <BigInt>[];
    var number = BigInt.zero;
    int index = 0;

    while (index < stop + 1) {
      if (index == 0) {
        number = BaseNumberSequence.One;
      } else if (index == 1) {
        number = BaseNumberSequence.One;
      } else {
        number = number * BigInt.from(index);
      }
      if (index >= start) numberList.add(number);
      index++;
    }
    return numberList;
  }
}