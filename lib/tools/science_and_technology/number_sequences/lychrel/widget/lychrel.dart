import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLychrelCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceLychrelCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.LYCHREL, maxIndex: 246);
}

class NumberSequenceLychrelDigits extends NumberSequenceDigits {
  const NumberSequenceLychrelDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.LYCHREL, maxDigits: 4);
}

class NumberSequenceLychrelRange extends NumberSequenceRange {
  const NumberSequenceLychrelRange({Key? key}) : super(key: key, mode: NumberSequencesMode.LYCHREL, maxIndex: 246);
}

class NumberSequenceLychrelNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceLychrelNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.LYCHREL, maxIndex: 246);
}

class NumberSequenceLychrelContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceLychrelContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.LYCHREL, maxIndex: 246);
}
