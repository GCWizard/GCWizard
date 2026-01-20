import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsIBANCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsIBANCheckNumber({super.key}) : super(mode: CheckDigitsMode.IBAN);
}

class CheckDigitsIBANCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsIBANCalculateCheckDigit({super.key}) : super(mode: CheckDigitsMode.IBAN);
}

class CheckDigitsIBANCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsIBANCalculateMissingDigit({super.key}) : super(mode: CheckDigitsMode.IBAN);
}
