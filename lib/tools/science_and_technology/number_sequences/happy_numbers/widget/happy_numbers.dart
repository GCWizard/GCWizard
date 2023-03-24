import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceHappyNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceHappyNumbersCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 142);
}

class NumberSequenceHappyNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceHappyNumbersDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.HAPPY_NUMBERS, maxDigits: 4);
}

class NumberSequenceHappyNumbersRange extends NumberSequenceRange {
  const NumberSequenceHappyNumbersRange({Key? key}) : super(key: key, mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 142);
}

class NumberSequenceHappyNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceHappyNumbersNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 142);
}

class NumberSequenceHappyNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceHappyNumbersContainsDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.HAPPY_NUMBERS, maxIndex: 142);
}
