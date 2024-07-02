part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsLoopsToExpected = [
  {'code' : code1l, 'expectedOutput' : '1\n2\n3'},
  {'code' : code2l, 'expectedOutput' : '1\n2\n3'},
  {'code' : code3l, 'expectedOutput' : '1\n3\n5'},
  {'code' : code4l, 'expectedOutput' : '1\n2\n3'},
  {'code' : code5l, 'expectedOutput' : '1\n2'},
  {'code' : code6l, 'expectedOutput' : '1\n1.5\n2.0\n2.5\n3.0\n3.5\n4.0\n4.5\n5.0\n5.5\n6.0'},
  {'code' : code7l, 'expectedOutput' : '3\n2\n1'},
];

var code1l = ''' 
for b = 1 to 3
  print b
next
end
''';

var code2l = ''' 
b = 1
while b < 4
  print b
  b = b + 1
wend
end
''';

var code3l = ''' 
for b = 1 to 6 step 2
  print b
next
end
''';

var code4l = ''' 
for b = 1 to 6
  print b
  if b = 3 then 
    break
  endif  
next
end
''';

var code5l = ''' 
b = 1
repeat
  print b
  b = b + 1
  if b = 3 then 
    break
  endif  
until b = 4
end
''';

var code6l = ''' 
for b = 1 to 6 step 0.5
  print b
next
end
''';

var code7l = ''' 
for b = 3 to 1 step -1
  print b
next
end
''';