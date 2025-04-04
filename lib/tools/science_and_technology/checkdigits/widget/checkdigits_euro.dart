import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsEUROCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsEUROCheckNumber({super.key}) : super(mode: CheckDigitsMode.EURO);
}

class CheckDigitsEUROCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsEUROCalculateCheckDigit({super.key}) : super(mode: CheckDigitsMode.EURO);
}

class CheckDigitsEUROCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsEUROCalculateMissingDigit({super.key}) : super(mode: CheckDigitsMode.EURO);
}
