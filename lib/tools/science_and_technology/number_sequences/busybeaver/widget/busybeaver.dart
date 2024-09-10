import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceBusyBeaverCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceBusyBeaverCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.BUSY_BEAVER, maxIndex: 4);
}

class NumberSequenceBusyBeaverDigits extends NumberSequenceDigits {
  const NumberSequenceBusyBeaverDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.BUSY_BEAVER, maxDigits: 8);
}

class NumberSequenceBusyBeaverRange extends NumberSequenceRange {
  const NumberSequenceBusyBeaverRange({Key? key}) : super(key: key, mode: NumberSequencesMode.BUSY_BEAVER, maxIndex: 4);
}

class NumberSequenceBusyBeaverNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceBusyBeaverNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.BUSY_BEAVER, maxIndex: 4);
}

class NumberSequenceBusyBeaverContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceBusyBeaverContainsDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.BUSY_BEAVER, maxIndex: 4);
}
