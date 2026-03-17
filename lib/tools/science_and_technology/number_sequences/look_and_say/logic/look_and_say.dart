
import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class LookAndSayNumberSequence extends BaseNumberSequence {
  const LookAndSayNumberSequence();

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    int index = 0;
    String numberString = '';

    while (index <= maxIndex) {
      if (index == 0) {
        numberString = '1';
      } else {
        numberString = lookAndSay(numberString);
      }
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
  BigInt containsDigits(int n) {

  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];

    var numberString = '1';
    while (numberString.length < digits + 1) {
      if (numberString.length == digits) numberList.add(BigInt.parse(numberString));
      numberString = lookAndSay(numberString);
    }
    return numberList;
  }

  @override
  Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}

String lookAndSay(String str) {
  final regex = RegExp(r'(.)\1*');
  return str.replaceAllMapped(regex, (match) {
    final seq = match.group(0)!;
    final p1 = match.group(1)!;
    return '${seq.length}$p1';
  });
}