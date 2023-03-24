import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/logic/vigenere_breaker.dart';

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

    // var text18 = 'Els eavg mgaoclov, aktt fln Etrrvztssij zxjtn hvvhvkbeey wjf.';
    // var text19 = 'Das wird moeglich, weil der Algorithmus recht performant ist.';

    var text20 = 'Wmwl lax wqf Mifg nq aby Qqbwguemgzdypmfk xcg jqu Uuimlvv ze xvrnxr';
    var text21 = 'Dies ist ein Text um die Entschluesselung mit dem Breaker zu testen';

    var text24 = 'Rg oéotdijevf vvz qv lflykn puz iqjahskh à csiclygn ka wkedvhqlh fq féfsuuebhoeqkoavs gdx oisecoova oolu takgeifngn nu gouoqluchx zmr « icypds » qq cej « céncrfngo », ggpo cimhxu mmdirovo à kugxazr ch okvce. Apa féffgedm tpsosqm ejw ekvrtzwaéa c’lq rabht fuppmmaew épimcyh gp qéjlyvwvs, fuolzdnrqz qv rvjoupzd uhy rqrikhy ab prulqea ue uw xkujlkwna « wxéowqs », céméidrgimmt gku jhbvouvo raev xwtdui. Gj 2013, ltts gk zmtx ponhqnnj jg oéotdijaa, fqz ébé iévgnbnrzéku lznj 222 oapv uqz lvv feneéihtvo rikhy sma trsoqvzukdotaa cfqycyzés à ea kozvot.';
    var text25 = 'Le géocaching est un loisir qui consiste à utiliser la technique du géopositionnement par satellite pour rechercher ou dissimuler des « caches » ou des « géocaches », dans divers endroits à travers le monde. Une géocache typique est constituée d’un petit contenant étanche et résistant, comprenant un registre des visites et parfois un ou plusieurs « trésors », généralement des bibelots sans valeur. En 2013, plus de deux millions de géocaches, ont été répertoriées dans 222 pays sur les différents sites web communautaires consacrés à ce loisir.';

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : '', 'expectedOutput' : ''},
      {'input' : '', 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 2, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : '', 'expectedOutput' : ''},

      {'input' : text10, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 10000, 'errorCode' : VigenereBreakerErrorCode.KEY_LENGTH, 'key' : '', 'expectedOutput' : ''},
      {'input' : text10, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 2, 'keyLengthMax' : 2, 'errorCode' : VigenereBreakerErrorCode.KEY_LENGTH, 'key' : '', 'expectedOutput' : ''},

      {'input' : text10, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'HELLO', 'expectedOutput' : text11},
      {'input' : text12, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'QUARK', 'expectedOutput' : text13},
      {'input' : text14, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'BLAISE', 'expectedOutput' : text15},
      {'input' : text16, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'BLAISE', 'expectedOutput' : text17},

      {'input' : text22, 'VigenereBreakerType' : VigenereBreakerType.AUTOKEYVIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.ENGLISH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'HELLO', 'expectedOutput' : text11},
      {'input' : text20, 'VigenereBreakerType' : VigenereBreakerType.AUTOKEYVIGENERE, 'ignoreNonLetters' : true, 'alphabet' : VigenereBreakerAlphabet.GERMAN, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'TEST', 'expectedOutput' : text21},
      {'input' : text24, 'VigenereBreakerType' : VigenereBreakerType.VIGENERE, 'ignoreNonLetters' : false, 'alphabet' : VigenereBreakerAlphabet.FRENCH, 'keyLengthMin' : 3, 'keyLengthMax' : 30, 'errorCode' : VigenereBreakerErrorCode.OK, 'key' : 'GCWIZARD', 'expectedOutput' : text25},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () async {
        var _actual = break_cipher(elem['input'] as String, elem['VigenereBreakerType'] as VigenereBreakerType, elem['alphabet'] as VigenereBreakerAlphabet, elem['keyLengthMin'] as int, elem['keyLengthMax'] as int, elem['ignoreNonLetters'] as bool, counterFunction: () => {});
        expect(_actual.plaintext, elem['expectedOutput']);
        expect(_actual.key, elem['key']);
        expect(_actual.errorCode, elem['errorCode']);
      });
    }

  });
}