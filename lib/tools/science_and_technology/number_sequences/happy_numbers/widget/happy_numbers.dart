import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceHappyNumbersCheckNumber extends NumberSequenceCheckNumber {
  NumberSequenceHappyNumbersCheckNumber() : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 142);
}

class NumberSequenceHappyNumbersDigits extends NumberSequenceDigits {
  NumberSequenceHappyNumbersDigits() : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxDigits: 4);
}

class NumberSequenceHappyNumbersRange extends NumberSequenceRange {
  NumberSequenceHappyNumbersRange() : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 142);
}

class NumberSequenceHappyNumbersNthNumber extends NumberSequenceNthNumber {
  NumberSequenceHappyNumbersNthNumber() : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 142);
}

class NumberSequenceHappyNumbersContainsDigits extends NumberSequenceContainsDigits {
  NumberSequenceHappyNumbersContainsDigits() : super(mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 142);
}
