// https://arxiv.org/pdf/1712.06259.pdf
// https://hohoho.jakobsenkl.pw/
// https://www.geocaching.com/geocache/GC9GFQM_hohoho
//
// Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hohohohohoho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Ho! Hohoho! Ho! Ho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohohohohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohohohohohohohohohohohohohohohohohohohoho! Hohohohohoho! Hohohohohoho! Hoho! Ho! Ho! Hoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hoho! Ho! Ho! Hoho! Hohohohohoho! Hoho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Ho! Hoho! Hohoho! Ho! Ho!
// HoHoHo HoHoHo HoHoHo HoHoHo HoHoHo HoHoHo HoHoHo Hohoho hohoho HoHoho HoHoHo HoHoHo HoHoHo HoHoHo HoHoHo HoHoHo HoHoHo hoHoHo hohoHo HoHoho HoHoHo HoHoHo HoHoHo hoHoho hohoho hohoho hoHoho HoHoHo HoHoHo HoHoHo HoHoHo HoHoHo hoHoho hohoho hohoho hohoho hohoho hohoho hohoho hoHoho hohoho hoHoho hohoho hoHoho HoHoHo hoHoho HoHoHo HoHoHo HoHoHo HoHoHo HoHoHo hoHoho HoHoHo hoHoho hohoho hoHoho HoHoHo HoHoHo HoHoHo HoHoHo hoHoho hoHoHo
//
//
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/logic/brainfk.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

const HOHOHO_ERROR_INVALID_PROGRAM = 'hohoho_error_syntax_invalidprogram';

const _HOHOHO_SUBSTITUTIONS = {
  '>': 'HoHoho',
  '<': 'hoHoHo',
  '+': 'HoHoHo',
  '-': 'hohoho',
  '.': 'hoHoho',
  ',': 'HohoHo',
  '[': 'Hohoho',
  ']': 'hohoHo'
};

class HohohoOutput {
  String output = '';
  String error = '';

  HohohoOutput(this.output, this.error);
}

HohohoOutput interpretHohoho(String plainText, {String? STDIN}) {
  if (plainText.isEmpty) return HohohoOutput('', '');

  plainText = plainText.trim();
  String result = plainText.replaceAll('!', '').replaceAll(' ', '');
  String test = plainText.replaceAll('Ho', '').replaceAll('ho', '').replaceAll('!', '').replaceAll(' ', '');
  String error = '';
  // test if correct syntax
  if (test.isNotEmpty || result.length % 6 != 0) error = HOHOHO_ERROR_INVALID_PROGRAM;

  // convert to hohoho
  test = '';
  for (int i = 1; i < result.length + 1; i++) {
    test = test + result[i - 1];
    if (i % 6 == 0) test = test + ' ';
  }

  // convert to Brainfck
  var BRAINF_CK = switchMapKeyValue(_HOHOHO_SUBSTITUTIONS);
  result = '';
  test.split(' ').forEach((element) {
    if (BRAINF_CK[element] != null) result += (BRAINF_CK[element] ?? '');
  });

  // interpret
  result = interpretBrainfk(result, input: STDIN).trim();
  // return result

  return HohohoOutput(result, error);
}

String generateHohoho(String OutputText) {
  if (OutputText.isEmpty) return '';

  // generate Brainfck
  String code = generateBrainfk(OutputText);
  String result = '';

  // transfer to hohoho
  code.split('').forEach((element) {
    result += (_HOHOHO_SUBSTITUTIONS[element] ?? '');
  });

  // normalize
  code = result.replaceAll('H', '! H') + '!';
  code = code.substring(2);

  // return result
  return code;
}
