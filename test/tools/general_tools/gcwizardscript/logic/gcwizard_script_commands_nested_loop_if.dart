part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsCommandsFORIFToExpected = [
  {'code' : codeFORIF_00i, 'expectedOutput' : '''
1       REMAINDER 1
2       REMAINDER 2
3       REMAINDER 3
4       DIVISIBLE BY 4
5       REMAINDER 1
6       REMAINDER 2
7       REMAINDER 3
8       DIVISIBLE BY 4
9       REMAINDER 1
10      REMAINDER 2'''},

];

var codeFORIF_00i = ''' 
FOR I = 1 TO 10 STEP 1
A = MOD(I,4)
IF A = 0 THEN
PRINT I,"DIVISIBLE BY 4"
ELSEIF A = 1 THEN
PRINT I,"REMAINDER 1"
ELSEIF A = 2 THEN
PRINT I, "REMAINDER 2"
ELSE
PRINT I,"REMAINDER 3"
ENDIF
NEXT
''';

