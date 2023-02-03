import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePellLucasCheckNumber extends NumberSequenceCheckNumber {
  NumberSequencePellLucasCheckNumber() : super(mode: NumberSequencesMode.PELL_LUCAS, maxIndex: 55555);
}

class NumberSequencePellLucasDigits extends NumberSequenceDigits {
  NumberSequencePellLucasDigits() : super(mode: NumberSequencesMode.PELL_LUCAS, maxDigits: 1111);
}

class NumberSequencePellLucasRange extends NumberSequenceRange {
  NumberSequencePellLucasRange() : super(mode: NumberSequencesMode.PELL_LUCAS, maxIndex: 55555);
}

class NumberSequencePellLucasNthNumber extends NumberSequenceNthNumber {
  NumberSequencePellLucasNthNumber() : super(mode: NumberSequencesMode.PELL_LUCAS, maxIndex: 55555);
}

class NumberSequencePellLucasContainsDigits extends NumberSequenceContainsDigits {
  NumberSequencePellLucasContainsDigits() : super(mode: NumberSequencesMode.PELL_LUCAS, maxIndex: 5555);
}
