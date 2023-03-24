part of 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/substitution_breaker/logic/substitution_logic_aggregator.dart';

/// Basic functions for encoding/decoding substitution ciphers with a given key
class BreakerKey {
  /*
   The first character of the alphabet corresponds to the first character of the
  key, the second character of the alphabet to the second character of the key,
  and so on. The alphabet can consist of any characters (including e.g.
  umlauts), and the length is variable, i.e., it is not restricted to the 26 letters
  of the alphabet.

  :example:
      Alphabet: abcdefghijklmnopqrstuvwxyz
      Key:      zebrascdfghijklmnopqtuvwxy

  The letter "a" from the plaintext maps to "z" in the ciphertext, "b" to "e",
  and so on. Thus the plaintext "flee at once. we are discovered!" is enciphered
  as "siaa zq lkba. va zoa rfpbluaoar!"

  This example was taken from Wikipedia <https://en.wikipedia.org/wiki/Substitution_cipher>
  */

  String? _alphabet;
  String? _key;
  Map<String, String>? _encode;
  Map<String, String>? _decode;

  /// Uses a key and an alphabet for transcoding substitution ciphers.
  /// :param key: The key to use. Must have the same length than alphabet. (It is case insensitive.)
  /// :param str alphabet: The set of characters which define the alphabet.
  ///         Characters which are not in the alphabet will be ignored when transcoding.
  BreakerKey(String key, {String alphabet = DEFAULT_ALPHABET}) {
    _alphabet = check_alphabet(alphabet);
    if (_alphabet == null) return;
    _key = check_key(key, _alphabet!);
    if (_key == null) return;

    var camel_key = (key.toUpperCase() + key.toLowerCase()).split('').toList();
    var camel_alphabet = (alphabet.toUpperCase() + alphabet.toLowerCase()).split('').toList();
    _encode = _maketrans(camel_alphabet, camel_key);
    _decode = _maketrans(camel_key, camel_alphabet);
  }

  /// Checks an alphabet for consistency
  /// :param alphabet: the alphabet to check
  /// return: the alphabet in normalized form (i.e., in lower cases)
  ///      null -> alphabet is invalid
  static String? check_alphabet(String alphabet) {
    if (alphabet.isEmpty) return null;
    alphabet = alphabet.toLowerCase();
    if (alphabet.length != _set(alphabet).length) {
      return null;
    }
    return alphabet;
  }

  /// Checks a key for consistency against a given alphabet
  /// :param key: the key to be validated
  /// :param alphabet: the alphabet against which the key is validated
  /// return: the validated key in normalized form (i.e., in lower cases)
  ///      null -> key is invalid
  static String? check_key(String key, String alphabet) {
    if (key.isEmpty) return null;
    key = key.toLowerCase();
    if (key.length != _set(key).length) {
      return null;
    }

    if (key.length != alphabet.length) {
      return null;
    }

    key.split('').map((char) => alphabet.contains(char));

    return key;
  }

  /// Decodes a ciphertext with the given key into the plaintext
  /// param ciphertext: the ciphertext to decode with the given key
  /// :return: the resulting plaintext
  String? decode(String ciphertext) {
    if (_decode == null) return null;
    return substitution(ciphertext, _decode!);
  }

  /// Encodes a plaintext with the given key into the ciphertext
  /// :param plaintext: the plaintext to encode with the given key
  /// :return: the resulting ciphertext
  String? encode(String plaintext) {
    if (_encode == null) return null;
    return substitution(plaintext, _encode!);
  }

  /// Decodes ciphertext read from the given file handle
  /// :param ciphertext_fh: the file handle the ciphertext is read from.
  /// :param plaintext_fh: the file handle the resulting plaintext is written to.
  void decode_file(String ciphertext, File plaintext_fh) {
    ciphertext.split('\n').forEach((line) {
      plaintext_fh.writeAsString(decode(line) ?? '');
    });
  }

  /// Encodes plaintext read from the given file handle
  /// :param plaintext_fh: the file handle the plaintext is read from.
  /// :param ciphertext_fh: the file handle the resulting ciphertext is written to.
  void encode_file(String plaintext, File ciphertext_fh) {
    plaintext.split('\n').forEach((line) {
      ciphertext_fh.writeAsString(encode(line) ?? '');
    });
  }

  static Map<String, String> _maketrans(List<String> keyList, List<String> valueList) {
    Map<String, String> map = {};
    for (int i = keyList.length - 1; i >= 0; i--) {
      map.putIfAbsent(keyList[i], () => valueList[i]);
    }

    return map;
  }

  /// remove double characters
  static String _set(String text) {
    return text.split('').toSet().join();
  }
}
