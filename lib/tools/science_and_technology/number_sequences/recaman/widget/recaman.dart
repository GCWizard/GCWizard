import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceRecamanCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceRecamanCheckNumber({super.key})
      : super(mode: NumberSequencesMode.RECAMAN, maxIndex: 11111);
}

class NumberSequenceRecamanDigits extends NumberSequenceDigits {
  const NumberSequenceRecamanDigits({super.key}) : super(mode: NumberSequencesMode.RECAMAN, maxDigits: 5);
}

class NumberSequenceRecamanRange extends NumberSequenceRange {
  const NumberSequenceRecamanRange({super.key}) : super(mode: NumberSequencesMode.RECAMAN, maxIndex: 11111);
}

class NumberSequenceRecamanNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceRecamanNthNumber({super.key})
      : super(mode: NumberSequencesMode.RECAMAN, maxIndex: 11111);
}

class NumberSequenceRecamanContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceRecamanContainsDigits({super.key})
      : super(mode: NumberSequencesMode.RECAMAN, maxIndex: 1111);
}
