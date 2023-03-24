import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMersennePrimesCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMersennePrimesCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_PRIMES, maxIndex: 18);
}

class NumberSequenceMersennePrimesDigits extends NumberSequenceDigits {
  const NumberSequenceMersennePrimesDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_PRIMES, maxDigits: 39);
}

class NumberSequenceMersennePrimesRange extends NumberSequenceRange {
  const NumberSequenceMersennePrimesRange({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_PRIMES, maxIndex: 18);
}

class NumberSequenceMersennePrimesNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMersennePrimesNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_PRIMES, maxIndex: 18);
}

class NumberSequenceMersennePrimesContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMersennePrimesContainsDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_PRIMES, maxIndex: 18);
}
