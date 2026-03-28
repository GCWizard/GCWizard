
import 'package:utility/utility.dart';

String lookAndSay(String input) {
  final regex = RegExp(r'(.)\1*');
  return input.replaceAllMapped(regex, (match) {
    final seq = match.group(0)!;
    final p1 = match.group(1)!;
    return '${seq.length}$p1';
  });
}

String? lookAndSayReverse(String input) {
  var current = input;
  if (input.length % 2 != 0) return null;

  while (true) {
    if (current.length % 2 != 0) break;

    var next = _lookAndSayReverseHelper(current);
    if (next == null) return null;

    if (lookAndSay(next) != current) return current;
    if (next == current) break;
    current = next;
  }
  return current;
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