List<List<String>> evaluateRegExPattern(String input, String pattern) {
  if (input.isEmpty) return [];
  if (pattern.isEmpty) {
    return [
      [input]
    ];
  }

  List<List<String>> result = [];

  RegExp regex = RegExp(pattern);
  var found = regex.allMatches(input);

  for (var match in found) {
    result.add([match.group(0)!]);
  }
  return result;
}
