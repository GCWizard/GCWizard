import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/rendering.dart';
import 'package:gc_wizard/logic/tools/crypto_and_encodings/rotator.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/colors/colors_rgb.dart';
import 'package:intl/intl.dart';

import 'alphabets.dart';
import 'constants.dart';

List<int> textToIntList(String text, {bool allowNegativeValues: false}) {
  var regex = allowNegativeValues ? RegExp(r'[^\-0-9]') : RegExp(r'[^0-9]');

  var list = text.split(regex);
  list.removeWhere((value) => value == null || value == '');

  return list.map((value) => value == '-' ? 0 : int.tryParse(value)).toList();
}

List<String> textToBinaryList(String text) {
  if (text == null || text.length == 0) return [];

  final regex = RegExp(r'[01]+');

  return regex.allMatches(text).map((value) => text.substring(value.start, value.end)).toList();
}

int extractIntegerFromText(String text) {
  if (text == null) return null;
  var digits = text.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length == 0) return null;

  return int.tryParse(digits);
}

int separateDecimalPlaces(double value) {
  if (value == null) return null;
  var valueSplitted = value.toString().split('.');

  if (valueSplitted.length < 2)
    return 0;
  else
    return int.parse(valueSplitted[1]);
}

String intListToString(List<int> list, {String delimiter: ''}) {
  return list.map((elem) => elem == null ? UNKNOWN_ELEMENT : elem).join(delimiter).trim();
}

String digitsToAlpha(String input, {int aValue: 0, bool removeNonDigits: true}) {
  if (input == null) return input;

  if (aValue == null) aValue = 0;

  if (removeNonDigits == null) removeNonDigits = false;

  final letters = Rotator().rotate(Rotator.defaultAlphabetAlpha, aValue);

  return input.split('').map((character) {
    var value = alphabet_09[character];

    if (value == null) if (removeNonDigits)
      return '';
    else
      return character;

    return letters[value];
  }).join();
}

String normalizeUmlauts(String input) {
  return input.split('').map((letter) {
    if (letter == String.fromCharCode(223)) //ß
      return 'ss';
    if (letter == String.fromCharCode(7838)) //Capital ß = ẞ
      return 'SS';

    var isLowerCase = letter == letter.toLowerCase();

    String out;
    switch (letter.toLowerCase().codeUnitAt(0)) {
      case 228: //ä
      case 230: //æ
        out = 'ae';
        break;
      case 246: //ö
        out = 'oe';
        break;
      case 252: //ü
        out = 'ue';
        break;
      default:
        out = letter;
    }

    return isLowerCase ? out : out.toUpperCase();
  }).join();
}

String removeAccents(String text) {
  String out = normalizeUmlauts(text);
  return removeDiacritics(out);
}

final RegExp reNonLetters = RegExp(r'[^A-Za-z]');

String removeNonLetters(String text) {
  return text.replaceAll(reNonLetters, '');
}

String insertCharacter(String text, int index, String character) {
  if (text == null || character == null) return text;

  if (index < 0) index = 0;

  if (index > text.length) index = text.length;

  return text.substring(0, index) + character + text.substring(index);
}

String insertSpaceEveryNthCharacter(String input, int n) {
  return insertEveryNthCharacter(input, n, ' ');
}

String insertEveryNthCharacter(String input, int n, String textToInsert) {
  if (n == null || n <= 0) return input; //TODO Exception

  String out = '';
  int i = 0;
  while (i < input.length) {
    if (input.length - i <= n) {
      out += input.substring(i);
      break;
    }

    out += input.substring(i, min(i + n, input.length)) + textToInsert;
    i += n;
  }

  return out;
}

String formatDaysToNearestUnit(double days) {
  var format = NumberFormat('0.00');

  if (days >= 365 * 1000000) return format.format(days / (365 * 1000000)) + ' Mio. a';
  if (days >= 365) return format.format(days / 365) + ' a';
  if (days >= 1) return format.format(days) + ' d';
  if (days >= 1 / 24) return format.format(days / (1 / 24)) + ' h';
  if (days >= 1 / 24 / 60) return format.format(days / (1 / 24 / 60)) + ' min';
  if (days >= 1 / 24 / 60 / 60) return format.format(days / (1 / 24 / 60 / 60)) + ' s';

  return format.format(days / (1 / 24 / 60 / 60 / 1000)) + ' ms';
}

DateTime hoursToHHmmss(double hours) {
  var h = hours.floor();
  var minF = (hours - h) * 60;
  var min = minF.floor();
  var secF = (minF - min) * 60;
  var sec = secF.floor();
  var milliSec = ((secF - sec) * 1000).round();

  return DateTime(0, 1, 1, h, min, sec, milliSec);
}

String formatHoursToHHmmss(double hours, {milliseconds: true, limitHours: true}) {
  if (hours == null) return null;
  var time = hoursToHHmmss(hours);

  var h = time.hour;
  var min = time.minute;
  var sec = time.second + time.millisecond / 1000.0;
  if (!limitHours) h += (time.day - 1) * 24 + (time.month - 1) * 31;

  var secondsStr = milliseconds ? NumberFormat('00.000').format(sec) : NumberFormat('00').format(sec.truncate());
  //Values like 59.999999999 may be rounded to 60.0. So in that case,
  //the greater unit (minutes or degrees) has to be increased instead
  if (secondsStr.startsWith('60')) {
    secondsStr = milliseconds ? '00.000' : '00';
    min += 1;
  }

  var minutesStr = min.toString().padLeft(2, '0');
  if (minutesStr.startsWith('60')) {
    minutesStr = '00';
    h += 1;
  }

  var hourStr = h.toString().padLeft(2, '0');

  return '$hourStr:$minutesStr:$secondsStr';
}

String formatDurationToHHmmss(Duration duration, {days: true, milliseconds: true, limitHours: true}) {
  if (duration == null) return null;

  var sign = duration.isNegative ? '-' : '';
  var _duration = duration.abs();
  var hours = days ? _duration.inHours.remainder(24) : _duration.inHours;
  var minutes = _duration.inMinutes.remainder(60);
  var seconds = _duration.inSeconds.remainder(60);
  var dayValue = limitHours ? _duration.inDays : _duration.inDays;

  var hourFormat = hours + (minutes / 60) + (seconds / 3600);

  return sign +
      (days ? dayValue.toString() + ':' : '') +
      formatHoursToHHmmss(hourFormat, milliseconds: milliseconds, limitHours: limitHours);
}

Map<U, T> switchMapKeyValue<T, U>(Map<T, U> map, {keepFirstOccurence: false}) {
  if (map == null) return null;

  var newMap = map;
  if (keepFirstOccurence) newMap = LinkedHashMap.fromEntries(map.entries.toList().reversed);

  return newMap.map((k, v) => MapEntry(v, k));
}

double degreesToRadian(double degrees) {
  return degrees * pi / 180.0;
}

double radianToDegrees(double radian) {
  return radian / pi * 180.0;
}

num modulo(num value, num modulator) {
  if (modulator <= 0.0) throw Exception("modulator must be positive");

  while (value < 0.0) value += modulator;

  return value % modulator;
}

bool doubleEquals(double a, double b, {double tolerance: 1e-10}) {
  if (a == null && b == null) return true;

  if (a == null || b == null) return false;

  return (a - b).abs() < tolerance;
}

bool isInteger(String text) {
  return BigInt.tryParse(text) != null;
}

// Copy from flutter/lib/foundation.dart;
// it includes dart:ui; this shouldn't be referenced in logic; so extracted this method
// for usage in logic
/// Returns the position of `value` in the `sortedList`, if it exists.
///
/// Returns `-1` if the `value` is not in the list. Requires the list items
/// to implement [Comparable] and the `sortedList` to already be ordered.
int binarySearch<T extends Comparable<Object>>(List<T> sortedList, T value) {
  int min = 0;
  int max = sortedList.length;
  while (min < max) {
    final int mid = min + ((max - min) >> 1);
    final T element = sortedList[mid];
    final int comp = element.compareTo(value);
    if (comp == 0) {
      return mid;
    }
    if (comp < 0) {
      min = mid + 1;
    } else {
      max = mid;
    }
  }
  return -1;
}

String applyAlphabetModification(String input, AlphabetModificationMode mode) {
  switch (mode) {
    case AlphabetModificationMode.J_TO_I:
      input = input.replaceAll('J', 'I');
      break;
    case AlphabetModificationMode.C_TO_K:
      input = input.replaceAll('C', 'K');
      break;
    case AlphabetModificationMode.W_TO_VV:
      input = input.replaceAll('W', 'VV');
      break;
    case AlphabetModificationMode.REMOVE_Q:
      input = input.replaceAll('Q', '');
      break;
  }

  return input;
}

bool isUpperCase(String letter) {
  if (letter == null || letter.length == 0) return false;
  if (letter == 'ß') return false;
  if (letter == 'ẞ') return true; // Capital ß

  return (letter.toUpperCase() == letter);
}

String colorToHexString(Color color) {
  return HexCode.fromRGB(RGB(color.red.toDouble(), color.green.toDouble(), color.blue.toDouble())).toString();
}

Color hexStringToColor(String hex) {
  RGB rgb = HexCode(hex).toRGB();
  return Color.fromARGB(255, rgb.red.floor(), rgb.green.floor(), rgb.blue.floor());
}

String removeDuplicateCharacters(String input) {
  if (input == null) return null;

  return input.split('').toSet().join();
}

bool hasDuplicateCharacters(String input) {
  if (input == null) return false;

  return input != removeDuplicateCharacters(input);
}

int countCharacters(String input, String characters) {
  if (input == null || characters == null) return 0;

  return input.replaceAll(RegExp('[^$characters]'), '').length;
}

bool allSameCharacters(String input) {
  if (input == null || input.isEmpty) return null;

  var firstCharacter = input[0];
  return input.replaceAll(firstCharacter, '').length == 0;
}

bool isOnlyLetters(String input) {
  if (input == null || input.isEmpty) return false;

  return removeAccents(input).replaceAll(RegExp(r'[A-Za-z]'), '').length == 0;
}

bool isOnlyNumerals(String input) {
  if (input == null || input.isEmpty) return false;

  return input.replaceAll(RegExp(r'[0-9]'), '').length == 0;
}

Uint8List trimNullBytes(Uint8List bytes) {
  if (bytes == null) return null;

  if (bytes.last != 0 && bytes.first != 0) return bytes;

  var tempList = List<int>.from(bytes);

  while (tempList.length > 0 && tempList.last == 0) tempList.removeLast();
  while (tempList.length > 0 && tempList.first == 0) tempList.removeAt(0);

  return Uint8List.fromList(tempList);
}

List<String> allCharacters() {
  var characters = <String>[];
  ALL_ALPHABETS.forEach((alphabet) {
    characters.addAll(alphabet.alphabet.keys);
  });
  return characters.toSet().toList();
}

dynamic round(double number, {int precision: 0}) {
  if (number == null) return null;

  if (precision == null || precision <= 0) return number.round();

  var exp = pow(10, precision);
  return (number * exp).round() / exp;
}

String removeControlCharacters(String input) {
  if (input == null || input.isEmpty)
    return input;

  var removedCodes = input.codeUnits.where((element) => element >= 32).toList();
  return String.fromCharCodes(removedCodes);
}

String normalizeCharacters(String input) {
  if (input == null || input.isEmpty)
    return input;

  final Map<String, String> _ALTERNATE_CHARACTERS = {
    // https://www.compart.com/de/unicode/category/Zs and Tab
    ' ': '\u0009\u000B\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2007\u2008\u2009\u200A\u202F\u205F\u3000',
    '"': '\u201e\u201f\u201d\u201c',
    '\'': '\u201b\u201a\u2019\u2018',
    '-': '\u2014\u2013\u02d7\u2212\u2012',
  };

  _ALTERNATE_CHARACTERS.forEach((key, value) {
    input = input.replaceAll(RegExp('[$value]'), key);
  });

  return input;
}
