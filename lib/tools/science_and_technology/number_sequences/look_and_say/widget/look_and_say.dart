import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';

class NumberSequenceLookAndSayCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceLookAndSayCheckNumber({super.key})
      : super(mode: NumberSequencesMode.LOOK_AND_SAY, maxIndex: 30);
}

class NumberSequenceLookAndSayDigits extends NumberSequenceDigits {
  const NumberSequenceLookAndSayDigits({super.key}) : super(mode: NumberSequencesMode.LOOK_AND_SAY, maxDigits: 4462);
}

class NumberSequenceLookAndSayRange extends NumberSequenceRange {
  const NumberSequenceLookAndSayRange({super.key}) : super(mode: NumberSequencesMode.LOOK_AND_SAY, maxIndex: 30);
}

class NumberSequenceLookAndSayNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceLookAndSayNthNumber({super.key})
      : super(mode: NumberSequencesMode.LOOK_AND_SAY, maxIndex: 30);
}

class NumberSequenceLookAndSayContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceLookAndSayContainsDigits({super.key})
      : super(mode: NumberSequencesMode.LOOK_AND_SAY, maxIndex: 30);
}
