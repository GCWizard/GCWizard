part of 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

OutputConvertToNumber _decodeROU(String element) {
  int decodeTripel(String element, Map<String, String> ROU_numbers) {
    List<String> syllables = [];

    int decodeTupel(String element, Map<String, String> ROU_numbers) {
      if (element.contains('sprezece')) return int.parse((ROU_numbers[element.trim()] ?? ''));

      syllables = element.split('si');
      if (syllables.length == 2) {
        return int.parse((ROU_numbers[syllables[0].trim()] ?? '')) +
            int.parse((ROU_numbers[syllables[1].trim()] ?? ''));
      } else {
        return int.parse((ROU_numbers[syllables[0].trim()] ?? ''));
      }
    }

    if (element.contains('o suta')) return 100 + decodeTupel(element.trim(), ROU_numbers);

    if (element.contains('sute')) {
      // element > 199
      syllables = element.split('sute');
      return int.parse((ROU_numbers[syllables[0].trim()] ?? '')) * 100 + decodeTupel(syllables[1].trim(), ROU_numbers);
    }

    return decodeTupel(element.trim(), ROU_numbers);
  }

  if (_isROU(element)) {
    int number = 0;
    List<String> syllables = [];
    if (element.contains('de mii')) {
      syllables = element.split('de mii');
    } else {
      syllables = element.split('mii');
    }
    Map<String, String> ROU_numbers = _normalize(_ROUWordToNum, NumeralWordsLanguage.ROU);
    if (syllables.length == 1) {
      number = decodeTripel(syllables[0].trim(), ROU_numbers);
    } else {
      number = (decodeTripel(syllables[0].trim(), ROU_numbers) * 1000 + decodeTripel(syllables[1].trim(), ROU_numbers));
    }
    return OutputConvertToNumber(number: number, numbersystem: number.toString(), title: '', error: '');
  } else {
    return OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: 'numeralwords_converter_error_rou');
  }
}

OutputConvertToNumeralWord _encodeROU(int currentNumber) {
  String encodeTripel(int currentNumber, Map<String, String> ROU_numbers) {
    int hundred = 0;
    int ten = 0;
    int one = 0;

    if (currentNumber == 0) return '';

    if (currentNumber < 20) {
      return (ROU_numbers[currentNumber.toString()] ?? '');
    }

    if (currentNumber < 100) {
      if (currentNumber % 10 == 0) return (ROU_numbers[(currentNumber ~/ 10 * 10).toString()] ?? '');
      return (ROU_numbers[(currentNumber ~/ 10 * 10).toString()] ?? '') +
          ' şi ' +
          (ROU_numbers[(currentNumber % 10).toString()] ?? '');
    }

    if (currentNumber < 120) {
      currentNumber = currentNumber - 100;
      if (currentNumber == 0) return 'o sută';
      return 'o sută ' + (ROU_numbers[(currentNumber).toString()] ?? '');
    }

    if (currentNumber < 200) {
      currentNumber = currentNumber - 100;
      return 'o sută ' +
          (ROU_numbers[(currentNumber ~/ 10 * 10).toString()] ?? '') +
          ((currentNumber % 10 == 0) ? '' : ' şi ' + (ROU_numbers[(currentNumber % 10).toString()] ?? ''));
    }

    if (currentNumber % 100 == 0) return (ROU_numbers[(currentNumber ~/ 100).toString()] ?? '') + ' sute';

    hundred = currentNumber ~/ 100;
    ten = (currentNumber - (currentNumber ~/ 100) * 100) ~/ 10;
    one = currentNumber % 10;

    return (ROU_numbers[hundred.toString()] ?? '') +
        ' sute ' +
        (ten == 0
            ? (ROU_numbers[one.toString()] ?? '')
            : (ten == 1)
                ? (ROU_numbers[(ten * 10 + one).toString()] ?? '')
                : (ROU_numbers[(ten * 10).toString()] ?? '') +
                    (one == 0 ? '' : ' şi ' + (ROU_numbers[one.toString()] ?? '')));
  }

  Map<String, String> ROU_numbers = switchMapKeyValue(_ROUWordToNum);
  if (currentNumber < 20) {
    return OutputConvertToNumeralWord(
        numeralWord: (ROU_numbers[currentNumber.toString()] ?? ''),
        targetNumberSystem: currentNumber.toString(),
        title: '',
        errorMessage: '');
  }
  if (currentNumber < 100) {
    if (currentNumber % 10 == 0) {
      return OutputConvertToNumeralWord(
          numeralWord: (ROU_numbers[(currentNumber ~/ 10 * 10).toString()] ?? ''),
          targetNumberSystem: currentNumber.toString(),
          title: '',
          errorMessage: '');
    }
    return OutputConvertToNumeralWord(
        numeralWord: (ROU_numbers[(currentNumber ~/ 10 * 10).toString()] ?? '') +
            ' şi ' +
            (ROU_numbers[(currentNumber % 10).toString()] ?? ''),
        targetNumberSystem: currentNumber.toString(),
        title: '',
        errorMessage: '');
  }
  if (currentNumber < 1000) {
    return OutputConvertToNumeralWord(
        numeralWord: encodeTripel(currentNumber, ROU_numbers),
        targetNumberSystem: currentNumber.toString(),
        title: '',
        errorMessage: '');
  }
  if (currentNumber < 2000) {
    return OutputConvertToNumeralWord(
        numeralWord: 'oh mie ' + encodeTripel(currentNumber - 1000, ROU_numbers),
        targetNumberSystem: currentNumber.toString(),
        title: '',
        errorMessage: '');
  }
  if (currentNumber < 10000) {
    return OutputConvertToNumeralWord(
        numeralWord: (ROU_numbers[(currentNumber ~/ 1000).toString()] ?? '') +
            ' mii ' +
            encodeTripel(currentNumber % 1000, ROU_numbers),
        targetNumberSystem: currentNumber.toString(),
        title: '',
        errorMessage: '');
  }
  return OutputConvertToNumeralWord(
      numeralWord: encodeTripel(currentNumber ~/ 1000, ROU_numbers) +
          ' de mii ' +
          encodeTripel(currentNumber % 1000, ROU_numbers),
      targetNumberSystem: currentNumber.toString(),
      title: '',
      errorMessage: '');
}

bool _isROU(String element) {
  if (element != '') {
    element = element
        .replaceAll(' ', '')
        .replaceAll('zero', '')
        .replaceAll('unu', '')
        .replaceAll('una', '')
        .replaceAll('doi', '')
        .replaceAll('doua', '')
        .replaceAll('trei', '')
        .replaceAll('patru', '')
        .replaceAll('cinci', '')
        .replaceAll('sase', '')
        .replaceAll('sapte', '')
        .replaceAll('opt', '')
        .replaceAll('noua', '')
        .replaceAll('zece', '')
        .replaceAll('spre', '')
        .replaceAll('pai', '')
        .replaceAll('si', '')
        .replaceAll('un', '')
        .replaceAll('zeci', '')
        .replaceAll('o suta', '')
        .replaceAll('sute', '')
        .replaceAll('apte', '')
        .replaceAll('oh mie', '')
        .replaceAll('dou', '')
        .replaceAll('de', '')
        .replaceAll('sai', '')
        .replaceAll('mii', '');

    return (element.isEmpty);
  }
  return false;
}

