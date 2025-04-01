import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePerfectNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePerfectNumbersCheckNumber({super.key})
      : super(mode: NumberSequencesMode.PERFECT_NUMBERS, maxIndex: 11);
}

class NumberSequencePerfectNumbersDigits extends NumberSequenceDigits {
  const NumberSequencePerfectNumbersDigits({super.key})
      : super(mode: NumberSequencesMode.PERFECT_NUMBERS, maxDigits: 80);
}

class NumberSequencePerfectNumbersRange extends NumberSequenceRange {
  const NumberSequencePerfectNumbersRange({super.key})
      : super(mode: NumberSequencesMode.PERFECT_NUMBERS, maxIndex: 11);
}

class NumberSequencePerfectNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePerfectNumbersNthNumber({super.key})
      : super(mode: NumberSequencesMode.PERFECT_NUMBERS, maxIndex: 11);
}

class NumberSequencePerfectNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePerfectNumbersContainsDigits({super.key})
      : super(mode: NumberSequencesMode.PERFECT_NUMBERS, maxIndex: 11);
}
