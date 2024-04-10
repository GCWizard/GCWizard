import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';


class CheckDigitsEANCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsEANCheckNumber({Key? key}) : super(key: key, mode: CheckDigitsMode.EAN_GTIN);
}

class CheckDigitsEANCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsEANCalculateCheckDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.EAN_GTIN);
}

class CheckDigitsEANCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsEANCalculateMissingDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.EAN_GTIN);
}