import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePrimesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePrimesCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.PRIMES, maxIndex: 10000000);
}

class NumberSequencePrimesDigits extends NumberSequenceDigits {
  const NumberSequencePrimesDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.PRIMES, maxDigits: 7);
}

class NumberSequencePrimesRange extends NumberSequenceRange {
  const NumberSequencePrimesRange({Key? key}) : super(key: key, mode: NumberSequencesMode.PRIMES, maxIndex: 10000000);
}

class NumberSequencePrimesNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePrimesNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.PRIMES, maxIndex: 10000000);
}

class NumberSequencePrimesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePrimesContainsDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.PRIMES, maxIndex: 10000000);
}
