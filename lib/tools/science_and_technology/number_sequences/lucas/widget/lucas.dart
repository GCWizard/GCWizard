import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLucasCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceLucasCheckNumber({super.key}) : super(mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasDigits extends NumberSequenceDigits {
  const NumberSequenceLucasDigits({super.key}) : super(mode: NumberSequencesMode.LUCAS, maxDigits: 1111);
}

class NumberSequenceLucasRange extends NumberSequenceRange {
  const NumberSequenceLucasRange({super.key}) : super(mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceLucasNthNumber({super.key}) : super(mode: NumberSequencesMode.LUCAS, maxIndex: 111111);
}

class NumberSequenceLucasContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceLucasContainsDigits({super.key})
      : super(mode: NumberSequencesMode.LUCAS, maxIndex: 11111);
}
