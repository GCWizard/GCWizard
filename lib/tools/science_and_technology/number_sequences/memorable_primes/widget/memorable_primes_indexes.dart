import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMemorablePrimesIndexesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMemorablePrimesIndexesCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxIndex: 1);
}

class NumberSequenceMemorablePrimesIndexesDigits extends NumberSequenceDigits {
  const NumberSequenceMemorablePrimesIndexesDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxDigits: 4);
}

class NumberSequenceMemorablePrimesIndexesRange extends NumberSequenceRange {
  const NumberSequenceMemorablePrimesIndexesRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxIndex: 1);
}

class NumberSequenceMemorablePrimesIndexesNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMemorablePrimesIndexesNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxIndex: 1);
}

class NumberSequenceMemorablePrimesIndexesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMemorablePrimesIndexesContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.MEMORABLE_PRIMES_INDEXES, maxIndex: 1);
}
