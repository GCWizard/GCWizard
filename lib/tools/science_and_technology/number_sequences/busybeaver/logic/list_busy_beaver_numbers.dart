import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class BusyBeaverNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, busy_beaver_numbers);
  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {

  }

  static Future<BigInt> calculateNumberAt(NumberSequencesMode sequence, int n, {SendPort? sendAsyncPort}) async {
    List<BigInt> result = await calculateRange(GetNumberRangeJobData(sequence: sequence, start: n, stop: n));


  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}

const List<String> busy_beaver_numbers = [
  '1',
  '6',
  '21',
  '107',
  '47176870',
];
