import 'dart:math';

const int COMBINATION_MAX_LENGTH = 12;

List<String> generateCombinations(String input, {bool avoidDuplicates = false}) {
  if (input.isEmpty) return [];

  var out = <String>[];

  var count = pow(2, input.length);
  for (int i = 1; i < count; i++) {
    var bitmask = i.toRadixString(2).padLeft(input.length, '0');
    var combination = '';

    for (int j = 0; j < bitmask.length; j++) {
      if (bitmask[j] == '0') continue;

      combination += input[j];
    }

    out.add(combination);
  }

  out.sort((a, b) {
    var lengthCompared = a.length.compareTo(b.length);
    if (lengthCompared != 0) return lengthCompared;

    return a.toLowerCase().compareTo(b.toLowerCase());
  });

  if (avoidDuplicates) {
    return out.toSet().toList();
  }

  return out;
}
