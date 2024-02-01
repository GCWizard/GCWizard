import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

final _QUSubstitutions = {'qu': 'qq', 'Qu': 'Qq', 'qU': 'qQ', 'QU': 'QQ'};

String _encodeQU(String input) {
  return substitution(input, _QUSubstitutions);
}

String _decodeQQ(String input) {
  return substitution(input, switchMapKeyValue(_QUSubstitutions));
}

String encryptPigLatin(String input) {
  if (input.isEmpty) return '';

  input = _encodeQU(removeAccents(input));

  return _decodeQQ(input.replaceAllMapped(RegExp(r'\b(\w*?)([aeiou]\w*)', caseSensitive: false), (match) {
    var output = '${match[2]}-${match[1]}ay'.toLowerCase();
    if (isUpperCase(match[0]![0])) output = output[0].toUpperCase() + output.substring(1);

    return output;
  }));
}

String decryptPigLatin(String input) {
  if (input.isEmpty) return '';

  return input.replaceAllMapped(RegExp(r'\b(\w+)-(\w*)ay', caseSensitive: false), (match) {
    var output = (match[2] ?? '') + (match[1] ?? '');
    if (isUpperCase(match[1]![0])) output = output[0].toUpperCase() + output.substring(1).toLowerCase();

    return output;
  });
}
