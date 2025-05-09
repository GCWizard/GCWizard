import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_decimalrange/widget/irrationalnumbers_decimalrange.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_nthdecimal/widget/irrationalnumbers_nthdecimal.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_search/widget/irrationalnumbers_search.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/sqrt3/logic/sqrt3.dart';

class SQRT3NthDecimal extends IrrationalNumbersNthDecimal {
  const SQRT3NthDecimal({super.key}) : super(irrationalNumber: SQRT_3);
}

class SQRT3DecimalRange extends IrrationalNumbersDecimalRange {
  const SQRT3DecimalRange({super.key}) : super(irrationalNumber: SQRT_3);
}

class SQRT3Search extends IrrationalNumbersSearch {
  const SQRT3Search({super.key}) : super(irrationalNumber: SQRT_3);
}
