import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMemorablePrimesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMemorablePrimesCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES, maxIndex: 1);
}

class NumberSequenceMemorablePrimesDigits extends NumberSequenceDigits {
  const NumberSequenceMemorablePrimesDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES, maxDigits: 17350);
}

class NumberSequenceMemorablePrimesRange extends NumberSequenceRange {
  const NumberSequenceMemorablePrimesRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES, maxIndex: 1);
}

class NumberSequenceMemorablePrimesNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMemorablePrimesNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES, maxIndex: 1);
}

class NumberSequenceMemorablePrimesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMemorablePrimesContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES, maxIndex: 1);
}
