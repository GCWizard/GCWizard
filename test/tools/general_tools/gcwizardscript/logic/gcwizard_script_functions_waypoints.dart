part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsWaypoinsToExpected = [
  {'code' : 'WPTSCLEAR()', 'expectedOutput' : ''},
  {'code' : 'WPTSCLEAR(10)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error_invalid_number_of_parameters'},
  {'code' : 'WPTSCLEAR("10")', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error_invalid_number_of_parameters'},

  {'code' : 'WPTSADD("10")', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error_invalid_number_of_parameters'},
  {'code' : 'WPTSADD(10)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error_invalid_number_of_parameters'},
  {'code' : 'WPTSADD(10, 10)', 'expectedOutput' : '', },
  {'code' : 'WPTSADD(10.0, 10.0)', 'expectedOutput' : ''},
  {'code' : 'WPTSADD(20.0, 20.0)', 'expectedOutput' : ''},

  {'code' : 'WPTSCOUNT()', 'expectedOutput' : ''},
  {'code' : 'WPTSCOUNT(0)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error_invalid_number_of_parameters'},

  {'code' : 'WPTSLAT("1")', 'expectedOutput' : '', 'error': 'gcwizard_script_casting_error'},
  {'code' : 'WPTSLAT(1)', 'expectedOutput' : '', 'error': 'gcwizard_script_range_error'},
  {'code' : 'WPTSLON("1")', 'expectedOutput' : '', 'error': 'gcwizard_script_casting_error'},
  {'code' : 'WPTSLON(4)', 'expectedOutput' : '', 'error': 'gcwizard_script_range_error'},

  {'code' : 'WPTSCENTER(4)', 'expectedOutput' : ''},
  {'code' : 'WPTSCENTER()', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},

  {'code' : 'WPTSADD(10.0, 10.0)\nPRINT WPTSCOUNT()', 'expectedOutput' : '1', },
  {'code' : 'WPTSADD(10.0, 20.0)\nPRINT WPTSCOUNT()\nPRINT WPTSLAT(1)', 'expectedOutput' : '1\n10.0', },
  {'code' : 'WPTSADD(10.0, 20.0)\nPRINT WPTSCOUNT()\nPRINT WPTSLON(1)', 'expectedOutput' : '1\n20.0', },

  {'code' : 'WPTSADD(0.0, 0.0)\nWPTSADD(10.0, 0.0)\nWPTSADD(0.0, 10.0)\nPRINT WPTSCOUNT()\nWPTSCENTER(0)\nPRINT GETLAT(), GETLON()', 'expectedOutput' : '3\n3.3333333333333335      3.3333333333333335', },

];