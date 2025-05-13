import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePrimesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePrimesCheckNumber({super.key}) : super(mode: NumberSequencesMode.PRIMES, maxIndex: 664578);
}

class NumberSequencePrimesDigits extends NumberSequenceDigits {
  const NumberSequencePrimesDigits({super.key}) : super(mode: NumberSequencesMode.PRIMES, maxDigits: 7);
}

class NumberSequencePrimesRange extends NumberSequenceRange {
  const NumberSequencePrimesRange({super.key}) : super(mode: NumberSequencesMode.PRIMES, maxIndex: 664578);
}

class NumberSequencePrimesNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePrimesNthNumber({super.key}) : super(mode: NumberSequencesMode.PRIMES, maxIndex: 664578);
}

class NumberSequencePrimesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePrimesContainsDigits({super.key}) : super(mode: NumberSequencesMode.PRIMES, maxIndex: 664578);
}
