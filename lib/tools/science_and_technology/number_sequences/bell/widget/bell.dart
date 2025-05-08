import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceBellCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceBellCheckNumber({super.key}) : super(mode: NumberSequencesMode.BELL, maxIndex: 1001);
}

class NumberSequenceBellDigits extends NumberSequenceDigits {
  const NumberSequenceBellDigits({super.key}) : super(mode: NumberSequencesMode.BELL, maxDigits: 1928);
}

class NumberSequenceBellRange extends NumberSequenceRange {
  const NumberSequenceBellRange({super.key}) : super(mode: NumberSequencesMode.BELL, maxIndex: 1001);
}

class NumberSequenceBellNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceBellNthNumber({super.key}) : super(mode: NumberSequencesMode.BELL, maxIndex: 1001);
}

class NumberSequenceBellContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceBellContainsDigits({super.key}) : super(mode: NumberSequencesMode.BELL, maxIndex: 1001);
}
