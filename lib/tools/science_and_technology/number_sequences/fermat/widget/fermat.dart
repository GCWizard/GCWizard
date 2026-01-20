import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceFermatCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceFermatCheckNumber({super.key}) : super(mode: NumberSequencesMode.FERMAT, maxIndex: 18);
}

class NumberSequenceFermatDigits extends NumberSequenceDigits {
  const NumberSequenceFermatDigits({super.key}) : super(mode: NumberSequencesMode.FERMAT, maxDigits: 1111);
}

class NumberSequenceFermatRange extends NumberSequenceRange {
  const NumberSequenceFermatRange({super.key}) : super(mode: NumberSequencesMode.FERMAT, maxIndex: 18);
}

class NumberSequenceFermatNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceFermatNthNumber({super.key}) : super(mode: NumberSequencesMode.FERMAT, maxIndex: 18);
}

class NumberSequenceFermatContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceFermatContainsDigits({super.key})
      : super(mode: NumberSequencesMode.FERMAT, maxIndex: 10);
}
