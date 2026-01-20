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
  // kotahi mano iwa rau waru tekau ma rua
  element = element.toLowerCase().replaceAll(' ', '').replaceAll('.', '').replaceAll(',', '');
  List<String> maoriElements = [];
  int number = 0;
  int detailedNumber = 0;
  if (_isMaori(element)) {
    if (element.contains('piriona')) {
      maoriElements = element.split('piriona');
      detailedNumber = _getMaoriNumber(maoriElements[0]);
      element = maoriElements[1];
      number = number + 1000000000 * detailedNumber;
    }

    if (element.contains('miriona')) {
      maoriElements = element.split('miriona');
      detailedNumber = _getMaoriNumber(maoriElements[0]);
      element = maoriElements[1];
      number = number + 1000000 * detailedNumber;
    }

    if (element.contains('mano')) {
      maoriElements = element.split('mano');
      detailedNumber = _getMaoriNumber(maoriElements[0]);
      element = maoriElements[1].trim();
      number = number + 1000 * detailedNumber;
    }
    number = number + _getMaoriNumber(element);
    return OutputConvertToNumber(number: number, numbersystem: '', title: '', error: '');
  } else {
    return OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: '');
  }
}

int _getMaoriNumber(String element){
  if (_isMaori(element)) {
    int hundred = 0;
    int ten = 0;
    int one = 0;
    List<String> maoriNumber = [];

    if (element.contains('rau')) {
      maoriNumber = element.split('rau');
      if (maoriNumber[0].isNotEmpty) {
        if (int.tryParse(_MAOWordToNum[maoriNumber[0]]!) != null) {
          hundred = int.parse(_MAOWordToNum[maoriNumber[0]]!);
          maoriNumber[1].isNotEmpty ? element = maoriNumber[1] : element = '';
        } else {
          hundred = 0;
        }
      } else {
        hundred = 1;
      }
    }
    if (element.contains('tekau')) {
      maoriNumber = element.split('tekau');
      if (maoriNumber.length == 2 && maoriNumber[0].isNotEmpty) {
        if (int.tryParse(_MAOWordToNum[maoriNumber[0]]!) != null) {
          ten = int.parse(_MAOWordToNum[maoriNumber[0]]!);
          maoriNumber[1].isNotEmpty ? element = maoriNumber[1] : element = '';
        } else {
          ten = 0;
        }
      } else {
        ten = 1;
      }
    }
    if (element.contains('rima')) {
      one = 5;
    } else if (element.contains('ma')) {
      maoriNumber = element.split('ma');
      if (maoriNumber[1].isNotEmpty) {
        if (int.tryParse(_MAOWordToNum[maoriNumber[1]]!) != null) {
          one = int.parse(_MAOWordToNum[maoriNumber[1]]!);
        } else {
          one = 0;
        }
      }
    } else {
      if (_MAOWordToNum[element] != null) {
        if (int.tryParse(_MAOWordToNum[element]!) != null) {
          one = int.parse(_MAOWordToNum[element]!);
        } else {
          one = 0;
        }
      }
    }

    return hundred * 100 + ten * 10 + one;
  } else {
    return 0;
  }
}

bool _isMaori(String element) {
  if (element != '') {
    element = element
        .replaceAll(' ', '')
        .replaceAll(',', '')
        .replaceAll('.', '')
        .replaceAll('mano', '')
        .replaceAll('kore', '')
        .replaceAll('kotahi', '')
        .replaceAll('rua', '')
        .replaceAll('toru', '')
        .replaceAll('wha', '')
        .replaceAll('rima', '')
        .replaceAll('ono', '')
        .replaceAll('whitu', '')
        .replaceAll('waru', '')
        .replaceAll('iwa', '')
        .replaceAll('tekau', '')
        .replaceAll('tahi', '')
        .replaceAll('rau', '')
        .replaceAll('ma', '')
        .replaceAll('miriona', '')
        .replaceAll('piriona', '');
    return (element.isEmpty);
  }
  return false;
}