import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class MemorablePrimesIndexesNumberSequence extends BaseNumberSequence {
  const MemorablePrimesIndexesNumberSequence();

  @override
  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, memorable_primes_indexes);
  }

  @override
  static BigInt containsDigits(int n) {

  }

  @override
  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, memorable_primes_indexes);
  }

  @override
  static Future<BigInt> calculateNumberAt(NumberSequencesMode sequence, int n, {SendPort? sendAsyncPort}) async {
    List<BigInt> result = await calculateRange(GetNumberRangeJobData(sequence: sequence, start: n, stop: n));


  }

  @override
  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}


const List<String> memorable_primes_indexes = [
  '10',
  '2446',
];

