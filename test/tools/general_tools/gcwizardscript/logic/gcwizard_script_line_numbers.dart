part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsLineNumbersToExpected = [
  {'code' : '''10 data 113, 53, 114, 125, 124, 119, 55, 16
20 for x = 1 to 8
70 read y
80 print y
90 next x''', 'expectedOutput' : '113\n53\n114\n125\n124\n119\n55\n16'},
  {'code' : '''data 113, 53, 114, 125, 124, 119, 55, 16
20 for x = 1 to 8
70 read y
80 print y
90 next x''', 'expectedOutput' : '113\n53\n114\n125\n124\n119\n55\n16'},
  {'code' : '''10 data 113, 53, 114, 125, 124, 119, 55, 16
for x = 1 to 8
read y
print y
next x''', 'expectedOutput' : '113\n53\n114\n125\n124\n119\n55\n16'},
];