
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class BusyBeaverNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, busy_beaver_numbers);
  }


  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, busy_beaver_numbers);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return calculateRangeBase(start, stop, busy_beaver_numbers);
  }
}

const List<String> busy_beaver_numbers = [
  '1',
  '6',
  '21',
  '107',
  '47176870',
];
