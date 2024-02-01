part of 'gcwizard_scipt_test.dart';

List<Map<String, Object?>> _inputsGeocachingToExpected = [
  {'code' : 'print BWW("ÄÖÜ", 0, 0)', 'expectedOutput' : '0'},
  {'code' : 'print BWW("ÄÖÜ", 1, 0)', 'expectedOutput' : '84'},
  {'code' : 'print BWW("ÄÖÜ", 2, 0)', 'expectedOutput' : '52'},
  {'code' : 'print BWW("ÄÖÜ", 3, 0)', 'expectedOutput' : '52'},

];