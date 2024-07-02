part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsStringToExpected = [
  {'code' : 'print STR(10)', 'expectedOutput' : '10'},
  {'code' : 'print VAL(10)', 'expectedOutput' : '10', },
  {'code' : 'print VAL("10")', 'expectedOutput' : '10.0'},
  {'code' : 'print LEN(10)', 'expectedOutput' : '0', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print LEN("10")', 'expectedOutput' : '2'},
  {'code' : 'print CHAR(10)', 'expectedOutput' : ''},
  {'code' : 'print ASC(10)', 'expectedOutput' : '-1', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print ASC("A")', 'expectedOutput' : '65'},
  {'code' : 'print ASC(A)', 'expectedOutput' : '-1', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print LEFT(10)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print RIGHT(10)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print MID(10)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print MID(10, 5)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print MID("MIDTEST", 4, 4)', 'expectedOutput' : 'TEST'},
  {'code' : 'print SUBST("MIDTEST", "E", "OA", 0)', 'expectedOutput' : 'MIDTOAST'},


];