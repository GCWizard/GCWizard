import 'dart:collection';
import 'dart:typed_data';

import 'package:gc_wizard/utils/constants.dart';

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

String intListToString(List<int> list, {String delimiter: ''}) {
  return list.map((elem) => elem == null ? UNKNOWN_ELEMENT : elem).join(delimiter).trim();
}

Map<U, T> switchMapKeyValue<T, U>(Map<T, U> map, {keepFirstOccurence: false}) {
  if (map == null) return null;

  var newMap = map;
  if (keepFirstOccurence) newMap = LinkedHashMap.fromEntries(map.entries.toList().reversed);

  return newMap.map((k, v) => MapEntry(v, k));
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

Uint8List trimNullBytes(Uint8List bytes) {
  if (bytes == null) return null;

  if (bytes.last != 0 && bytes.first != 0) return bytes;

  var tempList = List<int>.from(bytes);

  while (tempList.length > 0 && tempList.last == 0) tempList.removeLast();
  while (tempList.length > 0 && tempList.first == 0) tempList.removeAt(0);

  return Uint8List.fromList(tempList);
}