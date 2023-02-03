import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/gronsfeld/logic/gronsfeld.dart';

void main() {
  group("Gronsfeld.encrypt:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'key': null, 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : null, 'key': 'ABC', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': null, 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABC'},
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

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = encryptGronsfeld(elem['input'], elem['key'], elem['autoKey'], aValue: elem['aValue']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Gronsfeld.decrypt:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'key': null, 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : null, 'key': 'ABC', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': null, 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABC'},
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

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = decryptGronsfeld(elem['input'], elem['key'], elem['autoKey'], aValue: elem['aValue']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}