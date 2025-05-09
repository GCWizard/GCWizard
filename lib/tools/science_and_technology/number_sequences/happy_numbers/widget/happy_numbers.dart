import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceHappyNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceHappyNumbersCheckNumber({super.key})
      : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 100000);
}

class NumberSequenceHappyNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceHappyNumbersDigits({super.key})
      : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxDigits: 6);
}

class NumberSequenceHappyNumbersRange extends NumberSequenceRange {
  const NumberSequenceHappyNumbersRange({super.key})
      : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 100000);
}

class NumberSequenceHappyNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceHappyNumbersNthNumber({super.key})
      : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 100000);
}

class NumberSequenceHappyNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceHappyNumbersContainsDigits({super.key})
      : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 100000);
}
