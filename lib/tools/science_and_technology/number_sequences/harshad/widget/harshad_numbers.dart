import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceHarshadNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceHarshadNumbersCheckNumber({super.key}) : super(mode: NumberSequencesMode.HARSHAD, maxIndex: 11872);
}

class NumberSequenceHarshadNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceHarshadNumbersDigits({super.key}) : super(mode: NumberSequencesMode.HARSHAD, maxDigits: 6);
}

class NumberSequenceHarshadNumbersRange extends NumberSequenceRange {
  const NumberSequenceHarshadNumbersRange({super.key}) : super(mode: NumberSequencesMode.HARSHAD, maxIndex: 11872);
}

class NumberSequenceHarshadNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceHarshadNumbersNthNumber({super.key}) : super(mode: NumberSequencesMode.HARSHAD, maxIndex: 11872);
}

class NumberSequenceHarshadNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceHarshadNumbersContainsDigits({super.key}) : super(mode: NumberSequencesMode.HARSHAD, maxIndex: 11872);
}
