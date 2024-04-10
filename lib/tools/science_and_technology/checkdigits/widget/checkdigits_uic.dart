import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';


class CheckDigitsUICCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsUICCheckNumber({Key? key}) : super(key: key, mode: CheckDigitsMode.UIC);
}

class CheckDigitsUICCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsUICCalculateCheckDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.UIC);
}

class CheckDigitsUICCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsUICCalculateMissingDigit({Key? key}) : super(key: key, mode: CheckDigitsMode.UIC);
}