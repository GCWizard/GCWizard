import 'dart:convert';
import 'dart:isolate';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/science_and_technology/uic_wagoncode/logic/uic_wagoncode.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:gc_wizard/tools/science_and_technology/cross_sums/logic/crosstotals.dart';
import 'package:http/http.dart' as http;

part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits__datatypes.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_iban_de.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_iban_de_banknumber_data.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_ean.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_creditcard.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_de_taxid.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_iban.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_imei.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_isbn.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_euro.dart';
part 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits_uic.dart';

final _ITERATE_ALPHA = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];
final _ITERATE_ALPHANUMERIC = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];
final _ITERATE_NUMERIC = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
];
final _LOOP_DATA = {
  IBAN_IDENTIFIER_TYPES.ALPHA: _ITERATE_ALPHA,
  IBAN_IDENTIFIER_TYPES.ALPHANUMERIC: _ITERATE_ALPHANUMERIC,
  IBAN_IDENTIFIER_TYPES.NUMERIC: _ITERATE_NUMERIC,
};

String checkDigitsNormalizeNumber(String number) {
  return number.replaceAll(' ', '').replaceAll('-', '');
}

CheckDigitOutput checkDigitsCheckNumber(CheckDigitsMode mode, String number) {
  if (number == '') {
    return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
  }

  number = number.toUpperCase();
  switch (mode) {
    case CheckDigitsMode.EAN_GTIN:
      return _CheckEANNumber(number);
    case CheckDigitsMode.DETAXID:
      return _CheckDETaxIDNumber(number);
    case CheckDigitsMode.EURO:
      return _CheckEURONumber(number);
    case CheckDigitsMode.IBAN:
      return _CheckIBANNumber(number);
    case CheckDigitsMode.IMEI:
      return _CheckIMEINumber(number);
    case CheckDigitsMode.ISBN:
      return _CheckISBNNumber(number);
    case CheckDigitsMode.UIC:
      return _CheckUICNumber(number);
    case CheckDigitsMode.CREDITCARD:
      return _CheckCreditCardNumber(number);
    default:
      return CheckDigitOutput(false, '', ['']);
  }
}

String checkDigitsCalculateCheckDigitAndNumber(CheckDigitsMode mode, String number) {
  if (number == '') {
    return 'checkdigits_invalid_length';
  }
  number = number.toUpperCase();
  switch (mode) {
    case CheckDigitsMode.EAN_GTIN:
      return _CalculateCheckDigitAndNumber(number, _CalculateEANNumber);
    case CheckDigitsMode.DETAXID:
      return _CalculateCheckDigitAndNumber(number, _CalculateDETaxIDNumber);
    case CheckDigitsMode.EURO:
      return _CalculateCheckDigitAndNumber(number, _CalculateEURONumber);
    case CheckDigitsMode.IBAN:
      return _CalculateCheckDigitAndNumber(number, _CalculateIBANNumber);
    case CheckDigitsMode.IMEI:
      return _CalculateCheckDigitAndNumber(number, _CalculateIMEINumber);
    case CheckDigitsMode.ISBN:
      return _CalculateCheckDigitAndNumber(number, _CalculateISBNNumber);
    case CheckDigitsMode.UIC:
      return _CalculateCheckDigitAndNumber(number, _CalculateUICNumber);
    case CheckDigitsMode.CREDITCARD:
      return _CalculateCheckDigitAndNumber(number, _CalculateCreditCardNumber);
    default:
      return '';
  }
}

bool _toManyNumbersToSearch(String number){
  return ('?'.allMatches(number).length > 2);
}

List<String> checkDigitsCalculateMissingDigitsAndNumber(CheckDigitsMode mode, String number) {
  if (number == '') {
    return ['checkdigits_invalid_length'];
  }

  if (number.length == number.replaceAll('?', '').length) {
    return ['checkdigits_nothing_to_calculate'];
  }

  if (_toManyNumbersToSearch(number)) {
    return ['checkdigits_to_many_numbers_to_search'];
  }

  number = number.toUpperCase();
  switch (mode) {
    case CheckDigitsMode.EAN_GTIN:
      return _CalculateEANDigits(number);
    case CheckDigitsMode.DETAXID:
      return _CalculateDETaxIDDigits(number);
    case CheckDigitsMode.EURO:
      return _CalculateEURODigits(number);
    case CheckDigitsMode.IBAN:
      return _CalculateIBANDigits(number);
    case CheckDigitsMode.IMEI:
      return _CalculateIMEIDigits(number);
    case CheckDigitsMode.ISBN:
      return _CalculateISBNDigits(number);
    case CheckDigitsMode.UIC:
      return _CalculateUICDigits(number);
    case CheckDigitsMode.CREDITCARD:
      return _CalculateCreditCardDigits(number);
    default:
      return [''];
  }
}

bool _checkNumber(String number, Function f) {
  return f(number) as bool;
}

String _calculateCheckDigit(String number, Function f) {
  return f(number) as String;
}

String _CalculateCheckDigitAndNumber(String number, Function f) {
  return f(number) as String;
}

List<String> _CalculateGlitch(String number, Function f) {
  List<String> result = <String>[];
  String test = '';
  String testLeft = '';
  String testRight = '';
  int startIndex = 1;
  if (f == _checkIBAN) {
    startIndex = 4;
  }
  for (int index = startIndex; index < number.length; index++) {
    testLeft = number.substring(0, index - 1);
    testRight = number.substring(index);
    if ((f == _checkEURO) && (index == 1 || index == 2)) {
      for (int testDigit = 0; testDigit <= 25; testDigit++) {
        test = testLeft + String.fromCharCode(65 + testDigit) + testRight;
        if (_checkNumber(test, f)) {
          result.add(test);
        }
      }
    } else {
      for (int testDigit = 0; testDigit <= 9; testDigit++) {
        test = testLeft + testDigit.toString() + testRight;
        if (_checkNumber(test, f)) {
          result.add(test);
        }
      }
    } // for testDigit
  } // for index
  return result;
}

List<String> _CalculateDigits(String number, Function f) {
  List<String> result = <String>[];
  if (f == _checkIBAN) {
    if (IBAN_NUMERIC.contains(number.substring(0, 2))) {
      result = _calculateAlphaNumeric(_ITERATE_ALPHA, _ITERATE_ALPHA, number, f);
    } else {
      result = _calculateMixedIBAN(number);
    }
  } else if (f == _checkEURO) {
    result = _calculateAlphaNumeric(_ITERATE_ALPHA, _ITERATE_ALPHANUMERIC, number, f);
  } else {
    result = _CalculateDigitsOnlyNumbers(number, f);
  }
  return result;
}

List<String> _CalculateDigitsOnlyNumbers(String number, Function f, {String head = ''}) {
  List<String> result = <String>[];
  int maxDigits = 0;
  int len = 0;
  String maxNumber = '';
  int index = 0;
  String numberToCheck = '';
  for (int i = 0; i < number.length; i++) {
    if (int.tryParse(number[i]) == null) {
      maxNumber = maxNumber + '9';
    }
  }
  len = maxNumber.length;
  if (len > 0) {
    maxDigits = int.parse(maxNumber);
    for (int i = 0; i < maxDigits; i++) {
      maxNumber = i.toString();
      maxNumber = maxNumber.padLeft(len, '0');
      index = 0;
      numberToCheck = '';
      for (int i = 0; i < number.length; i++) {
        if (int.tryParse(number[i]) == null) {
          numberToCheck = numberToCheck + maxNumber[index];
          index++;
        } else {
          numberToCheck = numberToCheck + number[i];
        }
      }
      if (_checkNumber(head + numberToCheck, f)) {
        if (!result.contains(head + numberToCheck)) {
          result.add(head + numberToCheck);
        }
      }
    }
  } else {
    if (_checkNumber(head + number, f)) {
      if (!result.contains(head + number)) {
        result.add(head + number);
      }
    }
  }
  return result;
}

List<String> _calculateAlphaNumeric(List<String> letterSetOne, List<String> letterSetTwo, String number, Function f) {
  String head = number.substring(0, 2);
  String tail = number.substring(2);
  String headToCheck = '';
  List<String> result = <String>[];

  for (String headI in letterSetOne) {
    for (String headJ in letterSetTwo) {
      if (head[0] == '?') {
        headToCheck = headI;
      } else {
        headToCheck = head[0];
      }
      if (head[1] == '?') {
        headToCheck = headToCheck + headJ;
      } else {
        headToCheck = headToCheck + head[1];
      }
      for (String number in _CalculateDigitsOnlyNumbers(tail, f, head: headToCheck)) {
        if (!result.contains(number)) {
          result.add(number);
        }
      }
    }
  }
  return result;
}

List<String> _calculateMixedIBAN(String number) {
  List<String> result = [];

  List<int> bases = [];
  int blocks = 1;
  List<List<String>> loops = [];
  String block = '';

  List<Map<String, Object>> countryData = [];

  if (IBAN_DATA[number.substring(0, 2)] != null) {
    countryData = IBAN_DATA[number.substring(0, 2)]!;
    blocks = (countryData.length - 2) ~/ 2;
  } else {
    countryData = [
      {'country': 'common_country_unknown'},
      {'length': 33},
      {'b': 33},
      {'type': IBAN_IDENTIFIER_TYPES.ALPHANUMERIC},
    ];
  }

  int index = 4;
  for (int i = 0; i < blocks; i++) {
    List<int> digits = countryData[2 + i].entries.map((entry) => (entry.value as int)).toList();
    block = number.substring(index, index + digits[0]);
    index = index + digits[0];
    for (int j = 0; j < block.length; j++) {
      if (block[j] == '?') {
        List<IBAN_IDENTIFIER_TYPES> bankIdentifiers =
            countryData[2 + i + blocks].entries.map((entry) => (entry.value as IBAN_IDENTIFIER_TYPES)).toList();
        loops.add(_LOOP_DATA[bankIdentifiers[0]]!);
        bases.add(_LOOP_DATA[bankIdentifiers[0]]!.length);
      }
    }
  }
  List<int> convertBases = [0];
  convertBases = bases.reversed.toList();

  int maxLoops = 1;
  for (int i = 0; i < loops.length; i++) {
    maxLoops = maxLoops * loops[i].length;
  }

  String testPattern = '';
  String numberToCheck = '';
  for (int i = 0; i < maxLoops; i++) {
    testPattern = _getPattern(i, bases, convertBases, loops);
    index = 0;
    numberToCheck = '';
    for (int j = 0; j < number.length; j++) {
      if (number[j] == '?') {
        numberToCheck = numberToCheck + testPattern[index];
        index++;
      } else {
        numberToCheck = numberToCheck + number[j];
      }
    }
    if (_checkIBAN(numberToCheck)) {
      result.add(numberToCheck);
    }
  }

  return result;
}

String _getPattern(int indexToCheck, List<int> bases, List<int> convertBases, List<List<String>> loops) {
  String pattern = '';
  int loopIndex = 0;
  for (int i = 0; i < bases.length - 1; i++) {
    loopIndex = indexToCheck ~/ convertBases[i];
    pattern = pattern + loops[i][loopIndex];
    indexToCheck = indexToCheck % convertBases[i];
  }
  pattern = pattern + loops[bases.length - 1][indexToCheck];
  return pattern;
}
