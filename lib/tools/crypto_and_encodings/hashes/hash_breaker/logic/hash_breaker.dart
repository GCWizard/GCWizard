import 'dart:isolate';

import 'package:gc_wizard/utils/variable_string_expander.dart';

class HashBreakerJobData {
  final String input;
  final String searchMask;
  final Map<String, String> substitutions;
  final Function hashFunction;

  HashBreakerJobData({
    this.input = '',
    this.searchMask = '',
    this.substitutions,
    this.hashFunction,
  });
}

Future<Map<String, dynamic>> breakHashAsync(dynamic jobData) async {
  if (jobData == null) return null;

  var output = breakHash(jobData.parameters.input, jobData.parameters.searchMask, jobData.parameters.substitutions,
      jobData.parameters.hashFunction,
      sendAsyncPort: jobData.sendAsyncPort);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

Map<String, dynamic> breakHash(
    String input, String searchMask, Map<String, String> substitutions, Function hashFunction,
    {SendPort sendAsyncPort}) {
  if (input == null ||
      input.length == 0 ||
      searchMask == null ||
      searchMask.length == 0 ||
      substitutions == null ||
      hashFunction == null) return null;

  input = input.toLowerCase();
  var expander = VariableStringExpander(searchMask, substitutions, onAfterExpandedText: (expandedText) {
    var withoutBrackets = expandedText.replaceAll(RegExp(r'[\[\]]'), '');
    var hashValue = hashFunction(withoutBrackets).toLowerCase();

    if (hashValue == input)
      return withoutBrackets;
    else
      return null;
  }, breakCondition: VariableStringExpanderBreakCondition.BREAK_ON_FIRST_FOUND, sendAsyncPort: sendAsyncPort);

  var results = expander.run();

  if (results == null || results.length == 0) return {'state': 'not_found'};

  return {'state': 'ok', 'text': results[0]['text']};
}
