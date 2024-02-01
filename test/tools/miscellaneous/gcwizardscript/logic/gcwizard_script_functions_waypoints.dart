part of 'gcwizard_scipt_test.dart';

List<Map<String, Object?>> _inputsWaypoinsToExpected = [
  {'code' : 'print WPTSCLEAR()', 'expectedOutput' : ''},
  {'code' : 'print WPTSCLEAR(10)', 'expectedOutput' : ''},
  {'code' : 'print WPTSCLEAR("10")', 'expectedOutput' : ''},
  {'code' : 'print WPTSADD("10")', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print WPTSADD(10)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print WPTSADD(10, 10)', 'expectedOutput' : ''},
  {'code' : 'print WPTSADD(10.0, 10.0)', 'expectedOutput' : ''},
  {'code' : 'print WPTSADD(20.0, 20.0)', 'expectedOutput' : ''},
  {'code' : 'print WPTSCOUNT()', 'expectedOutput' : '2'},
  {'code' : 'print WPTSCOUNT(0)', 'expectedOutput' : '2'},

  {'code' : 'print WPTSCLEAR()', 'expectedOutput' : ''},
  {'code' : 'print WPTSADD(10, 30)', 'expectedOutput' : ''},
  {'code' : 'print WPTSLAT("1")', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print WPTSLAT(1)', 'expectedOutput' : '10'},
  {'code' : 'print WPTSLAT(4)', 'expectedOutput' : '', 'error': 'gcwizard_script_range_error'},
  {'code' : 'print WPTSLON("1")', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print WPTSLON(4)', 'expectedOutput' : '', 'error': 'gcwizard_script_range_error'},

  {'code' : 'print WPTSCLEAR()', 'expectedOutput' : ''},
  {'code' : 'print WPTSADD(10, 30)', 'expectedOutput' : ''},
  {'code' : 'print WPTSADD(1, 5)', 'expectedOutput' : ''},
  {'code' : 'print WPTSCENTER(4)', 'expectedOutput' : ''},
  {'code' : 'print WPTSCENTER()', 'expectedOutput' : ''},

  {'code' : 'print WPTSCLEAR()', 'expectedOutput' : ''},
  {'code' : 'print WPTSCENTER()', 'expectedOutput' : ''},

  {'code' : 'print WPTSCLEAR()', 'expectedOutput' : ''},
  {'code' : 'print WPTSADD(10, 30)', 'expectedOutput' : ''},
  {'code' : 'print WPTSCENTER()', 'expectedOutput' : ''},

];