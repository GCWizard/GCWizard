import 'dart:isolate';

import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class PrimaryPseudoPerfectNumbersNumberSequence extends BaseNumberSequence {
  const PrimaryPseudoPerfectNumbersNumberSequence();

  @override
  static PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, primary_pseudo_perfect_numbers);
  }

  @override
  static BigInt containsDigits(int n) {

  }

  @override
  static List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, primary_pseudo_perfect_numbers);
  }

  @override
  static Future<BigInt> calculateNumberAt(NumberSequencesMode sequence, int n, {SendPort? sendAsyncPort}) async {
    List<BigInt> result = await calculateRange(GetNumberRangeJobData(sequence: sequence, start: n, stop: n));


  }

  @override
  static Future<List<BigInt>> calculateRange(GetNumberRangeJobData data, {SendPort? sendAsyncPort}) async {

  }
}

const List<String> primary_pseudo_perfect_numbers = [
  '2',
  '6',
  '42',
  '1806',
  '47058',
  '2214502422',
  '52495396602',
  '8490421583559688410706771261086'
];
