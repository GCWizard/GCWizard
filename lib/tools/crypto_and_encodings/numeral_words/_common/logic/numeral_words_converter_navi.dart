part of 'package:gc_wizard/tools/crypto_and_encodings/numeral_words/_common/logic/numeral_words.dart';

OutputConvertToNumber _decodeNavi(String element) {
  // https://de.wikipedia.org/wiki/Na%E2%80%99vi-Sprache#Zahlen
  // https://james-camerons-avatar.fandom.com/de/wiki/Oktale_Arithmetik
  // https://forum.learnnavi.org/navi-lernen/das-navi-zahlensystem/#:~:text=Das%20Na%27vi%20hat%20zwei%20Lehnw%C3%B6rter%20aus%20dem%20Englischen.,Ziffern%2C%20wie%20z.%20B.%20Telefonnummern%2C%20Autokennzeichen%2C%20IDs%20etc.
      if (_isNavi(element)) {
      String number = '';
      String octal = '';
      if (_NAVIWordToNum[element] != null) number = (_NAVIWordToNum[element] ?? '');

      element = element
          .replaceAll('zame', 'zamme')
          .replaceAll('zavo', 'zamvo')
          .replaceAll('zapxe', 'zampxe')
          .replaceAll('zatsi', 'zamtsi')
          .replaceAll('zapu', 'zampu')
          .replaceAll('zamrr', 'zammrr')
          .replaceAll('zaki', 'zamki')
          .replaceAll('zasing', 'zamsing')
          .replaceAll('voaw', 'volaw')
          .replaceAll('vomun', 'volmun')
          .replaceAll('vopey', 'volpey')
          .replaceAll('vosing', 'volsing')
          .replaceAll('vomrr', 'volmrr')
          .replaceAll('vofu', 'volfu')
          .replaceAll('vohin', 'volhin');

      // check 4096
      if (element.contains('kizazam') ||
          element.contains('puzazam') ||
          element.contains('mrrzazam') ||
          element.contains('tsizazam') ||
          element.contains('pxezazam') ||
          element.contains('mezazam') ||
          element.contains('zazam')) {
        if (element.contains('kizazam')) {
          octal = '7';
          element = element.replaceAll('kizazam', '');
        } else if (element.contains('puzazam')) {
          octal = '6';
          element = element.replaceAll('puzazam', '');
        } else if (element.contains('mrrzazam')) {
          octal = '5';
          element = element.replaceAll('mrrzazam', '');
        } else if (element.contains('tsizazam')) {
          octal = '4';
          element = element.replaceAll('tsizazam', '');
        } else if (element.contains('pxezazam')) {
          octal = '3';
          element = element.replaceAll('pxezazam', '');
        } else if (element.contains('mezazam')) {
          octal = '2';
          element = element.replaceAll('mezazam', '');
        } else if (element.contains('zazam')) {
          octal = '1';
          element = element.replaceAll('zazam', '');
        }
      } else {
        octal = '0';
      }

      // check 512
      if (element.contains('kivozam') ||
          element.contains('puvozam') ||
          element.contains('mrrvozam') ||
          element.contains('tsivozam') ||
          element.contains('pxevozam') ||
          element.contains('mevozam') ||
          element.contains('vozam')) {
        if (element.contains('kivozam')) {
          octal = octal + '7';
          element = element.replaceAll('kivozam', '');
        } else if (element.contains('puvozam')) {
          octal = octal + '6';
          element = element.replaceAll('puvozam', '');
        } else if (element.contains('mrrvozam')) {
          octal = octal + '5';
          element = element.replaceAll('mrrvozam', '');
        } else if (element.contains('tsivozam')) {
          octal = octal + '4';
          element = element.replaceAll('tsivozam', '');
        } else if (element.contains('pxevozam')) {
          octal = octal + '3';
          element = element.replaceAll('pxevozam', '');
        } else if (element.contains('mevozam')) {
          octal = octal + '2';
          element = element.replaceAll('mevozam', '');
        } else if (element.contains('vozam')) {
          octal = octal + '1';
          element = element.replaceAll('vozam', '');
        }
      } else {
        octal = octal + '0';
      }

      // check 64
      if (element.contains('kizam') ||
          element.contains('puzam') ||
          element.contains('mrrzam') ||
          element.contains('tsizam') ||
          element.contains('pxezam') ||
          element.contains('mezam') ||
          element.contains('zam')) {
        if (element.contains('kizam')) {
          octal = octal + '7';
          element = element.replaceAll('kizam', '');
        } else if (element.contains('puzam')) {
          octal = octal + '6';
          element = element.replaceAll('puzam', '');
        } else if (element.contains('mrrzam')) {
          octal = octal + '5';
          element = element.replaceAll('mrrzam', '');
        } else if (element.contains('tsizam')) {
          octal = octal + '4';
          element = element.replaceAll('tsizam', '');
        } else if (element.contains('pxezam')) {
          octal = octal + '3';
          element = element.replaceAll('pxezam', '');
        } else if (element.contains('mezam')) {
          octal = octal + '2';
          element = element.replaceAll('mezam', '');
        } else if (element.contains('zam')) {
          octal = octal + '1';
          element = element.replaceAll('zam', '');
        }
      } else {
        octal = octal + '0';
      }

      // check 8
      if (element.contains('kivol') ||
          element.contains('puvol') ||
          element.contains('mrrvol') ||
          element.contains('tsivol') ||
          element.contains('pxevol') ||
          element.contains('mevol') ||
          element.contains('vol')) {
        if (element.contains('kivol')) {
          octal = octal + '7';
          element = element.replaceAll('kivol', '');
        } else if (element.contains('puvol')) {
          octal = octal + '6';
          element = element.replaceAll('puvol', '');
        } else if (element.contains('mrrvol')) {
          octal = octal + '5';
          element = element.replaceAll('mrrvol', '');
        } else if (element.contains('tsivol')) {
          octal = octal + '4';
          element = element.replaceAll('tsivol', '');
        } else if (element.contains('pxevol')) {
          octal = octal + '3';
          element = element.replaceAll('pxevol', '');
        } else if (element.contains('mevol')) {
          octal = octal + '2';
          element = element.replaceAll('mevol', '');
        } else if (element.contains('vol')) {
          octal = octal + '1';
          element = element.replaceAll('vol', '');
        }
      } else {
        octal = octal + '0';
      }

      // check 1
      if (element.contains('hin') ||
          element.contains('fu') ||
          element.contains('mrr') ||
          element.contains('sing') ||
          element.contains('pey') ||
          element.contains('mun') ||
          element.contains('aw')) {
        if (element.contains('hin')) {
          octal = octal + '7';
        } else if (element.contains('fu')) {
          octal = octal + '6';
        } else if (element.contains('mrr')) {
          octal = octal + '5';
        } else if (element.contains('sing')) {
          octal = octal + '4';
        } else if (element.contains('pey')) {
          octal = octal + '3';
        } else if (element.contains('mun')) {
          octal = octal + '2';
        } else if (element.contains('aw')) {
          octal = octal + '1';
        }
      } else {
        octal = octal + '0';
      }

      number = convertBase(octal, 8, 10);
      return OutputConvertToNumber(
          number: int.parse(number),
          numbersystem: convertBase(number, 10, 8),
          title: 'common_numeralbase_octenary',
          error: '');
    } else {
      return OutputConvertToNumber(number: 0, numbersystem: '', title: '', error: 'numeralwords_converter_error_navi');
    }
}

OutputConvertToNumeralWord _encodeNavi(int currentNumber) {
  String numeralWord = '';
  String octal = '';
  if (0 <= currentNumber && currentNumber <= 7) {
    switch (currentNumber) {
      case 0:
        numeralWord = 'kew';
        break;
      case 1:
        numeralWord = "'aw";
        break;
      case 2:
        numeralWord = 'mune';
        break;
      case 3:
        numeralWord = 'pxey';
        break;
      case 4:
        numeralWord = 'tsìng';
        break;
      case 5:
        numeralWord = 'mrr';
        break;
      case 6:
        numeralWord = 'pukap';
        break;
      case 7:
        numeralWord = 'kinä';
        break;
    }
  } else {
    octal = convertBase(currentNumber.toString(), 10, 8);
    while (octal.length < 5) {
      octal = '0' + octal;
    }
    switch (octal[0]) {
      //  4096
      case '0':
        numeralWord = '';
        break;
      case '1':
        numeralWord = 'zazam';
        break;
      case '2':
        numeralWord = 'mezazam';
        break;
      case '3':
        numeralWord = 'pxezazam';
        break;
      case '4':
        numeralWord = 'tsìzazam';
        break;
      case '5':
        numeralWord = 'mrrzazam';
        break;
      case '6':
        numeralWord = 'puzazam';
        break;
      case '7':
        numeralWord = 'kizazam';
        break;
    }
    switch (octal[1]) {
      // 512
      case '0':
        numeralWord = numeralWord + '';
        break;
      case '1':
        numeralWord = numeralWord + 'vozam';
        break;
      case '2':
        numeralWord = numeralWord + 'mevozam';
        break;
      case '3':
        numeralWord = numeralWord + 'pxevozam';
        break;
      case '4':
        numeralWord = numeralWord + 'tsìvozam';
        break;
      case '5':
        numeralWord = numeralWord + 'mrrvozam';
        break;
      case '6':
        numeralWord = numeralWord + 'puvozam';
        break;
      case '7':
        numeralWord = numeralWord + 'kivozam';
        break;
    }
    switch (octal[2]) {
      // 64
      case '0':
        numeralWord = numeralWord + '';
        break;
      case '1':
        numeralWord = numeralWord + 'zam';
        break;
      case '2':
        numeralWord = numeralWord + 'mezam';
        break;
      case '3':
        numeralWord = numeralWord + 'pxezam';
        break;
      case '4':
        numeralWord = numeralWord + 'tsìzam';
        break;
      case '5':
        numeralWord = numeralWord + 'mrrzam';
        break;
      case '6':
        numeralWord = numeralWord + 'puzam';
        break;
      case '7':
        numeralWord = numeralWord + 'kizam';
        break;
    }
    if (octal[4] == '0') {
      switch (octal[3]) {
        // 8
        case '0':
          numeralWord = numeralWord + '';
          break;
        case '1':
          numeralWord = numeralWord + 'vol';
          break;
        case '2':
          numeralWord = numeralWord + 'mevol';
          break;
        case '3':
          numeralWord = numeralWord + 'pxevol';
          break;
        case '4':
          numeralWord = numeralWord + 'tsìvol';
          break;
        case '5':
          numeralWord = numeralWord + 'mrrvol';
          break;
        case '6':
          numeralWord = numeralWord + 'puvol';
          break;
        case '7':
          numeralWord = numeralWord + 'kivol';
          break;
      }
    } else {
      switch (octal[3]) {
        // 8
        case '0':
          numeralWord = numeralWord + '';
          break;
        case '1':
          numeralWord = numeralWord + 'vo';
          break;
        case '2':
          numeralWord = numeralWord + 'mevo';
          break;
        case '3':
          numeralWord = numeralWord + 'pxevo';
          break;
        case '4':
          numeralWord = numeralWord + 'tsìvo';
          break;
        case '5':
          numeralWord = numeralWord + 'mrrvo';
          break;
        case '6':
          numeralWord = numeralWord + 'puvo';
          break;
        case '7':
          numeralWord = numeralWord + 'kivo';
          break;
      }
    }
    switch (octal[4]) {
      // 1
      case '0':
        numeralWord = numeralWord + '';
        break;
      case '1':
        numeralWord = numeralWord + 'aw';
        break;
      case '2':
        numeralWord = numeralWord + 'mun';
        break;
      case '3':
        numeralWord = numeralWord + 'pey';
        break;
      case '4':
        numeralWord = numeralWord + 'sìng';
        break;
      case '5':
        numeralWord = numeralWord + 'mrr';
        break;
      case '6':
        numeralWord = numeralWord + 'fu';
        break;
      case '7':
        numeralWord = numeralWord + 'hin';
        break;
    }
  }
  // normalize - Hinweis: Das m von zam fällt weg, wenn der Rest mit einem Konsonant beginnt.
  numeralWord = numeralWord
      .replaceAll('zamk', 'zak')
      .replaceAll('zamp', 'zap')
      .replaceAll('zams', 'zas')
      .replaceAll('zamt', 'zat')
      .replaceAll('zamv', 'zav')
      .replaceAll('zamm', 'zam');

  // normalize - inweis: Das l von vol fällt weg, wenn der Rest mit einem Konsonant beginnt.
  numeralWord = numeralWord
      .replaceAll('volk', 'vok')
      .replaceAll('volp', 'vop')
      .replaceAll('volt', 'vot')
      .replaceAll('volm', 'vom')
      .replaceAll('voaw', 'volaw');

  return OutputConvertToNumeralWord(
      numeralWord: numeralWord,
      targetNumberSystem: convertBase(currentNumber.toString(), 10, 8),
      title: 'common_numeralbase_octenary',
      errorMessage: '');
}

bool _isNavi(String element) {
  element = element
  //.replaceAll('zam', 'zamm')
      .replaceAll('zak', 'zamk')
      .replaceAll('zap', 'zamp')
      .replaceAll('zamr', 'zammr')
      .replaceAll('zas', 'zams')
      .replaceAll('zat', 'zamt')
      .replaceAll('zav', 'zamv')
      .replaceAll('zamu', 'zammu')
      .replaceAll('zame', 'zamme');
  if (element.endsWith('mm')) {
    element = element.substring(0, element.length - 1);
  }
  element = element
      .replaceAll('vok', 'volk')
      .replaceAll('vom', 'volm')
      .replaceAll('vop', 'volp')
      .replaceAll('vot', 'volt')
      .replaceAll('voz', 'volz')
      .replaceAll('volaw', 'volaw');

  element = element
      .replaceAll('mezazam', '')
      .replaceAll('pxezazam', '')
      .replaceAll('tsizazam', '')
      .replaceAll('mrrzazam', '')
      .replaceAll('puzazam', '')
      .replaceAll('kizazam', '')
      .replaceAll('zazam', '')
      .replaceAll('mevozam', '')
      .replaceAll('pxevozam', '')
      .replaceAll('tsivozam', '')
      .replaceAll('mrrvozam', '')
      .replaceAll('puvozam', '')
      .replaceAll('kivozam', '')
      .replaceAll('vozam', '')
      .replaceAll('mezam', '')
      .replaceAll('pxezam', '')
      .replaceAll('tsizam', '')
      .replaceAll('mrrzam', '')
      .replaceAll('puzam', '')
      .replaceAll('kizam', '')
      .replaceAll('zam', '')
      .replaceAll('mevol', '')
      .replaceAll('pxevol', '')
      .replaceAll('tsivol', '')
      .replaceAll('mrrvol', '')
      .replaceAll('puvol', '')
      .replaceAll('kivol', '')
      .replaceAll('vol', '')
      .replaceAll('mevo', '')
      .replaceAll('pxevo', '')
      .replaceAll('tsivo', '')
      .replaceAll('mrrvo', '')
      .replaceAll('puvo', '')
      .replaceAll('kivo', '')
      .replaceAll('vo', '')
      .replaceAll('kew', '')
      .replaceAll('aw', '')
      .replaceAll('mune', '')
      .replaceAll('mun', '')
      .replaceAll('mrr', '')
      .replaceAll('peysing', '')
      .replaceAll('pxey', '')
      .replaceAll('pey', '')
      .replaceAll('fu', '')
      .replaceAll('hin', '')
      .replaceAll('tsing', '')
      .replaceAll('pukap', '')
      .replaceAll('kinae', '')
      .replaceAll('sing', '')
      .replaceAll('za', '')
      .replaceAll('ki', '');
  return (element.isEmpty);
}