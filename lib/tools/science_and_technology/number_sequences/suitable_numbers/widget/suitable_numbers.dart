import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceSuitableNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceSuitableNumbersCheckNumber({super.key})
      : super(mode: NumberSequencesMode.SUITABLE_NUMBERS, maxIndex: 65);
}

class NumberSequenceSuitableNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceSuitableNumbersDigits({super.key})
      : super(mode: NumberSequencesMode.SUITABLE_NUMBERS, maxDigits: 65);
}

class NumberSequenceSuitableNumbersRange extends NumberSequenceRange {
  const NumberSequenceSuitableNumbersRange({super.key})
      : super(mode: NumberSequencesMode.SUITABLE_NUMBERS, maxIndex: 65);
}

class NumberSequenceSuitableNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceSuitableNumbersNthNumber({super.key})
      : super(mode: NumberSequencesMode.SUITABLE_NUMBERS, maxIndex: 65);
}

class NumberSequenceSuitableNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceSuitableNumbersContainsDigits({super.key})
      : super(mode: NumberSequencesMode.SUITABLE_NUMBERS, maxIndex: 65);
}
