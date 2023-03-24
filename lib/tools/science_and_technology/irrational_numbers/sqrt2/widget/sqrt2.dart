import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_decimalrange/widget/irrationalnumbers_decimalrange.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_nthdecimal/widget/irrationalnumbers_nthdecimal.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/irrationalnumbers_search/widget/irrationalnumbers_search.dart';
import 'package:gc_wizard/tools/science_and_technology/irrational_numbers/sqrt2/logic/sqrt2.dart';

class SQRT2NthDecimal extends IrrationalNumbersNthDecimal {
  const SQRT2NthDecimal({Key? key}) : super(key: key, irrationalNumber: SQRT_2);
}

class SQRT2DecimalRange extends IrrationalNumbersDecimalRange {
  const SQRT2DecimalRange({Key? key}) : super(key: key, irrationalNumber: SQRT_2);
}

class SQRT2Search extends IrrationalNumbersSearch {
  const SQRT2Search({Key? key}) : super(key: key, irrationalNumber: SQRT_2);
}
