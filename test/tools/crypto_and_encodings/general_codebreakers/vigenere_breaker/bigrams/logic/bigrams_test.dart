import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/logic/bigrams.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/logic/vigenere_breaker.dart';

void main() {

  group("vigenere_breaker.calc_fitness:", () {
    var text11 = 'This text is encrypted with the vigenere cipher. Breaking it is rather easy. :-)';

    var text13 = 'kurzerverschluesseltertext';

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : '', 'expectedOutput' : null},
      {'input' : '', 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 2, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : '', 'expectedOutput' : null},

      {'input' : 'quark', 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'expectedOutput' : 2943517/4/10000},
      {'input' : 'hallo', 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'expectedOutput' : 3299845/4/10000},
      {'input' : 'er', 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'expectedOutput' : 100.0},
      {'input' : 'th', 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'expectedOutput' : 100.0},
      {'input' : text11, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'expectedOutput' : 87.06553278688526},
      {'input' : text13, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'expectedOutput' : 84.360524},

      {'input' : 'nder', 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'expectedOutput' : 96.20213333333334},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = calc_fitnessBigrams(elem['input'] as String, getBigrams(elem['alphabet'] as VigenereBreakerAlphabet));
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}