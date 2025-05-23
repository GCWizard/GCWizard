import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceSuperPerfectNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceSuperPerfectNumbersCheckNumber({super.key})
      : super(mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxIndex: 9);
}

class NumberSequenceSuperPerfectNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceSuperPerfectNumbersDigits({super.key})
      : super(mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxDigits: 19);
}

class NumberSequenceSuperPerfectNumbersRange extends NumberSequenceRange {
  const NumberSequenceSuperPerfectNumbersRange({super.key})
      : super(mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxIndex: 9);
}

class NumberSequenceSuperPerfectNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceSuperPerfectNumbersNthNumber({super.key})
      : super(mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxIndex: 9);
}

class NumberSequenceSuperPerfectNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceSuperPerfectNumbersContainsDigits({super.key})
      : super(mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxIndex: 9);
}
