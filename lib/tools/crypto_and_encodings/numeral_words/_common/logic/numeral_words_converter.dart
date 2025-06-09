part of 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

OutputConvertToNumber decodeNumeralWordToNumber(NumeralWordsLanguage _currentLanguage, String currentDecodeInput) {
  if (currentDecodeInput.isEmpty) return OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: '');

  switch (_currentLanguage) {
    case NumeralWordsLanguage.ROU:
      return _decodeROU(currentDecodeInput);
    case NumeralWordsLanguage.NAVI:
      return _decodeNavi(currentDecodeInput);
    case NumeralWordsLanguage.SHA:
      return _decodeShadoks(currentDecodeInput);
    case NumeralWordsLanguage.MIN:
      return _decodeMinion(currentDecodeInput);
    case NumeralWordsLanguage.KLI:
      return _decodeKlingon(currentDecodeInput);
    case NumeralWordsLanguage.MAO:
      return _decodeMaori(currentDecodeInput);
    default:
      return OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: '');
  }
}

OutputConvertToNumeralWord encodeNumberToNumeralWord(NumeralWordsLanguage _currentLanguage, int currentNumber) {
  switch (_currentLanguage) {
    case NumeralWordsLanguage.NAVI:
      return _encodeNavi(currentNumber);
    case NumeralWordsLanguage.SHA:
      return _encodeShadok(currentNumber);
    case NumeralWordsLanguage.MIN:
      return _encodeMinion(currentNumber);
    case NumeralWordsLanguage.KLI:
      return _encodeKlingon(currentNumber);
    case NumeralWordsLanguage.ROU:
      return _encodeROU(currentNumber);
    case NumeralWordsLanguage.MAO:
      return _encodeMaori(currentNumber);
    default:
      return OutputConvertToNumeralWord(numeralWord: '', targetNumberSystem: '', title: '', errorMessage: '');
  }
}

bool _isNumeral(String input) {
  return (int.tryParse(input) != null);
}