import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/brainfk/logic/brainfk.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/string_utils.dart';

class BrainfkDerivatives {
  late Map<String, String> substitutions;
  final String? outputCommandDelimiter;
  final int? fixedSize;
  final bool isCaseSensitive;
  final String Function(String code)? convertToBrainfk;

  BrainfkDerivatives(
      {required String pointerShiftLeftInstruction,
      required String pointerShiftRightInstruction,
      required String decreaseValueInstruction,
      required String increaseValueInstruction,
      required String startLoopInstruction,
      required String endLoopInstruction,
      required String inputInstruction,
      required String outputInstruction,
      this.isCaseSensitive = false,
      this.convertToBrainfk,
      this.fixedSize,
      this.outputCommandDelimiter}) {
    substitutions = {
      pointerShiftRightInstruction: '>',
      pointerShiftLeftInstruction: '<',
      increaseValueInstruction: '+',
      decreaseValueInstruction: '-',
      outputInstruction: '.',
      inputInstruction: ',',
      startLoopInstruction: '[',
      endLoopInstruction: ']'
    };
  }

  String convertBrainfkDerivativeToBrainfk(String code) {
    if (convertToBrainfk != null) {
      return convertToBrainfk!(code);
    } else {
      code = code.replaceAll(RegExp(r'\s+'), ' ');

      if (fixedSize != null) {
        var allCharKeys = substitutions.keys.join();
        allCharKeys = _sanitizeRegExpCharacters(allCharKeys);
        code = code.replaceAll(RegExp(r'[^' + allCharKeys + ']'), '');
        code = insertEveryNthCharacter(code, fixedSize!, '\x00');
      }

      code = substitution(code, substitutions, caseSensitive: isCaseSensitive);
      return code.replaceAll(RegExp(r'[^><+\-.,\[\]]'), '');
    }
  }

  String interpretBrainfkDerivatives(String code, {String? input}) {
    if (code.isEmpty) return '';

    var brainfk = convertBrainfkDerivativeToBrainfk(code);
    return interpretBrainfk(brainfk, input: input);
  }

  String generateBrainfkDerivative(String text) {
    if (text.isEmpty) return '';

    var brainfk = generateBrainfk(text);
    if (outputCommandDelimiter != null && outputCommandDelimiter!.isNotEmpty) {
      brainfk = insertEveryNthCharacter(brainfk, 1, outputCommandDelimiter!);
    }

    return substitution(brainfk, switchMapKeyValue(substitutions));
  }
}

String _sanitizeRegExpCharacters(String text) {
  return text.split('').map((e) {
    switch (e) {
      case '[':
      case ']':
      case '.':
      case '+':
      case '-':
        return '\\' + e;
      default:
        return e;
    }
  }).join('');
}

String _sanitizeBrainfkCharacters(String code) {
  return code.replaceAll(RegExp(r'[^><+\-.,\[\]]'), '');
}

String _convertOokToBrainfk(String code) {
  code = code.replaceAll(RegExp(r'[^?!.]'), '');
  code = insertEveryNthCharacter(code, 2, ' ');
  code = substitution(code, BRAINFKDERIVATIVE_SHORTOOK.substitutions);
  return _sanitizeBrainfkCharacters(code);
}

// https://esolangs.org/wiki/Trivial_brainfuck_substitution

final BrainfkDerivatives BRAINFKDERIVATIVE_OMAM = BrainfkDerivatives(
    pointerShiftRightInstruction: 'hold your horses now',
    pointerShiftLeftInstruction: 'sleep until the sun goes down',
    increaseValueInstruction: 'through the woods we ran',
    decreaseValueInstruction: 'deep into the mountain sound',
    outputInstruction: "don't listen to a word i say",
    inputInstruction: 'the screams all sound the same',
    startLoopInstruction: 'though the truth may vary',
    endLoopInstruction: 'this ship will carry',
    outputCommandDelimiter: '\n');

final BrainfkDerivatives BRAINFKDERIVATIVE_REVOLUTION9 = BrainfkDerivatives(
    pointerShiftRightInstruction: "It's alright",
    pointerShiftLeftInstruction: 'turn me on, dead man',
    increaseValueInstruction: 'Number 9',
    decreaseValueInstruction: 'if you become naked',
    outputInstruction: 'The Beatles',
    inputInstruction: 'Paul is dead',
    startLoopInstruction: 'Revolution 1',
    endLoopInstruction: 'Revolution 9',
    outputCommandDelimiter: '\n');

final BrainfkDerivatives BRAINFKDERIVATIVE_DETAILEDFK = BrainfkDerivatives(
    pointerShiftRightInstruction: 'MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT',
    pointerShiftLeftInstruction: 'MOVE THE MEMORY POINTER ONE CELL TO THE LEFT',
    increaseValueInstruction: 'INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE',
    decreaseValueInstruction: 'DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE',
    outputInstruction: "PRINT THE CELL UNDER THE MEMORY POINTER' ' 'S VALUE AS AN ASCII CHARACTER",
    inputInstruction:
        "REPLACE THE CELL UNDER THE MEMORY POINTER' ' 'S VALUE WITH THE ASCII CHARACTER CODE OF USER INPUT",
    startLoopInstruction: "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK",
    endLoopInstruction: "IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK",
    outputCommandDelimiter: '\n');

final BrainfkDerivatives BRAINFKDERIVATIVE_GERMAN = BrainfkDerivatives(
    pointerShiftRightInstruction: 'Links',
    pointerShiftLeftInstruction: 'Rechts',
    increaseValueInstruction: 'Addition',
    decreaseValueInstruction: 'Subtraktion',
    outputInstruction: 'Eingabe',
    inputInstruction: 'Ausgabe',
    startLoopInstruction: 'Schleifenanfang',
    endLoopInstruction: 'Schleifenende',
    outputCommandDelimiter: '\n');

final BrainfkDerivatives BRAINFKDERIVATIVE_COLONOSCOPY = BrainfkDerivatives(
    pointerShiftRightInstruction: ';};',
    pointerShiftLeftInstruction: ';{;',
    increaseValueInstruction: ';;};',
    decreaseValueInstruction: ';;{;',
    outputInstruction: ';;;};',
    inputInstruction: ';;;{;',
    startLoopInstruction: '{{;',
    endLoopInstruction: '}};',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_KONFK = BrainfkDerivatives(
    pointerShiftRightInstruction: 'うんうんうん',
    pointerShiftLeftInstruction: 'うんうんたん',
    increaseValueInstruction: 'うんたんうん',
    decreaseValueInstruction: 'うんたんたん',
    outputInstruction: 'たんうんうん',
    inputInstruction: 'たんうんたん',
    startLoopInstruction: 'たんたんうん',
    endLoopInstruction: 'たんたんたん',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_FKBEES = BrainfkDerivatives(
    pointerShiftRightInstruction: 'f',
    pointerShiftLeftInstruction: 'u',
    increaseValueInstruction: 'c',
    decreaseValueInstruction: 'k',
    outputInstruction: 'b',
    inputInstruction: 'e',
    startLoopInstruction: 'E',
    endLoopInstruction: 's',
    outputCommandDelimiter: ' ',
    fixedSize: 1,
    isCaseSensitive: true);

final BrainfkDerivatives BRAINFKDERIVATIVE_PSSCRIPT = BrainfkDerivatives(
    pointerShiftRightInstruction: '8=D',
    pointerShiftLeftInstruction: '8==D',
    increaseValueInstruction: '8===D',
    decreaseValueInstruction: '8====D',
    outputInstruction: '8=====D',
    inputInstruction: '8======D',
    startLoopInstruction: '8=======D',
    endLoopInstruction: '8========D',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_ALPHK = BrainfkDerivatives(
    pointerShiftRightInstruction: 'a',
    pointerShiftLeftInstruction: 'c',
    increaseValueInstruction: 'e',
    decreaseValueInstruction: 'i',
    outputInstruction: 'j',
    inputInstruction: 'o',
    startLoopInstruction: 'p',
    endLoopInstruction: 's',
    fixedSize: 1);

final BrainfkDerivatives BRAINFKDERIVATIVE_REVERSEFK = BrainfkDerivatives(
    pointerShiftRightInstruction: '<',
    pointerShiftLeftInstruction: '>',
    increaseValueInstruction: '-',
    decreaseValueInstruction: '+',
    outputInstruction: ',',
    inputInstruction: '.',
    startLoopInstruction: ']',
    endLoopInstruction: '[',
    fixedSize: 1);

final BrainfkDerivatives BRAINFKDERIVATIVE_BTJZXGQUARTFRQIFJLV = BrainfkDerivatives(
    pointerShiftRightInstruction: 'f',
    pointerShiftLeftInstruction: 'rqi',
    increaseValueInstruction: 'qua',
    decreaseValueInstruction: 'rtf',
    outputInstruction: 'lv',
    inputInstruction: 'j',
    startLoopInstruction: 'btj',
    endLoopInstruction: 'zxg',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_BINARYFK = BrainfkDerivatives(
    pointerShiftRightInstruction: '010',
    pointerShiftLeftInstruction: '011',
    increaseValueInstruction: '000',
    decreaseValueInstruction: '001',
    outputInstruction: '100',
    inputInstruction: '101',
    startLoopInstruction: '110',
    endLoopInstruction: '111',
    fixedSize: 3);

final BrainfkDerivatives BRAINFKDERIVATIVE_TERNARY = BrainfkDerivatives(
    pointerShiftRightInstruction: '01',
    pointerShiftLeftInstruction: '00',
    increaseValueInstruction: '11',
    decreaseValueInstruction: '10',
    outputInstruction: '20',
    inputInstruction: '21',
    startLoopInstruction: '02',
    endLoopInstruction: '12',
    fixedSize: 2);

final BrainfkDerivatives BRAINFKDERIVATIVE_KENNYSPEAK = BrainfkDerivatives(
    pointerShiftRightInstruction: 'mmp',
    pointerShiftLeftInstruction: 'mmm',
    increaseValueInstruction: 'mpp',
    decreaseValueInstruction: 'pmm',
    outputInstruction: 'fmm',
    inputInstruction: 'fpm',
    startLoopInstruction: 'mmf',
    endLoopInstruction: 'mpf',
    fixedSize: 3);

final BrainfkDerivatives BRAINFKDERIVATIVE_MORSEFK = BrainfkDerivatives(
    pointerShiftRightInstruction: '.--',
    pointerShiftLeftInstruction: '--.',
    increaseValueInstruction: '..-',
    decreaseValueInstruction: '-..',
    outputInstruction: '-.-',
    inputInstruction: '.-.',
    startLoopInstruction: '---',
    endLoopInstruction: '...',
    fixedSize: 3);

final BrainfkDerivatives BRAINFKDERIVATIVE_AAA = BrainfkDerivatives(
    pointerShiftRightInstruction: 'aAaA',
    pointerShiftLeftInstruction: 'AAaa',
    increaseValueInstruction: 'AAAA',
    decreaseValueInstruction: 'AaAa',
    outputInstruction: 'aaaa',
    inputInstruction: 'aAaa',
    startLoopInstruction: 'aaAA',
    endLoopInstruction: 'aaaA',
    isCaseSensitive: true,
    fixedSize: 4);

final BrainfkDerivatives BRAINFKDERIVATIVE_BLUB = BrainfkDerivatives(
    pointerShiftRightInstruction: 'Blub. Blub?',
    pointerShiftLeftInstruction: 'Blub? Blub.',
    increaseValueInstruction: 'Blub. Blub.',
    decreaseValueInstruction: 'Blub! Blub!',
    outputInstruction: 'Blub! Blub.',
    inputInstruction: 'Blub. Blub!',
    startLoopInstruction: 'Blub! Blub?',
    endLoopInstruction: 'Blub? Blub!',
    outputCommandDelimiter: ' ',
    convertToBrainfk: _convertOokToBrainfk);

final BrainfkDerivatives BRAINFKDERIVATIVE_OOK = BrainfkDerivatives(
    pointerShiftRightInstruction: 'Ook. Ook?',
    pointerShiftLeftInstruction: 'Ook? Ook.',
    increaseValueInstruction: 'Ook. Ook.',
    decreaseValueInstruction: 'Ook! Ook!',
    outputInstruction: 'Ook! Ook.',
    inputInstruction: 'Ook. Ook!',
    startLoopInstruction: 'Ook! Ook?',
    endLoopInstruction: 'Ook? Ook!',
    outputCommandDelimiter: ' ',
    convertToBrainfk: _convertOokToBrainfk);

final BrainfkDerivatives BRAINFKDERIVATIVE_SHORTOOK = BrainfkDerivatives(
    pointerShiftRightInstruction: '.?',
    pointerShiftLeftInstruction: '?.',
    increaseValueInstruction: '..',
    decreaseValueInstruction: '!!',
    outputInstruction: '!.',
    inputInstruction: '.!',
    startLoopInstruction: '!?',
    endLoopInstruction: '?!',
    fixedSize: 2);

final BrainfkDerivatives BRAINFKDERIVATIVE_NAK = BrainfkDerivatives(
    pointerShiftRightInstruction: 'Nak. Nak?',
    pointerShiftLeftInstruction: 'Nak? Nak.',
    increaseValueInstruction: 'Nak. Nak.',
    decreaseValueInstruction: 'Nak! Nak!',
    outputInstruction: 'Nak! Nak.',
    inputInstruction: 'Nak. Nak!',
    startLoopInstruction: 'Nak! Nak?',
    endLoopInstruction: 'Nak? Nak!',
    outputCommandDelimiter: ' ',
    convertToBrainfk: _convertOokToBrainfk);

final BrainfkDerivatives BRAINFKDERIVATIVE_PIKALANG = BrainfkDerivatives(
    pointerShiftRightInstruction: 'pipi',
    pointerShiftLeftInstruction: 'pichu',
    increaseValueInstruction: 'pi',
    decreaseValueInstruction: 'ka',
    outputInstruction: 'pikachu',
    inputInstruction: 'pikapi',
    startLoopInstruction: 'pika',
    endLoopInstruction: 'chu',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_PEWLANG = BrainfkDerivatives(
    pointerShiftRightInstruction: 'pew',
    pointerShiftLeftInstruction: 'Pew',
    increaseValueInstruction: 'pEw',
    decreaseValueInstruction: 'peW',
    outputInstruction: 'PEw',
    inputInstruction: 'pEW',
    startLoopInstruction: 'PeW',
    endLoopInstruction: 'PEW',
    outputCommandDelimiter: ' ',
    isCaseSensitive: true,
    fixedSize: 3);

final BrainfkDerivatives BRAINFKDERIVATIVE_ROADRUNNER = BrainfkDerivatives(
    pointerShiftRightInstruction: 'meeP',
    pointerShiftLeftInstruction: 'Meep',
    increaseValueInstruction: 'mEEp',
    decreaseValueInstruction: 'MeeP',
    outputInstruction: 'MEEP',
    inputInstruction: 'meep',
    startLoopInstruction: 'mEEP',
    endLoopInstruction: 'MEEp',
    outputCommandDelimiter: ' ',
    isCaseSensitive: true,
    fixedSize: 4);

final BrainfkDerivatives BRAINFKDERIVATIVE_ZZZ = BrainfkDerivatives(
    pointerShiftRightInstruction: 'zz',
    pointerShiftLeftInstruction: '-zz',
    increaseValueInstruction: 'z',
    decreaseValueInstruction: '-z',
    outputInstruction: 'zzz',
    inputInstruction: '-zzz',
    startLoopInstruction: 'z+z',
    endLoopInstruction: 'z-z',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_SCREAMCODE = BrainfkDerivatives(
    pointerShiftRightInstruction: 'AAAH',
    pointerShiftLeftInstruction: 'AAAAGH',
    increaseValueInstruction: 'F*CK',
    decreaseValueInstruction: 'SHIT',
    outputInstruction: '!!!!!!',
    inputInstruction: 'WHAT?',
    startLoopInstruction: 'OW',
    endLoopInstruction: 'OWIE',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_FLUFFLEPUFF = BrainfkDerivatives(
    pointerShiftRightInstruction: 'b',
    pointerShiftLeftInstruction: 't',
    increaseValueInstruction: 'pf',
    decreaseValueInstruction: 'bl',
    outputInstruction: '!',
    inputInstruction: '?',
    startLoopInstruction: '*gasp*',
    endLoopInstruction: '*pomf*',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_TRIPLET = BrainfkDerivatives(
    pointerShiftRightInstruction: '001',
    pointerShiftLeftInstruction: '100',
    increaseValueInstruction: '111',
    decreaseValueInstruction: '000',
    outputInstruction: '010',
    inputInstruction: '101',
    startLoopInstruction: '110',
    endLoopInstruction: '011',
    outputCommandDelimiter: ' ',
    fixedSize: 3);

final BrainfkDerivatives BRAINFKDERIVATIVE_UWU = BrainfkDerivatives(
    pointerShiftRightInstruction: 'OwO',
    pointerShiftLeftInstruction: '°w°',
    increaseValueInstruction: 'UwU',
    decreaseValueInstruction: 'QwQ',
    outputInstruction: '@w@',
    inputInstruction: '>w<',
    startLoopInstruction: '~w~',
    endLoopInstruction: '-w-',
    outputCommandDelimiter: ' ',
    fixedSize: 3);

final BrainfkDerivatives BRAINFKDERIVATIVE___FK = BrainfkDerivatives(
    pointerShiftRightInstruction: '!!!!!#',
    pointerShiftLeftInstruction: '!!!!!!#',
    increaseValueInstruction: '!!!!!!!#',
    decreaseValueInstruction: '!!!!!!!!#',
    outputInstruction: '!!!!!!!!!!#',
    inputInstruction: '!!!!!!!!!#',
    startLoopInstruction: '!!!!!!!!!!!#',
    endLoopInstruction: '!!!!!!!!!!!!#',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_WEPMLRIO = BrainfkDerivatives(
    pointerShiftRightInstruction: 'r',
    pointerShiftLeftInstruction: 'l',
    increaseValueInstruction: 'p',
    decreaseValueInstruction: 'm',
    outputInstruction: 'o',
    inputInstruction: 'I',
    startLoopInstruction: 'w',
    endLoopInstruction: 'e',
    fixedSize: 1);

final BrainfkDerivatives BRAINFKDERIVATIVE_HTPF = BrainfkDerivatives(
    pointerShiftRightInstruction: '>',
    pointerShiftLeftInstruction: '<',
    increaseValueInstruction: '=',
    decreaseValueInstruction: '/',
    outputInstruction: '',
    inputInstruction: '#',
    startLoopInstruction: '&',
    endLoopInstruction: ';',
    fixedSize: 1);

final BrainfkDerivatives BRAINFKDERIVATIVE_GIBMEROL = BrainfkDerivatives(
    pointerShiftRightInstruction: 'G',
    pointerShiftLeftInstruction: 'i',
    increaseValueInstruction: 'b',
    decreaseValueInstruction: 'M',
    outputInstruction: 'e',
    inputInstruction: 'R',
    startLoopInstruction: 'o',
    endLoopInstruction: 'l',
    fixedSize: 1);

final BrainfkDerivatives BRAINFKDERIVATIVE_NAGAWOOSKI = BrainfkDerivatives(
    pointerShiftRightInstruction: 'na',
    pointerShiftLeftInstruction: 'ga',
    increaseValueInstruction: 'woo',
    decreaseValueInstruction: 'ski',
    outputInstruction: 'an',
    inputInstruction: 'ag',
    startLoopInstruction: 'oow',
    endLoopInstruction: 'iks');

final BrainfkDerivatives BRAINFKDERIVATIVE_MIERDA = BrainfkDerivatives(
    pointerShiftRightInstruction: 'Derecha',
    pointerShiftLeftInstruction: 'Izquierda',
    increaseValueInstruction: 'Mas',
    decreaseValueInstruction: 'Menos',
    outputInstruction: 'Decir',
    inputInstruction: 'Leer',
    startLoopInstruction: 'Iniciar Bucle',
    endLoopInstruction: 'Terminar Bucle',
    outputCommandDelimiter: ' ');

final BrainfkDerivatives BRAINFKDERIVATIVE_CUSTOM = BrainfkDerivatives(
    pointerShiftRightInstruction: '',
    pointerShiftLeftInstruction: '',
    increaseValueInstruction: '',
    decreaseValueInstruction: '',
    outputInstruction: '',
    inputInstruction: '',
    startLoopInstruction: '',
    endLoopInstruction: '',
    outputCommandDelimiter: ' ');

// NEVER EVER CHANGE THE NAMES! (the value strings of the map);
// They are used as keys in the multi decoder
final Map<BrainfkDerivatives, String> BRAINFK_DERIVATIVES = {
  BRAINFKDERIVATIVE___FK: '!!F**k',
  BRAINFKDERIVATIVE_AAA: 'AAA',
  BRAINFKDERIVATIVE_ALPHK: 'Alph**k',
  BRAINFKDERIVATIVE_BINARYFK: 'BinaryFuck',
  BRAINFKDERIVATIVE_BLUB: 'Blub',
  BRAINFKDERIVATIVE_BTJZXGQUARTFRQIFJLV: 'Btjzxgquartfrqifjlv',
  BRAINFKDERIVATIVE_COLONOSCOPY: 'Colonoscopy',
  BRAINFKDERIVATIVE_DETAILEDFK: 'DetailedF**k',
  BRAINFKDERIVATIVE_FLUFFLEPUFF: 'Fluffle Puff',
  BRAINFKDERIVATIVE_FKBEES: 'f**kbeEs',
  BRAINFKDERIVATIVE_GERMAN: 'GERMAN',
  BRAINFKDERIVATIVE_GIBMEROL: 'GibMeRol',
  BRAINFKDERIVATIVE_HTPF: 'HTPF',
  BRAINFKDERIVATIVE_KENNYSPEAK: 'Kenny Speak',
  BRAINFKDERIVATIVE_KONFK: 'K-on F**k',
  BRAINFKDERIVATIVE_MIERDA: 'Mierda',
  BRAINFKDERIVATIVE_MORSEFK: 'MorseF**k',
  BRAINFKDERIVATIVE_NAGAWOOSKI: 'Nagawooski',
  BRAINFKDERIVATIVE_NAK: 'Nak',
  BRAINFKDERIVATIVE_OMAM: 'Omam',
  BRAINFKDERIVATIVE_OOK: 'Ook',
  BRAINFKDERIVATIVE_PSSCRIPT: 'P***sScript',
  BRAINFKDERIVATIVE_PEWLANG: 'PewLang',
  BRAINFKDERIVATIVE_PIKALANG: 'PikaLang',
  BRAINFKDERIVATIVE_REVERSEFK: 'ReverseF**k',
  BRAINFKDERIVATIVE_REVOLUTION9: 'Revolution 9',
  BRAINFKDERIVATIVE_ROADRUNNER: 'Roadrunner',
  BRAINFKDERIVATIVE_SCREAMCODE: 'ScreamCode',
  BRAINFKDERIVATIVE_SHORTOOK: 'Short Ook',
  BRAINFKDERIVATIVE_TERNARY: 'Ternary',
  BRAINFKDERIVATIVE_TRIPLET: 'Triplet',
  BRAINFKDERIVATIVE_WEPMLRIO: 'wepmlrIo',
  BRAINFKDERIVATIVE_UWU: 'UwU',
  BRAINFKDERIVATIVE_ZZZ: 'ZZZ',
};

class BrainfckDerivateDropdown {
  final String title;
  final String description;

  const BrainfckDerivateDropdown({
    required this.title,
    required this.description,
  });
}

Map<BrainfkDerivatives, BrainfckDerivateDropdown> BRAINFK_DERIVATIVES_DETAILED = {
  BRAINFKDERIVATIVE___FK: const BrainfckDerivateDropdown(title: '!!F**k', description: '!!!!!#, !!!!!!#, !!!!!!!#, !!!!!!!!#, !!!!!!!!!!#, !!!!!!!!!#, !!!!!!!!!!!#, !!!!!!!!!!!!#'),
  BRAINFKDERIVATIVE_AAA: const BrainfckDerivateDropdown(title: 'AAA', description: 'aAaA, AAaa, AAAA, AaAa, aaaa, aAaa, aaAA, aaaA'),
  BRAINFKDERIVATIVE_ALPHK: const BrainfckDerivateDropdown(title: 'Alph**k', description: 'a, c, e, i, j, o, p, s'),
  BRAINFKDERIVATIVE_BINARYFK: const BrainfckDerivateDropdown(title: 'BinaryFuck', description: '010, 011, 000, 001, 100, 101, 110, 111'),
  BRAINFKDERIVATIVE_BLUB: const BrainfckDerivateDropdown(title: 'Blub', description: 'Blub. Blub?, Blub? Blub., Blub. Blub., Blub! Blub!, Blub! Blub., Blub. Blub!, Blub! Blub?, Blub? Blub!'),
  BRAINFKDERIVATIVE_BTJZXGQUARTFRQIFJLV: const BrainfckDerivateDropdown(title: 'Btjzxgquartfrqifjlv', description: 'f, rqi, qua, rtf, lv, j, btj, zxg'),
  BRAINFKDERIVATIVE_COLONOSCOPY: const BrainfckDerivateDropdown(title: 'Colonoscopy', description: ';};, ;{;, ;;};, ;;{;, ;;;};, ;;;{;, {{;, }};'),
  BRAINFKDERIVATIVE_DETAILEDFK: const BrainfckDerivateDropdown(title: 'DetailedF**k', description: "MOVE THE MEMORY POINTER ONE CELL TO THE RIGHT, MOVE THE MEMORY POINTER ONE CELL TO THE LEFT, INCREMENT THE CELL UNDER THE MEMORY POINTER BY ONE, DECREMENT THE CELL UNDER THE MEMORY POINTER BY ONE, REPLACE THE CELL UNDER THE MEMORY POINTER'S VALUE WITH THE ASCII CHARACTER CODE OF USER INPUT, PRINT THE CELL UNDER THE MEMORY POINTER'S VALUE AS AN ASCII CHARACTER, IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE ] COMMAND IN BRAINFUCK, IF THE CELL UNDER THE MEMORY POINTER'S VALUE IS NOT ZERO INSTEAD OF READING THE NEXT COMMAND IN THE PROGRAM JUMP TO THE CORRESPONDING COMMAND EQUIVALENT TO THE [ COMMAND IN BRAINFUCK"),
  BRAINFKDERIVATIVE_FLUFFLEPUFF: const BrainfckDerivateDropdown(title: 'Fluffle Puff', description: 'b, t, bf, pl, !, ?, *gasp*, *pomf*'),
  BRAINFKDERIVATIVE_FKBEES: const BrainfckDerivateDropdown(title: 'f**kbeEs', description: 'f, u, c, k, b, e, E, s'),
  BRAINFKDERIVATIVE_GERMAN: const BrainfckDerivateDropdown(title: 'GERMAN', description: 'LINKS, RECHTS, ADDITION, SUBTRAKTION, EINGABE, AUSGABE, SCHLEIFENANFANG, SCHLEIFENENDE'),
  BRAINFKDERIVATIVE_GIBMEROL: const BrainfckDerivateDropdown(title: 'GibMeRol', description: 'G, i, b, M, e, R, o, l'),
  BRAINFKDERIVATIVE_HTPF: const BrainfckDerivateDropdown(title: 'HTPF', description: '>, <, =, /, , #, &, ;'),
  BRAINFKDERIVATIVE_KENNYSPEAK: const BrainfckDerivateDropdown(title: 'Kenny Speak', description: 'mmp, mmm, mpp, pmm, fmm, fpm, mmf, mpf'),
  BRAINFKDERIVATIVE_KONFK: const BrainfckDerivateDropdown(title: 'K-on F**k', description: 'うんうんうん, うんうんたん, うんたんうん, うんたんたん, たんうんうん, たんうんたん, たんたんうん, たんたんたん'),
  BRAINFKDERIVATIVE_MIERDA: const BrainfckDerivateDropdown(title: 'Mierda', description: 'Derecha, Izquierda, Mas, Menos, Decir, Leer, Iniciar Bucle, Terminar Bucle'),
  BRAINFKDERIVATIVE_MORSEFK: const BrainfckDerivateDropdown(title: 'MorseF**k', description: '.--, --., ..-, -.., -.-, .-., ---, ...'),
  BRAINFKDERIVATIVE_NAGAWOOSKI: const BrainfckDerivateDropdown(title: 'Nagawooski', description: 'na, ga, woo, ski, an, ag, oow, iks'),
  BRAINFKDERIVATIVE_NAK: const BrainfckDerivateDropdown(title: 'Nak', description: 'Nak. Nak?, Nak? Nak., Nak. Nak., Nak! Nak!, Nak! Nak., Nak. Nak!, Nak! Nak?, Nak? Nak!'),
  BRAINFKDERIVATIVE_OMAM: const BrainfckDerivateDropdown(title: 'Omam', description: "old your horses now, sleep until the sun goes down, through the woods we ran, deep into the mountain sound, don't listen to a word i say, the screams all sound the same, though the truth may vary, this ship will carry"),
  BRAINFKDERIVATIVE_OOK: const BrainfckDerivateDropdown(title: 'Ook', description: 'Ook. Ook?, Ook? Ook., Ook. Ook., Ook! Ook!, Ook! Ook., Ook. Ook!, Ook! Ook?, Ook? Ook!'),
  BRAINFKDERIVATIVE_PSSCRIPT: const BrainfckDerivateDropdown(title: 'P***sScript', description: '8=D, 8==D, 8===D, 8====D, 8=====D, 8======D, 8=======D, 8========D'),
  BRAINFKDERIVATIVE_PEWLANG: const BrainfckDerivateDropdown(title: 'PewLang', description: 'pew, Pew, pEw, peW, PEw, pEW, PeW, PEW'),
  BRAINFKDERIVATIVE_PIKALANG: const BrainfckDerivateDropdown(title: 'PikaLang', description: 'pipi, pichu, pi, ka, pikachu, pikapi, pika, chu'),
  BRAINFKDERIVATIVE_REVERSEFK: const BrainfckDerivateDropdown(title: 'ReverseF**k', description: '<, >, -, +, ,, ., ], ['),
  BRAINFKDERIVATIVE_REVOLUTION9: const BrainfckDerivateDropdown(title: 'Revolution 9', description: "It's alright, turn me on, dead man, Number 9, if you become naked, The Beatles, Paul is dead, Revolution 1, Revolution 9"),
  BRAINFKDERIVATIVE_ROADRUNNER: const BrainfckDerivateDropdown(title: 'Roadrunner', description: 'meeP, Meep, mEEp, MeeP, MEEP, meep, mEEP, MEEp'),
  BRAINFKDERIVATIVE_SCREAMCODE: const BrainfckDerivateDropdown(title: 'ScreamCode', description: 'AAAH, AAAAGH, FUCK, SHIT, !!!!!!, WHAT?!, OW, OWIE'),
  BRAINFKDERIVATIVE_SHORTOOK: const BrainfckDerivateDropdown(title: 'Short Ook', description: '.?, ?., .., !!, !., .!, !?, ?!'),
  BRAINFKDERIVATIVE_TERNARY: const BrainfckDerivateDropdown(title: 'Ternary', description: '01, 00, 11, 10, 21, 20, 02, 12'),
  BRAINFKDERIVATIVE_TRIPLET: const BrainfckDerivateDropdown(title: 'Triplet', description: '001, 100, 111, 000, 010, 101, 110, 011'),
  BRAINFKDERIVATIVE_WEPMLRIO: const BrainfckDerivateDropdown(title: 'wepmlrIo', description: 'r, l, p, m, o, I, w, e'),
  BRAINFKDERIVATIVE_UWU: const BrainfckDerivateDropdown(title: 'UwU', description: 'OwO, °w°, UwU, QwQ, @w@, >w<, ~w~, ¯w¯'),
  BRAINFKDERIVATIVE_ZZZ: const BrainfckDerivateDropdown(title: 'ZZZ', description: 'zz, -zz, z, -z, zzz, -zzz, z+z, z-z'),
  BRAINFKDERIVATIVE_CUSTOM: const BrainfckDerivateDropdown(title: 'Custom', description: ''),
};