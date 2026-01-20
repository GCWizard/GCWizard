import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMemorablePrimesIndexesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMemorablePrimesIndexesCheckNumber({super.key})
      : super(mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxIndex: 2);
}

class NumberSequenceMemorablePrimesIndexesDigits extends NumberSequenceDigits {
  const NumberSequenceMemorablePrimesIndexesDigits({super.key})
      : super(mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxDigits: 4);
}

class NumberSequenceMemorablePrimesIndexesRange extends NumberSequenceRange {
  const NumberSequenceMemorablePrimesIndexesRange({super.key})
      : super(mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxIndex: 2);
}

class NumberSequenceMemorablePrimesIndexesNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMemorablePrimesIndexesNthNumber({super.key})
      : super(mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxIndex: 2);
}

class NumberSequenceMemorablePrimesIndexesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMemorablePrimesIndexesContainsDigits({super.key})
      : super(mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxIndex: 2);
}
