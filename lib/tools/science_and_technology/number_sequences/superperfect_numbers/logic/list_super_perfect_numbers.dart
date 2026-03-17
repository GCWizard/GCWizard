import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class SuperPerfectNumberSequence extends BaseNumberSequence {
  const SuperPerfectNumberSequence();

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, superperfect_numbers);
  }

  @override
  BigInt containsDigits(int n) {

  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, superperfect_numbers);
  }

  @override
  Future<BigInt> calculateNumberAt(NumberSequencesMode sequence, int n, {SendPort? sendAsyncPort}) async {
    List<BigInt> result = await calculateRange(GetNumberRangeJobData(sequence: sequence, start: n, stop: n));


  }

  @override
  Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}

const List<String> superperfect_numbers = [
  '2',
  '4',
  '16',
  '64',
  '4096',
  '65536',
  '262144',
  '1073741824',
  '1152921504606846976'
];
