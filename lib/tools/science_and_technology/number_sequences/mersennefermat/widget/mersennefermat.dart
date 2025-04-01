import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMersenneFermatCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMersenneFermatCheckNumber({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_FERMAT, maxIndex: 111111);
}

class NumberSequenceMersenneFermatDigits extends NumberSequenceDigits {
  const NumberSequenceMersenneFermatDigits({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_FERMAT, maxDigits: 1111);
}

class NumberSequenceMersenneFermatRange extends NumberSequenceRange {
  const NumberSequenceMersenneFermatRange({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_FERMAT, maxIndex: 111111);
}

class NumberSequenceMersenneFermatNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMersenneFermatNthNumber({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_FERMAT, maxIndex: 111111);
}

class NumberSequenceMersenneFermatContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMersenneFermatContainsDigits({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_FERMAT, maxIndex: 11111);
}
