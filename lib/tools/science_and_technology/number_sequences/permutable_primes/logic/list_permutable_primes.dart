import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class PermutablePrimesNumberSequence extends BaseNumberSequence {

  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, permutable_primes);
  }

  static BigInt containsDigits(int n) {

  }

  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, permutable_primes);
  }

  static Future<BigInt> calculateNumberAt(NumberSequencesMode sequence, int n, {SendPort? sendAsyncPort}) async {
    List<BigInt> result = await calculateRange(GetNumberRangeJobData(sequence: sequence, start: n, stop: n));


  }

  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}

List<String> permutable_primes = [
  '2',
  '3',
  '5',
  '7',
  '11',
  '13',
  '17',
  '31',
  '71',
  '73',
  '79',
  '97',
  '113',
  '131',
  '199',
  '311',
  '337',
  '373',
  '733',
  '919',
  '991',
  '1111111111111111111',
  '11111111111111111111111',
  '1' * 317,
  '1' * 1031,
];
