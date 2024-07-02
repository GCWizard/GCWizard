part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

CheckDigitOutput _CheckIMEINumber(String number) {
  if (number.length == 15) {
    if (_checkNumber(number, _checkIMEI)) {
      return CheckDigitOutput(true, '', ['']);
    } else {
      return CheckDigitOutput(
          false,
          _CalculateCheckDigitAndNumber(number.substring(0, number.length - 1), _CalculateIMEINumber),
          _CalculateGlitch(number, _checkIMEI));
    }
  }
  return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
}

String _CalculateIMEINumber(String number) {
  if (number.length == 14) {
    return number + _calculateIMEICheckDigit(number);
  }
  return 'checkdigits_invalid_length';
}

List<String> _CalculateIMEIDigits(String number) {
  if (number.length == 15) {
    return _CalculateDigits(number, _checkIMEI);
  } else {
    return ['checkdigits_invalid_length'];
  }
}

bool _checkIMEI(String number) {
  return (number[14] == _calculateIMEICheckDigit(number.substring(0, number.length - 1)));
}

String _calculateIMEICheckDigit(String number) {
  int sum = 0;
  int product = 0;
  for (int i = 0; i < number.length; i++) {
    if (i % 2 == 0) {
      product = 1 * int.parse(number[i]);
    } else {
      product = 2 * int.parse(number[i]);
    }
    sum = sum + product ~/ 10 + product % 10;
  }
  if (sum >= 100) {
    sum = sum % 100;
  }
  sum = sum % 10;
  sum = 10 - sum;
  if (sum == 10) {
    sum = 0;
  }
  return sum.toString();
}
