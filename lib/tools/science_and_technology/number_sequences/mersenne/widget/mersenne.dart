import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMersenneCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMersenneCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.MERSENNE, maxIndex: 111111);
}

class NumberSequenceMersenneDigits extends NumberSequenceDigits {
  const NumberSequenceMersenneDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE, maxDigits: 1111);
}

class NumberSequenceMersenneRange extends NumberSequenceRange {
  const NumberSequenceMersenneRange({Key? key}) : super(key: key, mode: NumberSequencesMode.MERSENNE, maxIndex: 111111);
}

class NumberSequenceMersenneNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMersenneNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.MERSENNE, maxIndex: 111111);
}

class NumberSequenceMersenneContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMersenneContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.MERSENNE, maxIndex: 11111);
}
