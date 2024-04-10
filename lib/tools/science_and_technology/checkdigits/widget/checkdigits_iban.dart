import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsIBANCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsIBANCheckNumber({Key? key}) : super(key: key, mode: CheckDigitsMode.IBAN);
}

class CheckDigitsIBANCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsIBANCalculateCheckDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.IBAN);
}

class CheckDigitsIBANCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsIBANCalculateMissingDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.IBAN);
}