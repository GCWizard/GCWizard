import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceSuperPerfectNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceSuperPerfectNumbersCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxIndex: 8);
}

class NumberSequenceSuperPerfectNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceSuperPerfectNumbersDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxDigits: 8);
}

class NumberSequenceSuperPerfectNumbersRange extends NumberSequenceRange {
  const NumberSequenceSuperPerfectNumbersRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxIndex: 8);
}

class NumberSequenceSuperPerfectNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceSuperPerfectNumbersNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxIndex: 8);
}

class NumberSequenceSuperPerfectNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceSuperPerfectNumbersContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.SUPERPERFECT_NUMBERS, maxIndex: 8);
}
