import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePalindromePrimesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePalindromePrimesCheckNumber({super.key}) : super(mode: NumberSequencesMode.PALINDROME_PRIMES, maxIndex: 10000);
}

class NumberSequencePalindromePrimesDigits extends NumberSequenceDigits {
  const NumberSequencePalindromePrimesDigits({super.key}) : super(mode: NumberSequencesMode.PALINDROME_PRIMES, maxDigits: 11);
}

class NumberSequencePalindromePrimesRange extends NumberSequenceRange {
  const NumberSequencePalindromePrimesRange({super.key}) : super(mode: NumberSequencesMode.PALINDROME_PRIMES, maxIndex: 10000);
}

class NumberSequencePalindromePrimesNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePalindromePrimesNthNumber({super.key}) : super(mode: NumberSequencesMode.PALINDROME_PRIMES, maxIndex: 10000);
}

class NumberSequencePalindromePrimesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePalindromePrimesContainsDigits({super.key}) : super(mode: NumberSequencesMode.PALINDROME_PRIMES, maxIndex: 10000);
}
