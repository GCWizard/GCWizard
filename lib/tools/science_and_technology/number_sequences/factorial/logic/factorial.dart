
import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class FactorialNumberSequence extends BaseNumberSequence {
  const FactorialNumberSequence();

  @override
  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    BigInt number = One;
    int index = 2;
    String numberString = '';

    if (check == Zero.toString()) {
      return PositionOfSequenceOutput('0', 0, 1);
    } else if (check == One.toString()) {
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
  static BigInt containsDigits(int n) {

  }

  @override
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

  @override
  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}