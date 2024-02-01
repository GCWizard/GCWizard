part of 'gcwizard_scipt_test.dart';

  String _convertTo_3 = '''SETLAT(52.345678)
SETLON(13.456789)
PRINT CONVERTTO(3)''';

String _convertTo_11 = '''SETLAT(52.345678)
SETLON(13.456789)
PRINT CONVERTTO(11)''';

String _convertFrom_3 = '''DIM C
LISTADD(C, 33)
LISTADD(C, "U")
LISTADD(C, 394878.89897400007)
LISTADD(C, 5800607.559253929)
CONVERTFROM(3, C)
PRINT GETLAT()
PRINT GETLON()''';

String _convertFrom_11 = '''DIM C
LISTADD(C, "JO62RI42TX51MB52")
CONVERTFROM(11, C)
PRINT GETLAT()
PRINT GETLON()''';

List<Map<String, Object?>> _inputsCoordinatesToExpected = [

  {'code' : 'print BEARING(x, 13.678, 52.123, 11.534)', 'expectedOutput' : '358.3236011961208'},
  {'code' : 'print BEARING(54.123, 52.123, 11.534)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print BEARING(54.123, 13.678, 52.123, 11.534, 34.45)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print BEARING(54.123, 13.678, 52.123, 11.534)', 'expectedOutput' : '213.6786724810965'},

  {'code' : 'print DISTANCE(x, 13.678, 52.123, 11.534)', 'expectedOutput' : '5780521.806478069'},
  {'code' : 'print DISTANCE(54.123, 52.123, 11.534)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DISTANCE(54.123, 13.678, 52.123, 11.534, 34.45)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DISTANCE(54.123, 13.678, 52.123, 11.534)', 'expectedOutput' : '264815.84563546465'},

  {'code' : 'PROJECTION(x, 13.678, 52.123)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error_invalid_number_of_parameters'},
  {'code' : 'PROJECTION(54.123, 52.123, 11.534)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error_invalid_number_of_parameters'},
  {'code' : 'PROJECTION(54.123, 13.678, 52.123, 11.534, 34.45)', 'expectedOutput' : '', 'error': 'gcwizard_script_unbalanced_parentheses'},
  {'code' : 'PROJECTION(54.123, 13.678, 52.123, 11.534)', 'expectedOutput' : ''},
  {'code' : 'PROJECTION(54.123, 13.678, "A",11.534)', 'expectedOutput' : '', 'error': 'gcwizard_script_casting_error'},

  {'code' : 'print DECTODMM()', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DECTODMM(x)', 'expectedOutput' : '0° 0.000\''},
  {'code' : 'print DECTODMM(0)', 'expectedOutput' : ''},
  {'code' : 'print DECTODMM(54.123)', 'expectedOutput' : '54° 7.380\''},
  {'code' : 'print DECTODMM(54.123, 1)', 'expectedOutput' : '54° 7.380\'', 'error' : 'gcwizard_script_unbalanced_parentheses'},

  {'code' : 'print DECTODMS()', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DECTODMS(x)', 'expectedOutput' : '0° 0\' 0.000"'},
  {'code' : 'print DECTODMS(0)', 'expectedOutput' : ''},
  {'code' : 'print DECTODMS(54.123)', 'expectedOutput' : '54° 7\' 22.800"'},
  {'code' : 'print DECTODMS(54.123, 1)', 'expectedOutput' : '54° 7\' 22.800"', 'error' : 'gcwizard_script_unbalanced_parentheses'},

  {'code' : 'print DMMTODEC()', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMMTODEC(x)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMMTODEC(0)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMMTODEC(54.123)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMMTODEC(54.123, 12)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMMTODEC(54.123, 12.456)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMMTODEC(54, 12)', 'expectedOutput' : '54.2'},
  {'code' : 'print DMMTODEC(54, 12.456)', 'expectedOutput' : '54.2076'},

  {'code' : 'print DMSTODEC()', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMSTODEC(x)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMSTODEC(0)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMSTODEC(54.123)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMSTODEC(54.123, 1, 3)', 'expectedOutput' : '', 'error': 'gcwizard_script_syntax_error'},
  {'code' : 'print DMSTODEC(54, 1, 3)', 'expectedOutput' : '54.0175'},
  {'code' : 'print DMSTODEC(54, 1, 3.0)', 'expectedOutput' : '54.0175'},

  {'code' : _convertTo_3, 'expectedOutput' : '[33U 394878.89897400007 5800607.559253929, 33, U, 394878.89897400007, 5800607.559253929]'},
  {'code' : _convertTo_11, 'expectedOutput' : '[JO62RI42TX51MB52]'},

  {'code' : _convertFrom_3, 'expectedOutput' : '52.34567800325836\n13.456788999833897'},
  {'code' : _convertFrom_11, 'expectedOutput' : '52.34567795138889\n13.456788917824042'},
];