import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLonelyNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceLonelyNumbersCheckNumber({super.key}) : super(mode: NumberSequencesMode.LONELY, maxIndex: 212);
}

class NumberSequenceLonelyNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceLonelyNumbersDigits({super.key}) : super(mode: NumberSequencesMode.LONELY, maxDigits: 14);
}

class NumberSequenceLonelyNumbersRange extends NumberSequenceRange {
  const NumberSequenceLonelyNumbersRange({super.key}) : super(mode: NumberSequencesMode.LONELY, maxIndex: 212);
}

class NumberSequenceLonelyNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceLonelyNumbersNthNumber({super.key}) : super(mode: NumberSequencesMode.LONELY, maxIndex: 212);
}

class NumberSequenceLonelyNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceLonelyNumbersContainsDigits({super.key}) : super(mode: NumberSequencesMode.LONELY, maxIndex: 212);
}
