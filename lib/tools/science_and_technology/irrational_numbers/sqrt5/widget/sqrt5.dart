import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_decimalrange/widget/irrationalnumbers_decimalrange.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_nthdecimal/widget/irrationalnumbers_nthdecimal.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_search/widget/irrationalnumbers_search.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/sqrt5/logic/sqrt5.dart';

class SQRT5NthDecimal extends IrrationalNumbersNthDecimal {
  const SQRT5NthDecimal({super.key}) : super(irrationalNumber: SQRT_5);
}

class SQRT5DecimalRange extends IrrationalNumbersDecimalRange {
  const SQRT5DecimalRange({super.key}) : super(irrationalNumber: SQRT_5);
}

class SQRT5Search extends IrrationalNumbersSearch {
  const SQRT5Search({super.key}) : super(irrationalNumber: SQRT_5);
}
