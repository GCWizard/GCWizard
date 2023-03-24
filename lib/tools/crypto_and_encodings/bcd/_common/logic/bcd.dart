// Maps are besed on information from
// https://de.wikipedia.org/wiki/BCD-Code
// https://de.wikipedia.org/wiki/Aiken-Code
// https://de.wikipedia.org/wiki/Stibitz-Code
// https://de.wikipedia.org/wiki/Libaw-Craig-Code
// https://de.wikipedia.org/wiki/Gray-Code
// https://www.itwissen.info/Glixon-Code-Glixon-code.html
// http://www.ahok.de/en/hoklas-code.html#:~:text=Three%20of%20the%20four%20bits%20of%20Tompkins%27s%20code,least%20significant%20bits.%20It%27s%20known%20as%20%22reflected%20code%22.

import 'package:gc_wizard/utils/collection_utils.dart';

final _DigitToBCDOriginal = {
  '0': "0000",
  '1': '0001',
  '2': '0010',
  '3': '0011',
  '4': '0100',
  '5': '0101',
  '6': '0110',
  '7': '0111',
  '8': '1000',
  '9': '1001'
};
final _DigitToBCDAiken = {
  '0': '0000',
  '1': '0001',
  '2': '0010',
  '3': '0011',
  '4': '0100',
  '5': '1011',
  '6': '1100',
  '7': '1101',
  '8': '1110',
  '9': '1111'
};
final _DigitToBCDStibitz = {
  '0': '0011',
  '1': '0100',
  '2': '0101',
  '3': '0110',
  '4': '0111',
  '5': '1000',
  '6': '1001',
  '7': '1010',
  '8': '1011',
  '9': '1100'
};
final _DigitToBCDGray = {
  '0': '0000',
  '1': '0001',
  '2': '0011',
  '3': '0010',
  '4': '0110',
  '5': '0111',
  '6': '0101',
  '7': '0100',
  '8': '1100',
  '9': '1101'
};
final _DigitToBCDGlixon = {
  '0': '0000',
  '1': '0001',
  '2': '0011',
  '3': '0010',
  '4': '0110',
  '5': '0111',
  '6': '0101',
  '7': '0100',
  '8': '1100',
  '9': '1000'
};
final _DigitToBCDOBrien = {
  '0': '0001',
  '1': '0011',
  '2': '0010',
  '3': '0110',
  '4': '0100',
  '5': '1100',
  '6': '1110',
  '7': '1010',
  '8': '1011',
  '9': '1001'
};
final _DigitToBCDPetherick = {
  '0': '0101',
  '1': '0001',
  '2': '0011',
  '3': '0010',
  '4': '0110',
  '5': '1110',
  '6': '1010',
  '7': '1011',
  '8': '1001',
  '9': '1101'
};
final _DigitToBCDTompkins = {
  '0': '0010',
  '1': '0011',
  '2': '0111',
  '3': '0101',
  '4': '0100',
  '5': '1100',
  '6': '1101',
  '7': '1001',
  '8': '1011',
  '9': '1010'
};
final _DigitToBCDGrayExcess = {
  '0': '0010',
  '1': '0110',
  '2': '0111',
  '3': '0100',
  '4': '0101',
  '5': '1101',
  '6': '1100',
  '7': '1110',
  '8': '1111',
  '9': '1011'
};
final _DigitToBCDLibawCraig = {
  '0': '00000',
  '1': '00001',
  '2': '00011',
  '3': '00111',
  '4': '01111',
  '5': '11111',
  '6': '11110',
  '7': '11100',
  '8': '11000',
  '9': '10000'
};
final _DigitToBCD2of5 = {
  '0': '00011',
  '1': '00101',
  '2': '00110',
  '3': '01001',
  '4': '01010',
  '5': '01100',
  '6': '10001',
  '7': '10010',
  '8': '10100',
  '9': '11000'
};
final _DigitToBCD2of5Postnet = {
  '0': '11000',
  '1': '00011',
  '2': '00101',
  '3': '00110',
  '4': '01001',
  '5': '01010',
  '6': '01100',
  '7': '10001',
  '8': '10010',
  '9': '10100'
};
final _DigitToBCD2of5Planet = {
  '0': '00111',
  '1': '11100',
  '2': '11010',
  '3': '11001',
  '4': '10110',
  '5': '10101',
  '6': '10011',
  '7': '01110',
  '8': '01101',
  '9': '01011'
};
final _DigitToBCDHamming = {
  '0': '0000000',
  '1': '0000111',
  '2': '0011001',
  '3': '0011110',
  '4': '0101010',
  '5': '0101101',
  '6': '0110011',
  '7': '0110100',
  '8': '1001011',
  '9': '1001100'
};
final _DigitToBCDBiquinaer = {
  '0': '1000001',
  '1': '1000010',
  '2': '1000100',
  '3': '1001000',
  '4': '1010000',
  '5': '0100001',
  '6': '0100010',
  '7': '0100100',
  '8': '0101000',
  '9': '0110000'
};
final _DigitToBCD1of10 = {
  '0': '0000000001',
  '1': '0000000010',
  '2': '0000000100',
  '3': '0000001000',
  '4': '0000010000',
  '5': '0000100000',
  '6': '0001000000',
  '7': '0010000000',
  '8': '0100000000',
  '9': '1000000000'
};

var _BCDOriginalToDigit = switchMapKeyValue(_DigitToBCDOriginal);
var _BCDAikenToDigit = switchMapKeyValue(_DigitToBCDAiken);
var _BCDStibitzToDigit = switchMapKeyValue(_DigitToBCDStibitz);
var _BCDGrayToDigit = switchMapKeyValue(_DigitToBCDGray);
var _BCDGlixonToDigit = switchMapKeyValue(_DigitToBCDGlixon);
var _BCDOBrienToDigit = switchMapKeyValue(_DigitToBCDOBrien);
var _BCDPetherickToDigit = switchMapKeyValue(_DigitToBCDPetherick);
var _BCDTompkinsToDigit = switchMapKeyValue(_DigitToBCDTompkins);
var _BCDLibawCraigToDigit = switchMapKeyValue(_DigitToBCDLibawCraig);
var _BCDGrayExcessToDigit = switchMapKeyValue(_DigitToBCDGrayExcess);
var _BCDHammingToDigit = switchMapKeyValue(_DigitToBCDHamming);
var _BCD1of10ToDigit = switchMapKeyValue(_DigitToBCD1of10);
var _BCD2of5ToDigit = switchMapKeyValue(_DigitToBCD2of5);
var _BCD2of5PlanetToDigit = switchMapKeyValue(_DigitToBCD2of5Planet);
var _BCD2of5PostnetToDigit = switchMapKeyValue(_DigitToBCD2of5Postnet);
var _BCDBiquinaerToDigit = switchMapKeyValue(_DigitToBCDBiquinaer);

enum BCDType {
  ORIGINAL,
  AIKEN,
  STIBITZ,
  GRAY,
  GLIXON,
  OBRIEN,
  PETHERICK,
  TOMPKINS,
  LIBAWCRAIG,
  GRAYEXCESS,
  TWOOFFIVE,
  ONEOFTEN,
  PLANET,
  POSTNET,
  HAMMING,
  BIQUINARY
}

String encodeBCD(String input, BCDType type) {
  if (input.isEmpty) return '';

  Map<String, String> bcdMap;
  switch (type) {
    case BCDType.ORIGINAL:
      bcdMap = _DigitToBCDOriginal;
      break;
    case BCDType.AIKEN:
      bcdMap = _DigitToBCDAiken;
      break;
    case BCDType.STIBITZ:
      bcdMap = _DigitToBCDStibitz;
      break;
    case BCDType.GRAY:
      bcdMap = _DigitToBCDGray;
      break;
    case BCDType.GLIXON:
      bcdMap = _DigitToBCDGlixon;
      break;
    case BCDType.OBRIEN:
      bcdMap = _DigitToBCDOBrien;
      break;
    case BCDType.PETHERICK:
      bcdMap = _DigitToBCDPetherick;
      break;
    case BCDType.TOMPKINS:
      bcdMap = _DigitToBCDTompkins;
      break;
    case BCDType.LIBAWCRAIG:
      bcdMap = _DigitToBCDLibawCraig;
      break;
    case BCDType.GRAYEXCESS:
      bcdMap = _DigitToBCDGrayExcess;
      break;
    case BCDType.TWOOFFIVE:
      bcdMap = _DigitToBCD2of5;
      break;
    case BCDType.PLANET:
      bcdMap = _DigitToBCD2of5Planet;
      break;
    case BCDType.POSTNET:
      bcdMap = _DigitToBCD2of5Postnet;
      break;
    case BCDType.ONEOFTEN:
      bcdMap = _DigitToBCD1of10;
      break;
    case BCDType.HAMMING:
      bcdMap = _DigitToBCDHamming;
      break;
    case BCDType.BIQUINARY:
      bcdMap = _DigitToBCDBiquinaer;
      break;
  }

  return input
      .split('')
      .where((character) => bcdMap[character] != null)
      .map((character) => bcdMap[character])
      .join(' ');
}

String decodeBCD(String input, BCDType type) {
  if (input.isEmpty) return '';

  Map<String, String> bcdMap;
  switch (type) {
    case BCDType.ORIGINAL:
      bcdMap = _BCDOriginalToDigit;
      break;
    case BCDType.AIKEN:
      bcdMap = _BCDAikenToDigit;
      break;
    case BCDType.STIBITZ:
      bcdMap = _BCDStibitzToDigit;
      break;
    case BCDType.GRAY:
      bcdMap = _BCDGrayToDigit;
      break;
    case BCDType.GLIXON:
      bcdMap = _BCDGlixonToDigit;
      break;
    case BCDType.OBRIEN:
      bcdMap = _BCDOBrienToDigit;
      break;
    case BCDType.PETHERICK:
      bcdMap = _BCDPetherickToDigit;
      break;
    case BCDType.TOMPKINS:
      bcdMap = _BCDTompkinsToDigit;
      break;
    case BCDType.LIBAWCRAIG:
      bcdMap = _BCDLibawCraigToDigit;
      break;
    case BCDType.GRAYEXCESS:
      bcdMap = _BCDGrayExcessToDigit;
      break;
    case BCDType.TWOOFFIVE:
      bcdMap = _BCD2of5ToDigit;
      break;
    case BCDType.PLANET:
      bcdMap = _BCD2of5PlanetToDigit;
      break;
    case BCDType.POSTNET:
      bcdMap = _BCD2of5PostnetToDigit;
      break;
    case BCDType.ONEOFTEN:
      bcdMap = _BCD1of10ToDigit;
      break;
    case BCDType.HAMMING:
      bcdMap = _BCDHammingToDigit;
      break;
    case BCDType.BIQUINARY:
      bcdMap = _BCDBiquinaerToDigit;
      break;
  }

  return input.split(RegExp(r'[^01]')).map((bcd) {
    var character = bcdMap[bcd];
    return character ?? '';
  }).join();
}
