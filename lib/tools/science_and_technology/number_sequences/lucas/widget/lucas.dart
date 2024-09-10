import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLucasCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceLucasCheckNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasDigits extends NumberSequenceDigits {
  const NumberSequenceLucasDigits({Key? key}) : super(key: key, mode: NumberSequencesMode.LUCAS, maxDigits: 1111);
}

class NumberSequenceLucasRange extends NumberSequenceRange {
  const NumberSequenceLucasRange({Key? key}) : super(key: key, mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceLucasNthNumber({Key? key}) : super(key: key, mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceLucasContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.LUCAS, maxIndex: 11111);
}
