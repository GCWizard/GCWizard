import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/science_and_technology/numeral_bases/logic/numeral_bases.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/string_utils.dart';

part 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words_classes.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words_converter.dart';
part 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words_maps.dart';

List<NumeralWordsDecodeOutput> decodeNumeralwords(
    {required String input, required NumeralWordsLanguage language, bool decodeModeWholeWords = false}) {
  RegExp expr;
  List<NumeralWordsDecodeOutput> output = [];

  if (input.isEmpty) {
    output.add(NumeralWordsDecodeOutput('', '', 'numeralwords_language_empty'));
    return output;
  }

  input = _normalizeNumeralWord(input, language).toLowerCase();

  _languageList = {NumeralWordsLanguage.NUM: 'numeralwords_language_num'};
  _languageList!.addAll(NUMERALWORDS_LANGUAGES);

  bool _alreadyFound = false;
  List<String> decodeText;

  if (decodeModeWholeWords) {
    // search only whole words

    String? helpText;
    String? helpText1;
    String inputToDecode;

    // simplify input
    input = input.replaceAll(RegExp(r'\s+'), ' ');

    // trim korean
    input = input
        .replaceAll('hah - nah', 'hah-nah')
        .replaceAll('dah suht', 'dahsuht')
        .replaceAll('yuh suht', 'yuhsuht')
        .replaceAll('eel gob', 'eelgob')
        .replaceAll('yuh duh', 'yuhduh')
        .replaceAll('ah hob', 'ahhob')
        .replaceAll('-sip', 'sip')
        .replaceAll('sip-', 'sip')
        .replaceAll('yeol-', 'yeol');

    // trim Klingon
    // identify west
    expr = RegExp(r"(ting 'ev|'ev ting)");
    if (expr.hasMatch(input)) {
      helpText = input.replaceAllMapped(expr, (Match m) {
        return m.group(0)!.replaceAll(' ', '');
      });
      input = helpText;
    }

    // identify complex klingon numbers
    //expr = RegExp(r"((wa'|cha'|wej|los|vagh|jav|soch|chorgh|hut)( |-)?(bip|netlh|sad|sanid|vatlh|mah))+( |-)?(wa'|cha'|wej|los|vagh|jav|soch|chorgh|hut)?\s");
    expr = RegExp(
        r"((wa'|cha'|wej|los|vagh|jav|soch|chorgh|hut)(bip|netlh|sad|sanid|vatlh|mah)[ -]?)+(wa'|cha'|wej|los|vagh|jav|soch|chorgh|hut)?(\s|$)");
    if (expr.hasMatch(input)) {
      helpText = input.replaceAllMapped(expr, (Match m) {
        return _complexMultipleKlingon(m.group(0)!);
      });
      input = helpText;
    }

    // identify single digits - change "-" to " "
    expr =
        RegExp(r"(pagh|wa'|cha'|wej|los|vagh|jav|soch|chorgh|hut)(-(pagh|wa'|cha'|wej|los|vagh|jav|soch|chorgh|hut))+");
    if (expr.hasMatch(input)) {
      helpText = input.replaceAllMapped(expr, (Match m) {
        return m.group(0)!.replaceAll('-', ' ');
      });
      input = helpText;
    }

    // trim english: identify correct numeral words and remove spaces
    expr = RegExp(
        '(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen)[ ](hundred|thousand)');
    if (expr.hasMatch(input)) {
      helpText1 = input.replaceAllMapped(expr, (Match m) {
        return m.group(0)!.replaceAll(' ', '');
      });
    } else {
      helpText1 = input;
    }

    if (helpText1.startsWith('a hundred')) {
      helpText = helpText1.replaceFirst('a hundred', 'onehundred');
    } else if (helpText1.startsWith('a thousand')) {
      helpText = helpText1.replaceFirst('a thousand', ' a thousand');
    } else {
      helpText = helpText1;
    }

    // trim esperanto : identify correct numeral words and remove spaces
    expr = RegExp('cent( )(unu|du|tri|kvar|kvin|ses|sep|ok|nau|dek)');
    if (expr.hasMatch(helpText)) {
      helpText1 = helpText.replaceAllMapped(expr, (Match m) {
        return m.group(0)!.replaceAll(' ', '');
      });
    } else {
      helpText1 = helpText;
    }

    expr = RegExp('dek( )(unu|du|tri|kvar|kvin|ses|sep|ok|nau)');
    if (expr.hasMatch(helpText1)) {
      helpText = helpText1.replaceAllMapped(expr, (Match m) {
        return m.group(0)!.replaceAll(' ', '');
      });
    } else {
      helpText = helpText1;
    }

    // trim solresol : identify correct numeral words and remove spaces
    // 1st trim: SOL_farere => SOLfarere_
    expr = RegExp(r'(redodo|remimi|refafa|resolsol|relala|resisi|mimido|mimire|mimifa) farere');
    if (expr.hasMatch(helpText)) {
      helpText1 = helpText.replaceAllMapped(expr, (Match m) {
        return (m.group(0) != ' ') ? m.group(0)!.replaceAll(' ', '') : '';
      });
    } else {
      helpText1 = helpText;
    }

    // 2nd trim:
    expr = RegExp(
        r'(fafare|fafami|fafasol|fafala|fafasi|fadodo) (mimisol|mimila|mimisi|midodo|mirere|mifafa|misolsol|milala|misisi|fafado|redodo|remimi|refafa|resolsol|relala|resisi|mimido|mimire|mimifa)');
    if (expr.hasMatch(helpText1)) {
      helpText = helpText1.replaceAllMapped(expr, (Match m) {
        return (m.group(0) != ' ') ? m.group(0)!.replaceAll(' ', '') : '';
      });
    } else {
      helpText = helpText1;
    }

    expr = RegExp(r'mimisol (redodo|remimi|refafa|resolsol|relala|resisi|mimido|mimire|mimifa)');
    if (expr.hasMatch(helpText)) {
      helpText1 = helpText.replaceAllMapped(expr, (Match m) {
        return (m.group(0) != ' ') ? m.group(0)!.replaceAll(' ', '') : '';
      });
    } else {
      helpText1 = helpText;
    }

    // 3rd trim: SOLfarere_SOL => SOLfarereSOL
    expr = RegExp(
        r'(redodo|remimi|refafa|resolsol|relala|resisi|mimido|mimire|mimifa)farere (fafare|fafami|fafasol|fafala|fafasi|fadodo|mimisol|mimila|mimisi|midodo|mirere|mifafa|misolsol|milala|misisi|fafado|redodo|remimi|refafa|resolsol|relala|resisi|mimido|mimire|mimifa)');
    if (expr.hasMatch(helpText1)) {
      helpText = helpText1.replaceAllMapped(expr, (Match m) {
        return (m.group(0) != ' ') ? m.group(0)!.replaceAll(' ', '') : '';
      });
    } else {
      helpText = helpText1;
    }

    //4th trim: famimi_SOL => SOLfamimiSOL
    expr = RegExp(
        r'famimi (farere|fafare|fafami|fafasol|fafala|fafasi|fadodo|mimisol|mimila|mimisi|midodo|mirere|mifafa|misolsol|milala|misisi|fafado|redodo|remimi|refafa|resolsol|relala|resisi|mimido|mimire|mimifa)');
    if (expr.hasMatch(helpText)) {
      helpText1 = helpText.replaceAllMapped(expr, (Match m) {
        return (m.group(0) != ' ') ? m.group(0)!.replaceAll(' ', '') : '';
      });
    } else {
      helpText1 = helpText;
    }

    // 5th trim: SOL_famimi => SOLfamimi
    expr = RegExp(
        r'(farere|fafare|fafami|fafasol|fafala|fafasi|fadodo|mimisol|mimila|mimisi|midodo|mirere|mifafa|misolsol|milala|misisi|fafado|redodo|remimi|refafa|resolsol|relala|resisi|mimido|mimire|mimifa) famimi');
    if (expr.hasMatch(helpText1)) {
      helpText = helpText1.replaceAllMapped(expr, (Match m) {
        return (m.group(0) != ' ') ? m.group(0)!.replaceAll(' ', '') : '';
      });
    } else {
      helpText = helpText1;
    }

    // trim esperanto: identify correct numeral words and remove spaces
    expr = RegExp(
        r'(.*unu|.*du|.*tri|.*kvar|.*kvin|.*ses|.*sep|.*ok|.*nau)( )mil(( )(unu.*|du.*|tri.*|kvar.*|kvin.*|ses.*|spe.*|ok.*|nau.*))?');
    if (expr.hasMatch(helpText)) {
      helpText1 = helpText.replaceAllMapped(expr, (Match m) {
        return m.group(0)!.replaceAll(' ', '');
      });
    } else {
      helpText1 = helpText;
    }

    // trim german
    inputToDecode = helpText1
        .replaceAll('zehnten', 'zehn')
        .replaceAll('zehnter', 'zehn')
        .replaceAll('zehnte', 'zehn')
        .replaceAll('zigsten', 'zig')
        .replaceAll('zigster', 'zig')
        .replaceAll('zigste', 'zig')
        .replaceAll('hundertsten', 'hundert')
        .replaceAll('hundertster', 'hundert')
        .replaceAll('hundertste', 'hundert')
        .replaceAll('tausendsten', 'tausend')
        .replaceAll('tausendster', 'tausend')
        .replaceAll('tausendste', 'tausend')
        .replaceAll(' a hundred', ' onehundred')
        .replaceAll(' hundred ', 'hundred ')
        .replaceAll('hundred and ', 'hundred')
        .replaceAll(' a thousand', ' onethousand')
        .replaceAll(' thousand', 'thousand')
        .replaceAll('thousand and ', 'thousand')
        .replaceAll('einhundert', 'einshundert')
        .replaceAll('eintausend', 'einstausend')
        .replaceAll('hundertund', 'hundert')
        .replaceAll('tausendund', 'tausend')
        .replaceAll('mil ', 'mil');

    // build map to identify numeral words
    var searchLanguages = <NumeralWordsLanguage, Map<String, String>>{};
    if (language == NumeralWordsLanguage.ALL) {
      // search element in all languages
      NUMERAL_WORDS.forEach((language, value) {
        // key: language  value: map
        var sKey = language;
        var sValue = <String, String>{};
        value.forEach((key, value) {
          sValue[_normalizeNumeralWord(key.toLowerCase(), language)] = value;
        });
        searchLanguages[sKey] = sValue;
      });
    } else {
      // search only in one language
      var sValue = <String, String>{};
      NUMERAL_WORDS[language]!.forEach((key, value) {
        sValue[_normalizeNumeralWord(key.toLowerCase(), language)] = value;
      });
      searchLanguages[language] = sValue;
    }

    // check degree ° and dot .
    inputToDecode = inputToDecode.replaceAll('°', ' ° ').replaceAll('.', ' . ').replaceAll('  ', ' ');

    // start decoding
    decodeText = inputToDecode.split(RegExp(r'[ ]'));
    for (var element in decodeText) {
      _alreadyFound = false;
      if (element != '') {
        if (element == '°') {
          output.add(NumeralWordsDecodeOutput(element, element, ''));
        } else if (element == '.') {
          output.add(NumeralWordsDecodeOutput(element, element, ''));
        } else if (_isShadoks(element) &&
            (language == NumeralWordsLanguage.ALL || language == NumeralWordsLanguage.SHA)) {
          output.add(NumeralWordsDecodeOutput(
              _decodeShadoks(element), element, _languageList?[NumeralWordsLanguage.SHA] ?? ''));
        } else if (_isMinion(element) &&
            (language == NumeralWordsLanguage.ALL || language == NumeralWordsLanguage.MIN)) {
          output.add(NumeralWordsDecodeOutput(
              _decodeMinion(element), element, _languageList?[NumeralWordsLanguage.MIN] ?? ''));
        } else if (_isKlingon(element) &&
            (language == NumeralWordsLanguage.ALL || language == NumeralWordsLanguage.KLI)) {
          output.add(NumeralWordsDecodeOutput(_decodeKlingon(element), element.replaceAll('€', ' ').trim(),
              _languageList?[NumeralWordsLanguage.KLI] ?? ''));
        } else if (_isNavi(element) &&
            (language == NumeralWordsLanguage.ALL || language == NumeralWordsLanguage.NAVI)) {
          output.add(
              NumeralWordsDecodeOutput(_decodeNavi(element), element, _languageList?[NumeralWordsLanguage.NAVI] ?? ''));
        } else if (_isNumeral(element)) {
          // checks - if is a number/digit
          output.add(NumeralWordsDecodeOutput(element, element, _languageList?[NumeralWordsLanguage.NUM] ?? ''));
        } else {
          _alreadyFound = false;

          searchLanguages.forEach((correctNumeralWord, value) {
            var result =
                _isNumeralWordTable(element, correctNumeralWord, value); // checks - if element is part of a map
            if (result.state) {
              if (!_alreadyFound) {
                output.add(NumeralWordsDecodeOutput(result.output, element, _languageList?[correctNumeralWord] ?? ''));
                _alreadyFound = true;
              } else {
                output.add(NumeralWordsDecodeOutput('', '', _languageList?[correctNumeralWord] ?? ''));
              }
            } else {
              result = _isNumeralWord(element, correctNumeralWord, value); // checks - if is a numeral word
              if (result.state) {
                output.add(NumeralWordsDecodeOutput(result.output, element, _languageList?[correctNumeralWord] ?? ''));
              }
            }
          }); //forEach searchLanguage
        }
      }
    }
    //for each element to decode
    if (output.isEmpty) {
      output.add(NumeralWordsDecodeOutput('', '', 'numeralwords_language_empty'));
    }
    return output;
  } else {
    // entire parts - search parts of words: weight => eight => 8
    input = input
        .replaceAll(RegExp(r'[\s]'), '')
        .replaceAll('^', '')
        .replaceAll('°', '')
        .replaceAll('!', '')
        .replaceAll('"', '')
        .replaceAll('§', '')
        .replaceAll('\$', '')
        .replaceAll('%', '')
        .replaceAll('&', '')
        .replaceAll('/', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('=', '')
        .replaceAll('?', '')
        .replaceAll('´', '')
        .replaceAll('`', '')
        .replaceAll('{', '')
        .replaceAll('}', '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('\\', '')
        .replaceAll('>', '')
        .replaceAll('<', '')
        .replaceAll('|', '')
        .replaceAll(';', '')
        .replaceAll(',', '')
        .replaceAll('.', '')
        .replaceAll(':', '')
        .replaceAll('-', '')
        .replaceAll('_', '')
        .replaceAll('#', '')
        .replaceAll("'", '')
        .replaceAll('+', '')
        .replaceAll('*', '')
        .replaceAll('~', '')
        .replaceAll('µ', '')
        .replaceAll('@', '')
        .replaceAll('€', '');

    for (int i = 0; i < input.length; i++) {
      String checkWord = input.substring(i);
      if (language == NumeralWordsLanguage.ALL) {
        // search entire parts in all languages - Standard for Numeral Words Language search
        _alreadyFound = false;
        int oldValueInt = 0;
        String oldValueStr = '';

        NUMERAL_WORDS.forEach((language, languageMap) {
          // forEach language
          NumeralWordsLanguage _language = language;
          String oldKeyStr = '';

          languageMap.forEach((correctNumeralWord, value) {
            // check language map

            if (_language == NumeralWordsLanguage.KLI) {
              correctNumeralWord = correctNumeralWord.replaceAll('-', '').replaceAll(' ', '').replaceAll("'", '');
            }
            if (checkWord.startsWith(_normalizeNumeralWord(correctNumeralWord, _language))) {
              if (!_alreadyFound) {
                _alreadyFound = true;
                oldKeyStr = correctNumeralWord;

                if (int.tryParse(value) == null) {
                  oldValueStr = value;
                } else {
                  oldValueInt = int.parse(value);
                }
                output.add(NumeralWordsDecodeOutput(value, _normalizeNumeralWord(correctNumeralWord, _language),
                    NUMERALWORDS_LANGUAGES[_language] ?? ''));
              } else {
                if (oldKeyStr != _normalizeNumeralWord(correctNumeralWord, _language)) {
                  if (int.tryParse(value) == null) {
                    if (oldValueStr == value) {
                      output.add(NumeralWordsDecodeOutput('', _normalizeNumeralWord(correctNumeralWord, _language),
                          NUMERALWORDS_LANGUAGES[_language] ?? ''));
                    } else {
                      output.add(NumeralWordsDecodeOutput(value, _normalizeNumeralWord(correctNumeralWord, _language),
                          NUMERALWORDS_LANGUAGES[_language] ?? ''));
                    }
                  } else if (oldValueInt == int.parse(value)) {
                    output.add(NumeralWordsDecodeOutput('', _normalizeNumeralWord(correctNumeralWord, _language),
                        NUMERALWORDS_LANGUAGES[_language] ?? ''));
                  } else {
                    output.add(NumeralWordsDecodeOutput(value, _normalizeNumeralWord(correctNumeralWord, _language),
                        NUMERALWORDS_LANGUAGES[_language] ?? ''));
                  }
                }
              }
            }
          });
        });
      } else {
        // search entire parts for specific language
        NUMERAL_WORDS[language]!.forEach((correctNumeralWord, value) {
          if (checkWord.startsWith(_normalizeNumeralWord(correctNumeralWord, language))) {
            output.add(NumeralWordsDecodeOutput(
                value, _normalizeNumeralWord(correctNumeralWord, language), NUMERALWORDS_LANGUAGES[language] ?? ''));
          }
        });
      } // else
    } // for element

    if (output.isEmpty) {
      output.add(NumeralWordsDecodeOutput('', '', 'numeralwords_language_empty'));
    }
    return output;
  }
}

String _normalizeNumeralWord(String numeralWord, NumeralWordsLanguage language) {
  if (language == NumeralWordsLanguage.DEU ||
      language == NumeralWordsLanguage.DNK ||
      language == NumeralWordsLanguage.FIN ||
      language == NumeralWordsLanguage.NOR ||
      language == NumeralWordsLanguage.SVK ||
      language == NumeralWordsLanguage.SWE ||
      language == NumeralWordsLanguage.TUR ||
      language == NumeralWordsLanguage.UNG) {
    return (numeralWord);
  }
  return removeAccents(numeralWord);
}

NumeralWordsOutput _isNumeralWord(String input, NumeralWordsLanguage language, Map<String, String> decodingTable) {
  bool state = false;
  String output = '';
  String pattern = '';
  int numberBefore = 0;
  int numberAfter = 0;
  NumeralWordsOutput resultBefore;
  NumeralWordsOutput resultAfter;
  switch (language) {
    case NumeralWordsLanguage.DEU:
    case NumeralWordsLanguage.ENG:
    case NumeralWordsLanguage.VOL:
    case NumeralWordsLanguage.EPO:
    case NumeralWordsLanguage.SOL:
      switch (language) {
        case NumeralWordsLanguage.DEU:
          pattern = 'tausend';
          break;
        case NumeralWordsLanguage.SOL:
          pattern = 'famimi';
          break;
        case NumeralWordsLanguage.ENG:
          pattern = 'thousand';
          break;
        case NumeralWordsLanguage.VOL:
        case NumeralWordsLanguage.EPO:
          pattern = 'mil';
          break;
        default:
      }
      if (input.contains(pattern)) {
        // numeral word contains 1000
        List<String> decode = input.split(pattern);
        if (decode.length == 2) {
          if (decode[0].isEmpty) {
            resultBefore = NumeralWordsOutput(true, '1', _languageList?[language] ?? '');
          } else {
            resultBefore = _isNumeralWordBelow1000(decode[0], language, decodingTable);
          }

          if (decode[1].isEmpty) {
            resultAfter = NumeralWordsOutput(true, '0', _languageList?[language] ?? '');
          } else {
            resultAfter = _isNumeralWordBelow1000(decode[1], language, decodingTable);
          }

          if (resultBefore.state && resultAfter.state) {
            state = true;
            numberBefore = int.parse(resultBefore.output) * 1000;
            numberAfter = int.parse(resultAfter.output);
            output = (numberBefore + numberAfter).toString();
          }
        } else {
          resultBefore = _isNumeralWordBelow1000(decode[0], language, decodingTable);
          if (resultBefore.state) {
            state = true;
            output = resultBefore.output;
          }
        }
      } else {
        resultBefore = _isNumeralWordBelow1000(input, language, decodingTable);
        if (resultBefore.state) {
          state = true;
          output = resultBefore.output;
        }
      }
      break;
    default:
  }
  return NumeralWordsOutput(state, output, _languageList?[language] ?? '');
}

NumeralWordsOutput _isNumeralWord10(String input, NumeralWordsLanguage language, Map<String, String> decodingTable) {
  bool state = false;
  String output = '';
  int orderOne = 0;
  int orderTen = 0;
  RegExp expr;
  if (language == NumeralWordsLanguage.DEU) {
    var pattern =
        '(ein|zwei|drei|vier|fuenf|fünf|sechs|sieben|acht|neun)(und)(zwanzig|dreissig|dreißig|vierzig|fuenfzig|fünfzig|sechzig|siebzig|achtzig|neunzig)';
    expr = RegExp(pattern);
    if (expr.hasMatch(input)) {
      state = true;
      var matches = expr.firstMatch(input)!;
      if (matches.group(1) == 'ein') {
        orderOne = 1;
      } else {
        decodingTable[matches.group(1)] == null ? orderOne = 0 : orderOne = int.parse(decodingTable[matches.group(1)]!);
      }
      decodingTable[matches.group(3)] == null ? orderTen = 0 : orderTen = int.parse(decodingTable[matches.group(3)]!);
      //orderTen = int.parse(decodingTable[matches.group(3)] ?? '');
      output = (orderTen + orderOne).toString();
    }
  } else if (language == NumeralWordsLanguage.ENG) {
    expr = RegExp(
        r'(twenty|thirty|fourty|fifty|sixty|seventy|eighty|ninety)[-]?(one|two|three|four|five|six|seven|eight|nine)');
    if (expr.hasMatch(input)) {
      state = true;
      var matches = expr.firstMatch(input)!;
      orderOne = int.parse(decodingTable[matches.group(2)] ?? '');
      orderTen = int.parse(decodingTable[matches.group(1)] ?? '');
      output = (orderTen + orderOne).toString();
    }
  } else if (language == NumeralWordsLanguage.VOL) {
    RegExp expr = RegExp('(bal|tel|kil|fol|lul|mael|vel|joel|zuel)?(deg)(bal|tel|kil|fol|lul|mael|vel|joel|zuel)?');
    if (expr.hasMatch(input)) {
      state = true;
      var matches = expr.firstMatch(input)!;
      if (matches.group(1) != null) orderTen = int.parse(decodingTable[matches.group(1)] ?? '');
      if (matches.group(3) != null) orderOne = int.parse(decodingTable[matches.group(3)] ?? '');
      output = (orderTen * 10 + orderOne).toString();
    }
  } else if (language == NumeralWordsLanguage.EPO) {
    expr = RegExp('(unu|du|tri|kvar|kvin|ses|sep|ok|nau)?(dek)(unu|du|tri|kvar|kvin|ses|spe|ok|nau)?');
    if (expr.hasMatch(input)) {
      state = true;
      var matches = expr.firstMatch(input)!;
      if (matches.group(1) != null) orderTen = int.parse(decodingTable[matches.group(1)] ?? '');
      if (matches.group(3) != null) orderOne = int.parse(decodingTable[matches.group(3)] ?? '');
      output = (orderTen * 10 + orderOne).toString();
    }
  } else if (language == NumeralWordsLanguage.SOL) {
    expr = RegExp(
        r'^(mimisol|fafare|fafami|fafasol|fafala|fafasi|fafasimimisol|fadodo|fadodomimisol)?(redodo|remimi|refafa|resolsol|relala|resisi|mimido|mimire|mimifa|mimila|mimisi|midodo|mirere|mifafa|misolsol|milala|misisi|fafado)$');
    if (expr.hasMatch(input)) {
      state = true;
      var matches = expr.firstMatch(input)!;
      if (matches.group(1) != null) {
        if (matches.group(1) == 'fafasimimisol' || matches.group(1) == 'fadodomimisol') {
          orderTen = int.parse(decodingTable[matches.group(1)!.replaceAll('mimisol', ' mimisol')] ?? '');
        } else {
          orderTen = int.parse(decodingTable[matches.group(1)] ?? '');
        }
      }
      if (matches.group(2) != null) orderOne = int.parse(decodingTable[matches.group(2)] ?? '');
      output = (orderTen + orderOne).toString();
    }
  }

  return NumeralWordsOutput(state, output, _languageList?[language]);
}

NumeralWordsOutput _isNumeralWordBelow100(
    String input, NumeralWordsLanguage language, Map<String, String> decodingTable) {
  bool state = false;
  String output = '';
  NumeralWordsOutput result;
  result = _isNumeralWordTable(input, language, decodingTable);
  if (result.state) {
    state = true;
    output = result.output;
  } else {
    result = _isNumeralWord10(input, language, decodingTable);
    if (result.state) {
      state = true;
      output = result.output;
    }
  }
  return NumeralWordsOutput(state, output, _languageList?[language]);
}

NumeralWordsOutput _isNumeralWordBelow1000(
    String input, NumeralWordsLanguage language, Map<String, String> decodingTable) {
  bool state = false;
  String output = '';
  String pattern = '';
  int numberBefore = 0;
  int numberAfter = 0;
  List<String> decode = <String>[];
  NumeralWordsOutput resultBefore;
  NumeralWordsOutput resultAfter;
  switch (language) {
    case NumeralWordsLanguage.DEU:
    case NumeralWordsLanguage.ENG:
    case NumeralWordsLanguage.VOL:
    case NumeralWordsLanguage.EPO:
    case NumeralWordsLanguage.SOL:
      switch (language) {
        case NumeralWordsLanguage.DEU:
          pattern = 'hundert';
          break;
        case NumeralWordsLanguage.ENG:
          pattern = 'hundred';
          break;
        case NumeralWordsLanguage.VOL:
          pattern = 'tum';
          break;
        case NumeralWordsLanguage.EPO:
          pattern = 'cent';
          break;
        case NumeralWordsLanguage.SOL:
          pattern = 'farere';
          break;
        default:
      }
      if (input.contains(pattern)) {
        // numeral word contains 100
        if (language == NumeralWordsLanguage.SOL) {
          if (decodingTable[input.split(pattern)[0]] != null) {
            decode = input.split(pattern);
          } else {
            decode.add(input);
          }
        } else {
          decode = input.split(pattern);
        }
        if (decode.length == 2) {
          if (decode[0].isEmpty) {
            resultBefore = NumeralWordsOutput(true, '1', _languageList?[language]);
          } else {
            resultBefore = _isNumeralWordBelow100(decode[0], language, decodingTable);
          }

          if (decode[1].isEmpty) {
            resultAfter = NumeralWordsOutput(true, '0', _languageList?[language]);
          } else {
            resultAfter = _isNumeralWordBelow100(decode[1], language, decodingTable);
          }

          if (resultBefore.state && resultAfter.state) {
            state = true;
            numberBefore = int.parse(resultBefore.output) * 100;
            numberAfter = int.parse(resultAfter.output);
            output = (numberBefore + numberAfter).toString();
          }
        } else {
          resultBefore = _isNumeralWordBelow100(decode[0], language, decodingTable);
          if (resultBefore.state) {
            state = true;
            output = resultBefore.output;
          }
        }
      } else {
        resultBefore = _isNumeralWordBelow100(input, language, decodingTable);
        if (resultBefore.state) {
          state = true;
          output = resultBefore.output;
        }
      }
      break;
    default:
  }
  return NumeralWordsOutput(state, output, _languageList?[language]);
}

NumeralWordsOutput _isNumeralWordTable(String input, NumeralWordsLanguage language, Map<String, String> decodingTable) {
  bool state = false;
  String output = '';
  String checkWord = '';
  if (language == NumeralWordsLanguage.EPO) {
    if (input.contains('dek')) {
      checkWord = 'dek ' + input.split('dek').join('');
    } else {
      checkWord = input;
    }
  } else {
    checkWord = input;
  }
  decodingTable.forEach((correctNumeralWord, value) {
    if (_normalizeNumeralWord(correctNumeralWord, language) == checkWord) {
      state = true;
      output = value;
    }
  });
  return NumeralWordsOutput(state, output, _languageList?[language]);
}

Map<String, String> _normalize(Map<String, String> table, NumeralWordsLanguage language) {
  Map<String, String> result = {};
  table.forEach((key, value) {
    result[_normalizeNumeralWord(key, language)] = _normalizeNumeralWord(value, language);
  });
  return result;
}
