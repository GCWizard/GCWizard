import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/gronsfeld/logic/gronsfeld.dart';

void main() {
  group("Gronsfeld.encrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : '', 'key': 'ABC', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': '', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABC'},
  
      {'input' : 'ABC', 'key': '012', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ACE'},
      {'input' : 'ABC', 'key': '567', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'FHJ'},
      {'input' : 'ABCDEF', 'key': '01', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ACCEEG'},
      {'input' : 'ABCDEF', 'key': '01', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'ACCEGI'},

      {'input' : 'Abc', 'key': '012', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'Ace'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'AcCEeG'},
      {'input' : 'ABcdeF', 'key': '01', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'ACcegI'},

      {'input' : 'Ab12c', 'key': '012', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'Ac12e'},
      {'input' : ' A%67bC DeF_', 'key': '01', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ' A%67cC EeG_'},
      {'input' : 'A Bcd23eF', 'key': '01', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'A Cce23gI'},

      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'BdDFfH'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 13, 'expectedOutput' : 'NpPRrT'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 26, 'expectedOutput' : 'AcCEeG'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 27, 'expectedOutput' : 'BdDFfH'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 52, 'expectedOutput' : 'AcCEeG'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -1, 'expectedOutput' : 'ZbBDdF'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -13, 'expectedOutput' : 'NpPRrT'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -26, 'expectedOutput' : 'AcCEeG'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -27, 'expectedOutput' : 'ZbBDdF'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -52, 'expectedOutput' : 'AcCEeG'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 1, 'expectedOutput' : 'BdDFhJ'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 13, 'expectedOutput' : 'NpPRtV'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 26, 'expectedOutput' : 'AcCEgI'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 27, 'expectedOutput' : 'BdDFhJ'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 52, 'expectedOutput' : 'AcCEgI'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -1, 'expectedOutput' : 'ZbBDfH'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -13, 'expectedOutput' : 'NpPRtV'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -26, 'expectedOutput' : 'AcCEgI'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -27, 'expectedOutput' : 'ZbBDfH'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -52, 'expectedOutput' : 'AcCEgI'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = encryptGronsfeld(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Gronsfeld.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : '', 'key': 'ABC', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': '', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABC'},
    
      {'input' : 'ABC', 'key': '012', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'AAA'},
      {'input' : 'ABC', 'key': '567', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'VVV'},
      {'input' : 'ABCDEF', 'key': '01', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'AACCEE'},
      {'input' : 'ABCDEF', 'key': '01', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'AACDCC'},
    
      {'input' : 'Abc', 'key': '012', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'Aaa'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'AaCCeE'},
      {'input' : 'ABcdeF', 'key': '01', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'AAcdcC'},
    
      {'input' : 'Ab12c', 'key': '012', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'Aa12a'},
      {'input' : ' A%67bC DeF_', 'key': '01', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ' A%67aC CeE_'},
      {'input' : 'A Bcd23eF', 'key': '01', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'A Acd23cC'},
    
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'ZzBBdD'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 13, 'expectedOutput' : 'NnPPrR'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 26, 'expectedOutput' : 'AaCCeE'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 27, 'expectedOutput' : 'ZzBBdD'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': 52, 'expectedOutput' : 'AaCCeE'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -1, 'expectedOutput' : 'BbDDfF'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -13, 'expectedOutput' : 'NnPPrR'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -26, 'expectedOutput' : 'AaCCeE'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -27, 'expectedOutput' : 'BbDDfF'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': false, 'aValue': -52, 'expectedOutput' : 'AaCCeE'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 1, 'expectedOutput' : 'ZzCDbB'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 13, 'expectedOutput' : 'NnCDpP'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 26, 'expectedOutput' : 'AaCDcC'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 27, 'expectedOutput' : 'ZzCDbB'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': 52, 'expectedOutput' : 'AaCDcC'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -1, 'expectedOutput' : 'BbCDdD'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -13, 'expectedOutput' : 'NnCDpP'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -26, 'expectedOutput' : 'AaCDcC'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -27, 'expectedOutput' : 'BbCDdD'},
      {'input' : 'AbCDeF', 'key': '01', 'autoKey': true, 'aValue': -52, 'expectedOutput' : 'AaCDcC'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = decryptGronsfeld(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  // group("Gronsfeld.digitsToAlpha:", () {
  //   List<Map<String, Object?>> _inputsToExpected = [
  //     {'input' : null, 'aValue': null, 'removeNonDigits' : null, 'expectedOutput' : null},
  //     {'input' : null, 'aValue': null, 'removeNonDigits' : true, 'expectedOutput' : null},
  //     {'input' : null, 'aValue': 0, 'removeNonDigits' : null, 'expectedOutput' : null},
  //     {'input' : '', 'aValue': null, 'removeNonDigits' : null, 'expectedOutput' : ''},
  //
  //     {'input' : '', 'aValue': 0, 'removeNonDigits' : null, 'expectedOutput' : ''},
  //     {'input' : '', 'aValue': null, 'removeNonDigits' : false, 'expectedOutput' : ''},
  //
  //     {'input' : null, 'aValue': 0, 'removeNonDigits' : true, 'expectedOutput' : null},
  //
  //     {'input' : '', 'aValue': 0, 'removeNonDigits' : true, 'expectedOutput' : ''},
  //
  //     {'input' : '0', 'aValue': 0, 'removeNonDigits' : true, 'expectedOutput' : 'A'},
  //     {'input' : '9', 'aValue': 0, 'removeNonDigits' : true, 'expectedOutput' : 'J'},
  //
  //     {'input' : '0', 'aValue': 1, 'removeNonDigits' : true, 'expectedOutput' : 'B'},
  //     {'input' : '9', 'aValue': 1, 'removeNonDigits' : true, 'expectedOutput' : 'K'},
  //
  //     {'input' : '0', 'aValue': 13, 'removeNonDigits' : true, 'expectedOutput' : 'N'},
  //     {'input' : '9', 'aValue': 13, 'removeNonDigits' : true, 'expectedOutput' : 'W'},
  //
  //     {'input' : '0', 'aValue': 26, 'removeNonDigits' : true, 'expectedOutput' : 'A'},
  //     {'input' : '9', 'aValue': 26, 'removeNonDigits' : true, 'expectedOutput' : 'J'},
  //     {'input' : '0', 'aValue': 39, 'removeNonDigits' : true, 'expectedOutput' : 'N'},
  //     {'input' : '9', 'aValue': 39, 'removeNonDigits' : true, 'expectedOutput' : 'W'},
  //     {'input' : '0', 'aValue': 52, 'removeNonDigits' : true, 'expectedOutput' : 'A'},
  //     {'input' : '9', 'aValue': 52, 'removeNonDigits' : true, 'expectedOutput' : 'J'},
  //
  //     {'input' : '0', 'aValue': -1, 'removeNonDigits' : true, 'expectedOutput' : 'Z'},
  //     {'input' : '9', 'aValue': -1, 'removeNonDigits' : true, 'expectedOutput' : 'I'},
  //     {'input' : '0', 'aValue': -13, 'removeNonDigits' : true, 'expectedOutput' : 'N'},
  //     {'input' : '9', 'aValue': -13, 'removeNonDigits' : true, 'expectedOutput' : 'W'},
  //     {'input' : '0', 'aValue': -26, 'removeNonDigits' : true, 'expectedOutput' : 'A'},
  //     {'input' : '9', 'aValue': -26, 'removeNonDigits' : true, 'expectedOutput' : 'J'},
  //     {'input' : '0', 'aValue': -39, 'removeNonDigits' : true, 'expectedOutput' : 'N'},
  //     {'input' : '9', 'aValue': -39, 'removeNonDigits' : true, 'expectedOutput' : 'W'},
  //     {'input' : '0', 'aValue': -52, 'removeNonDigits' : true, 'expectedOutput' : 'A'},
  //     {'input' : '9', 'aValue': -52, 'removeNonDigits' : true, 'expectedOutput' : 'J'},
  //
  //     {'input' : '0123456789', 'aValue': 0, 'removeNonDigits' : true, 'expectedOutput' : 'ABCDEFGHIJ'},
  //     {'input' : '97531', 'aValue': 0, 'removeNonDigits' : true, 'expectedOutput' : 'JHFDB'},
  //
  //     {'input' : '0123456789', 'aValue': 21, 'removeNonDigits' : true, 'expectedOutput' : 'VWXYZABCDE'},
  //     {'input' : '97531', 'aValue': 21, 'removeNonDigits' : true, 'expectedOutput' : 'ECAYW'},
  //
  //     {'input' : '0123456789', 'aValue': -5, 'removeNonDigits' : true, 'expectedOutput' : 'VWXYZABCDE'},
  //     {'input' : '97531', 'aValue': -5, 'removeNonDigits' : true, 'expectedOutput' : 'ECAYW'},
  //
  //     {'input' : ' 0 !"1§ 2% 3 4. 5 6b 7 s8 E9- ', 'aValue': 0, 'removeNonDigits' : true, 'expectedOutput' : 'ABCDEFGHIJ'},
  //     {'input' : '  !"§ %  .  b  s E- ', 'aValue': 0, 'removeNonDigits' : true, 'expectedOutput' : ''},
  //
  //     {'input' : ' 0 !"1§ 2% 3 4. 5 6b 7 s8 E9- ', 'aValue': 0, 'removeNonDigits' : false, 'expectedOutput' : ' A !"B§ C% D E. F Gb H sI EJ- '},
  //     {'input' : '  !"§ %  .  b  s E- ', 'aValue': 0, 'removeNonDigits' : false, 'expectedOutput' : '  !"§ %  .  b  s E- '},
  //
  //     {'input' : ' 0 !"1§ 2% 3 4. 5 6b 7 s8 E9- ', 'aValue': 13, 'removeNonDigits' : true, 'expectedOutput' : 'NOPQRSTUVW'},
  //     {'input' : '  !"§ %  .  b  s E- ', 'aValue': 13, 'removeNonDigits' : true, 'expectedOutput' : ''},
  //
  //     {'input' : ' 0 !"1§ 2% 3 4. 5 6b 7 s8 E9- ', 'aValue': 13, 'removeNonDigits' : false, 'expectedOutput' : ' N !"O§ P% Q R. S Tb U sV EW- '},
  //     {'input' : '  !"§ %  .  b  s E- ', 'aValue': 13, 'removeNonDigits' : false, 'expectedOutput' : '  !"§ %  .  b  s E- '},
  //
  //   ];
  //
  //   _inputsToExpected.forEach((elem) {
  //     test('input: ${elem['input']}, aValue: ${elem['aValue']}, removeNonDigits: ${elem['removeNonDigits']}', () {
  //       var _actual = _digitsToAlpha(elem['input'] as String, aValue: elem['aValue'] as Int,, removeNonDigits: elem['removeNonDigits']);
  //       expect(_actual, elem['expectedOutput']);
  //     });
  //   });
  // }
}