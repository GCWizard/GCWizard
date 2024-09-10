import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceFactorialCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceFactorialCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialDigits extends NumberSequenceDigits {
  const NumberSequenceFactorialDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.FACTORIAL, maxDigits: 1111);
}

class NumberSequenceFactorialRange extends NumberSequenceRange {
  const NumberSequenceFactorialRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceFactorialNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.FACTORIAL, maxIndex: 11111);
}

class NumberSequenceFactorialContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceFactorialContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.FACTORIAL, maxIndex: 1111);
}
