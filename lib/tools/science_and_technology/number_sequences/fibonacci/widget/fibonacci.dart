import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceFibonacciCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceFibonacciCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.FIBONACCI, maxIndex: 111111);
}

class NumberSequenceFibonacciDigits extends NumberSequenceDigits {
  const NumberSequenceFibonacciDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.FIBONACCI, maxDigits: 1111);
}

class NumberSequenceFibonacciRange extends NumberSequenceRange {
  const NumberSequenceFibonacciRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.FIBONACCI, maxIndex: 111111);
}

class NumberSequenceFibonacciNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceFibonacciNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.FIBONACCI, maxIndex: 111111);
}

class NumberSequenceFibonacciContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceFibonacciContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.FIBONACCI, maxIndex: 1111);
}
