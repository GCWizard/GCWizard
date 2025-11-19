class regexOutput {
  final bool ok;
  final List<List<String>>  result;

  regexOutput(this.ok, this.result);
}

regexOutput getRegExPattern(String input, String pattern){
  if (input.isEmpty) return regexOutput(true, [[]]);
  if (pattern.isEmpty) return regexOutput(true, [[input]]);

  List<List<String>> result = [[]];

  try {
    RegExp regex = RegExp(pattern);
    var found = regex.allMatches(input);

    for (var match in found) {
      result.add([match.group(0)!]);
    }
    return regexOutput(true, result);
  } on FormatException catch (e) {
    result.add([e.message]);
    return regexOutput(false, result);
  }

}