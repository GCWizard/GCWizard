
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class BusyBeaverNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return BaseNumberSequence.getFirstPositionOfSequenceBase(check, expr, _busy_beaver_numbers);
  }


  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return BaseNumberSequence.getNumbersWithNDigitsBase(digits, _busy_beaver_numbers);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return BaseNumberSequence.calculateRangeBase(start, stop, _busy_beaver_numbers);
  }
}

const List<String> _busy_beaver_numbers = [
  '1',
  '6',
  '21',
  '107',
  '47176870',
];
