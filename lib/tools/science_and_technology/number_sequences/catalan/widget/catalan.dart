import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceCatalanCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceCatalanCheckNumber({super.key})
      : super(mode: NumberSequencesMode.CATALAN, maxIndex: 11111);
}

class NumberSequenceCatalanDigits extends NumberSequenceDigits {
  const NumberSequenceCatalanDigits({super.key}) : super(mode: NumberSequencesMode.CATALAN, maxDigits: 1111);
}

class NumberSequenceCatalanRange extends NumberSequenceRange {
  const NumberSequenceCatalanRange({super.key}) : super(mode: NumberSequencesMode.CATALAN, maxIndex: 11111);
}

class NumberSequenceCatalanNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceCatalanNthNumber({super.key})
      : super(mode: NumberSequencesMode.CATALAN, maxIndex: 11111);
}

class NumberSequenceCatalanContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceCatalanContainsDigits({super.key})
      : super(mode: NumberSequencesMode.CATALAN, maxIndex: 1111);
}
