import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceWeirdNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceWeirdNumbersCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 34);
}

class NumberSequenceWeirdNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceWeirdNumbersDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.WEIRD_NUMBERS, maxDigits: 5);
}

class NumberSequenceWeirdNumbersRange extends NumberSequenceRange {
  const NumberSequenceWeirdNumbersRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 34);
}

class NumberSequenceWeirdNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceWeirdNumbersNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 34);
}

class NumberSequenceWeirdNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceWeirdNumbersContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.WEIRD_NUMBERS, maxIndex: 34);
}
