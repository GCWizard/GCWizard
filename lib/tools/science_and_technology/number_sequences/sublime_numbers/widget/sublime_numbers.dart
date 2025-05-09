import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceSublimeNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceSublimeNumbersCheckNumber({super.key})
      : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxIndex: 2);
}

class NumberSequenceSublimeNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceSublimeNumbersDigits({super.key})
      : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxDigits: 76);
}

class NumberSequenceSublimeNumbersRange extends NumberSequenceRange {
  const NumberSequenceSublimeNumbersRange({super.key})
      : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxIndex: 2);
}

class NumberSequenceSublimeNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceSublimeNumbersNthNumber({super.key})
      : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxIndex: 2);
}

class NumberSequenceSublimeNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceSublimeNumbersContainsDigits({super.key})
      : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxIndex: 2);
}
