part of 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

OutputConvertToNumber _decodeMinion(String element) {
  if (_isMinion(element)) {
    int number = 0;
    element.replaceAll('hana', '1').replaceAll('dul', '2').replaceAll('sae', '3').split('').forEach((element) {
      number = number + int.parse(element);
    });
    String decodedMinion = number.toString();
    return OutputConvertToNumber(
        number: int.parse(decodedMinion), numbersystem: '', title: '', error: '');
  } else {
    return OutputConvertToNumber(
        number: 0, numbersystem: '', title: '', error: 'numeralwords_converter_error_minion');
  }
}

OutputConvertToNumeralWord _encodeMinion(int currentNumber) {
  String numeralWord = '';
  if (currentNumber < 1) {
    return OutputConvertToNumeralWord(numeralWord: '', targetNumberSystem: '', title: '', errorMessage: '');
  }
  List<String> digits = [];
  numeralWord = '';
  while (currentNumber >= 3) {
    currentNumber = currentNumber - 3;
    digits.add('3');
  }
  while (currentNumber >= 2) {
    currentNumber = currentNumber - 2;
    digits.add('2');
  }
  while (currentNumber >= 1) {
    currentNumber = currentNumber - 1;
    digits.add('1');
  }
  numeralWord = digits.join('').replaceAll('3', 'SAE').replaceAll('2', 'DUL').replaceAll('1', 'HANA');
  return OutputConvertToNumeralWord(numeralWord: numeralWord, targetNumberSystem: '', title: '', errorMessage: '');
}

bool _isMinion(String element) {
  if (element != '') {
    return (element.replaceAll('hana', '').replaceAll('dul', '').replaceAll('sae', '').isEmpty);
  } else {
    return false;
  }
}