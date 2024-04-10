part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

CheckDigitOutput _CheckISBNNumber(String number){
  number = number.replaceAll('#', '').toUpperCase();
  if (number == '') {
    return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
  }

  if (number.length == 10 || number.length == 13) {
    if (_checkNumber(number, _checkISBN)) {
      return CheckDigitOutput(true, '', ['']);
    } else {
      return CheckDigitOutput(false, _CalculateCheckDigitAndNumber(number.substring(0, number.length - 1), _CalculateISBNNumber), _CalculateGlitch(number, _checkISBN));
    }
  }
  return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
}

String _CalculateISBNNumber(String number){
  if (number.length == 9) {
    return number + _calculateCheckDigit(number, _calculateISBNCheckDigit);
  } else {
    if (number.length == 12) {
      if (int.tryParse(number) == null) {
        return 'checkdigits_invalid_format';
      } else {
        return number + _calculateCheckDigit(number, _calculateEANCheckDigit);
      }
    } else {
      return 'checkdigits_invalid_length';
    }
  }
}

List<String> _CalculateISBNDigits(String number){
  number = number.toUpperCase();
  if (number.length == 10 || number.length == 13) {
    return _CalculateDigits(number, _checkISBN);
  } else {
    return ['checkdigits_invalid_length'];
  }
}


bool _checkISBN(String number) {
  if (number.length > 10 && int.tryParse(number) == null) {
    return false;
  } else {
    return (number[number.length - 1] ==
        _calculateCheckDigit(number.substring(0, number.length - 1), _calculateISBNCheckDigit));
  }
}

String  _calculateISBNCheckDigit(String number) {
  if (number.length == 9) {
    int sum = 0;
    for (int i = 1; i < 10; i++) {
      sum = sum + i * int.parse(number[i]);
      sum = sum % 11;
      if (sum == 10) {
        return 'X';
      } else {
        return sum.toString();
      }
    }
    if (sum >= 100) {
      sum = sum % 100;
    }
    sum = sum % 10;
    sum = 10 - sum;
    return sum.toString();
  } else {
    if (int.tryParse(number) == null) {
      return '';
    } else {
      return _calculateCheckDigit(number, _calculateEANCheckDigit);
    }
  }
}