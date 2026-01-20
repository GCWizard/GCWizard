import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_decimalrange/widget/irrationalnumbers_decimalrange.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_nthdecimal/widget/irrationalnumbers_nthdecimal.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_search/widget/irrationalnumbers_search.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/phi/logic/phi.dart';

class PhiNthDecimal extends IrrationalNumbersNthDecimal {
  const PhiNthDecimal({super.key}) : super(irrationalNumber: PHI);
}

class PhiDecimalRange extends IrrationalNumbersDecimalRange {
  const PhiDecimalRange({super.key}) : super(irrationalNumber: PHI);
}

class PhiSearch extends IrrationalNumbersSearch {
  const PhiSearch({super.key}) : super(irrationalNumber: PHI);
}
