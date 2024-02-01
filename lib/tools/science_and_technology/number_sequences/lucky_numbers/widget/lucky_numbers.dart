import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLuckyNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceLuckyNumbersCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceLuckyNumbersDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.LUCKY_NUMBERS, maxDigits: 6);
}

class NumberSequenceLuckyNumbersRange extends NumberSequenceRange {
  const NumberSequenceLuckyNumbersRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceLuckyNumbersNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}

class NumberSequenceLuckyNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceLuckyNumbersContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.LUCKY_NUMBERS, maxIndex: 71917);
}
