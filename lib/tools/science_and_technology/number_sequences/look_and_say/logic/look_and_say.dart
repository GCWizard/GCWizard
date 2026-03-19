
import 'dart:math';

import 'package:utility/utility.dart';

String lookAndSay(String input) {
  if (input.isEmpty) return '';

  final regex = RegExp(r'(.)\1*');
  return input.replaceAllMapped(regex, (match) {
    final seq = match.group(0)!;
    final p1 = match.group(1)!;
    return '${seq.length}$p1';
  });
}

String lookAndSayReverse(String input) {
  String current = input;

  while (true) {
    if (current.length % 2 != 0) break;

    String next = _lookAndSayReverseHelper(current);
    if (next == '-1') return 'invalid input';
    
    if (lookAndSay(next) != current) {
      return current;
    }
    if (next == current) break;
    current = next;
  }
  return current;
}

String _lookAndSayReverseHelper(String input) {
  if (input.length % 2 != 0) return '-1';

  var result = '';
  for (int i = 0; i < input.length; i += 2) {
    if (!input[i].isNumber) return '-1';
    int count = int.parse(input[i]);
    String digit = input[i + 1];
    result += digit * count;
  }
  return result;
}



void main() {
  // 1211  1
  // 111321 111
  // 1412211512 2222122222
  // 22 22
  // 1113122113121113222112311311222113 11123
 print(lookAndSayReverse("1412211512"));
}