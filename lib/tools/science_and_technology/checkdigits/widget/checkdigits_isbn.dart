import 'package:gc_wizard/tools/science_and_technology/checkdigits/logic/checkdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_checkdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_calculate_missingdigit.dart';
import 'package:gc_wizard/tools/science_and_technology/checkdigits/widget/base/checkdigits_check_number.dart';

class CheckDigitsISBNCheckNumber extends CheckDigitsCheckNumber {
  const CheckDigitsISBNCheckNumber({super.key}) : super(mode: CheckDigitsMode.ISBN);
}

class CheckDigitsISBNCalculateCheckDigit extends CheckDigitsCalculateCheckDigit {
  const CheckDigitsISBNCalculateCheckDigit({super.key}) : super(mode: CheckDigitsMode.ISBN);
}

class CheckDigitsISBNCalculateMissingDigit extends CheckDigitsCalculateMissingDigits {
  const CheckDigitsISBNCalculateMissingDigit({super.key}) : super(mode: CheckDigitsMode.ISBN);
}
