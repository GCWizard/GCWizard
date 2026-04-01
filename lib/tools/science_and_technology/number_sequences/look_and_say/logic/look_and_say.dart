
import 'package:utility/utility.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class LookAndSayNumberSequence extends BaseNumberSequence {

  @override
  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    int index = 0;
    String numberString = '';

    while (index <= maxIndex) {
      if (index == 0) {
        numberString = '1';
      } else {
        numberString = lookAndSay(numberString);
      }
      if (expr.hasMatch(numberString)) {
        int j = 0;
        while (!numberString.substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(numberString, index + 1, j + 1);
      }
      index++;
    }
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  @override
  List<BigInt> getNumbersWithNDigits(int digits) {
    var numberList = <BigInt>[];
    var numberString = '1';

    while (numberString.length < digits + 1) {
      if (numberString.length == digits) numberList.add(BigInt.parse(numberString));
      numberString = lookAndSay(numberString);
    }
    return numberList;
  }

  @override
  List<BigInt> calculateRange(int start, int stop) {
    var numberList = <BigInt>[];
    var numberString = '';
    int index = 0;

    while (index < stop + 1) {
      if (index == 0) {
        numberString = '1';
      } else {
        numberString = lookAndSay(numberString);
      }
      if (index >= start) numberList.add(BigInt.parse(numberString));
      index++;
    }
    return numberList;
  }
}

String lookAndSay(String input) {
  final regex = RegExp(r'(.)\1*');
  return input.replaceAllMapped(regex, (match) {
    final seq = match.group(0)!;
    final p1 = match.group(1)!;
    return '${seq.length}$p1';
  });
}

List<String>? lookAndSayReverse(String input) {
  var current = input.trim();
  var result = <String>[];
  if (current.length % 2 != 0) return null;

  while (true) {
    if (current.length % 2 != 0) break;

    var next = _lookAndSayReverseHelper(current);
    if (next == null) return null;

    if (lookAndSay(next) != current) return result;
    if (next == current) break;
    current = next;
    result.add(current);
  }
  return result;
}

String? _lookAndSayReverseHelper(String input) {
  if (input.length % 2 != 0) return input;

  var result = '';
  for (int i = 0; i < input.length; i += 2) {
    if (!input[i].isNumber) return null;
    var count = int.parse(input[i]);
    var digit = input[i + 1];
    result += digit * count;
  }
  return result;
}