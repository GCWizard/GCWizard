import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/vigenere_breaker.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/bigrams.dart';

void main() {
  group("vigenere_breaker.encrypt:", () {
    var text10 = 'Altd hlbe tg lrncmwxpo kpxs evl ztrsuicp qptspf. Ivplyprr th pw clhoic pozc. :-)';
    var text11 = 'This text is encrypted with the vigenere cipher. Breaking it is rather easy. :-)';
    var text22 = 'Altd hxeb al ikvzqtggu uxml wdm opzlrzzk gvtyit. Jglebjek id qf ximpwi etzc. :-)';

    var text12 = 'aorqohpeicsblloimecdultvhj';
    var text13 = 'kurzerverschluesseltertext';

    var text14 = 'Els eave xomypjnh, ewmm oez Sphzrqllnfs zwgie pmjjpcmifx jdt.';
    var text15 = 'Das wird moeglich, weil der Algorithmus recht performant ist.';

    var text16 = 'elseavexomypjnhewmmoezsphzrqllnfszwgiepmjjpcmifxjdt';
    var text17 = 'daswirdmoeglichweilderalgorithmusrechtperformantist';

    var text18 = 'Els eavg mgaoclov, aktt fln Etrrvztssij zxjtn hvvhvkbeey wjf.';
    var text19 = 'Das wird moeglich, weil der Algorithmus recht performant ist.';

    var text20 = 'Wmwl lax wqf Mifg nq aby Qqbwguemgzdypmfk xcg jqu Uuimlvv ze xvrnxr';
    var text21 = 'Dies ist ein Text um die Entschluesselung mit dem Breaker zu testen';



    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : '', 'expectedOutput' : ''},
      {'input' : '', 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : '', 'expectedOutput' : ''},
      {'input' : '', 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 2, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : '', 'expectedOutput' : ''},

      {'input' : text10, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 10000, 'errorCode' : VigenereBreakerErrorCode.KEY_LENGTH, 'key' : '', 'expectedOutput' : ''},
      {'input' : text10, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 2, 'keyLengthMax' : 2, 'errorCode' : VigenereBreakerErrorCode.KEY_LENGTH, 'key' : '', 'expectedOutput' : ''},

      {'input' : text10, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'hello', 'expectedOutput' : text11},
      {'input' : text12, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'quark', 'expectedOutput' : text13},
      {'input' : text14, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'blaise', 'expectedOutput' : text15},
      {'input' : text16, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'blaise', 'expectedOutput' : text17},

      {'input' : text22, 'VigenereBreakerType' : VigenereBreakerType.AUTOKEYVIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'hello', 'expectedOutput' : text11},
      {'input' : text20, 'VigenereBreakerType' : VigenereBreakerType.AUTOKEYVIGENERE, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'test', 'expectedOutput' : text21},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () async {
        var _actual = await break_cipher(elem['input'], elem['VigenereBreakerType'], elem['alphabet'], elem['keyLengthMin'], elem['keyLengthMax']);
        expect(_actual.plaintext, elem['expectedOutput']);
        expect(_actual.key, elem['key']);
        expect(_actual.errorCode, elem['errorCode']);
      });
    });
  });

  group("vigenere_breaker.calc_fitness:", () {
    var text11 = 'This text is encrypted with the vigenere cipher. Breaking it is rather easy. :-)';

    var text13 = 'kurzerverschluesseltertext';

    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : '', 'expectedOutput' : null},
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

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = calc_fitnessBigrams(elem['input'], getBigrams(elem['alphabet']));
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}