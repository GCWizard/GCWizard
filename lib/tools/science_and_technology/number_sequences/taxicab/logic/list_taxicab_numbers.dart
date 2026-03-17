
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class TaxicabNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, taxicab_numbers);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, taxicab_numbers);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return calculateRangeBase(start, stop, taxicab_numbers);
  }
}

const List<String> taxicab_numbers = [
  '2', '1729', '87539319', '6963472309248', '48988659276962496', '24153319581254312065344'
];
