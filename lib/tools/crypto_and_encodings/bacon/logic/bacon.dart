import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

const _AZToBacon = {
  'A': 'AAAAA',
  'B': 'AAAAB',
  'C': 'AAABA',
  'D': 'AAABB',
  'E': 'AABAA',
  'F': 'AABAB',
  'G': 'AABBA',
  'H': 'AABBB',
  'J': 'ABAAA',
  'I': 'ABAAA',
  'K': 'ABAAB',
  'L': 'ABABA',
  'M': 'ABABB',
  'N': 'ABBAA',
  'O': 'ABBAB',
  'P': 'ABBBA',
  'Q': 'ABBBB',
  'R': 'BAAAA',
  'S': 'BAAAB',
  'T': 'BAABA',
  'V': 'BAABB',
  'U': 'BAABB',
  'W': 'BABAA',
  'X': 'BABAB',
  'Y': 'BABBA',
  'Z': 'BABBB',
};

// I has same code as J, so I replaces J in mapping; J will not occur in this map
// U has same code as V, so U replaces V in mapping; V will not occur in this map
final _BaconToAZ = switchMapKeyValue(_AZToBacon);

String encodeBacon(String input, bool inverse, bool binary) {
  if (input.isEmpty) return '';

  var out = input.toUpperCase().split('').map((character) {
    var bacon = _AZToBacon[character];
    return bacon ?? '';
  }).join();

  if (inverse) out = _inverseString(out);

  if (binary) {
    out = substitution(out, {'A': '0', 'B': '1'});
  }

  return out;
}

String decodeBacon(String input, bool invers, bool binary) {
  if (input.isEmpty) return '';

  if (binary) {
    input = input.toUpperCase().replaceAll(RegExp('[A-B]'), '');
    input = substitution(input, {'0': 'A', '1': 'B'});
  }

  input = input.toUpperCase().replaceAll(RegExp(r'[^A-B]'), '');
  if (invers) input = _inverseString(input);

  input = input.substring(0, input.length - (input.length % 5));

  var out = '';
  int i = 0;
  while (i < input.length) {
    out += _BaconToAZ[input.substring(i, i + 5)] ?? '';
    i += 5;
  }

  return out;
}

String _inverseString(String text) {
  return substitution(text, {'A': 'B', 'B': 'A'});
}
