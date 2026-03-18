part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

List<BigInt> numberSequencesGetNumbersWithNDigits(NumberSequencesMode sequence, int? digits) {
  if (digits == null) return [];

  return NUMBERSEQUENCES[sequence]!.sequence.getNumbersWithNDigits(digits);
}
