import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequencePellCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequencePellCheckNumber({super.key}) : super(mode: NumberSequencesMode.PELL, maxIndex: 55555);
}

class NumberSequencePellDigits extends NumberSequenceDigits {
  const NumberSequencePellDigits({super.key}) : super(mode: NumberSequencesMode.PELL, maxDigits: 1111);
}

class NumberSequencePellRange extends NumberSequenceRange {
  const NumberSequencePellRange({super.key}) : super(mode: NumberSequencesMode.PELL, maxIndex: 55555);
}

class NumberSequencePellNthNumber extends NumberSequenceNthNumber {
  const NumberSequencePellNthNumber({super.key}) : super(mode: NumberSequencesMode.PELL, maxIndex: 55555);
}

class NumberSequencePellContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequencePellContainsDigits({super.key}) : super(mode: NumberSequencesMode.PELL, maxIndex: 5555);
}
