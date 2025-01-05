import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';

void main() {
  group("NumeralBases.convert:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '16', 'startBase' : 10, 'destinationBase' : 2, 'expectedOutput' : '10000'},
      {'input' : '10000', 'startBase' : 2, 'destinationBase' : 10, 'expectedOutput' : '16'},
      {'input' : '10600', 'startBase' : 2, 'destinationBase' : 10, 'expectedOutput' : ''},
      {'input' : '10600', 'startBase' : 10, 'destinationBase' : 10, 'expectedOutput' : '10600'},
      {'input' : '16', 'startBase' : 10, 'destinationBase' : 16, 'expectedOutput' : '10'},
      {'input' : '10', 'startBase' : 16, 'destinationBase' : 10, 'expectedOutput' : '16'},
      {'input' : '10', 'startBase' : 16, 'destinationBase' : 2, 'expectedOutput' : '10000'},
      {'input' : '10', 'startBase' : 2, 'destinationBase' : 16, 'expectedOutput' : '2'},
      {'input' : '10000', 'startBase' : 2, 'destinationBase' : 16, 'expectedOutput' : '10'},
      {'input' : '10000', 'startBase' : 10, 'destinationBase' : 16, 'expectedOutput' : '2710'},
      {'input' : '2710', 'startBase' : 16, 'destinationBase' : 10, 'expectedOutput' : '10000'},
      {'input' : '10000', 'startBase' : 16, 'destinationBase' : 16, 'expectedOutput' : '10000'},
      {'input' : 'a', 'startBase' : 16, 'destinationBase' : 10, 'expectedOutput' : '10'},
      {'input' : 'A', 'startBase' : 16, 'destinationBase' : 10, 'expectedOutput' : '10'},
      {'input' : 'Z', 'startBase' : 36, 'destinationBase' : 10, 'expectedOutput' : '35'},
      {'input' : 'z', 'startBase' : 36, 'destinationBase' : 10, 'expectedOutput' : '35'},
      {'input' : 'Z', 'startBase' : 37, 'destinationBase' : 10, 'expectedOutput' : '35'},
      {'input' : 'z', 'startBase' : 37, 'destinationBase' : 10, 'expectedOutput' : ''},
      {'input' : 'A', 'startBase' : 37, 'destinationBase' : 10, 'expectedOutput' : '10'},
      {'input' : 'a', 'startBase' : 37, 'destinationBase' : 10, 'expectedOutput' : '36'},
      {'input' : 'z', 'startBase' : 62, 'destinationBase' : 10, 'expectedOutput' : '61'},

      {'input' : '42', 'startBase' : 10, 'destinationBase' : 2, 'expectedOutput' : '101010'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 3, 'expectedOutput' : '1120'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 4, 'expectedOutput' : '222'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 5, 'expectedOutput' : '132'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 6, 'expectedOutput' : '110'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 7, 'expectedOutput' : '60'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 8, 'expectedOutput' : '52'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 9, 'expectedOutput' : '46'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 10, 'expectedOutput' : '42'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 11, 'expectedOutput' : '39'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 16, 'expectedOutput' : '2A'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 20, 'expectedOutput' : '22'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 40, 'expectedOutput' : '12'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 42, 'expectedOutput' : '10'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 62, 'expectedOutput' : 'g'},

      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 2, 'input' : '101010'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 3, 'input' : '1120'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 4, 'input' : '222'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 5, 'input' : '132'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 6, 'input' : '110'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 7, 'input' : '60'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 8, 'input' : '52'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 9, 'input' : '46'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 10, 'input' : '42'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 11, 'input' : '39'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 16, 'input' : '2A'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 20, 'input' : '22'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 40, 'input' : '12'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 42, 'input' : '10'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : 62, 'input' : 'g'},

      {'input' : '42', 'startBase' : 10, 'destinationBase' : -2, 'expectedOutput' : '1111110'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -3, 'expectedOutput' : '12210'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -4, 'expectedOutput' : '322'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -5, 'expectedOutput' : '222'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -6, 'expectedOutput' : '250'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -7, 'expectedOutput' : '110'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -8, 'expectedOutput' : '132'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -9, 'expectedOutput' : '156'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -10, 'expectedOutput' : '162'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -11, 'expectedOutput' : '189'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -16, 'expectedOutput' : '1EA'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -20, 'expectedOutput' : '1I2'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -40, 'expectedOutput' : '1d2'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -42, 'expectedOutput' : '1f0'},
      {'input' : '42', 'startBase' : 10, 'destinationBase' : -62, 'expectedOutput' : 'g'},

      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -2, 'input' : '1111110'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -3, 'input' : '12210'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -4, 'input' : '322'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -5, 'input' : '222'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -6, 'input' : '250'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -7, 'input' : '110'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -8, 'input' : '132'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -9, 'input' : '156'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -10, 'input' : '162'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -11, 'input' : '189'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -16, 'input' : '1EA'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -20, 'input' : '1I2'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -40, 'input' : '1d2'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -42, 'input' : '1f0'},
      {'expectedOutput' : '42', 'destinationBase' : 10, 'startBase' : -62, 'input' : 'g'},

      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 2, 'expectedOutput' : '-101010'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 3, 'expectedOutput' : '-1120'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 4, 'expectedOutput' : '-222'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 5, 'expectedOutput' : '-132'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 6, 'expectedOutput' : '-110'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 7, 'expectedOutput' : '-60'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 8, 'expectedOutput' : '-52'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 9, 'expectedOutput' : '-46'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 10, 'expectedOutput' : '-42'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 11, 'expectedOutput' : '-39'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 16, 'expectedOutput' : '-2A'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 20, 'expectedOutput' : '-22'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 40, 'expectedOutput' : '-12'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 42, 'expectedOutput' : '-10'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : 62, 'expectedOutput' : '-g'},

      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 2, 'input' : '-101010'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 3, 'input' : '-1120'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 4, 'input' : '-222'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 5, 'input' : '-132'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 6, 'input' : '-110'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 7, 'input' : '-60'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 8, 'input' : '-52'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 9, 'input' : '-46'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 10, 'input' : '-42'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 11, 'input' : '-39'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 16, 'input' : '-2A'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 20, 'input' : '-22'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 40, 'input' : '-12'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 42, 'input' : '-10'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : 62, 'input' : '-g'},

      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -2, 'expectedOutput' : '101010'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -3, 'expectedOutput' : '2220'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -4, 'expectedOutput' : '1232'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -5, 'expectedOutput' : '1443'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -6, 'expectedOutput' : '1510'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -7, 'expectedOutput' : '60'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -8, 'expectedOutput' : '66'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -9, 'expectedOutput' : '53'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -10, 'expectedOutput' : '58'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -11, 'expectedOutput' : '42'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -16, 'expectedOutput' : '36'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -20, 'expectedOutput' : '3I'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -40, 'expectedOutput' : '2c'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -42, 'expectedOutput' : '10'},
      {'input' : '-42', 'startBase' : 10, 'destinationBase' : -62, 'expectedOutput' : '1K'},

      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -2, 'input' : '101010'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -3, 'input' : '2220'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -4, 'input' : '1232'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -5, 'input' : '1443'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -6, 'input' : '1510'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -7, 'input' : '60'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -8, 'input' : '66'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -9, 'input' : '53'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -10, 'input' : '58'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -11, 'input' : '42'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -16, 'input' : '36'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -20, 'input' : '3I'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -40, 'input' : '2c'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -42, 'input' : '10'},
      {'expectedOutput' : '-42', 'destinationBase' : 10, 'startBase' : -62, 'input' : '1K'},

      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 2, 'expectedOutput' : '101010.01101011100001010001111010111000010100011110101110'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 3, 'expectedOutput' : '1120.10210001121201222110102100011212012200021021220011'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 4, 'expectedOutput' : '222.122320110132232011013223201'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 5, 'expectedOutput' : '132.20222222222222222222222323441102400343013402001133'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 6, 'expectedOutput' : '110.23041530415304153041533020313211140055225054411010'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 7, 'expectedOutput' : '60.26402640264026402640351514150053441365564663223526'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 8, 'expectedOutput' : '52.327024365605075341'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 9, 'expectedOutput' : '46.37015518733701551465724800440338241104884421633301'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 10, 'expectedOutput' : '42.42'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 11, 'expectedOutput' : '39.46902469024690251066850980312A7240A506858520516A27'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 16, 'expectedOutput' : '2A.6B851EB851EB84'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 20, 'expectedOutput' : '22.8800000000001921ACH94C7D2A'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 40, 'expectedOutput' : '12.GW000000007I0b6D5'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 42, 'expectedOutput' : '10.HQaeDIK6UAD2bRV86AZUR0KIQVdW4UYM9BOVZ8bYC5c2QAL'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : 62, 'expectedOutput' : 'g.Q2Tl7RHMJeXKTkFiZbTEBKWVWC4UkdmLtBOJtctsr2Q9gckV'},

      {'expectedOutput' : '42.41999999999999993', 'destinationBase' : 10, 'startBase' : 2, 'input' : '101010.01101011100001010001111010111000010100011110101110'},
      {'expectedOutput' : '42.4199999999999998', 'destinationBase' : 10, 'startBase' : 3, 'input' : '1120.10210001121201222110102100011212012200021021220011'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : 4, 'input' : '222.122320110132232011013223201'},
      {'expectedOutput' : '42.4200000000000002', 'destinationBase' : 10, 'startBase' : 5, 'input' : '132.20222222222222222222222323441102400343013402001133'},
      {'expectedOutput' : '42.41999999999999993', 'destinationBase' : 10, 'startBase' : 6, 'input' : '110.23041530415304153041533020313211140055225054411010'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : 7, 'input' : '60.26402640264026402640351514150053441365564663223526'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : 8, 'input' : '52.327024365605075341'},
      {'expectedOutput' : '42.4199999999999999', 'destinationBase' : 10, 'startBase' : 9, 'input' : '46.37015518733701551465724800440338241104884421633301'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : 10, 'input' : '42.42'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : 11, 'input' : '39.46902469024690251066850980312A7240A506858520516A27'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : 16, 'input' : '2A.6B851EB851EB84'},
      {'expectedOutput' : '42.42000000000000004', 'destinationBase' : 10, 'startBase' : 20, 'input' : '22.8800000000001921ACH94C7D2A'},
      {'expectedOutput' : '42.42000000000000004', 'destinationBase' : 10, 'startBase' : 40, 'input' : '12.GW000000007I0b6D5'},
      {'expectedOutput' : '42.42000000000000004', 'destinationBase' : 10, 'startBase' : 42, 'input' : '10.HQaeDIK6UAD2bRV86AZUR0KIQVdW4UYM9BOVZ8bYC5c2QAL'},
      {'expectedOutput' : '42.41999999999999993', 'destinationBase' : 10, 'startBase' : 62, 'input' : 'g.Q2Tl7RHMJeXKTkFiZbTEBKWVWC4UkdmLtBOJtctsr2Q9gckV'},

      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -2, 'expectedOutput' : '1111111.10111100100001010110001111001000010101100011110010'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -3, 'expectedOutput' : '12211.21110002102202001221211100021022020012212111000210'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -4, 'expectedOutput' : '323.33102131021310213102131021310213102131021310213102'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -5, 'expectedOutput' : '223.31333333333333333333333333333333333333333333333333'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -6, 'expectedOutput' : '251.43054031221305403122130540312213054031221305403122'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -7, 'expectedOutput' : '111.40314031403140314031403140314031403140314031403140'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -8, 'expectedOutput' : '133.53116557360670344262131165573606703442621311655736'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -9, 'expectedOutput' : '157.67024670246702467024670246702467024670246702467024'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -10, 'expectedOutput' : '163.62'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -11, 'expectedOutput' : '18A.77219559037721955903772195590377219559037721955903'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -16, 'expectedOutput' : '1EB.AC86FF59B22C86FF59B22C86FF59B22C86FF59B22C86FF59B2'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -20, 'expectedOutput' : '1I3.C8'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -40, 'expectedOutput' : '1d3.OW'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -42, 'expectedOutput' : '1f1.PR6fTJM7CBdGb2EOLaVW4R6fTJM7CBdGb2EOLaVW4R6fTJM7CB'},
      {'input' : '42.42', 'startBase' : 10, 'destinationBase' : -62, 'expectedOutput' : 'h.a3XmtSjNhrwyUF8ZIeKA53XmtSjNhrwyUF8ZIeKA53XmtSjNhr'},

      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -2, 'input' : '1111111.10111100100001010110001111001000010101100011110010'},
      {'expectedOutput' : '42.419999999999995', 'destinationBase' : 10, 'startBase' : -3, 'input' : '12211.21110002102202001221211100021022020012212111000210'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -4, 'input' : '323.33102131021310213102131021310213102131021310213102'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -5, 'input' : '223.31333333333333333333333333333333333333333333333333'},
      {'expectedOutput' : '42.420000000000016', 'destinationBase' : 10, 'startBase' : -6, 'input' : '251.43054031221305403122130540312213054031221305403122'},
      {'expectedOutput' : '42.419999999999995', 'destinationBase' : 10, 'startBase' : -7, 'input' : '111.40314031403140314031403140314031403140314031403140'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -8, 'input' : '133.53116557360670344262131165573606703442621311655736'},
      {'expectedOutput' : '42.41999999999999', 'destinationBase' : 10, 'startBase' : -9, 'input' : '157.67024670246702467024670246702467024670246702467024'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -10, 'input' : '163.62'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -11, 'input' : '18A.77219559037721955903772195590377219559037721955903'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -16, 'input' : '1EB.AC86FF59B22C86FF59B22C86FF59B22C86FF59B22C86FF59B2'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -20, 'input' : '1I3.C8'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -40, 'input' : '1d3.OW'},
      {'expectedOutput' : '42.42', 'destinationBase' : 10, 'startBase' : -42, 'input' : '1f1.PR6fTJM7CBdGb2EOLaVW4R6fTJM7CBdGb2EOLaVW4R6fTJM7CB'},
      {'expectedOutput' : '42.42000000000001', 'destinationBase' : 10, 'startBase' : -62, 'input' : 'h.a3XmtSjNhrwyUF8ZIeKA53XmtSjNhrwyUF8ZIeKA53XmtSjNhr'},

      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 2, 'expectedOutput' : '-101010.01101011100001010001111010111000010100011110101110'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 3, 'expectedOutput' : '-1120.10210001121201222110102100011212012200021021220011'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 4, 'expectedOutput' : '-222.122320110132232011013223201'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 5, 'expectedOutput' : '-132.20222222222222222222222323441102400343013402001133'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 6, 'expectedOutput' : '-110.23041530415304153041533020313211140055225054411010'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 7, 'expectedOutput' : '-60.26402640264026402640351514150053441365564663223526'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 8, 'expectedOutput' : '-52.327024365605075341'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 9, 'expectedOutput' : '-46.37015518733701551465724800440338241104884421633301'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 10, 'expectedOutput' : '-42.42'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 11, 'expectedOutput' : '-39.46902469024690251066850980312A7240A506858520516A27'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 16, 'expectedOutput' : '-2A.6B851EB851EB84'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 20, 'expectedOutput' : '-22.8800000000001921ACH94C7D2A'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 40, 'expectedOutput' : '-12.GW000000007I0b6D5'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 42, 'expectedOutput' : '-10.HQaeDIK6UAD2bRV86AZUR0KIQVdW4UYM9BOVZ8bYC5c2QAL'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : 62, 'expectedOutput' : '-g.Q2Tl7RHMJeXKTkFiZbTEBKWVWC4UkdmLtBOJtctsr2Q9gckV'},

      {'expectedOutput' : '-42.41999999999999993', 'destinationBase' : 10, 'startBase' : 2, 'input' : '-101010.01101011100001010001111010111000010100011110101110'},
      {'expectedOutput' : '-42.4199999999999998', 'destinationBase' : 10, 'startBase' : 3, 'input' : '-1120.10210001121201222110102100011212012200021021220011'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : 4, 'input' : '-222.122320110132232011013223201'},
      {'expectedOutput' : '-42.4200000000000002', 'destinationBase' : 10, 'startBase' : 5, 'input' : '-132.20222222222222222222222323441102400343013402001133'},
      {'expectedOutput' : '-42.41999999999999993', 'destinationBase' : 10, 'startBase' : 6, 'input' : '-110.23041530415304153041533020313211140055225054411010'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : 7, 'input' : '-60.26402640264026402640351514150053441365564663223526'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : 8, 'input' : '-52.327024365605075341'},
      {'expectedOutput' : '-42.4199999999999999', 'destinationBase' : 10, 'startBase' : 9, 'input' : '-46.37015518733701551465724800440338241104884421633301'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : 10, 'input' : '-42.42'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : 11, 'input' : '-39.46902469024690251066850980312A7240A506858520516A27'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : 16, 'input' : '-2A.6B851EB851EB84'},
      {'expectedOutput' : '-42.42000000000000004', 'destinationBase' : 10, 'startBase' : 20, 'input' : '-22.8800000000001921ACH94C7D2A'},
      {'expectedOutput' : '-42.42000000000000004', 'destinationBase' : 10, 'startBase' : 40, 'input' : '-12.GW000000007I0b6D5'},
      {'expectedOutput' : '-42.42000000000000004', 'destinationBase' : 10, 'startBase' : 42, 'input' : '-10.HQaeDIK6UAD2bRV86AZUR0KIQVdW4UYM9BOVZ8bYC5c2QAL'},
      {'expectedOutput' : '-42.41999999999999993', 'destinationBase' : 10, 'startBase' : 62, 'input' : '-g.Q2Tl7RHMJeXKTkFiZbTEBKWVWC4UkdmLtBOJtctsr2Q9gckV'},

      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -2, 'expectedOutput' : '101010.10010101100011110010000101011000111100100001010110'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -3, 'expectedOutput' : '2220.22020012212111000210220200122121110002102202001221'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -4, 'expectedOutput' : '1232.22312023120231202312023120231202312023120231202312'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -5, 'expectedOutput' : '1443.20333333333333333333333333333333333333333333333333'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -6, 'expectedOutput' : '1510.33122130540312213054031221305403122130540312213054'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -7, 'expectedOutput' : '60.31403140314031403140314031403140314031403140314031'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -8, 'expectedOutput' : '66.46703442621311655736067034426213116557360670344262'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -9, 'expectedOutput' : '53.42186421864218642186421864218642186421864218642186'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -10, 'expectedOutput' : '58.58'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -11, 'expectedOutput' : '42.55903772195590377219559037721955903772195590377219'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -16, 'expectedOutput' : '36.759B22C86FF59B22C86FF59B22C86FF59B22C86FF59B22C86F'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -20, 'expectedOutput' : '3I.9C'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -40, 'expectedOutput' : '2c.H8'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -42, 'expectedOutput' : '10.IGb2EOLaVW4R6fTJM7CBdGb2EOLaVW4R6fTJM7CBdGb2EOLaVW'},
      {'input' : '-42.42', 'startBase' : 10, 'destinationBase' : -62, 'expectedOutput' : '1K.RyUF8ZIeKA53XmtSjNhrwyUF8ZIeKA53XmtSjNhrwyUF8ZIeKA'},

      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : -2, 'input' : '101010.10010101100011110010000101011000111100100001010110'},
      {'expectedOutput' : '-42.41999999999998', 'destinationBase' : 10, 'startBase' : -3, 'input' : '2220.22020012212111000210220200122121110002102202001221'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : -4, 'input' : '1232.22312023120231202312023120231202312023120231202312'},
      {'expectedOutput' : '-42.419999999999995', 'destinationBase' : 10, 'startBase' : -5, 'input' : '1443.20333333333333333333333333333333333333333333333333'},
      {'expectedOutput' : '-42.419999999999995', 'destinationBase' : 10, 'startBase' : -6, 'input' : '1510.33122130540312213054031221305403122130540312213054'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : -7, 'input' : '60.31403140314031403140314031403140314031403140314031'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : -8, 'input' : '66.46703442621311655736067034426213116557360670344262'},
      {'expectedOutput' : '-42.41999999999998', 'destinationBase' : 10, 'startBase' : -9, 'input' : '53.42186421864218642186421864218642186421864218642186'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : -10, 'input' : '58.58'},
      {'expectedOutput' : '-42.419999999999995', 'destinationBase' : 10, 'startBase' : -11, 'input' : '42.55903772195590377219559037721955903772195590377219'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : -16, 'input' : '36.759B22C86FF59B22C86FF59B22C86FF59B22C86FF59B22C86F'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : -20, 'input' : '3I.9C'},
      {'expectedOutput' : '-42.419999999999995', 'destinationBase' : 10, 'startBase' : -40, 'input' : '2c.H8'},
      {'expectedOutput' : '-42.42000000000001', 'destinationBase' : 10, 'startBase' : -42, 'input' : '10.IGb2EOLaVW4R6fTJM7CBdGb2EOLaVW4R6fTJM7CBdGb2EOLaVW'},
      {'expectedOutput' : '-42.42', 'destinationBase' : 10, 'startBase' : -62, 'input' : '1K.RyUF8ZIeKA53XmtSjNhrwyUF8ZIeKA53XmtSjNhrwyUF8ZIeKA'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, startBase: ${elem['startBase']}, destinationBase: ${elem['destinationBase']}', () {
        var _actual = convertBase(elem['input'] as String, elem['startBase'] as int, elem['destinationBase'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("NumeralBases.convertNegativeValuesOnNegativeBases:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -2, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -3, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -4, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -5, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -6, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -7, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -8, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -9, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -10, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -11, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -16, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -20, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -40, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -42, 'expectedOutput' : null},
      {'input' : '-42', 'destinationBase' : 10, 'startBase' : -62, 'expectedOutput' : null},

      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -2, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -3, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -4, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -5, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -6, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -7, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -8, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -9, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -10, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -11, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -16, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -20, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -40, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -42, 'expectedOutput' : null},
      {'input' : '-42.42', 'destinationBase' : 10, 'startBase' : -62, 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, startBase: ${elem['startBase']}, destinationBase: ${elem['destinationBase']}', () {
        try {
          convertBase(elem['input'] as String, elem['startBase'] as int, elem['destinationBase'] as int);
          expect(false, true);
        } catch(e) {
          expect(true, true);
        }
      });
    }
  });

  group("NumeralBases.convertWithSpecialAlphabets:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'EC', 'startBase' : 10, 'destinationBase' : 42, 'inputAlphabet': 'ABCDEFGHIJ', 'outputAlphabet': '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 'expectedOutput' : '10'},
      {'input' : 'DFJ', 'startBase' : 10, 'destinationBase' : 24, 'inputAlphabet': 'ABCDEFGHIJ', 'outputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : 'QZ'},
      {'input' : 'A', 'startBase' : 10, 'destinationBase' : 24, 'inputAlphabet': 'ABCDEFGHIJ', 'outputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : 'A'},
      {'input' : 'AA', 'startBase' : 10, 'destinationBase' : 24, 'inputAlphabet': 'ABCDEFGHIJ', 'outputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : 'A'},

      {'expectedOutput' : 'EC', 'destinationBase' : 10, 'startBase' : 42, 'outputAlphabet': 'ABCDEFGHIJ', 'inputAlphabet': '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 'input' : '10'},
      {'expectedOutput' : 'DFJ', 'destinationBase' : 10, 'startBase' : 24, 'outputAlphabet': 'ABCDEFGHIJ', 'inputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'input' : 'QZ'},
      {'expectedOutput' : 'A', 'destinationBase' : 10, 'startBase' : 24, 'outputAlphabet': 'ABCDEFGHIJ', 'inputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'input' : 'A'},
      {'expectedOutput' : 'A', 'destinationBase' : 10, 'startBase' : 24, 'outputAlphabet': 'ABCDEFGHIJ', 'inputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'input' : 'AA'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, startBase: ${elem['startBase']}, destinationBase: ${elem['destinationBase']}, inputAlphabet: ${elem['inputAlphabet']}, outputAlphabet: ${elem['outputAlphabet']}', () {
        var _actual = convertBase(elem['input'] as String, elem['startBase'] as int, elem['destinationBase'] as int, inputAlphabet: elem['inputAlphabet'] as String, outputAlphabet: elem['outputAlphabet'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("NumeralBases.convertWithSpecialOutputAlphabet:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '42', 'startBase' : 10, 'destinationBase' : 42, 'outputAlphabet': '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 'expectedOutput' : '10'},
      {'input' : '359', 'startBase' : 10, 'destinationBase' : 24, 'outputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : 'QZ'},
      {'input' : '0', 'startBase' : 10, 'destinationBase' : 24, 'outputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : 'A'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, startBase: ${elem['startBase']}, destinationBase: ${elem['destinationBase']}, outputAlphabet: ${elem['outputAlphabet']}', () {
        var _actual = convertBase(elem['input'] as String, elem['startBase'] as int, elem['destinationBase'] as int, outputAlphabet: elem['outputAlphabet'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("NumeralBases.convertWithSpecialInputAlphabet:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '10', 'startBase' : 42, 'destinationBase' : 10, 'inputAlphabet': '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 'expectedOutput' : '42'},
      {'input' : 'QZ', 'startBase' : 24, 'destinationBase' : 10, 'inputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : '359'},
      {'input' : 'A', 'startBase' : 24, 'destinationBase' : 10, 'inputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : '0'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, startBase: ${elem['startBase']}, destinationBase: ${elem['destinationBase']}, inputAlphabet: ${elem['inputAlphabet']}', () {
        var _actual = convertBase(elem['input'] as String, elem['startBase'] as int, elem['destinationBase'] as int, inputAlphabet: elem['inputAlphabet'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("NumeralBases.convertIntWithSpecialOutputAlphabet:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '42', 'destinationBase' : 42, 'outputAlphabet': '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 'expectedOutput' : '10'},
      {'input' : '359', 'destinationBase' : 24, 'outputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : 'QZ'},
      {'input' : '0', 'destinationBase' : 24, 'outputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : 'A'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, startBase: ${elem['startBase']}, destinationBase: ${elem['destinationBase']}, outputAlphabet: ${elem['outputAlphabet']}', () {
        var _actual = convertIntToBase(elem['input'] as String, elem['destinationBase'] as int, outputAlphabet: elem['outputAlphabet'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("NumeralBases.convertBaseToIntWithSpecialInputAlphabet:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '10', 'startBase' : 42, 'destinationBase' : 10, 'inputAlphabet': '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 'expectedOutput' : '42'},
      {'input' : 'QZ', 'startBase' : 24, 'destinationBase' : 10, 'inputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : '359'},
      {'input' : 'A', 'startBase' : 24, 'destinationBase' : 10, 'inputAlphabet': 'ABCDEFGHJKLMNPQRSTUVWXYZ', 'expectedOutput' : '0'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, startBase: ${elem['startBase']}, destinationBase: ${elem['destinationBase']}, inputAlphabet: ${elem['inputAlphabet']}', () {
        var _actual = convertBaseToInt(elem['input'] as String, elem['startBase'] as int, inputAlphabet: elem['inputAlphabet'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
