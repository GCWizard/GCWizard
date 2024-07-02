import 'package:gc_wizard/utils/string_utils.dart' as strUtils;

String reverseAll(String input) {
  return strUtils.reverse(input);
}

String reverseBlocks(String input, {String blockDelimiters = ' \n'}) {
  if (input.isEmpty) return input;

  var delimiters = input.replaceAll(RegExp(r'[^' + blockDelimiters + ']'), '');
  var blocks = input.split(RegExp(r'[' + blockDelimiters + ']')).toList().reversed.toList();

  var output = blocks.first;
  for (int i = 0; i < delimiters.length; i++) {
    output += delimiters[i] + blocks[i + 1];
  }

  return output;
}

String reverseKeepBlockOrder(String input, {String blockDelimiters = ' \n'}) {
  if (input.isEmpty) return input;

  var delimiters = input.replaceAll(RegExp(r'[^' + blockDelimiters + ']'), '');
  var blocks = input.split(RegExp(r'[' + blockDelimiters + ']')).map((e) => strUtils.reverse(e)).toList();

  var output = blocks.first;
  for (int i = 0; i < delimiters.length; i++) {
    output += delimiters[i] + blocks[i + 1];
  }

  return output;
}
