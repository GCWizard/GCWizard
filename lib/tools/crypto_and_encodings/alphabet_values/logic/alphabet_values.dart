import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/constants.dart';

class AlphabetValues {
  late Map<String, String> _alphabet;

  AlphabetValues({Map<String, String>? alphabet}) {
    alphabet ??= alphabetAZ.alphabet;
    _alphabet = alphabet;
  }

  /*
  Because of: https://github.com/S-Man42/GCWizard/issues/102;
  WebVersion always generates SS for ß. That's because JavaScript's toUpperCase() does this.

  To avoid behaviour differences between Dart and JavaScript, here is a toUpperCase() function
  which makes everything upperCase except ß
   */
  String _toUpperCase(String text) {
    return text.split('').map((character) {
      if (character != '\u00DF') {
        //ß
        return character.toUpperCase();
      } else {
        return character;
      }
    }).join();
  }

  List<int?> textToValues(String text, {bool keepNumbers = false}) {
    var output = <int?>[];

    if (text.isEmpty) return output;

    text = _toUpperCase(text);

    var entries = _alphabet.entries.toList();

    if (keepNumbers) {
      var entryKeys = entries.map((e) => e.key).toList();
      for (var entry in alphabet_09.entries) {
        if (!entryKeys.contains(entry.key)) entries.add(MapEntry(entry.key, entry.value.toString()));
      }
    }

    entries.sort((a, b) {
      return b.key.length.compareTo(a.key.length);
    });

    var maxKeyLength = entries.first.key.length;

    while (text.isNotEmpty) {
      String? value;
      int i = 0;
      for (i = min(maxKeyLength, text.length); i >= 1; i--) {
        var entry = entries.firstWhereOrNull((entry) => entry.key == text.substring(0, i));
        if (entry != null) {
          value = entry.value;
          break;
        }
      }

      if (value == null) {
        output.add(null);
        text = text.substring(1);
      } else {
        value.split(',').forEach((v) {
          output.add(int.tryParse(v));
        });

        text = text.substring(i);
      }
    }

    return output;
  }

  String valuesToText(List<int> values) {
    var alphabetMap = switchMapKeyValue(_alphabet, keepFirstOccurence: true);

    return values
        .map((value) {
          var character = alphabetMap[value.toString()];
          return character ?? UNKNOWN_ELEMENT;
        })
        .toList()
        .join();
  }
}
