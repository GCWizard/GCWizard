import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceMersenneExponentsCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceMersenneExponentsCheckNumber({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxIndex: 50);
}

class NumberSequenceMersenneExponentsDigits extends NumberSequenceDigits {
  const NumberSequenceMersenneExponentsDigits({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxDigits: 8);
}

class NumberSequenceMersenneExponentsRange extends NumberSequenceRange {
  const NumberSequenceMersenneExponentsRange({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxIndex: 50);
}

class NumberSequenceMersenneExponentsNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceMersenneExponentsNthNumber({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxIndex: 50);
}

class NumberSequenceMersenneExponentsContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceMersenneExponentsContainsDigits({super.key})
      : super(mode: NumberSequencesMode.MERSENNE_EXPONENTS, maxIndex: 50);
}
