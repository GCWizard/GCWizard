
import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class PellLucasNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    BigInt pn0 = Two;
    BigInt pn1 = Two;
    BigInt number = pn1;
    int index = 2;
    String numberString = '';

    if (check == Two.toString()) {
      return PositionOfSequenceOutput('2', 0, 1);
    }
    while (index <= maxIndex) {
      number = Two * pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
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

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];
    BigInt number;

    BigInt pn0 = Two;
    BigInt pn1 = Two;
    if (digits == 1) {
      numberList.add(pn0);
      numberList.add(pn1);
    }
    number = pn1;
    while (number.toString().length < digits + 1) {
      number = Two * pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
      if (number.toString().length == digits) numberList.add(number);
    }
    return numberList;
  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}