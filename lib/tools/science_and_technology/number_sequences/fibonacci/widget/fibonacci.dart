import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceFibonacciCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceFibonacciCheckNumber({super.key})
      : super(mode: NumberSequencesMode.FIBONACCI, maxIndex: 111111);
}

class NumberSequenceFibonacciDigits extends NumberSequenceDigits {
  const NumberSequenceFibonacciDigits({super.key})
      : super(mode: NumberSequencesMode.FIBONACCI, maxDigits: 1111);
}

class NumberSequenceFibonacciRange extends NumberSequenceRange {
  const NumberSequenceFibonacciRange({super.key})
      : super(mode: NumberSequencesMode.FIBONACCI, maxIndex: 111111);
}

class NumberSequenceFibonacciNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceFibonacciNthNumber({super.key})
      : super(mode: NumberSequencesMode.FIBONACCI, maxIndex: 111111);
}

class NumberSequenceFibonacciContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceFibonacciContainsDigits({super.key})
      : super(mode: NumberSequencesMode.FIBONACCI, maxIndex: 1111);
}
