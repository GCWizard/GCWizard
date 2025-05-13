import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceTaxicabNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceTaxicabNumbersCheckNumber({super.key}) : super(mode: NumberSequencesMode.TAXICAB, maxIndex: 6);
}

class NumberSequenceTaxicabNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceTaxicabNumbersDigits({super.key}) : super(mode: NumberSequencesMode.TAXICAB, maxDigits: 23);
}

class NumberSequenceTaxicabNumbersRange extends NumberSequenceRange {
  const NumberSequenceTaxicabNumbersRange({super.key}) : super(mode: NumberSequencesMode.TAXICAB, maxIndex: 6);
}

class NumberSequenceTaxicabNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceTaxicabNumbersNthNumber({super.key}) : super(mode: NumberSequencesMode.TAXICAB, maxIndex: 6);
}

class NumberSequenceTaxicabNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceTaxicabNumbersContainsDigits({super.key}) : super(mode: NumberSequencesMode.TAXICAB, maxIndex: 6);
}
