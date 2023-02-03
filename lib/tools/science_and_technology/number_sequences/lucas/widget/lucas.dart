import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLucasCheckNumber extends NumberSequenceCheckNumber {
  NumberSequenceLucasCheckNumber() : super(mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasDigits extends NumberSequenceDigits {
  NumberSequenceLucasDigits() : super(mode: NumberSequencesMode.LUCAS, maxDigits: 1111);
}

class NumberSequenceLucasRange extends NumberSequenceRange {
  NumberSequenceLucasRange() : super(mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasNthNumber extends NumberSequenceNthNumber {
  NumberSequenceLucasNthNumber() : super(mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasContainsDigits extends NumberSequenceContainsDigits {
  NumberSequenceLucasContainsDigits() : super(mode: NumberSequencesMode.LUCAS, maxIndex: 11111);
}
