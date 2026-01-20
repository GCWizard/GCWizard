import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceFactorialCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceFactorialCheckNumber({super.key})
      : super(mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialDigits extends NumberSequenceDigits {
  const NumberSequenceFactorialDigits({super.key})
      : super(mode: NumberSequencesMode.FACTORIAL, maxDigits: 1111);
}

class NumberSequenceFactorialRange extends NumberSequenceRange {
  const NumberSequenceFactorialRange({super.key})
      : super(mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceFactorialNthNumber({super.key})
      : super(mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceFactorialContainsDigits({super.key})
      : super(mode: NumberSequencesMode.FACTORIAL, maxIndex: 1111);
}
