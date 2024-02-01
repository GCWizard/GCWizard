part of 'gcwizard_scipt_test.dart';

List<Map<String, Object?>> _inputsMathNestedFunctionsToExpected = [
  {'code' : 'print SQRT(SQR(10))', 'expectedOutput' : '10.0'},
  {'code' : 'print FAC(TRUNC(SQRT(SQR(10))))', 'expectedOutput' : '3628800'},
  {'code' : 'print POW(SQRT(4),SQR(2))', 'expectedOutput' : '16.0'},
  {'code' : 'print POW(SQRT(SQR(2)),4)', 'expectedOutput' : '16.0'},
  {'code' : 'print POW(2,SQRT(SQR(2)))', 'expectedOutput' : '4.0'},
  {'code' : 'print POW(SQRT(SQR(2)),SQRT(SQR(2)))', 'expectedOutput' : '4.0'},

];