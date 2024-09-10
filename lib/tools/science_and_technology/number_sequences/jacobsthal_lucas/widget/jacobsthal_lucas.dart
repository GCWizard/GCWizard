import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceJacobsthalLucasCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceJacobsthalLucasCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.JACOBSTHAL_LUCAS, maxIndex: 111111);
}

class NumberSequenceJacobsthalLucasDigits extends NumberSequenceDigits {
  const NumberSequenceJacobsthalLucasDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.JACOBSTHAL_LUCAS, maxDigits: 1111);
}

class NumberSequenceJacobsthalLucasRange extends NumberSequenceRange {
  const NumberSequenceJacobsthalLucasRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.JACOBSTHAL_LUCAS, maxIndex: 111111);
}

class NumberSequenceJacobsthalLucasNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceJacobsthalLucasNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.JACOBSTHAL_LUCAS, maxIndex: 111111);
}

class NumberSequenceJacobsthalLucasContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceJacobsthalLucasContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.JACOBSTHAL_LUCAS, maxIndex: 11111);
}
