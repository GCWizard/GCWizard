import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceRecamanCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceRecamanCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.RECAMAN, maxIndex: 11111);
}

class NumberSequenceRecamanDigits extends NumberSequenceDigits {
  const NumberSequenceRecamanDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.RECAMAN, maxDigits: 5);
}

class NumberSequenceRecamanRange extends NumberSequenceRange {
  const NumberSequenceRecamanRange({Key? key}) : super(key: key, mode: NumberSequencesMode.RECAMAN, maxIndex: 11111);
}

class NumberSequenceRecamanNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceRecamanNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.RECAMAN, maxIndex: 11111);
}

class NumberSequenceRecamanContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceRecamanContainsDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.RECAMAN, maxIndex: 1111);
}
