part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsBaseToExpected = [
  {'code' : 'print BASE(16.0, 0, "30")', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print BASE(16, test, "30")', 'expectedOutput' : '0'},
  {'code' : 'print BASE(15, 0, "30")', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print BASE(16, 0, "30", 5)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print BASE(16, 0)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},

  {'code' : 'print BASE(16, 0, "30")', 'expectedOutput' : '0'},
  {'code' : 'print BASE(16, 0, "3A")', 'expectedOutput' : ':'},
  {'code' : 'print BASE(16, 1, "0")', 'expectedOutput' : '30'},
  {'code' : 'print BASE(16, 1, ":")', 'expectedOutput' : '3a'},

  {'code' : 'print BASE(32, 0, "GA======")', 'expectedOutput' : '0'},
  {'code' : 'print BASE(32, 0, "HI======")', 'expectedOutput' : ':'},
  {'code' : 'print BASE(32, 1, "0")', 'expectedOutput' : 'GA======'},
  {'code' : 'print BASE(32, 1, ":")', 'expectedOutput' : 'HI======'},


  {'code' : 'print BASE(58, 0, "30")', 'expectedOutput' : '2'},
  {'code' : 'print BASE(58, 0, "3A")', 'expectedOutput' : '150'},
  {'code' : 'print BASE(58, 1, "2")', 'expectedOutput' : '3'},
  {'code' : 'print BASE(58, 1, "150")', 'expectedOutput' : '3A'},

  {'code' : 'print BASE(64, 0, "MzAw")', 'expectedOutput' : '300'},
  {'code' : 'print BASE(64, 0, "MzAx")', 'expectedOutput' : '301'},
  {'code' : 'print BASE(64, 1, "300")', 'expectedOutput' : 'MzAw'},
  {'code' : 'print BASE(64, 1, "301")', 'expectedOutput' : 'MzAx'},

  {'code' : 'print BASE(85, 0, "<~1GCK~>")', 'expectedOutput' : '300'},
  {'code' : 'print BASE(85, 0, "<~1GCN~>")', 'expectedOutput' : '301'},
  {'code' : 'print BASE(85, 1, "300")', 'expectedOutput' : '<~1GCK~>'},
  {'code' : 'print BASE(85, 1, "301")', 'expectedOutput' : '<~1GCN~>'},

  {'code' : 'print BASE(91, 0, "0tVE")', 'expectedOutput' : '300'},
  {'code' : 'print BASE(91, 0, "0tdE")', 'expectedOutput' : '301'},
  {'code' : 'print BASE(91, 1, "300")', 'expectedOutput' : '0tVE'},
  {'code' : 'print BASE(91, 1, "301")', 'expectedOutput' : '0tdE'},

  {'code' : 'print BASE(122, 0, " MFc1Tl4")', 'expectedOutput' : 'A666564'},
  {'code' : 'print BASE(122, 1, "A666564")', 'expectedOutput' : ' MFc1Tl4'},
];