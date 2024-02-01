/// Class representing the result for breaking a vigenere cipher
/// :param str key: the best key found by the breaker
/// :param float fitness: the fitness of the resulting plaintext
class BreakerResult {
  List<int> key;
  double fitness;

  BreakerResult({
    required this.key,
    this.fitness = 0,
  });
}

BreakerResult break_vigenere(
    List<int> cipher_bin, int keyLength, List<List<int>> vigenereSquare, List<List<int>> bigrams, bool autoKey,
    {required void Function() counterFunction}) {
  if (autoKey) return break_vigenereAutoKey(cipher_bin, keyLength, vigenereSquare, bigrams);

  var key = <int>[];
  var best_fitness_0 = 0;
  var best_key_ch1_0 = 0;
  var best_key_ch1 = 0;
  var best_key_ch2 = 0;
  var best_fitness = 0;
  var prev_best_fitness = 0;
  var prev_best_key_ch2 = 0;

  for (var key_idx = 0; key_idx < keyLength; key_idx++) {
    best_fitness = 0;
    best_key_ch1 = 0;
    best_key_ch2 = 0;
    for (var key_ch1 = 0; key_ch1 < vigenereSquare.length; key_ch1++) {
      for (var key_ch2 = 0; key_ch2 < vigenereSquare.length; key_ch2++) {
        var fitness = 0;
        for (var text_idx = key_idx; text_idx < (cipher_bin.length - 1); text_idx += keyLength) {
          if (cipher_bin[text_idx] >= 0 && cipher_bin[text_idx + 1] >= 0) {
            var clear_ch1 = vigenereSquare[cipher_bin[text_idx]][key_ch1];
            var clear_ch2 = vigenereSquare[cipher_bin[text_idx + 1]][key_ch2];
            fitness += bigrams[clear_ch1][clear_ch2];
          }
        }
        if (fitness > best_fitness) {
          best_fitness = fitness;
          best_key_ch1 = key_ch1;
          best_key_ch2 = key_ch2;
        }
        counterFunction();
      }
    }
    if (key_idx == 0) {
      best_fitness_0 = best_fitness;
      best_key_ch1_0 = best_key_ch1;
      key.add(0); // just a placeholder
    } else {
      key.add((prev_best_fitness > best_fitness) ? prev_best_key_ch2 : best_key_ch1);
    }
    prev_best_fitness = best_fitness;
    prev_best_key_ch2 = best_key_ch2;
  }
  key[0] = (best_fitness > best_fitness_0) ? best_key_ch2 : best_key_ch1_0;

  return BreakerResult(key: key);
}

BreakerResult break_vigenereAutoKey(
    List<int> cipher_bin, int keyLength, List<List<int>> vigenereSquare, List<List<int>> bigrams) {
  var key = <int>[];
  var best_fitness_0 = 0;
  var best_key_ch1_0 = 0;
  var best_key_ch1 = 0;
  var best_key_ch2 = 0;
  var best_fitness = 0;
  var prev_best_fitness = 0;
  var prev_best_key_ch2 = 0;

  for (var key_idx = 0; key_idx < keyLength; key_idx++) {
    best_fitness = 0;
    best_key_ch1 = 0;
    best_key_ch2 = 0;
    for (var key_ch1 = 0; key_ch1 < vigenereSquare.length; key_ch1++) {
      for (var key_ch2 = 0; key_ch2 < vigenereSquare.length; key_ch2++) {
        var fitness = 0;
        var autoKey = List<int>.filled(cipher_bin.length + keyLength, -1);
        for (var text_idx = key_idx; text_idx < (cipher_bin.length - 1); text_idx += keyLength) {
          if (cipher_bin[text_idx] >= 0 && cipher_bin[text_idx + 1] >= 0) {
            var clear_ch1 = 0;
            var clear_ch2 = 0;
            if (text_idx < keyLength) {
              clear_ch1 = vigenereSquare[cipher_bin[text_idx]][key_ch1];
              clear_ch2 = vigenereSquare[cipher_bin[text_idx + 1]][key_ch2];
            } else {
              clear_ch1 = vigenereSquare[cipher_bin[text_idx]][autoKey[text_idx]];
              clear_ch2 = vigenereSquare[cipher_bin[text_idx + 1]][autoKey[text_idx + 1]];
            }
            autoKey[text_idx + keyLength] = clear_ch1;
            autoKey[text_idx + 1 + keyLength] = clear_ch2;
            fitness += bigrams[clear_ch1][clear_ch2];
          }
        }
        if (fitness > best_fitness) {
          best_fitness = fitness;
          best_key_ch1 = key_ch1;
          best_key_ch2 = key_ch2;
        }
      }
    }
    if (key_idx == 0) {
      best_fitness_0 = best_fitness;
      best_key_ch1_0 = best_key_ch1;
      key.add(0); // just a placeholder
    } else {
      key.add((prev_best_fitness > best_fitness) ? prev_best_key_ch2 : best_key_ch1);
    }
    prev_best_fitness = best_fitness;
    prev_best_key_ch2 = best_key_ch2;
  }
  key[0] = (best_fitness > best_fitness_0) ? best_key_ch2 : best_key_ch1_0;

  return BreakerResult(key: key);
}

/// Implements an iterator for a given text string
/// :param str txt: the text string to process
/// :param str alphabet: the alphabet to apply with this text string
/// :return: an iterator which iterates over all characters of the text string which are present in the alphabet.
Iterable<int> iterateText(String text, String alphabet, {bool ignoreNonLetters = true}) sync* {
  var trans = alphabet.toLowerCase();
  int index = -1;

  text = text.toLowerCase();
  for (int i = 0; i < text.length; i++) {
    index = trans.indexOf(text[i]);
    if (index >= 0) {
      yield index;
    } else if (!ignoreNonLetters) {
      yield -1;
    }
  }
}
