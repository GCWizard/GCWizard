import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePrimaryPseudoPerfectNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePrimaryPseudoPerfectNumbersCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxIndex: 7);
}

class NumberSequencePrimaryPseudoPerfectNumbersDigits extends NumberSequenceDigits {
  const NumberSequencePrimaryPseudoPerfectNumbersDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxDigits: 35);
}

class NumberSequencePrimaryPseudoPerfectNumbersRange extends NumberSequenceRange {
  const NumberSequencePrimaryPseudoPerfectNumbersRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxIndex: 7);
}

class NumberSequencePrimaryPseudoPerfectNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePrimaryPseudoPerfectNumbersNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxIndex: 7);
}

class NumberSequencePrimaryPseudoPerfectNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePrimaryPseudoPerfectNumbersContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS, maxIndex: 7);
}
