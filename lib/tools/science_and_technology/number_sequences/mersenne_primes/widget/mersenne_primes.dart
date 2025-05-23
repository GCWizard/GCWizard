import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMersennePrimesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMersennePrimesCheckNumber({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_PRIMES, maxIndex: 19);
}

class NumberSequenceMersennePrimesDigits extends NumberSequenceDigits {
  const NumberSequenceMersennePrimesDigits({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_PRIMES, maxDigits: 1281);
}

class NumberSequenceMersennePrimesRange extends NumberSequenceRange {
  const NumberSequenceMersennePrimesRange({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_PRIMES, maxIndex: 19);
}

class NumberSequenceMersennePrimesNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMersennePrimesNthNumber({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_PRIMES, maxIndex: 19);
}

class NumberSequenceMersennePrimesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMersennePrimesContainsDigits({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_PRIMES, maxIndex: 19);
}
