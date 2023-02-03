import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';

String recognizableChronogramInput(String input, {bool JUToIV: false, YToII: false, WToVV: false}) {
  if (input == null || input.length == 0) return null;

  var pattern = 'MDCLXVI';

  if (JUToIV) {
    pattern += 'JU';
  }
  if (YToII) {
    pattern += 'Y';
  }
  if (WToVV) {
    pattern += 'W';
  }

  pattern = '[^' + pattern + ']';

  return input.toUpperCase().replaceAll(RegExp(pattern), '');
}

int decodeChronogram(String input, {bool JUToIV: false, YToII: false, WToVV: false}) {
  if (input == null || input.length == 0) return null;

  input = input.toUpperCase();
  if (JUToIV) {
    input = input.replaceAll('J', 'I');
    input = input.replaceAll('U', 'V');
  }
  if (YToII) {
    input = input.replaceAll('Y', 'II');
  }
  if (WToVV) {
    input = input.replaceAll('W', 'VV');
  }

  return decodeRomanNumbers(input, type: RomanNumberType.ONLY_ADDITION);
}
