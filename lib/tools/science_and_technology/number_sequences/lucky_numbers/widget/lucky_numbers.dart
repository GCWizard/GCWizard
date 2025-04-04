import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLuckyNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceLuckyNumbersCheckNumber({super.key})
      : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceLuckyNumbersDigits({super.key})
      : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxDigits: 6);
}

class NumberSequenceLuckyNumbersRange extends NumberSequenceRange {
  const NumberSequenceLuckyNumbersRange({super.key})
      : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceLuckyNumbersNthNumber({super.key})
      : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceLuckyNumbersContainsDigits({super.key})
      : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}
