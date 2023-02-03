import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceFactorialCheckNumber extends NumberSequenceCheckNumber {
  NumberSequenceFactorialCheckNumber() : super(mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialDigits extends NumberSequenceDigits {
  NumberSequenceFactorialDigits() : super(mode: NumberSequencesMode.FACTORIAL, maxDigits: 1111);
}

class NumberSequenceFactorialRange extends NumberSequenceRange {
  NumberSequenceFactorialRange() : super(mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialNthNumber extends NumberSequenceNthNumber {
  NumberSequenceFactorialNthNumber() : super(mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialContainsDigits extends NumberSequenceContainsDigits {
  NumberSequenceFactorialContainsDigits() : super(mode: NumberSequencesMode.FACTORIAL, maxIndex: 1111);
}
