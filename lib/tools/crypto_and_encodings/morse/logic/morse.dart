import 'package:gc_wizard/utils/collection_utils.dart';

final AZToMorse = {
  'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.', 'G': '--.', 'H': '....', 'I': '..',
  'J': '.---', 'K': '-.-', 'L': '.-..', 'M': '--',
  'N': '-.', 'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-', 'U': '..-', 'V': '...-',
  'W': '.--', 'X': '-..-', 'Y': '-.--', 'Z': '--..',
  '1': '.----', '2': '..---', '3': '...--', '4': '....-', '5': '.....', '6': '-....', '7': '--...', '8': '---..',
  '9': '----.', '0': '-----',
  String.fromCharCode(197): '.--.-', //Å
  String.fromCharCode(192): '.--.-', //À
  String.fromCharCode(196): '.-.-', //Ä
  String.fromCharCode(200): '.-..-', //È
  String.fromCharCode(201): '..-..', //É
  String.fromCharCode(214): '---.', //Ö
  String.fromCharCode(220): '..--', //Ü
  String.fromCharCode(223): '...--..', //ß
  String.fromCharCode(209): '--.--', //Ñ
  'CH': '----', '.': '.-.-.-', ',': '--..--', ':': '---...', ';': '-.-.-.', '?': '..--..', '@': '.--.-.',
  '-': '-....-', '_': '..--.-', '(': '-.--.', ')': '-.--.-', '\'': '.----.', '=': '-...-', '+': '.-.-.', '/': '-..-.',
  '!': '-.-.--'
};

// Å has same code as À, so À replaces Å in mapping; Å will not occur in this map
final MorseToAZ = switchMapKeyValue(AZToMorse);

String encodeMorse(String input) {
  if (input == null || input == '') return '';

  return input.toUpperCase().split('').map((character) {
    if (character == ' ') return '|';

    var morse = AZToMorse[character];
    return morse != null ? morse : '';
  }).join(String.fromCharCode(8195)); // using wide space
}

String decodeMorse(String input) {
  if (input == null || input == '') return '';

  return input.split(RegExp(r'[^\.\-/\|]')).map((morse) {
    if (morse == '|' || morse == '/') return ' ';

    var character = MorseToAZ[morse];
    return character != null ? character : '';
  }).join();
}
