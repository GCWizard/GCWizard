import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/string_utils.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/nva_substitution_tables/_common/logic/common.dart';

const Map<String, String> _AZToHVA1950 = {
  'I': '0', 'R': '1', 'N': '2', 'E': '8', 'S': '6', 'T': '5',
  'A': '91', 'B': '96', 'C': '95', 'D': '98', 'F': '94', 'G': '97',
  'H': '41', 'J': '40', 'K': '42', 'L': '46', 'M': '48', 'O': '49', 'P': '43',
  'Q': '72', 'U': '75', 'V': '74', 'W': '77',
  'X': '31', 'Y': '30', 'Z': '32',
  '\u00C4': '90', // Ä
  '\u00D6': '47', // Ö
  '\u00DC': '78', // Ü
  '\u00DF': '76', // ß
  '.': '38',
  ',': '34',
  '-': '39',
  ':': '37',
  '(': '33',
  ')': '33',
};
final Map<String, String> _HVA1950ToAZ = switchMapKeyValue(_AZToHVA1950);

const Map<String, String> _CodeToHVA1950 = {
  'BERICHT': '92',
  'INFORMATION': '99',
  'No': '93',
  'BESTÄTIGEN': '45',
  'STIMMUNG': '44',
  'BENÖTIGEN': '71',
  'ABLAGE': '70',
  'TELEGRAMM': '79',
  'POST ERHALTEN': '73',
  'TREFF': '36',
};
final Map<String, String> _HVA1950ToCode = switchMapKeyValue(_CodeToHVA1950);

const Map<String, String> _NumbersToHVA1950 = {
  '0': '000',
  '1': '111',
  '2': '222',
  '3': '333',
  '4': '444',
  '5': '555',
  '6': '666',
  '7': '777',
  '8': '888',
  '9': '999'
};
final Map<String, String> _HVA1950ToNumbers = switchMapKeyValue(_NumbersToHVA1950);

const _LETTERS_NUMBER_SWITCH_HVA1950 = '35';
const _FILLING_HVA1950 = '38';

const Map<String, String> _AZToHVA1970 = {
  'S': '7', 'E': '9', 'A': '8', 'I': '2', 'T': '5', 'N': '4',
  'B': '69', 'C': '68', 'D': '64', 'F': '66', 'G': '60',
  'H': '07', 'J': '09', 'K': '08', 'L': '02', 'M': '04', 'O': '01', 'P': '03',
  'Q': '00',
  'R': '17', 'U': '12', 'V': '11', 'W': '16', 'X': '10',
  'Y': '37', 'Z': '39',
  '\u00C4': '67', // Ä
  '\u00D6': '06', // Ö
  '\u00DC': '15', // Ü
  '\u00DF': '18', // ß
  ':': '31',
  '.': '32',
  ',': '35',
  '(': '36',
  ')': '36',
  '/': '30',
};
final Map<String, String> _HVA1970ToAZ = switchMapKeyValue(_AZToHVA1970);

final Map<String, String> _CodeToHVA1970 = {
  'ERHALTEN': '62',
  'BENÖTIGEN': '65',
  'MITTEILEN': '61',
  'MITTEILUNG': '61',
  'TELEGRAMM': '63',
  'INFORMATION': '05',
  'STIMMUNG': '19',
  'BERICHT': '14',
  'BESTÄTIGEN': '13',
  'TBK': '33',
};
const Map<String, String> _HVA1970ToCode = {
  '62': 'ERHALTEN',
  '65': 'BENÖTIGEN',
  '61': 'MITTEILEN/-UNG',
  '63': 'TELEGRAMM',
  '05': 'INFORMATION',
  '19': 'STIMMUNG',
  '14': 'BERICHT',
  '13': 'BESTÄTIGEN',
  '33': 'TBK',
};

const Map<String, String> _NumbersToHVA1970 = {
  '0': '000',
  '1': '111',
  '2': '222',
  '3': '333',
  '4': '444',
  '5': '555',
  '6': '666',
  '7': '777',
  '8': '888',
  '9': '999'
};
final Map<String, String> _HVA1970ToNumbers = switchMapKeyValue(_NumbersToHVA1970);

const _LETTERS_NUMBER_SWITCH_HVA1970 = '38';
const _FILLING_HVA1970 = '32';

String _encodeHVA(String input, bool codeHVA1950) {
  Map<String, String> _AZToHVA = {};
  Map<String, String> _NumbersToHVA = {};
  Map<String, String> _CodeToHVA = {};

  String _LETTERS_NUMBER_SWITCH = '';
  String _FILLING = '';

  if (codeHVA1950) {
    _LETTERS_NUMBER_SWITCH = _LETTERS_NUMBER_SWITCH_HVA1950;
    _FILLING = _FILLING_HVA1950;
    _AZToHVA = _AZToHVA1950;
    _NumbersToHVA = _NumbersToHVA1950;
    _CodeToHVA = _CodeToHVA1950;
  } else {
    _LETTERS_NUMBER_SWITCH = _LETTERS_NUMBER_SWITCH_HVA1970;
    _FILLING = _FILLING_HVA1970;
    _AZToHVA = _AZToHVA1970;
    _NumbersToHVA = _NumbersToHVA1970;
    _CodeToHVA = _CodeToHVA1970;
  }

  //remove non-encodable chars
  input = input.toUpperCase();
  input = input
      .split('')
      .where((char) => _AZToHVA[char] != null || _NumbersToHVA[char] != null)
      .join();

  var isLetterMode = true;
  List<String> out = [];

  //encode
  int i = 0;
  while (i < input.length) {
    String? code = codebook(input, i, _CodeToHVA);
    if (code != null) {
      out.add(_CodeToHVA[code]!);
      i += code.length;
    } else {
      if (isLetterMode) {
        var character = _AZToHVA[input[i]];
        if (character != null) {
          out.add(character);
          i++;
          continue;
        } else {
          character = _NumbersToHVA[input[i]];
          if (character != null) {
            out.add(_LETTERS_NUMBER_SWITCH);
            out.add(character);
            isLetterMode = false;
            i++;
            continue;
          }
        }
      } else {
        var character = _NumbersToHVA[input[i]];
        if (character != null) {
          out.add(character);
          i++;
          continue;
        } else {
          character = _AZToHVA[input[i]];
          if (character != null) {
            out.add(_LETTERS_NUMBER_SWITCH);
            out.add(character);
            isLetterMode = true;
            i++;
            continue;
          }
        }
      }
    }
  }

  var output = out.join();

  //fill to dividable by 5
  if (output.length % 5 != 0 && !isLetterMode) {
    output += _LETTERS_NUMBER_SWITCH;
  }
  while (output.length % 5 != 0) {
    output += _FILLING;
  }

  return output;
}

String encryptHVA(String input, String? keyOneTimePad, bool codeHVA1950) {
  if (input.isEmpty) return '';

  var output = _encodeHVA(input, codeHVA1950);

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    output = addOneTimePad(output, keyOneTimePad);
  }

  return insertSpaceEveryNthCharacter(output, 5);
}

String _decodeHVA(String input, bool codeHVA1950) {
  if (input.isEmpty) return '';

  Map<String, String> _HVAToAZ = {};
  Map<String, String> _HVAToNumbers = {};

  String _LETTERS_NUMBER_SWITCH = '';

  if (codeHVA1950) {
    _LETTERS_NUMBER_SWITCH = _LETTERS_NUMBER_SWITCH_HVA1950;
    _HVAToAZ = _HVA1950ToAZ;
    _HVAToAZ.addAll(_HVA1950ToCode);
    _HVAToNumbers = _HVA1950ToNumbers;
  } else {
    _LETTERS_NUMBER_SWITCH = _LETTERS_NUMBER_SWITCH_HVA1970;
    _HVAToAZ = _HVA1970ToAZ;
    _HVAToNumbers = _HVA1970ToNumbers;
    _HVAToAZ.addAll(_HVA1970ToCode);
  }

  var isLetterMode = true;
  String out = '';

  int i = 0;
  while (i < input.length) {
    String? character;
    var code = input.substring(i, i + 1);

    if (i + 1 < input.length) {
      code = input.substring(i, i + 2);
      if (code == _LETTERS_NUMBER_SWITCH) {
        isLetterMode = !isLetterMode;
        i += 2;
        continue;
      } else {
        if (isLetterMode) {
          character = _HVAToAZ[code];
          if (character != null) {
            out += character;
            i += 2;
            continue;
          } else {
            code = input.substring(i, i + 1);
            character = _HVAToAZ[code];
            if (character != null) {
              out += character;
              i += 1;
              continue;
            }
          }
        } else {
          code = input.substring(i, i + 3);
          character = _HVAToNumbers[code];
          if (character != null) {
            out += character;
            i += 3;
            continue;
          } else {
            out += UNKNOWN_ELEMENT;
            i += 2;
            continue;
          }
        }
      }
    } else {
      out += UNKNOWN_ELEMENT;
      i++;
      continue;
    }
  }

  return out.trim();
}

String decryptHVA(String input, String? keyOneTimePad, bool codeHVA1950) {
  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.isEmpty) return '';

  if (keyOneTimePad != null && keyOneTimePad.isNotEmpty) {
    input = subtractOneTimePad(input, keyOneTimePad);
  }

  return _decodeHVA(input, codeHVA1950);
}
