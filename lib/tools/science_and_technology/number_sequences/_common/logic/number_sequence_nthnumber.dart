part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

BigInt numberSequencesGetNumberAt(NumberSequencesMode sequence, int? n) {
  if (n == null) {
    return Zero;
  } else {
    return numberSequencesGetNumbersInRange(sequence, n, n)[0];
  }
}
