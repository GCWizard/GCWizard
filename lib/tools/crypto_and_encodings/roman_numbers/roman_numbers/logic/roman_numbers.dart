import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

enum RomanNumberType {
  ONLY_ADDITION,
  USE_SUBTRACTION_RULE //default
}

const Map<String, int> _romanToNumber = {'M': 1000, 'D': 500, 'C': 100, 'L': 50, 'X': 10, 'V': 5, 'I': 1};
const Map<String, String> _subtractionSubstitutions = {
  'DCCCC': 'CM',
  'CCCC': 'CD',
  'LXXXX': 'XC',
  'XXXX': 'XL',
  'VIIII': 'IX',
  'IIII': 'IV'
};

String encodeRomanNumbers(int number, {RomanNumberType type = RomanNumberType.USE_SUBTRACTION_RULE}) {
  if (number < 1) return '';

  var out = '';
  var remaining = number;
  for (var value in _romanToNumber.entries) {
    while (remaining >= value.value) {
      out += value.key;
      remaining -= value.value;
    }
  }

  if (type == RomanNumberType.USE_SUBTRACTION_RULE) {
    out = substitution(out, _subtractionSubstitutions);
  }

  return out;
}

int? decodeRomanNumbers(String input, {RomanNumberType type = RomanNumberType.USE_SUBTRACTION_RULE}) {
  input = input.toUpperCase().replaceAll(RegExp(r'[^MDCLXVI]'), '');
  if (input.isEmpty) return null;

  var roman = input;
  if (type == RomanNumberType.USE_SUBTRACTION_RULE) {
    roman = substitution(input, switchMapKeyValue(_subtractionSubstitutions));
  }

  var out = 0;
  roman.split('').forEach((character) => out += (_romanToNumber[character] ?? 0));

  return out;
}
