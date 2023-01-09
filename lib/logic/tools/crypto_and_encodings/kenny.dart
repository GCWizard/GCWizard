import 'package:gc_wizard/logic/tools/crypto_and_encodings/substitution.dart';
import 'package:gc_wizard/logic/tools/science_and_technology/numeral_bases.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/common_utils.dart';

/*
 * Main idea of algorithm:
 * Kenny's Code works as follows: mmm, mmp, mmf, mpm, mpp, mpf, mfm, mfp, mff, pmm, ...
 * If you changed m = 0, p = 1, f = 2, you'd simply get 0, 1, 2, 10, 11, 12, 20, 21, 22, 100, ...
 * which equals the numeral system based 3.
 *
 * So it makes sense to convert the letters in to the integer values. These can be converted
 * into decimal system, which results in 0, 1, 2, 3, 4, 5, 6, 7, 8...
 * These values can be converted into their alphabet values (adding +1, naturally).
 */

encryptKenny(String input, List<String> replaceCharacters, bool caseSensitive) {
  if (input == null || input.length == 0) return '';

  if (replaceCharacters == null || replaceCharacters.length < 3) return '';

  Map<String, String> substitutions = {};
  for (int i = 0; i <= 2; i++) {
    substitutions.putIfAbsent(i.toString(), () => replaceCharacters[i]);
  }

  input = normalizeUmlauts(input);

  var output = '';
  RegExp regExp = RegExp(r'[A-Za-z]');
  input.split('').forEach((letter) {
    if (!letter.startsWith(regExp)) {
      output += letter;
      return;
    }
    var value = convertBase((alphabet_AZ[letter.toUpperCase()] - 1).toString(), 10, 3).padLeft(3, '0');
    value = substitution(value, substitutions);
    if (caseSensitive) {
      if (isUpperCase(letter))
        value = value[0].toUpperCase() + value.substring(1).toLowerCase();
      else
        value = value.toLowerCase();
    }
    output += value;
  });
  return output;
}

/*
 * For decoding, the method searches for valid letter triples. mmam wouldn't be valid, for example,
 * these letter will be ignored.
 * If theres a valid triple found, it will be converted in the way decribed above.
 *
 * The main problem is, that the Kenny key mustn't be m, p and f, but can be any string you like.
 *
 * First problem: What if key is mpf, but you get this input: mmm1ppp2:
 * This won't be recognized as 000 1 111 2, but as valid triples 000 111 12, which in fact is wrong.
 * For this reason, the key string will not be substituted with 012 but with non-writeable characters
 * in the first step - to be able to differ the "wrong" characters in input. The final substitution
 * comes later, when all chunks (triples) are identified.
 *
 * Second problem: What if the key is ma, ab, xy? This mustn't be a huge problem at the first glance,
 * since these strings would be substituted the same way as the single letters. But now think about
 * the case sensitivity: Input MaMaMa could be case sensitive. What about mAmAmA? Or MAMAMA. What if
 * the key itself would be Ma instead of ma. Or mA? It becomes even more complex if the key gets more
 * characters...
 * For this single - and, to be honest, absolutely rare case - the function grows that nasty size. So:
 * TODO: Find more readable algorithm
 */
decryptKenny(String input, List<String> replaceCharacters, bool caseSensitive) {
  if (input == null || input.length == 0) return '';

  if (replaceCharacters == null || replaceCharacters.length < 3) return '';

  var replaceToCharacters = [String.fromCharCode(0), String.fromCharCode(1), String.fromCharCode(2)];

  Map<String, String> substitutions = {};
  Map<String, String> substitutionsSwitched = {};
  Map<String, String> integerSubstitutions = {};

  // build substitutions:
  // 1. the key characters/string (default: m, p, f) to non-writeable characters
  // 2. non-writeable characters to 012 for numeral system step later
  for (int i = 0; i <= 2; i++) {
    substitutions.putIfAbsent(replaceCharacters[i], () => replaceToCharacters[i]);
    integerSubstitutions.putIfAbsent(replaceToCharacters[i], () => i.toString());
  }

  // substitute key characters/string with non-writeable characters
  var _input = substitution(input, substitutions, caseSensitive: false);
  int chunkStart = 0; // start position of chunk in the original text
  int chunkOffset = 0; // position in the chunk
  substitutionsSwitched = switchMapKeyValue(substitutions);

  var output = '';
  // Go through input string.
  // if you find a non-writeable character (== a key character), add it to chunk
  // if not, simply add the current chunk to output
  // if chunk length is 3 (found triple) -> convert it into a letter using the numerals system approach
  while (_input.length > 0) {
    var chunk = '';
    chunkStart += chunkOffset;
    chunkOffset = 0;
    while (chunk.length < 3 && _input.length > 0) {
      var character = _input[0];
      // add valid character to chunk
      if (replaceToCharacters.contains(character)) {
        chunk += character;
        // add length of the key
        chunkOffset += substitutionsSwitched[character].length;
      } else {
        // if not valid
        // restore the chunk to the original text
        var outputTmp =
            _restoreChunks(chunk + input[chunkStart + chunkOffset], input, chunkStart, substitutionsSwitched);
        output += outputTmp;
        chunk = '';
        chunkOffset = 0;
        // note the position in the original text
        chunkStart += outputTmp.length;
      }

      _input = _input.substring(1);
    }

    // when chunk length reaches 3, convert it.
    if (chunk.length == 3) {
      var index = int.tryParse(convertBase(substitution(chunk, integerSubstitutions), 3, 10));
      if (index < 26) {
        var outputChar = alphabet_AZIndexes[index + 1];
        if (caseSensitive) {
          // first character in the original lower case ?
          if (!isUpperCase(input[chunkStart]))
            // char to lower case
            outputChar = outputChar.toLowerCase();
        }
        output += outputChar;
        continue;
      }
    }

    var outputTmp = substitution(chunk, substitutionsSwitched);
    for (int i = 0; i < outputTmp.length; i++) output += input[chunkStart + i];
  }
  // restore unused chunks to the original text
  output = _restoreChunks(output + _input, input, 0, substitutionsSwitched);
  if (!caseSensitive) output = output.toUpperCase();

  return output;
}

// this is used to track the original characters and their lower/upper case state
// in case the current chunk is not a valid decodeable triple, the original data needs to
// be restored
String _restoreChunks(String chunk, String input, int position, Map<String, String> substitutionsSwitched) {
  var output = '';
  for (int i = 0; i < chunk.length; i++) {
    // key character ?
    if (substitutionsSwitched.containsKey(chunk[i])) {
      // restore original text
      output += input.substring(position, position + substitutionsSwitched[chunk[i]].length);
      // note the position in the original text
      position += substitutionsSwitched[chunk[i]].length;
    } else
      output += chunk[i];
    // note the position in the original text
    position += chunk[i].length;
  }
  return output;
}
