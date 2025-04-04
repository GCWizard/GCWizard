import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsCreditCardCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsCreditCardCheckNumber({super.key}) : super(mode: CheckDigitsMode.CREDITCARD);
}

class CheckDigitsCreditCardCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsCreditCardCalculateCheckDigit({super.key}) : super(mode: CheckDigitsMode.CREDITCARD);
}

class CheckDigitsCreditCardCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsCreditCardCalculateMissingDigit({super.key}) : super(mode: CheckDigitsMode.CREDITCARD);
}
