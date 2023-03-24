import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMersenneFermatCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMersenneFermatCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_FERMAT, maxIndex: 111111);
}

class NumberSequenceMersenneFermatDigits extends NumberSequenceDigits {
  const NumberSequenceMersenneFermatDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_FERMAT, maxDigits: 1111);
}

class NumberSequenceMersenneFermatRange extends NumberSequenceRange {
  const NumberSequenceMersenneFermatRange({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_FERMAT, maxIndex: 111111);
}

class NumberSequenceMersenneFermatNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMersenneFermatNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_FERMAT, maxIndex: 111111);
}

class NumberSequenceMersenneFermatContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMersenneFermatContainsDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE_FERMAT, maxIndex: 11111);
}
