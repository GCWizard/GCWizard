import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceWeirdNumbersCheckNumber extends NumberSequenceCheckNumber {
  NumberSequenceWeirdNumbersCheckNumber() : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 34);
}

class NumberSequenceWeirdNumbersDigits extends NumberSequenceDigits {
  NumberSequenceWeirdNumbersDigits() : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxDigits: 5);
}

class NumberSequenceWeirdNumbersRange extends NumberSequenceRange {
  NumberSequenceWeirdNumbersRange() : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 34);
}

class NumberSequenceWeirdNumbersNthNumber extends NumberSequenceNthNumber {
  NumberSequenceWeirdNumbersNthNumber() : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 34);
}

class NumberSequenceWeirdNumbersContainsDigits extends NumberSequenceContainsDigits {
  NumberSequenceWeirdNumbersContainsDigits() : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 34);
}
