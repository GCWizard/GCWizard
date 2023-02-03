import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceSublimeNumbersCheckNumber extends NumberSequenceCheckNumber {
  NumberSequenceSublimeNumbersCheckNumber() : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxIndex: 1);
}

class NumberSequenceSublimeNumbersDigits extends NumberSequenceDigits {
  NumberSequenceSublimeNumbersDigits() : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxDigits: 80);
}

class NumberSequenceSublimeNumbersRange extends NumberSequenceRange {
  NumberSequenceSublimeNumbersRange() : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxIndex: 1);
}

class NumberSequenceSublimeNumbersNthNumber extends NumberSequenceNthNumber {
  NumberSequenceSublimeNumbersNthNumber() : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxIndex: 1);
}

class NumberSequenceSublimeNumbersContainsDigits extends NumberSequenceContainsDigits {
  NumberSequenceSublimeNumbersContainsDigits() : super(mode: NumberSequencesMode.SUBLIME_NUMBERS, maxIndex: 1);
}
