import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceBellCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceBellCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.BELL, maxIndex: 555);
}

class NumberSequenceBellDigits extends NumberSequenceDigits {
  const NumberSequenceBellDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.BELL, maxDigits: 1111);
}

class NumberSequenceBellRange extends NumberSequenceRange {
  const NumberSequenceBellRange({Key? key}) : super(key: key, mode: NumberSequencesMode.BELL, maxIndex: 555);
}

class NumberSequenceBellNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceBellNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.BELL, maxIndex: 555);
}

class NumberSequenceBellContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceBellContainsDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.BELL, maxIndex: 555);
}
