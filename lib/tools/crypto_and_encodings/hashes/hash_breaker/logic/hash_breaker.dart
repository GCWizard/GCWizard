import 'dart:isolate';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/variable_string_expander.dart';

class HashBreakerJobData {
  final String input;
  final String searchMask;
  final Map<String, String> substitutions;
  final Function hashFunction;

  HashBreakerJobData({
    this.input = '',
    this.searchMask = '',
    required this.substitutions,
    required this.hashFunction,
  });
}

Future<BoolText?> breakHashAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! HashBreakerJobData) return null;

  var data = jobData!.parameters as HashBreakerJobData;
  var output = breakHash(data.input, data.searchMask, data.substitutions, data.hashFunction,
      sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

BoolText? breakHash(String input, String? searchMask, Map<String, String>? substitutions, Function? hashFunction,
    {SendPort? sendAsyncPort}) {
  if (input.isEmpty || searchMask == null || searchMask.isEmpty || substitutions == null || hashFunction == null) {
    return null;
  }

  input = input.toLowerCase();
  var expander = VariableStringExpander(searchMask, substitutions, onAfterExpandedText: (expandedText) {
    var withoutBrackets = expandedText.replaceAll(RegExp(r'[\[\]]'), '');
    var hashValue = hashFunction(withoutBrackets).toLowerCase();

    if (hashValue == input) {
      return withoutBrackets;
    } else {
      return null;
    }
  }, breakCondition: VariableStringExpanderBreakCondition.BREAK_ON_FIRST_FOUND, sendAsyncPort: sendAsyncPort);

  var results = expander.run();

  if (results.isEmpty) return BoolText('', false);

  return BoolText(results[0].text!, true);
}
