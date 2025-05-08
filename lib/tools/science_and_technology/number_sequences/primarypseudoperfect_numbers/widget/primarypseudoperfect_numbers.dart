import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePrimaryPseudoPerfectNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePrimaryPseudoPerfectNumbersCheckNumber({super.key})
      : super(mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxIndex: 8);
}

class NumberSequencePrimaryPseudoPerfectNumbersDigits extends NumberSequenceDigits {
  const NumberSequencePrimaryPseudoPerfectNumbersDigits({super.key})
      : super(mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxDigits: 31);
}

class NumberSequencePrimaryPseudoPerfectNumbersRange extends NumberSequenceRange {
  const NumberSequencePrimaryPseudoPerfectNumbersRange({super.key})
      : super(mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxIndex: 8);
}

class NumberSequencePrimaryPseudoPerfectNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePrimaryPseudoPerfectNumbersNthNumber({super.key})
      : super(mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxIndex: 8);
}

class NumberSequencePrimaryPseudoPerfectNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePrimaryPseudoPerfectNumbersContainsDigits({super.key})
      : super(mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxIndex: 8);
}
