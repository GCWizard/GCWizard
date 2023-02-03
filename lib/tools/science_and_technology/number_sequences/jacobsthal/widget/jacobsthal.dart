import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceJacobsthalCheckNumber extends NumberSequenceCheckNumber {
  NumberSequenceJacobsthalCheckNumber() : super(mode: NumberSequencesMode.JACOBSTAHL, maxIndex: 111111);
}

class NumberSequenceJacobsthalDigits extends NumberSequenceDigits {
  NumberSequenceJacobsthalDigits() : super(mode: NumberSequencesMode.JACOBSTAHL, maxDigits: 1111);
}

class NumberSequenceJacobsthalRange extends NumberSequenceRange {
  NumberSequenceJacobsthalRange() : super(mode: NumberSequencesMode.JACOBSTAHL, maxIndex: 111111);
}

class NumberSequenceJacobsthalNthNumber extends NumberSequenceNthNumber {
  NumberSequenceJacobsthalNthNumber() : super(mode: NumberSequencesMode.JACOBSTAHL, maxIndex: 111111);
}

class NumberSequenceJacobsthalContainsDigits extends NumberSequenceContainsDigits {
  NumberSequenceJacobsthalContainsDigits() : super(mode: NumberSequencesMode.JACOBSTAHL, maxIndex: 11111);
}
