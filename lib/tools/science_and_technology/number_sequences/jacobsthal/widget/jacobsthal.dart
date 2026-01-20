import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceJacobsthalCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceJacobsthalCheckNumber({super.key})
      : super(mode: NumberSequencesMode.JACOBSTAHL, maxIndex: 111111);
}

class NumberSequenceJacobsthalDigits extends NumberSequenceDigits {
  const NumberSequenceJacobsthalDigits({super.key})
      : super(mode: NumberSequencesMode.JACOBSTAHL, maxDigits: 1111);
}

class NumberSequenceJacobsthalRange extends NumberSequenceRange {
  const NumberSequenceJacobsthalRange({super.key})
      : super(mode: NumberSequencesMode.JACOBSTAHL, maxIndex: 111111);
}

class NumberSequenceJacobsthalNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceJacobsthalNthNumber({super.key})
      : super(mode: NumberSequencesMode.JACOBSTAHL, maxIndex: 111111);
}

class NumberSequenceJacobsthalContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceJacobsthalContainsDigits({super.key})
      : super(mode: NumberSequencesMode.JACOBSTAHL, maxIndex: 11111);
}
