part of 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

String _complexMultipleKlingon(String kliNumber) {
  return '€' + kliNumber.trim().replaceAll('-', '€').replaceAll(' ', '€') + '€ ';
}

String _decodeKlingonString(String element) {

  if (element.isEmpty) return '';
  if (element[0] == '€' && element[element.length - 1] == '€') {
    return _decodeMultipleKlingon(element.substring(1, element.length - 1));
  }
  if (element == 'chan') return 'numeralwords_e';
  if (element == "ting'ev" || element == "'evting" || element == 'maH') return 'numeralwords_w';
  if (element == "'oy'") return 'numeralwords_n';
  if (element == 'watlh') return 'numeralwords_s';
  if (element == 'ngev' || element == 'ghob') return '.';
  if (element == 'qoch') return '°';
  String result = element
      .replaceAll('pagh', '0')
      .replaceAll("wa'", '1')
      .replaceAll("cha'", '2')
      .replaceAll('wej', '3')
      .replaceAll('los', '4')
      .replaceAll('vagh', '5')
      .replaceAll('jav', '6')
      .replaceAll('soch', '7')
      .replaceAll('chorgh', '8')
      .replaceAll('hut', '9')
      .replaceAll('mah', '0')
      .replaceAll('vatlh', '00')
      .replaceAll('sad', '000')
      .replaceAll('sanid', '000')
      .replaceAll('netlh', '0000')
      .replaceAll('bip', '00000');
  return result;
}

OutputConvertToNumber _decodeKlingon(String currentDecodeInput) {

  if (_isKlingon(currentDecodeInput)) {
    RegExp expr = RegExp(
        r"((wa'|cha'|wej|los|vagh|jav|soch|chorgh|hut)(bip|netlh|sad|sanid|vatlh|mah)[ -]?)+(wa'|cha'|wej|los|vagh|jav|soch|chorgh|hut)?(\s|$)");
    if (expr.hasMatch(currentDecodeInput)) {
      String helpText = currentDecodeInput.replaceAllMapped(expr, (Match m) {
        return _complexMultipleKlingon(m.group(0)!);
      });
      currentDecodeInput = helpText;
    }
    return OutputConvertToNumber(
        number: int.parse(_decodeMultipleKlingon(currentDecodeInput.replaceAll(' ', ''))),
        numbersystem: '',
        title: '',
        error: '');
  } else {
    return OutputConvertToNumber(
        number: 0, numbersystem: '', title: '', error: 'numeralwords_converter_error_klingon');
  }
}

String _decodeMultipleKlingon(String kliNumber) {
  kliNumber = kliNumber.trim();
  if (kliNumber.isEmpty) return '';
  int number = 0;
  kliNumber.split('€').forEach((element) {
    if (int.tryParse(_decodeKlingonString(element)) != null) number = number + int.parse(_decodeKlingonString(element));
  });
  return number.toString();
}

OutputConvertToNumeralWord _encodeKlingon(int currentNumber) {
  String numeralWord = '';
  numeralWord = '';
  if (currentNumber == 0) {
    return OutputConvertToNumeralWord(numeralWord: 'pagh', targetNumberSystem: '', title: '', errorMessage: '');
  }

  bool negative = false;
  if (currentNumber < 0) {
    negative = true;
    currentNumber = -1 * currentNumber;
  }
  int tenth = (pow(10, (currentNumber.toString().length - 1))).toInt();
  while (currentNumber > 0) {
    switch (currentNumber ~/ tenth) {
      case 0:
        numeralWord = numeralWord + "pagh";
        break;
      case 1:
        numeralWord = numeralWord + "wa'";
        break;
      case 2:
        numeralWord = numeralWord + "cha'";
        break;
      case 3:
        numeralWord = numeralWord + "wej";
        break;
      case 4:
        numeralWord = numeralWord + "loS";
        break;
      case 5:
        numeralWord = numeralWord + "vagh";
        break;
      case 6:
        numeralWord = numeralWord + "jav";
        break;
      case 7:
        numeralWord = numeralWord + "Soch";
        break;
      case 8:
        numeralWord = numeralWord + "chorgh";
        break;
      case 9:
        numeralWord = numeralWord + "Hut";
        break;
    }
    switch (tenth) {
      case 10:
        numeralWord = numeralWord + "maH ";
        break;
      case 100:
        numeralWord = numeralWord + "vatlh ";
        break;
      case 1000:
        numeralWord = numeralWord + "SaD ";
        break;
      case 10000:
        numeralWord = numeralWord + "SanID ";
        break;
      case 100000:
        numeralWord = numeralWord + "netlh ";
        break;
      case 1000000:
        numeralWord = numeralWord + "bIp ";
        break;
      case 10000000:
        numeralWord = numeralWord + "'uy' ";
        break;
      case 100000000:
        numeralWord = numeralWord + "Saghan ";
        break;
    }
    currentNumber = currentNumber % tenth;
    tenth = tenth ~/ 10;
  }
  if (negative) numeralWord = numeralWord + ' Dop';
  return OutputConvertToNumeralWord(numeralWord: numeralWord, targetNumberSystem: '', title: '', errorMessage: '');
}

bool _isKlingon(String element) {
  if (element != '') {
    return (element
            .replaceAll(' ', '')
            .replaceAll('€', '')
            .replaceAll('pagh', '')
            .replaceAll("wa'", '')
            .replaceAll("cha'", '')
            .replaceAll('wej', '')
            .replaceAll('los', '')
            .replaceAll('vagh', '')
            .replaceAll('jav', '')
            .replaceAll('soch', '')
            .replaceAll('chorgh', '')
            .replaceAll('hut', '')
            .replaceAll('mah', '')
            .replaceAll('vatlh', '')
            .replaceAll('sad', '')
            .replaceAll('sanid', '')
            .replaceAll('netlh', '')
            .replaceAll('bip', '')
            .replaceAll('chan', '') ==
        '');
  } else {
    return false;
  }
}



