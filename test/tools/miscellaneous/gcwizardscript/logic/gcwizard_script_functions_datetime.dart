part of 'gcwizard_scipt_test.dart';

DateTime _now = DateTime.now();
var date = DateFormat('yyyy/MM/dd').format(_now);
var time = DateFormat('HH:mm:ss').format(_now);

List<Map<String, Object?>> _inputsDateTimeToExpected = [

  {'code' : 'print DATE()', 'expectedOutput' : date},
  // {'code' : 'print TIME()', 'expectedOutput' : time}, will not work due to delay of 2 sec while interpreting
  {'code' : 'print DATE(x)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print TIME(x)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},

  {'code' : 'print DATE', 'expectedOutput' : '0.0'},
  {'code' : 'print TIME', 'expectedOutput' : '0.0'},
];