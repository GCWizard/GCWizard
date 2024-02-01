import 'package:gc_wizard/utils/collection_utils.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/morse/logic/morse_data.dart';

enum MORSE_CODE {MORSE_ITU, MORSE1838, MORSE1844, STEINHEIL, GERKE}

final Map<MORSE_CODE, String> MORSE_CODES = {
  MORSE_CODE.MORSE_ITU: 'symboltables_morse',
  MORSE_CODE.MORSE1838: 'symboltables_morse_1838_patent',
  MORSE_CODE.MORSE1844: 'symboltables_morse_1844_vail',
  MORSE_CODE.GERKE: 'symboltables_morse_gerke',
  MORSE_CODE.STEINHEIL: 'symboltables_morse_steinheil',
};

final Map<MORSE_CODE, Map<String, String>> _AZTO_MORSE_CODE = {
  MORSE_CODE.MORSE_ITU: _AZToMorse,
  MORSE_CODE.MORSE1838: _AZToMorse1838,
  MORSE_CODE.MORSE1844: _AZToMorse1844,
  MORSE_CODE.GERKE: _AZToGerke,
  MORSE_CODE.STEINHEIL: _AZToSteinheil,
};

final Map<MORSE_CODE, Map<String, String>> _MORSE_CODETOAZ = {
  MORSE_CODE.MORSE_ITU: _MorseToAZ,
  MORSE_CODE.MORSE1838: _Morse1838ToAZ,
  MORSE_CODE.MORSE1844: _Morse1844ToAZ,
  MORSE_CODE.GERKE: _GerkeToAZ,
  MORSE_CODE.STEINHEIL: _SteinheilToAZ,
};



String encodeMorse(String input, MORSE_CODE code) {
  if (input.isEmpty) return '';

  return input.toUpperCase().split('').map((character) {
    if (character == ' ') return '|';

    var morse = _AZTO_MORSE_CODE[code]?[character];
    return morse ?? '';
  }).join(String.fromCharCode(8195)); // using wide space
}

String decodeMorse(String input, MORSE_CODE code) {
  if (input.isEmpty) return '';

  return input.split(RegExp(r'[^\.\-–·―\u202F/\|]')).map((morse) {
    if (morse == '|' || morse == '/') return ' ';
    var character = _MORSE_CODETOAZ[code]?[morse];
    return character ?? '';
  }).join();
}
