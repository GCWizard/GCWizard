import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceJacobsthalOblongCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceJacobsthalOblongCheckNumber({super.key})
      : super(mode: NumberSequencesMode.JACOBSTHAL_OBLONG, maxIndex: 111111);
}

class NumberSequenceJacobsthalOblongDigits extends NumberSequenceDigits {
  const NumberSequenceJacobsthalOblongDigits({super.key})
      : super(mode: NumberSequencesMode.JACOBSTHAL_OBLONG, maxDigits: 1111);
}

class NumberSequenceJacobsthalOblongRange extends NumberSequenceRange {
  const NumberSequenceJacobsthalOblongRange({super.key})
      : super(mode: NumberSequencesMode.JACOBSTHAL_OBLONG, maxIndex: 111111);
}

class NumberSequenceJacobsthalOblongNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceJacobsthalOblongNthNumber({super.key})
      : super(mode: NumberSequencesMode.JACOBSTHAL_OBLONG, maxIndex: 111111);
}

class NumberSequenceJacobsthalOblongContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceJacobsthalOblongContainsDigits({super.key})
      : super(mode: NumberSequencesMode.JACOBSTHAL_OBLONG, maxIndex: 11111);
}
