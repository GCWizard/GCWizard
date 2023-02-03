import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePermutablePrimesCheckNumber extends NumberSequenceCheckNumber {
  NumberSequencePermutablePrimesCheckNumber() : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 23);
}

class NumberSequencePermutablePrimesDigits extends NumberSequenceDigits {
  NumberSequencePermutablePrimesDigits() : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxDigits: 317);
}

class NumberSequencePermutablePrimesRange extends NumberSequenceRange {
  NumberSequencePermutablePrimesRange() : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 23);
}

class NumberSequencePermutablePrimesNthNumber extends NumberSequenceNthNumber {
  NumberSequencePermutablePrimesNthNumber() : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 23);
}

class NumberSequencePermutablePrimesContainsDigits extends NumberSequenceContainsDigits {
  NumberSequencePermutablePrimesContainsDigits() : super(mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 23);
}
