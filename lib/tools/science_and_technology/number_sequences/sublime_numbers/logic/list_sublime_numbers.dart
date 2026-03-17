
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class SublimeNumbersNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return getFirstPositionOfSequenceBase(check, expr, sublime_number);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    return getNumbersWithNDigitsBase(digits, sublime_number);
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    return calculateRangeBase(start, stop, sublime_number);
  }
}

const List<String> sublime_number = [
  '12',
  '6086555670238378989670371734243169622657830773351885970528324860512791691264'
];
