part of 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';

const _defaultAlphabetAlpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const _defaultAlphabetDigits = '0123456789';

String _rotx(Object text, Object rot) {
  if (_isNotAString(text) || _isAString(rot)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  return Rotator().rotate((text as String), (rot as num).round());
}

String _rot5(
  Object text,
) {
  if (_isNotAString(text)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  Rotator rot = Rotator();
  rot.alphabet = _defaultAlphabetDigits;
  return rot.rotate((text as String), 5);
}

String _rot13(
  Object text,
) {
  if (_isNotAString(text)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  Rotator rot = Rotator();
  rot.alphabet = _defaultAlphabetAlpha;
  return rot.rotate((text as String), 5);
}

String _rot18(
  Object text,
) {
  if (_isNotAString(text)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }

  return (text as String).split('').map((char) {
    if (_defaultAlphabetAlpha.contains(char.toUpperCase())) {
      return _rot13(char);
    } else if (_defaultAlphabetDigits.contains(char)) {
      return _rot5(char);
    } else {
      return char;
    }
  }).join();
}

String _rot47(
  Object text,
) {
  if (_isNotAString(text)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }

  Rotator rot = Rotator();
  rot.alphabet = '!"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';
  return rot.rotate((text as String), 47, removeUnknownCharacters: false, ignoreCase: false);
}

int _bww(Object text, Object opt_alph, Object opt_itqs) {
  if (_isNotAString(text) || _isAString(opt_alph) || _isAString(opt_itqs)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  Map<String, String> alphabet = {};
  switch ((opt_alph as num).round()) {
    case 0:
      alphabet = alphabetAZ.alphabet;
      break;
    case 1:
      alphabet = alphabetGerman1.alphabet;
      break;
    case 2:
      alphabet = alphabetGerman2.alphabet;
      break;
    case 3:
      alphabet = alphabetGerman3.alphabet;
      break;
    default:
      alphabet = alphabetAZ.alphabet;
  }
  int wordValue = 0;
  List<int> values = [];
  AlphabetValues(alphabet: alphabet).textToValues(text as String).forEach((number) {
    if (number != null) values.add(number);
  }); // as List<int>;//.cast<int>();
  for (int number in values) {
    wordValue = wordValue + number;
  }
  switch ((opt_itqs as num).round()) {
    case 0:
      return wordValue;
    case 1:
      return sumCrossSum(values).toInt();
    case 2:
      return sumCrossSumIterated(values).toInt();
  }
  return 0;
}

String _decToRoman(Object x) {
  if (_isAString(x)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  return encodeRomanNumbers((x as int), type: RomanNumberType.USE_SUBTRACTION_RULE);
}

int _romanToDec(Object x) {
  if (_isAInt(x) || _isADouble(x)) {
    _handleError(_INVALIDTYPECAST);
    return 0;
  }
  return decodeRomanNumbers((x as String), type: RomanNumberType.USE_SUBTRACTION_RULE)!;
}
