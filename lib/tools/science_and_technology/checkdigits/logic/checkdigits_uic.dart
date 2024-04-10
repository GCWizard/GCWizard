part of 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';

CheckDigitOutput _CheckUICNumber(String number) {
  if (number.length == 12) {
    var uicWagonCode = UICWagonCode.fromNumber(number);

    if (uicWagonCode.hasValidCheckDigit) {
      return CheckDigitOutput(true, '', ['']);
    } else {
      return CheckDigitOutput(
          false,
          _CalculateCheckDigitAndNumber(number.substring(0, number.length - 1), _CalculateUICNumber),
          _CalculateGlitch(number, (String x) => UICWagonCode.fromNumber(x).hasValidCheckDigit)
      );
    }
  }
  return CheckDigitOutput(false, 'checkdigits_invalid_length', ['']);
}

String _CalculateUICNumber(String number) {
  if (number.length == 11) {
    return number + UICWagonCode.calculateUICWagonCodeCheckDigit(number);
  }
  return 'checkdigits_invalid_length';
}

List<String> _CalculateUICDigits(String number) {
  if (number.length == 12) {
    return _CalculateDigits(number, (String x) => UICWagonCode.fromNumber(x).hasValidCheckDigit);
  } else {
    return ['checkdigits_invalid_length'];
  }
}
