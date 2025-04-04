import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsEANCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsEANCheckNumber({super.key}) : super(mode: CheckDigitsMode.EAN_GTIN);
}

class CheckDigitsEANCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsEANCalculateCheckDigit({super.key}) : super(mode: CheckDigitsMode.EAN_GTIN);
}

class CheckDigitsEANCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsEANCalculateMissingDigit({super.key}) : super(mode: CheckDigitsMode.EAN_GTIN);
}
