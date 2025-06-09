part of 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

OutputConvertToNumeralWord _encodeMaori(int currentNumber) {
  List<String> numeralWord = [];
  List<String> digits = currentNumber.toString().split('');
  int digit = 0;
  int tenth = 0;
  Map<String, String> numWords = switchMapKeyValue(_MAOWordToNum);

  if (numWords[currentNumber.toString()] != null) {
    numeralWord.add(numWords[currentNumber.toString()]!);
  } else {
    for (int i = digits.length; i > 0; i--) {
      digit = int.parse(digits[digits.length - i]);
      tenth = pow(10, i - 1).toInt();
      if (digit != 0) {
        if (tenth == 1000) {
          if (digit == 1) {
            numeralWord.add('kotahi mano');
          } else {
            numeralWord.add(numWords[digit.toString()]! + ' ' + 'mano');
          }
        } else if (tenth == 10) {
          int digit0 = int.parse(digits[digits.length - 1]);
          if (digit == 1) {
            numeralWord.add(numWords[tenth.toString()]! + ' ' + 'ma' + ' ' + numWords[digit0.toString()]!);
          } else {
            numeralWord.add(numWords[digit.toString()]! + ' ' + numWords[tenth.toString()]! + ' ' + 'ma' + ' ' + numWords[digit0.toString()]!);
          }
          break;
        } else {
          if (numWords[(digit * tenth).toString()] != null) {
            numeralWord.add(numWords[(digit * tenth).toString()]!);
          } else {
            numeralWord.add(numWords[digit.toString()]! + ' ' + numWords[tenth.toString()]!);
          }
        }
      }

    }
  }

  return OutputConvertToNumeralWord(
      numeralWord: numeralWord.join(' '),
      targetNumberSystem: '',
      title: '',
      errorMessage: '');
}

OutputConvertToNumber _decodeMaori(String element) {
  return OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: '');
}

bool _isMaori(String element) {
  if (element != '') {
    element = element
        .replaceAll(' ', '')
        .replaceAll('kore', '')
        .replaceAll('tahi', '')
        .replaceAll('rua', '')
        .replaceAll('toru', '')
        .replaceAll('wha', '')
        .replaceAll('rima', '')
        .replaceAll('ono', '')
        .replaceAll('whitu', '')
        .replaceAll('waru', '')
        .replaceAll('iwa', '')
        .replaceAll('tekau', '')
        .replaceAll('kotahi', '')
        .replaceAll('rau', '')
        .replaceAll('mano', '')
        .replaceAll('miriona', '');

    return (element.isEmpty);
  }
  return false;
}