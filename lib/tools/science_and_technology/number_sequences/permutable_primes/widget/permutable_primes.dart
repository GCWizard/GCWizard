import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePermutablePrimesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePermutablePrimesCheckNumber({super.key})
      : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 25);
}

class NumberSequencePermutablePrimesDigits extends NumberSequenceDigits {
  const NumberSequencePermutablePrimesDigits({super.key})
      : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxDigits: 1031);
}

class NumberSequencePermutablePrimesRange extends NumberSequenceRange {
  const NumberSequencePermutablePrimesRange({super.key})
      : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 25);
}

class NumberSequencePermutablePrimesNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePermutablePrimesNthNumber({super.key})
      : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 25);
}

class NumberSequencePermutablePrimesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePermutablePrimesContainsDigits({super.key})
      : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 25);
}
