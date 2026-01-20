part of 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

OutputConvertToNumber _decodeShadoks(String element) {
  if (_isShadoks(element)) {
    String decodedShadoks = convertBase(
        element.replaceAll('ga', '0').replaceAll('bu', '1').replaceAll('zo', '2').replaceAll('meu', '3'), 4, 10);
       return OutputConvertToNumber(
           number: int.parse(decodedShadoks),
           numbersystem: convertBase(decodedShadoks, 10, 4),
           title: 'common_numeralbase_quaternary',
           error: '');
     } else {
       return OutputConvertToNumber(
           number: 0, numbersystem: '', title: '', error: 'numeralwords_converter_error_shadoks');
     }
}

OutputConvertToNumeralWord _encodeShadok(int currentNumber) {
  String numeralWord = '';
  numeralWord = convertBase(currentNumber.toString(), 10, 4)
      .toString()
      .replaceAll('0', 'GA')
      .replaceAll('1', 'BU')
      .replaceAll('2', 'ZO')
      .replaceAll('3', 'MEU');
  return OutputConvertToNumeralWord(
      numeralWord: numeralWord,
      targetNumberSystem: convertBase(currentNumber.toString(), 10, 4),
      title: 'common_numeralbase_quaternary',
      errorMessage: '');
}

bool _isShadoks(String element) {
  if (element != '') {
    if (element.replaceAll('ga', '').replaceAll('bu', '').replaceAll('zo', '').replaceAll('meu', '') == '') {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

