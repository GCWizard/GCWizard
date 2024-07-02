part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsCommandsToExpected = [
  {'code' : codePRINT, 'expectedOutput' : '''
Hello GC Wizard
Hello GC Wizard
Hello GC Wizard
Hello GC Wizard Hello'''},
];

var codePRINT = ''' 
A = "Hello"
B = "GC Wizard"
print A + " " +  B
print A + " GC Wizard"
print "Hello " + B
print "Hello " + B + " " + A
''';

