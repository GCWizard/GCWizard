import 'package:gc_wizard/tools/crypto_and_encodings/substitution/logic/substitution.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

enum BaconType { ORIGINAL, FULL }

const _AZToBaconOriginal = {
  'A': 'AAAAA',
  'B': 'AAAAB',
  'C': 'AAABA',
  'D': 'AAABB',
  'E': 'AABAA',
  'F': 'AABAB',
  'G': 'AABBA',
  'H': 'AABBB',
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
  'U': 'BAABB',
  'W': 'BABAA',
  'X': 'BABAB',
  'Y': 'BABBA',
  'Z': 'BABBB',
};

const _AZToBaconFull = {
  'A': 'AAAAA',
  'B': 'AAAAB',
  'C': 'AAABA',
  'D': 'AAABB',
  'E': 'AABAA',
  'F': 'AABAB',
  'G': 'AABBA',
  'H': 'AABBB',
  'I': 'ABAAA',
  'J': 'ABAAB',
  'K': 'ABABA',
  'L': 'ABABB',
  'M': 'ABBAA',
  'N': 'ABBAB',
  'O': 'ABBBA',
  'P': 'ABBBB',
  'Q': 'BAAAA',
  'R': 'BAAAB',
  'S': 'BAABA',
  'T': 'BAABB',
  'U': 'BABAA',
  'V': 'BABAB',
  'W': 'BABBA',
  'X': 'BABBB',
  'Y': 'BBAAA',
  'Z': 'BBAAB',
};

// I has same code as J, so I replaces J in mapping; J will not occur in this map
// U has same code as V, so U replaces V in mapping; V will not occur in this map
final _BaconOriginalToAZ = switchMapKeyValue(_AZToBaconOriginal);

final _BaconFullToAZ = switchMapKeyValue(_AZToBaconFull);

String encodeBacon(String input, {bool inverse = false, bool binary = false, BaconType type = BaconType.ORIGINAL}) {
  if (input.isEmpty) return '';

  var baconMap = type == BaconType.ORIGINAL ? _AZToBaconOriginal : _AZToBaconFull;
  var out = input.toUpperCase();
  if (type == BaconType.ORIGINAL) {
    out = out.replaceAll('V', 'U').replaceAll('J', 'I');
  }

  out = out.split('').map((character) {
    var bacon = baconMap[character];
    return bacon ?? '';
  }).join();

  if (inverse) out = _inverseString(out);

  if (binary) {
    out = substitution(out, {'A': '0', 'B': '1'});
  }

  return out;
}

String decodeBacon(String input, {bool inverse = false, bool binary = false, BaconType type = BaconType.ORIGINAL}) {
  if (input.isEmpty) return '';
// I has same code as J, so I replaces J in mapping; J will not occur in this map
// U has same code as V, so U replaces V in mapping; V will not occur in this map

  if (binary) {
    input = input.replaceAll(RegExp(r'[^01]'), '');
    input = substitution(input, {'0': 'A', '1': 'B'});
  }

  input = input.toUpperCase().replaceAll(RegExp(r'[^A-B]'), '');
  if (inverse) input = _inverseString(input);

  input = input.substring(0, input.length - (input.length % 5));

  var baconMap = type == BaconType.ORIGINAL ? _BaconOriginalToAZ : _BaconFullToAZ;

  var out = '';
  int i = 0;
  while (i < input.length) {
    out += baconMap[input.substring(i, i + 5)] ?? '';
    i += 5;
  }

  return out;
}

String _inverseString(String text) {
  return substitution(text, {'A': 'B', 'B': 'A'});
}

String analyzeBaconCodeWordwiseAlphabet(String code){
  List<String> listAM = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'];
  List<String> listNZ = ['N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  List<String> result = [];
  String codeWord = '';

  for (String word in code.toUpperCase().split(' ')) {
    if (word.isNotEmpty) {
      if (listAM.contains(word[0])) {
        codeWord = 'A';
      } else if (listNZ.contains(word[0])) {
        codeWord = 'B';
      } else {
        codeWord = '';
      }
      result.add(codeWord);
    }
  }
  return result.join('');
}

String analyzeBaconCodeWordwiseUpperLowerCase(String code){
  List<String> result = [];
  String codeWord = '';

  for (String word in code.split(' ')) {
    if (word.isNotEmpty) {
      if (65 <= word.codeUnitAt(0) && word.codeUnitAt(0) <= 90) {
        codeWord = 'A';
      } else {
        if (97 <= word.codeUnitAt(0) && word.codeUnitAt(0) <= 122) {
          codeWord = 'B';
        } else {
          codeWord = '';
        }
      }
      result.add(codeWord);
    }
  }
  return result.join('');
}

String analyzeBaconCodeLetterwiseAlphabet(String code){
  List<String> listAM = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'];
  List<String> listNZ = ['N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  List<String> result = [];
  String codeWord = '';

  for (String letter in code.toUpperCase().split('')) {
      if (listAM.contains(letter[0])) {
        codeWord = 'A';
      } else if (listNZ.contains(letter[0])) {
        codeWord = 'B';
      } else {
        codeWord = '';
      }
      result.add(codeWord);
  }
  return result.join('');
}

String analyzeBaconCodeLetterwiseUpperLowerCase(String code){
  List<String> result = [];
  String codeWord = '';

  for (String letter in code.split('')) {
      if (65 <= letter.codeUnitAt(0) && letter.codeUnitAt(0) <= 90) {
        codeWord = 'A';
      } else {
        if (97 <= letter.codeUnitAt(0) && letter.codeUnitAt(0) <= 122) {
          codeWord = 'B';
        } else {
          codeWord = '';
        }
      }
      result.add(codeWord);
  }
  return result.join('');
}