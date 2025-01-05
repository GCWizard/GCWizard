import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsCreditCardCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsCreditCardCheckNumber({Key? key}) : super(key: key, mode: CheckDigitsMode.CREDITCARD);
}

class CheckDigitsCreditCardCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsCreditCardCalculateCheckDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.CREDITCARD);
}

class CheckDigitsCreditCardCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsCreditCardCalculateMissingDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.CREDITCARD);
}
