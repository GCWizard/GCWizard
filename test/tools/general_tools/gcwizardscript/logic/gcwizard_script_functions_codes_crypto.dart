part of 'gcwizard_scipt_test.dart';

// ignore: unused_element
List<Map<String, Object?>> _inputsCryptoToExpected = [
  {'code' : 'a="HALLO"\nprint ABADDON(a, 1)', 'expectedOutput' : 'þµ¥¥¥µµ¥¥µ¥¥þþþ'},
  {'code' : 'a="þµ¥¥¥µµ¥¥µ¥¥þþþ"\nprint ABADDON(a, 0)', 'expectedOutput' : 'HALLO'},

  {'code' : 'a="HALLO"\nprint ATBASH(a, 0)', 'expectedOutput' : '(Z|O)TKKH'},
  {'code' : 'a="ZTKKH"\nprint ATBASH(a, 0)', 'expectedOutput' : 'Z(A|N)LL(Z|O)'},
  {'code' : 'a="OTKKH"\nprint ATBASH(a, 0)', 'expectedOutput' : 'H(A|N)LL(Z|O)'},
  {'code' : 'a="HALLO"\nprint ATBASH(a, 1)', 'expectedOutput' : 'SZOOL'},
  {'code' : 'a="SZOOL"\nprint ATBASH(a, 1)', 'expectedOutput' : 'HALLO'},

  // It does not make sense to test a function which is based on a random function
  // {'code' : 'a="HALLO"\nprint AVEMARIA(a, 1)', 'expectedOutput' : 'arbiter clemens immortalis immortalis gloriosus'},
  {'code' : 'a="arbiter clemens immortalis immortalis gloriosus"\nprint AVEMARIA(a, 0)', 'expectedOutput' : 'HALLO'},

  {'code' : 'a="HALLO"\nprint BACON(a, 1)', 'expectedOutput' : 'AABBBAAAAAABABAABABAABBAB'},
  {'code' : 'a="AABBBAAAAAABABAABABAABBAB"\nprint BACON(a, 0)', 'expectedOutput' : 'HALLO'},

  {'code' : 'a="HALLO"\nprint rot5(a)', 'expectedOutput' : 'HALLO'},
  {'code' : 'a="123"\nprint rot5(a)', 'expectedOutput' : '678'},
  {'code' : 'a="HALLO"\nprint rot13(a)', 'expectedOutput' : 'MFQQT'},
  {'code' : 'a="HALLO123"\nprint rot13(a)', 'expectedOutput' : 'MFQQT123'},
  {'code' : 'a="HALLO"\nprint rot18(a)', 'expectedOutput' : 'MFQQT'},
  {'code' : 'a="HALLO123"\nprint rot18(a)', 'expectedOutput' : 'MFQQT678'},
  {'code' : 'a="HALLO"\nprint rot47(a)', 'expectedOutput' : 'wp{{~'},
  {'code' : 'a="HALLO123"\nprint rot47(a)', 'expectedOutput' : 'wp{{~`ab'},
  {'code' : 'a="HALLO"\nprint rotx(a, 1)', 'expectedOutput' : 'IBMMP'},
  {'code' : 'a="HALLO123"\nprint rotx(a, 1)', 'expectedOutput' : 'IBMMP123'},

  {'code' : 'print gccode("gcafdx1", 0)', 'expectedOutput' : '9284317'},
  {'code' : 'print gccode("9284317", 1)', 'expectedOutput' : 'GCAFDX1'},
  {'code' : 'print gccode(9284317, 1)', 'expectedOutput' : 'GCAFDX1'},

  {'code' : 'print morse("hallo", 1, 0)', 'expectedOutput' : '.... .- .-.. .-.. ---'},
  {'code' : 'print morse(".... .- .-.. .-.. ---", 0, 0)', 'expectedOutput' : 'HALLO'},
  {'code' : 'PRINT MORSE("HALLO", 1, 0)\n'+
            'PRINT MORSE("HALLO", 1, 10)\n'+
            'PRINT MORSE("HALLO", 1, 11)\n'+
            'PRINT MORSE("HALLO", 1, 2)\n'+
            'PRINT MORSE("HALLO", 1, 3)', 'expectedOutput' : '.... .- .-.. .-.. ---\n'+
                                                            '.... ... – – ..\n'+
                                                            '.... .- – – . .\n'+
                                                            '.... .- .-.. .-.. .-...\n'+
                                                            '---- .-. -.. -.. ...'},

  {'code' : 'print enclosedareas("HALLO 9876543210 MEINS", 0, 0)', 'expectedOutput' : '2 5 0'},
  {'code' : 'print enclosedareas("HALLO 9876543210 MEINS", 0, 1)', 'expectedOutput' : '2 6 0'},
  {'code' : 'print enclosedareas("HALLO 9876543210 MEINS", 1, 0)', 'expectedOutput' : '5'},
  {'code' : 'print enclosedareas("HALLO 9876543210 MEINS", 1, 1)', 'expectedOutput' : '6'},

  {'code' : 'print bcd("1234567890", 1, 0)', 'expectedOutput' : '0001 0010 0011 0100 0101 0110 0111 1000 1001 0000'},
  {'code' : 'print bcd(1234567890, 1, 0)', 'expectedOutput' : '0001 0010 0011 0100 0101 0110 0111 1000 1001 0000'},
  {'code' : 'print bcd("0001 0010 0011 0100 0101 0110 0111 1000 1001 0000", 0, 0)', 'expectedOutput' : '1234567890'},

  {'code' : 'print bifid("ZBDH", 5, 0, 0, "", 1)', 'expectedOutput' : 'VYBH'},
  {'code' : 'print bifid("ZBDH", 6, 0, 0, "", 1)', 'expectedOutput' : 'YJBH'},

  {'code' : 'print trifid("ZBDH", 2, 0, 1, "")', 'expectedOutput' : 'VTCK'},
  {'code' : 'print trifid("ZBDH", 3, 0, 1, "")', 'expectedOutput' : 'STMH'},
  {'code' : 'print trifid("ZBDH", 4, 0, 1, "")', 'expectedOutput' : 'SVLE'},
  {'code' : 'print trifid("ZBDH", 2, 1, 1, "")', 'expectedOutput' : 'UEBT'},
  {'code' : 'print trifid("ZBDH", 3, 2, 1, "")', 'expectedOutput' : 'STMH'},
  {'code' : 'print trifid("ZBDH", 4, 2, 1, "")', 'expectedOutput' : 'SGQK'},
  {'code' : 'print trifid("ZBDH", 4, 0, 0, "QWERTZUIOPASDFGHJKLYXCVBNM,")', 'expectedOutput' : 'RJBC'},
  {'code' : 'print trifid("ZBDH", 4, 0, 0, "QWERTZUIOPASDFGHJKLYXCVBN,")', 'expectedOutput' : 'trifid_error_alphabet'},


];