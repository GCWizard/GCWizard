import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class SublimeNumbersNumberSequence extends BaseNumberSequence {
  const SublimeNumbersNumberSequence();

  @override
  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, sublime_number);
  }

  @override
  static BigInt containsDigits(int n) {

  }

  @override
  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, sublime_number);
  }

  @override
  static Future<BigInt> calculateNumberAt(NumberSequencesMode sequence, int n, {SendPort? sendAsyncPort}) async {
    List<BigInt> result = await calculateRange(GetNumberRangeJobData(sequence: sequence, start: n, stop: n));


  }

  @override
  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}

const List<String> sublime_number = [
  '12',
  '6086555670238378989670371734243169622657830773351885970528324860512791691264'
];
