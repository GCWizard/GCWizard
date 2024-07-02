import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsDETaxIDCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsDETaxIDCheckNumber({Key? key}) : super(key: key, mode: CheckDigitsMode.DETAXID);
}

class CheckDigitsDETaxIDCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsDETaxIDCalculateCheckDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.DETAXID);
}

class CheckDigitsDETaxIDCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsDETaxIDCalculateMissingDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.DETAXID);
}
