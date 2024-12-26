part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsFilesToExpected = [
  {
    'code': '''
  writetofile("HALLO")
writetofile(1)
writetofile(3.14)
print dumpfile(0)
print dumpfile(1)
print dumpfile(2)''',
    'expectedOutput': '''
 72  65  76  76  79   0  49   0  51  46  49  52   0
48 41 4C 4C 4F 0 31 0 33 2E 31 34 0
HALLO 1 3.14'''
  },
  {'code': '''
writetofile("HALLO")
writetofile(1)
writetofile(3.14)
a = readfromfile(0,3)
print a
''', 'expectedOutput': '''
LO'''},
  {'code': '''
writetofile("HALLO")
writetofile(1)
writetofile(3.14)
a = readfromfile(0,3)
print a
a = readfromfile(0,-1)
print a''', 'expectedOutput': '''
LO
1'''},
  {'code': '''
writetofile("HALLO")
a = readfromfile(1,3)
print a
a = readfromfile(0,-1)
print a''', 'expectedOutput': '''
76
O'''},
  {'code': '''
writetofile("HALLO")
a = readfromfile(1,3)
print a, char(a)
print eof()
a = readfromfile(1,-1)
print a, char(a)
print eof()''', 'expectedOutput': '''
76      L
0
79      O
1'''},
];
