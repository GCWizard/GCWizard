part of 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';

const _DECODE = 0;
const _ENCODE = 1;

String _bacon(Object text, Object mode) {
  if (_isNotAString(text) || _isNotAInt(mode)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  String output = '';
  switch (mode as int) {
    case _DECODE:
      output = decodeBacon(text as String, inverse: false, binary: false);
      break;
    case _ENCODE:
      output = encodeBacon(text as String, inverse: false, binary: false);
      break;
  }
  return output;
}

String _abaddon(Object text, Object mode) {
  if (_isNotAString(text) || _isNotAInt(mode)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  String output = '';
  switch (mode) {
    case _DECODE:
      output = decryptAbaddon(text as String, {'¥': '¥', 'µ': 'µ', 'þ': 'þ'});
      break;
    case _ENCODE:
      output = encryptAbaddon(text as String, {'¥': '¥', 'µ': 'µ', 'þ': 'þ'});
      break;
  }
  return output;
}

String _atbash(Object text, Object mode) {
  if (_isNotAString(text) || _isNotANumber(mode)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  return atbash(text as String, historicHebrew: (mode as int) == 0);
}

String _avemaria(Object text, Object mode) {
  if (_isNotAString(text) || _isNotAInt(mode)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  String output = '';
  switch (mode) {
    case _DECODE:
      output = decodeAveMaria(text as String);
      break;
    case _ENCODE:
      output = encodeAveMaria(text as String);
      break;
  }
  return output;
}

String _morse(Object text, Object mode, Object code) {
  if (_isNotAString(text) || _isNotAInt(mode) || _isNotAInt(code)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }

  final Map<int, MorseType> CODETABLE = {
    0: MorseType.MORSE_ITU,
    10: MorseType.MORSE1838,
    11: MorseType.MORSE1844,
    2: MorseType.GERKE,
    3: MorseType.STEINHEIL,
  };

  String output = '';

  if (CODETABLE[code as int] == null) {
    return '';
  }

  switch (mode) {
    case _DECODE:
      output = decodeMorse(text as String, type: CODETABLE[code]!);
      break;
    case _ENCODE:
      output = encodeMorse(text as String, type: CODETABLE[code]!);
      break;
    default:
      return '';
  }
  return output;
}

String _enclosedAreas(Object text, Object modeOnlyNumbers, Object modeWith4) {
  if (_isNotAString(text) || _isNotAInt(modeWith4) || _isNotAInt(modeOnlyNumbers)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  return decodeEnclosedAreas(text as String, onlyNumbers: (modeOnlyNumbers == 1), with4: (modeWith4 == 1));
}

String _bcd(Object text, Object mode, Object type) {
  if (_isNotAInt(mode) || _isNotAInt(type)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  String output = '';
  switch (mode) {
    case _DECODE:
      if ((text as String).replaceAll('0', '').replaceAll('1', '').replaceAll(' ', '') != '') {
        _handleError(_INVALIDTYPECAST);
        return '';
      }
      output = decodeBCD(text, _intToBCDType(type as int));
      break;
    case _ENCODE:
      if (_isAInt(text)) {
        output = encodeBCD((text as int).toString(), _intToBCDType(type as int));
      } else if (int.tryParse(text as String) == null) {
        _handleError(_INVALIDTYPECAST);
        return '';
      } else {
        output = encodeBCD(text, _intToBCDType(type as int));
      }
      break;
  }
  return output;
}

BCDType _intToBCDType(int type) {
  switch (type) {
    case 1:
      return BCDType.AIKEN;
    case 2:
      return BCDType.STIBITZ;
    case 3:
      return BCDType.GRAY;
    case 4:
      return BCDType.GLIXON;
    case 5:
      return BCDType.OBRIEN;
    case 6:
      return BCDType.PETHERICK;
    case 7:
      return BCDType.TOMPKINS;
    case 8:
      return BCDType.LIBAWCRAIG;
    case 9:
      return BCDType.GRAYEXCESS;
    case 10:
      return BCDType.TWOOFFIVE;
    case 11:
      return BCDType.ONEOFTEN;
    case 12:
      return BCDType.POSTNET;
    case 13:
      return BCDType.PLANET;
    case 14:
      return BCDType.HAMMING;
    case 15:
      return BCDType.BIQUINARY;
    default:
      return BCDType.ORIGINAL;
  }
}

Object _GCCode(Object text, Object mode) {
  if (_isNotAInt(mode)) {
    _handleError(_INVALIDTYPECAST);
    return '';
  }
  Object output = '';
  switch (mode) {
    case _DECODE:
      if (_isNotAString(text)) {
        _handleError(_INVALIDTYPECAST);
        return '';
      }
      output = gcCodeToID(text as String) as Object;
      break;
    case _ENCODE:
      if (_isAInt(text)) output = idToGCCode(text as int);
      if (_isAString(text)) {
        if (int.tryParse(text as String) == null) {
          _handleError(_INVALIDTYPECAST);
          return '';
        }
        output = idToGCCode(int.parse(text));
      }
      break;
  }
  return output;
}
