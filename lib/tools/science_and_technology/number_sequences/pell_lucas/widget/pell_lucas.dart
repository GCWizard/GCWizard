import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePellLucasCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePellLucasCheckNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.PELL_LUCAS, maxIndex: 55555);
}

class NumberSequencePellLucasDigits extends NumberSequenceDigits {
  const NumberSequencePellLucasDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.PELL_LUCAS, maxDigits: 1111);
}

class NumberSequencePellLucasRange extends NumberSequenceRange {
  const NumberSequencePellLucasRange({Key? key})
      : super(key: key, mode: NumberSequencesMode.PELL_LUCAS, maxIndex: 55555);
}

class NumberSequencePellLucasNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePellLucasNthNumber({Key? key})
      : super(key: key, mode: NumberSequencesMode.PELL_LUCAS, maxIndex: 55555);
}

class NumberSequencePellLucasContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePellLucasContainsDigits({Key? key})
      : super(key: key, mode: NumberSequencesMode.PELL_LUCAS, maxIndex: 5555);
}
