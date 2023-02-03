import 'dart:collection';

String substitution(String input, Map<String, String> substitutions, {bool caseSensitive: true}) {
  if (input == null || input.length == 0) return '';

  if (!caseSensitive) {
    input = input.toUpperCase();
  }

  if (substitutions == null) return input;

  if (substitutions.keys.where((key) => key.length != 0).isEmpty) return input;

  List<String> keys = [];

  //Copy map to keep the original one
  var substCopy = {};
  substitutions.entries.forEach((entry) {
    if (entry.key.length == 0) return;

    if (caseSensitive) {
      substCopy.putIfAbsent(entry.key, () => entry.value);
    } else {
      substCopy.putIfAbsent(entry.key.toUpperCase(), () => entry.value.toUpperCase());
    }
  });

  substCopy.entries.forEach((entry) {
    var key = entry.key;
    if (!caseSensitive) key = key.toUpperCase();

    keys.add(key);
  });
  keys.sort((a, b) => b.length.compareTo(a.length));

  //SplayTreeMap is ordered by key
  var replacements = SplayTreeMap<int, String>();
  //find occurrences and replace them with ASCII-0 character
  //this ensures, that the input indexes remain but already considered patterns not occur twice
  //e.g.: ABBBA -> replace BB only should replace A_BB_BA and not also AB_BB_A
  //So find first -> replace it -> A__BA. Second occurrence not found anymore
  keys.forEach((key) {
    int i = 0;
    while (input.indexOf(key, i) >= 0) {
      var index = input.indexOf(key, i);
      replacements.putIfAbsent(index, () => key);

      input = input.replaceRange(index, index + key.length, String.fromCharCode(0) * key.length);

      i = index + key.length;
    }
  });

  //Unconsidered elements are put into the index map and the substitution map
  //The will be replaced by themselves.
  input.split('').asMap().forEach((index, character) {
    if (character != String.fromCharCode(0)) {
      replacements.putIfAbsent(index, () => character);
      substCopy.putIfAbsent(character, () => character);
    }
  });

  var output = '';
  replacements.entries.forEach((entry) {
    if (substCopy.containsKey(entry.value)) output += substCopy[entry.value];
  });

  return output;
}
