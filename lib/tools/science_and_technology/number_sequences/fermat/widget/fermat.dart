import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceFermatCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceFermatCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.FERMAT, maxIndex: 18);
}

class NumberSequenceFermatDigits extends NumberSequenceDigits {
  const NumberSequenceFermatDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.FERMAT, maxDigits: 1111);
}

class NumberSequenceFermatRange extends NumberSequenceRange {
  const NumberSequenceFermatRange({Key? key}) : super(key: key, mode: NumberSequencesMode.FERMAT, maxIndex: 18);
}

class NumberSequenceFermatNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceFermatNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.FERMAT, maxIndex: 18);
}

class NumberSequenceFermatContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceFermatContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.FERMAT, maxIndex: 10);
}
