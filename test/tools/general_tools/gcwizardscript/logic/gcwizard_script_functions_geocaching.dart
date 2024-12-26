part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsGeocachingToExpected = [
  {'code' : 'print BWW("ÄÖÜ", 0, 0)', 'expectedOutput' : '0'},
  {'code' : 'print BWW("ÄÖÜ", 1, 0)', 'expectedOutput' : '84'},
  {'code' : 'print BWW("ÄÖÜ", 2, 0)', 'expectedOutput' : '52'},
  {'code' : 'print BWW("ÄÖÜ", 3, 0)', 'expectedOutput' : '52'},

  {'code' : 'A="ZBDH HBIOS HIKRZ XHIKR IBEUZ HIKSZ LSHIB IHRZS BHIRX ZKMO IKLUX ORSU"\nDIM L\nTEXTANALYSIS(L, A, 0)\nPRINT LISTTOSTRING(L)', 'expectedOutput' : '[[12. 68], [B, 5], [D, 1], [E, 1], [H, 8], [I, 9], [K, 5], [L, 2], [M, 1], [O, 3], [R, 5], [S, 5], [U, 3], [Z, 6]]'},

];