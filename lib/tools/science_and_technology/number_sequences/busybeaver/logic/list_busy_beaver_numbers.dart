import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class BusyBeaverNumberSequence extends BaseNumberSequence {
  const BusyBeaverNumberSequence();

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, busy_beaver_numbers);
  }

  @override
  BigInt containsDigits(int n) {

  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, busy_beaver_numbers);
  }

  @override
  Future<BigInt> calculateNumberAt(NumberSequencesMode sequence, int n, {SendPort? sendAsyncPort}) async {
    List<BigInt> result = await calculateRange(GetNumberRangeJobData(sequence: sequence, start: n, stop: n));


  }

  @override
  Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}

const List<String> busy_beaver_numbers = [
  '1',
  '6',
  '21',
  '107',
  '47176870',
];
