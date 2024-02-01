import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMersenneExponentsCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMersenneExponentsCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxIndex: 50);
}

class NumberSequenceMersenneExponentsDigits extends NumberSequenceDigits {
  const NumberSequenceMersenneExponentsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxDigits: 8);
}

class NumberSequenceMersenneExponentsRange extends NumberSequenceRange {
  const NumberSequenceMersenneExponentsRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxIndex: 50);
}

class NumberSequenceMersenneExponentsNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMersenneExponentsNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxIndex: 50);
}

class NumberSequenceMersenneExponentsContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMersenneExponentsContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxIndex: 50);
}
