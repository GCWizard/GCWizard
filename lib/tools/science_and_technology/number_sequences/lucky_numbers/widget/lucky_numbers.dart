import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLuckyNumbersCheckNumber extends NumberSequenceCheckNumber {
  NumberSequenceLuckyNumbersCheckNumber() : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersDigits extends NumberSequenceDigits {
  NumberSequenceLuckyNumbersDigits() : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxDigits: 6);
}

class NumberSequenceLuckyNumbersRange extends NumberSequenceRange {
  NumberSequenceLuckyNumbersRange() : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersNthNumber extends NumberSequenceNthNumber {
  NumberSequenceLuckyNumbersNthNumber() : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersContainsDigits extends NumberSequenceContainsDigits {
  NumberSequenceLuckyNumbersContainsDigits() : super(mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}
