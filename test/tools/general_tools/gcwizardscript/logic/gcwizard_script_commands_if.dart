part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsCommandsIFToExpected = [
  {'code' : codeIF_00i, 'expectedOutput' : '''
Test 0'''},
  {'code' : codeIF_01i, 'expectedOutput' : '''
Test 1'''},
  {'code' : codeIF_02i, 'expectedOutput' : '''
Test 2'''},
  {'code' : codeIF_00d, 'expectedOutput' : '''
Test 0.0'''},
  {'code' : codeIF_01d, 'expectedOutput' : '''
Test 1.0'''},
  {'code' : codeIF_02d, 'expectedOutput' : '''
Test 2.0'''},
  {'code' : codeIF_00di, 'expectedOutput' : '''
Test 0'''},
  {'code' : codeIF_01di, 'expectedOutput' : '''
Test 1'''},
  {'code' : codeIF_02di, 'expectedOutput' : '''
Test 2'''},
  {'code' : codeIF_00s, 'expectedOutput' : '''
Test 0'''},
  {'code' : codeIF_01s, 'expectedOutput' : '''
Test 1'''},
  {'code' : codeIF_02s, 'expectedOutput' : '''
Test 2'''},
];

var codeIF_00i = ''' 
A = 0
IF A = 0 THEN
PRINT "Test 0"
ELSEIF A = 1 THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';

var codeIF_01i = ''' 
A = 1
IF A = 0 THEN
PRINT "Test 0"
ELSEIF A = 1 THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';

var codeIF_02i = ''' 
A = 2
IF A = 0 THEN
PRINT "Test 0"
ELSEIF A = 1 THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';

var codeIF_00d = ''' 
A = 0.0
IF A = 0.0 THEN
PRINT "Test 0.0"
ELSEIF A = 1 THEN
PRINT "Test 1.0"
ELSE
PRINT "Test 2.0"
ENDIF
''';

var codeIF_01d = ''' 
A = 1.0
IF A = 0 THEN
PRINT "Test 0"
ELSEIF A = 1.0 THEN
PRINT "Test 1.0"
ELSE
PRINT "Test 2.0"
ENDIF
''';

var codeIF_02d = ''' 
A = 2.0
IF A = 0 THEN
PRINT "Test 0"
ELSEIF A = 1 THEN
PRINT "Test 1.0"
ELSE
PRINT "Test 2.0"
ENDIF
''';

var codeIF_00di = ''' 
A = 0.0
IF A = 0 THEN
PRINT "Test 0"
ELSEIF A = 1 THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';

var codeIF_01di = ''' 
A = 1
IF A = 0 THEN
PRINT "Test 0"
ELSEIF A = 1.0 THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';

var codeIF_02di = ''' 
A = 2.0
IF A = 0 THEN
PRINT "Test 0"
ELSEIF A = 1 THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';

var codeIF_00s = ''' 
A = "0"
IF A = "0" THEN
PRINT "Test 0"
ELSEIF A = "1" THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';

var codeIF_01s = ''' 
A = "1"
IF A = "0" THEN
PRINT "Test 0"
ELSEIF A = "1" THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';

var codeIF_02s = ''' 
A = "2"
IF A = "0" THEN
PRINT "Test 0"
ELSEIF A = "1" THEN
PRINT "Test 1"
ELSE
PRINT "Test 2"
ENDIF
''';
