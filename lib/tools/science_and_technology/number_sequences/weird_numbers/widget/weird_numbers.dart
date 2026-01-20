import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceWeirdNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceWeirdNumbersCheckNumber({super.key})
      : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 10000);
}

class NumberSequenceWeirdNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceWeirdNumbersDigits({super.key})
      : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxDigits: 7);
}

class NumberSequenceWeirdNumbersRange extends NumberSequenceRange {
  const NumberSequenceWeirdNumbersRange({super.key})
      : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 10000);
}

class NumberSequenceWeirdNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceWeirdNumbersNthNumber({super.key})
      : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 10000);
}

class NumberSequenceWeirdNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceWeirdNumbersContainsDigits({super.key})
      : super(mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 10000);
}
