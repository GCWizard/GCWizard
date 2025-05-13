import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceCarmichaelNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceCarmichaelNumbersCheckNumber({super.key}) : super(mode: NumberSequencesMode.CARMICHAEL, maxIndex: 10000);
}

class NumberSequenceCarmichaelNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceCarmichaelNumbersDigits({super.key}) : super(mode: NumberSequencesMode.CARMICHAEL, maxDigits: 13);
}

class NumberSequenceCarmichaelNumbersRange extends NumberSequenceRange {
  const NumberSequenceCarmichaelNumbersRange({super.key}) : super(mode: NumberSequencesMode.CARMICHAEL, maxIndex: 10000);
}

class NumberSequenceCarmichaelNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceCarmichaelNumbersNthNumber({super.key}) : super(mode: NumberSequencesMode.CARMICHAEL, maxIndex: 10000);
}

class NumberSequenceCarmichaelNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceCarmichaelNumbersContainsDigits({super.key}) : super(mode: NumberSequencesMode.CARMICHAEL, maxIndex: 10000);
}
