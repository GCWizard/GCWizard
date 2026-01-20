import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsDETaxIDCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsDETaxIDCheckNumber({super.key}) : super(mode: CheckDigitsMode.DETAXID);
}

class CheckDigitsDETaxIDCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsDETaxIDCalculateCheckDigit({super.key}) : super(mode: CheckDigitsMode.DETAXID);
}

class CheckDigitsDETaxIDCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsDETaxIDCalculateMissingDigit({super.key}) : super(mode: CheckDigitsMode.DETAXID);
}
