import 'package:gc_wizard/tools/science_and_technology/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/base/numbersequences_check/widget/numbersequences_check.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/base/numbersequences_containsdigits/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/base/numbersequences_digits/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/base/numbersequences_nthnumber/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/base/numbersequences_range/widget/numbersequences_range.dart';

class NumberSequenceCatalanCheckNumber extends NumberSequenceCheckNumber {
  NumberSequenceCatalanCheckNumber() : super(mode: NumberSequencesMode.CATALAN, maxIndex: 11111);
}

class NumberSequenceCatalanDigits extends NumberSequenceDigits {
  NumberSequenceCatalanDigits() : super(mode: NumberSequencesMode.CATALAN, maxDigits: 1111);
}

class NumberSequenceCatalanRange extends NumberSequenceRange {
  NumberSequenceCatalanRange() : super(mode: NumberSequencesMode.CATALAN, maxIndex: 11111);
}

class NumberSequenceCatalanNthNumber extends NumberSequenceNthNumber {
  NumberSequenceCatalanNthNumber() : super(mode: NumberSequencesMode.CATALAN, maxIndex: 11111);
}

class NumberSequenceCatalanContainsDigits extends NumberSequenceContainsDigits {
  NumberSequenceCatalanContainsDigits() : super(mode: NumberSequencesMode.CATALAN, maxIndex: 1111);
}
