part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

CheckDigitOutput _CheckDETaxIDNumber(String number) {
  if (number.length == 11) {
    if (_checkDETaxID(number)) {
      return CheckDigitOutput(true, '', ['']);
    } else {
      return CheckDigitOutput(
          false,
          _CalculateCheckDigitAndNumber(number.substring(0, number.length - 1), _CalculateDETaxIDNumber),
          _CalculateGlitch(number, _checkDETaxID));
    }
  }
  return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
}

String _CalculateDETaxIDNumber(String number) {
  if (number.length == 10) {
    return number + _calculateDETaxIDCheckDigit(number);
  }
  return 'checkdigits_invalid_length';
}

List<String> _CalculateDETaxIDDigits(String number) {
  if (number.length == 11) {
    return _CalculateDigits(number, _checkDETaxID);
  } else {
    return ['checkdigits_invalid_length'];
  }
}

bool _checkDETaxID(String number) {
  return (number[10] == _calculateDETaxIDCheckDigit(number.substring(0, number.length - 1)));
}

String _calculateDETaxIDCheckDigit(String number) {
  int product = 10;
  int sum = 0;
  int pz = 0;
  for (int i = 0; i < 10; i++) {
    sum = (int.parse(number[i]) + product) % 10;
    if (sum == 0) {
      sum = 10;
    }
    product = (sum * 2) % 11;
  }
  pz = 11 - product;
  if (pz == 10) {
    pz = 0;
  }
  return pz.toString();
}
