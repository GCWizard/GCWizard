import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/logic/brainfk_derivative.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

void main() {
  group("BrainfkDerivatives.convertToBrainfk:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'code': '.?..!!.! !  ? ?! !....?', 'derivative': BRAINFKDERIVATIVE_OOK, 'expectedOutput': '>+-,[].+>'},
      {'code': '.?..!!.! !  ? ?! !....?', 'derivative': BRAINFKDERIVATIVE_SHORTOOK, 'expectedOutput': '>+-,[].+>'},
      {'code': '.?..!Muss das hier jetzt so!.! WEnn alle!  Aber so? ?! !....?', 'derivative': BRAINFKDERIVATIVE_SHORTOOK, 'expectedOutput': '>+-,[].+>'},
      {'code': 'Ook. ook? OOK. OOK. ook! oOk!.! !  ? OOk? Ooooo k! !....?', 'derivative': BRAINFKDERIVATIVE_OOK, 'expectedOutput': '>+-,[].+>'},
      {'code': 'Ook. ook? OOKa. Aber dann OOK. ook! oOk!.! !  Und so? OOk? Ooooo k! !....?', 'derivative': BRAINFKDERIVATIVE_OOK, 'expectedOutput': '>+-,[].+>'},

      {'code': '010011112112', 'derivative': BRAINFKDERIVATIVE_TERNARY, 'expectedOutput': '><++,]'},
      {'code': '01 00 11 11 21 12', 'derivative': BRAINFKDERIVATIVE_TERNARY, 'expectedOutput': '><++,]'},
      {'code': '010 011 1121     1   2', 'derivative': BRAINFKDERIVATIVE_TERNARY, 'expectedOutput': '><++,]'},
      {'code': '0310 011 1444121     1   2', 'derivative': BRAINFKDERIVATIVE_TERNARY, 'expectedOutput': '><++,]'},

      {'code': 'pipi pi pi ka pi pikapi pi ka pika pipi chu', 'derivative': BRAINFKDERIVATIVE_PIKALANG, 'expectedOutput': '>++-+,+-[>]'},
      {'code': 'pipipipikapipikapipikapikapipichu', 'derivative': BRAINFKDERIVATIVE_PIKALANG, 'expectedOutput': '>+,,,-+<'},
      {'code': 'pipi pi    pi ka pi PikaPi glu Pi man ka manda    pika pipi chu', 'derivative': BRAINFKDERIVATIVE_PIKALANG, 'expectedOutput': '>++-+,+-[>]'},

      {'code': 'AAAAGH F*CK WHAT?', 'derivative': BRAINFKDERIVATIVE_SCREAMCODE, 'expectedOutput': '<+,'},
      {'code': 'AAAAGHF*CKWHAT?', 'derivative': BRAINFKDERIVATIVE_SCREAMCODE, 'expectedOutput': '<+,'},
      {'code': 'aaaaghf*ckwhat?', 'derivative': BRAINFKDERIVATIVE_SCREAMCODE, 'expectedOutput': '<+,'},

      {'code': 'aAaA AAAA aaAA aAaa aaaa aaaA AAAA AAaa aAaA AAaa AaAa', 'derivative': BRAINFKDERIVATIVE_AAA, 'expectedOutput': '>+[,.]+<><-'},
      {'code': 'aAaAAAAAaaAAaAaaaaaaaaaAAAAAAAaaaAaAAAaaAaAa', 'derivative': BRAINFKDERIVATIVE_AAA, 'expectedOutput': '>+[,.]+<><-'},
      {'code': 'aAaAAAAaaAAaAaaaaaaaaAAAAAAaaaAaAAaaAaAa', 'derivative': BRAINFKDERIVATIVE_AAA, 'expectedOutput': '>.<-'},

      {'code': "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
          "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
          "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
          "REPLACE THE CELL UNDER THE MEMORY POINTER'S VALUE WITH THE ASCII CHARACTER CODE OF USER INPUT\n" +
          "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
          "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
          "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
          "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
          "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
          "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
          "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
          "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n",
        'derivative': BRAINFKDERIVATIVE_DETAILEDFK, 'expectedOutput': '>+[,[].]+<><-'},

    ];

    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}, input: ${elem['input']}', () {
        var _actual = (elem['derivative'] as BrainfkDerivatives).convertBrainfkDerivativeToBrainfk(elem['code'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BrainfkDerivatives.decode", () {
    String brainfck =
        "++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++++++++.<++.++++++++++++++++++++.++++.+++++++.-----------.----.--.++.++++++.++.-----------------.-------.>---------.--------------.++++++++.----------.-----.--.++++.++..";
    String result = "N 48?40.068' E7?50.244";

/*    //https://esolangs.org/wiki/Trivial_brainfuck_substitution
    String Pewlang = brainfck
        .replaceAll('>', 'pew ')
        .replaceAll('<', 'Pew ')
        .replaceAll('+', 'pEw ')
        .replaceAll('-', 'peW ')
        .replaceAll('.', 'PEw ')
        .replaceAll('[', 'PeW ')
        .replaceAll(']', 'PEW ');
    String Roadrunner = brainfck
        .replaceAll('>', 'meeP ')
        .replaceAll('<', 'Meep ')
        .replaceAll('+', 'mEEp ')
        .replaceAll('-', 'MeeP ')
        .replaceAll('.', 'MEEP ')
        .replaceAll('[', 'mEEP ')
        .replaceAll(']', 'MEEp ');
    String Kenny = brainfck
        .replaceAll('>', 'mmp ')
        .replaceAll('<', 'mmm ')
        .replaceAll('+', 'mpp ')
        .replaceAll('-', 'pmm ')
        .replaceAll('.', 'fmm ')
        .replaceAll('[', 'mmf ')
        .replaceAll(']', 'mpf ');
    String pikaLang =
        "pi pi pi pi pi pi pi pi pi pi pika pipi pi pipi pi pi pi pipi pi pi pi pi pi pi pi pipi pi pi pi pi pi pi pi pi pi pi pichu pichu pichu pichu ka chu pipi pipi pipi pi pi pi pi pi pi pi pi pikachu pichu pi pi pikachu pi pi pi pi pi pi pi pi pi pi pi pi pi pi pi pi pi pi pi pi pikachu pi pi pi pi pikachu pi pi pi pi pi pi pi pikachu ka ka ka ka ka ka ka ka ka ka ka pikachu ka ka ka ka pikachu ka ka pikachu pi pi pikachu pi pi pi pi pi pi pikachu pi pi pikachu ka ka ka ka ka ka ka ka ka ka ka ka ka ka ka ka ka pikachu ka ka ka ka ka ka ka pikachu pipi ka ka ka ka ka ka ka ka ka pikachu ka ka ka ka ka ka ka ka ka ka ka ka ka ka pikachu pi pi pi pi pi pi pi pi pikachu ka ka ka ka ka ka ka ka ka ka pikachu ka ka ka ka ka pikachu ka ka pikachu pi pi pi pi pikachu pi pi pikachu pikachu";
    String AAA = brainfck
        .replaceAll('>', 'aAaA ')
        .replaceAll('<', 'AAaa ')
        .replaceAll('+', 'AAAA ')
        .replaceAll('-', 'AaAa ')
        .replaceAll('.', 'aaaa ')
        .replaceAll('[', 'aaAA ')
        .replaceAll(']', 'aaaA ');
    String Colonoscopy = brainfck
        .replaceAll('>', ';}; ')
        .replaceAll('<', ';{; ')
        .replaceAll('+', ';;}; ')
        .replaceAll('-', ';;{; ')
        .replaceAll('.', ';;;}; ')
        .replaceAll('[', '{{; ')
        .replaceAll(']', '}}; ');
    String fuckbeEs = brainfck
        .replaceAll('>', 'f ')
        .replaceAll('<', 'u ')
        .replaceAll('+', 'c ')
        .replaceAll('-', 'k ')
        .replaceAll('.', 'b ')
        .replaceAll('[', 'E ')
        .replaceAll(']', 's ');
    String ZZZ = brainfck
        .replaceAll('-', '-z ')
        .replaceAll('>', 'zz ')
        .replaceAll('<', '-zz ')
        .replaceAll('+', 'z ')
        .replaceAll('.', 'zzz ')
        .replaceAll('[', 'z+z ')
        .replaceAll(']', 'z-z ');
    String Fuck = brainfck
        .replaceAll('>', '!!!!!# ')
        .replaceAll('<', '!!!!!!# ')
        .replaceAll('+', '!!!!!!!# ')
        .replaceAll('-', '!!!!!!!!# ')
        .replaceAll('.', '!!!!!!!!!!# ')
        .replaceAll('[', '!!!!!!!!!!!# ')
        .replaceAll(']', '!!!!!!!!!!!!# ');
    String Morsefuck = brainfck
        .replaceAll('-', '-xx ')
        .replaceAll('.', '-x- ')
        .replaceAll('>', 'x-- ')
        .replaceAll('<', '--x ')
        .replaceAll('+', 'xx- ')
        .replaceAll('[', '--- ')
        .replaceAll(']', 'xxx ')
        .replaceAll('x', '.');
    String Nak =
        "Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak! Nak? Nak. Nak? +Nak. Nak? Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak? Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak? Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak? Nak. Nak? Nak. Nak? Nak. Nak? Nak. Nak! Nak! Nak? Nak! Nak. Nak? Nak. Nak? Nak. Nak? Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak? Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak. Nak. Nak? Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak! Nak. Nak! Nak! Nak! Nak! Nak! Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak. Nak. Nak. Nak. Nak! Nak. Nak! Nak.";
    String Ook =
        "Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook. Ook? +Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook. Ook? Ook. Ook? Ook. Ook? Ook. Ook! Ook! Ook? Ook! Ook. Ook? Ook. Ook? Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook. Ook? Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook! Ook! Ook! Ook! Ook! Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook! Ook. ";
    String Blub =
        "Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub! Blub? Blub. Blub? +Blub. Blub? Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub? Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub? Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub? Blub. Blub? Blub. Blub? Blub. Blub? Blub. Blub! Blub! Blub? Blub! Blub. Blub? Blub. Blub? Blub. Blub? Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub? Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub. Blub. Blub? Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub! Blub. Blub! Blub! Blub! Blub! Blub! Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub. Blub. Blub. Blub. Blub! Blub. Blub! Blub. ";
    String Triplet = brainfck
        .replaceAll('>', '001 ')
        .replaceAll('<', '100 ')
        .replaceAll('+', '111 ')
        .replaceAll('-', '000 ')
        .replaceAll('.', '010 ')
        .replaceAll('[', '110 ')
        .replaceAll(']', '011 ');
    String Ternary = brainfck
        .replaceAll('>', '01 ')
        .replaceAll('<', '00 ')
        .replaceAll('+', '11 ')
        .replaceAll('-', '10 ')
        .replaceAll('.', '20 ')
        .replaceAll('[', '02 ')
        .replaceAll(']', '12 ');
    String BinaryFk = brainfck
        .replaceAll('>', '010 ')
        .replaceAll('<', '011 ')
        .replaceAll('+', '000 ')
        .replaceAll('-', '001 ')
        .replaceAll('.', '100 ')
        .replaceAll('[', '110 ')
        .replaceAll(']', '111 ');
    String Screamcode = brainfck
        .replaceAll('>', 'AAAH ')
        .replaceAll('<', 'AAAAGH ')
        .replaceAll('+', 'F*CK ')
        .replaceAll('-', 'SHIT ')
        .replaceAll('.', '!!!!!! ')
        .replaceAll('[', 'OW ')
        .replaceAll(']', 'OWIE ');
    String FlufflPuff = brainfck
        .replaceAll('>', 'b ')
        .replaceAll('<', 't ')
        .replaceAll('+', 'pf ')
        .replaceAll('-', 'bl ')
        .replaceAll('.', '! ')
        .replaceAll('[', '*gasp* ')
        .replaceAll(']', '*pomf* ');
    String UWU = brainfck
        .replaceAll('>', 'OwO ')
        .replaceAll('<', '°w° ')
        .replaceAll('+', 'UwU ')
        .replaceAll('-', 'QwQ ')
        .replaceAll('.', '@w@ ')
        .replaceAll('[', '~w~ ')
        .replaceAll(']', '-w- ');
    String ShortOOK = brainfck
        .replaceAll('>', 'x? ')
        .replaceAll('<', '?x ')
        .replaceAll('+', 'xx ')
        .replaceAll('-', '!! ')
        .replaceAll('.', '!. ')
        .replaceAll('[', '!? ')
        .replaceAll(']', '?! ')
        .replaceAll('x', '.');
    String frqiquartf = brainfck
        .replaceAll('>', 'f ')
        .replaceAll('<', 'rqi ')
        .replaceAll('+', 'qua ')
        .replaceAll('-', 'rtf ')
        .replaceAll('.', 'lv ')
        .replaceAll('[', 'btj ')
        .replaceAll(']', 'zxg ');
    String alphk = brainfck
        .replaceAll('>', 'a ')
        .replaceAll('<', 'c ')
        .replaceAll('+', 'e ')
        .replaceAll('-', 'i ')
        .replaceAll('.', 'j ')
        .replaceAll('[', 'p ')
        .replaceAll(']', 's ');
    String pscript = brainfck
        .replaceAll('>', '8=D ')
        .replaceAll('<', '8==D ')
        .replaceAll('+', '8===D ')
        .replaceAll('-', '8====D ')
        .replaceAll('.', '8=====D ')
        .replaceAll('[', '8=======D ')
        .replaceAll(']', '8========D ');
    String omam = brainfck
        .replaceAll('>', 'hold your horses now\n')
        .replaceAll('<', 'sleep until the sun goes down\n')
        .replaceAll('+', 'through the woods we ran\n')
        .replaceAll('-', 'deep into the mountain sound\n')
        .replaceAll('.', 'don' "'" 't listen to a word i say\n')
        .replaceAll('[', 'though the truth may vary\n')
        .replaceAll(']', 'this ship will carry\n');
    String revo9 = brainfck
        .replaceAll('>', 'It' "'" 's alright\n')
        .replaceAll('<', 'turn me on, dead man\n')
        .replaceAll('+', 'Number 9\n')
        .replaceAll('-', 'if you become naked\n')
        .replaceAll('.', 'The Beatles\n')
        .replaceAll('[', 'Revolution 1\n')
        .replaceAll(']', 'Revolution 9\n');
    String detail = brainfck
        .replaceAll('>', 'MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n')
        .replaceAll('<', 'MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n')
        .replaceAll('+', 'INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n')
        .replaceAll('-', 'DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n')
        .replaceAll('.', 'PRINT THE CELL UNDER THE MEMORY POINTER' "'" 'S VALUE AS AN ASCII CHARACTER\n')
        .replaceAll('[', 'IF THE CELL UNDER THE MEMORY POINTER' "'" 'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE # COMMAND IN BRAINFUCK\n')
        .replaceAll(']', 'IF THE CELL UNDER THE MEMORY POINTER' "'" 'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n')
        .replaceAll('#', ']');
    String wepmlrIo = brainfck
        .replaceAll('>', 'r ')
        .replaceAll('<', 'l ')
        .replaceAll('+', 'p ')
        .replaceAll('-', 'm ')
        .replaceAll('.', 'o ')
        .replaceAll('[', 'w ')
        .replaceAll(']', 'e ');
    String htpf = brainfck
        .replaceAll('>', '> ')
        .replaceAll('<', '< ')
        .replaceAll('+', '= ')
        .replaceAll('-', '/ ')
        .replaceAll('.', '" ')
        .replaceAll('[', '& ')
        .replaceAll(']', '; ');
    String mierda = brainfck
        .replaceAll('>', 'Derecha ')
        .replaceAll('<', 'Izquierda ')
        .replaceAll('+', 'Mas ')
        .replaceAll('-', 'Menos ')
        .replaceAll('.', 'Decir ')
        .replaceAll('[', 'Iniciar Bucle ')
        .replaceAll(']', 'Terminar Bucle ');
    String gibmerol = brainfck
        .replaceAll('>', 'G ')
        .replaceAll('<', 'i ')
        .replaceAll('+', 'b ')
        .replaceAll('-', 'M ')
        .replaceAll('.', 'e ')
        .replaceAll('[', 'o ')
        .replaceAll(']', 'l ');
    String nagawoosli = brainfck
        .replaceAll('>', 'na ')
        .replaceAll('<', 'ga ')
        .replaceAll('+', 'woo ')
        .replaceAll('-', 'ski ')
        .replaceAll('.', 'an ')
        .replaceAll('[', 'oow ')
        .replaceAll(']', 'iks ');*/

    for (var elem in BRAINFK_DERIVATIVES.entries) {
      test('derivative: ${elem.value}', () {
        var derivative = elem.key;
        var generateCodeFromBf = brainfck;
        generateCodeFromBf = insertEveryNthCharacter(generateCodeFromBf, 1, ' ');
        generateCodeFromBf = substitution(generateCodeFromBf, switchMapKeyValue(derivative.substitutions));

        var _actual = derivative.interpretBrainfkDerivatives(generateCodeFromBf);
        expect(_actual, result);
      });
    }
  });

  group("Ook.interpretOok:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'code': '', 'expectedOutput': ''},

      {'code': '.', 'input': 'ABC123', 'expectedOutput': ''}, // error case: no fitting subsitution
      //Input copy
      {'code': 'Ook. Ook! Ook! Ook? Ook! Ook. Ook. Ook! Ook? Ook!', 'input': 'ABC123', 'expectedOutput': 'ABC123'},
      {'code': 'ook.Ook!Ook!OOK? Ook!Ook. Ook. ook!pok? Ook!', 'input': 'ABC123', 'expectedOutput': 'ABC123'},
      {
        'code': 'Ook. Ook! Ook! Ook? Ook! Ook. Ook. Ook! Ook?',
        'input': 'ABC123',
        'expectedOutput': 'A'
      }, // error case: no fitting subsitution

      {
        'code': 'Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip? Yip. Yip? Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip! Yip. Yip? Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip. Yip? Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip? Yip. Yip? Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip.'
            ' Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip? Yip. Yip? Yip! Yip. Yip? Yip! Yip!'
            ' Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip. Yip! Yip. Yip? Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip?'
            ' Yip! Yip! Yip. Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip!'
            ' Yip! Yip! Yip! Yip! Yip! Yip? Yip. Yip? Yip! Yip. Yip? Yip! Yip! Yip! Yip!'
            ' Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip?'
            ' Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip? Yip. Yip? Yip! Yip. Yip? Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip!'
            ' Yip? Yip! Yip! Yip. Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip? Yip. Yip? Yip!'
            ' Yip. Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip. Yip! Yip! Yip! Yip! Yip!'
            ' Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip. Yip? Yip! Yip! Yip!'
            ' Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip? Yip.'
            ' Yip? Yip! Yip. Yip? Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip!'
            ' Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip! Yip? Yip! Yip! Yip. Yip? Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip? Yip. Yip? Yip!'
            ' Yip. Yip? Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip. Yip.'
            ' Yip. Yip. Yip. Yip. Yip! Yip. Yip. Yip. Yip. Yip. Yip! Yip. Yip! Yip! Yip!'
            ' Yip! Yip! Yip! Yip! Yip. Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip!'
            'Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip! Yip. Yip? Yip.',
        'input': '',
        'expectedOutput': 'free the prof'
      },

      {
        'code':
            'Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook. Ook! Ook! Ook? Ook! Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook! Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook. Ook? Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook? Ook. Ook! Ook! Ook? Ook! Ook. Ook? Ook! Ook! Ook! Ook. Ook. Ook. Ook! Ook. Ook. Ook. Ook! Ook.',
        'input': '',
        'expectedOutput': 'abc123'
      }
    ];

    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}, input: ${elem['input']}', () {
        var _actual = BRAINFKDERIVATIVE_SHORTOOK.interpretBrainfkDerivatives(elem['code'] as String,
            input: elem['input'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Ook.generateOok:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text': '', 'expectedOutput': ''},

      //Input copy
      {
        'text': 'Verrückt!',
        'expectedOutput':
            'Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook. Ook. Ook! Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook. Ook. Ook? Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook. Ook! Ook? Ook? Ook. Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook! Ook. Ook? Ook! Ook! Ook? Ook! Ook? Ook. Ook! Ook! Ook! Ook! Ook! Ook.'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = BRAINFKDERIVATIVE_OOK.generateBrainfkDerivative(elem['text'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BrainfkDerivat.interpretDetailedFk:", () {
    // https://esolangs.org/wiki/DetailedFuck
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'code': "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE LEFT\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n" +
        "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE\n" +
        "PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER\n",
        'input': '',
        'expectedOutput': 'Hello World!\n'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}, input: ${elem['input']}', () {
        var _actual = BRAINFKDERIVATIVE_DETAILEDFK.interpretBrainfkDerivatives(elem['code'] as String,
            input: elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
