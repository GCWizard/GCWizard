import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsIMEICheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsIMEICheckNumber({super.key}) : super(mode: CheckDigitsMode.IMEI);
}

class CheckDigitsIMEICalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsIMEICalculateCheckDigit({super.key}) : super(mode: CheckDigitsMode.IMEI);
}

class CheckDigitsIMEICalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsIMEICalculateMissingDigit({super.key}) : super(mode: CheckDigitsMode.IMEI);
}
