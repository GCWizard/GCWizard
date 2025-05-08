import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceBusyBeaverCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceBusyBeaverCheckNumber({super.key}) : super(mode: NumberSequencesMode.BUSY_BEAVER, maxIndex: 5);
}

class NumberSequenceBusyBeaverDigits extends NumberSequenceDigits {
  const NumberSequenceBusyBeaverDigits({super.key}) : super(mode: NumberSequencesMode.BUSY_BEAVER, maxDigits: 8);
}

class NumberSequenceBusyBeaverRange extends NumberSequenceRange {
  const NumberSequenceBusyBeaverRange({super.key}) : super(mode: NumberSequencesMode.BUSY_BEAVER, maxIndex: 5);
}

class NumberSequenceBusyBeaverNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceBusyBeaverNthNumber({super.key}) : super(mode: NumberSequencesMode.BUSY_BEAVER, maxIndex: 5);
}

class NumberSequenceBusyBeaverContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceBusyBeaverContainsDigits({super.key}) : super(mode: NumberSequencesMode.BUSY_BEAVER, maxIndex: 5);
}
