import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePermutablePrimesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePermutablePrimesCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 23);
}

class NumberSequencePermutablePrimesDigits extends NumberSequenceDigits {
  const NumberSequencePermutablePrimesDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxDigits: 317);
}

class NumberSequencePermutablePrimesRange extends NumberSequenceRange {
  const NumberSequencePermutablePrimesRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 23);
}

class NumberSequencePermutablePrimesNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePermutablePrimesNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 23);
}

class NumberSequencePermutablePrimesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePermutablePrimesContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.PERMUTABLE_PRIMES, maxIndex: 23);
}
