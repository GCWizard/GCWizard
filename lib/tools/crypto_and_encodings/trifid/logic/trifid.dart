import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';

class TrifidOutput {
  final String output;
  final String grid;

  TrifidOutput(this.output, this.grid);
}

TrifidOutput encryptTrifid(String input, int blockSize,
    {PolybiosMode mode = PolybiosMode.AZ09, required String alphabet}) {
  if (input.isEmpty) return TrifidOutput('', '');

  Map<String, String> EncodeMatrix = <String, String>{};
  Map<String, String> DecodeMatrix = <String, String>{};

  List<String> line1 = <String>[];
  List<String> line2 = <String>[];
  List<String> line3 = <String>[];
  List<String> result = <String>[];

  input = input.toUpperCase();
  alphabet = alphabet.toUpperCase();

  switch (mode) {
    case PolybiosMode.AZ09:
      alphabet = alphabet_AZ.keys.join() + '+';
      break;
    case PolybiosMode.ZA90:
      alphabet = alphabet_AZ.keys.toList().reversed.join() + '+';
      break;
    case PolybiosMode.CUSTOM:
      if (alphabet.length != 27) {
        return TrifidOutput('trifid_error_alphabet', '');
      } else if (incompleteCustomAlphabet(alphabet)) {
        return TrifidOutput('trifid_invalid_alphabet', '');
      }
      break;
    default:
      break;
  }
  EncodeMatrix = _buildEncodeMatrix(alphabet);
  DecodeMatrix = switchMapKeyValue(EncodeMatrix);
  for (int i = 0; i < input.length; i++) {
    line1.add(EncodeMatrix[input[i]]?[0] ?? '');
    line2.add(EncodeMatrix[input[i]]?[1] ?? '');
    line3.add(EncodeMatrix[input[i]]?[2] ?? '');
  }
  input = '';
  for (int i = 0; i < line1.length ~/ blockSize; i++) {
    input = input +
        line1.join('').substring(i * blockSize, i * blockSize + blockSize) +
        line2.join('').substring(i * blockSize, i * blockSize + blockSize) +
        line3.join('').substring(i * blockSize, i * blockSize + blockSize);
  }
  input = input +
      line1.join('').substring(line1.length ~/ blockSize * blockSize) +
      line2.join('').substring(line1.length ~/ blockSize * blockSize) +
      line3.join('').substring(line1.length ~/ blockSize * blockSize);

  for (int i = 0; i < input.length ~/ 3; i++) {
    result.add(DecodeMatrix[input.substring(i * 3, i * 3 + 3)] ?? '');
  }

  return TrifidOutput(result.join(''), _MatrixToString(alphabet));
}

TrifidOutput decryptTrifid(String input, int blockSize,
    {PolybiosMode mode = PolybiosMode.AZ09, required String alphabet}) {
  if (input.isEmpty) return TrifidOutput('', '');

  input = input.toUpperCase();
  alphabet = alphabet.toUpperCase();

  Map<String, String> EncodeMatrix = <String, String>{};
  Map<String, String> DecodeMatrix = <String, String>{};
  List<String> result = <String>[];
  String line1 = '';
  String line2 = '';
  String line3 = '';
  String tupel = '';
  String blockLine = '';

  switch (mode) {
    case PolybiosMode.AZ09:
      alphabet = alphabet_AZ.keys.join() + '+';
      break;
    case PolybiosMode.ZA90:
      alphabet = alphabet_AZ.keys.toList().reversed.join() + '+';
      break;
    case PolybiosMode.CUSTOM:
      if (alphabet.length != 27) {
        return TrifidOutput('trifid_error_alphabet', '');
      } else if (incompleteCustomAlphabet(alphabet)) {
        return TrifidOutput('trifid_invalid_alphabet', '');
      }
      break;
    default:
      break;
  }
  EncodeMatrix = _buildEncodeMatrix(alphabet);
  DecodeMatrix = switchMapKeyValue(EncodeMatrix);
  for (int i = 0; i < input.length; i++) {
    tupel = tupel + (EncodeMatrix[input[i]] ?? '');
  }
  for (int i = 0; i < tupel.length ~/ blockSize ~/ 3; i++) {
    blockLine = tupel.substring(i * blockSize * 3, i * blockSize * 3 + blockSize * 3);
    line1 = line1 + blockLine.substring(0, blockLine.length ~/ 3);
    line2 = line2 + blockLine.substring(blockLine.length ~/ 3, 2 * blockLine.length ~/ 3);
    line3 = line3 + blockLine.substring(2 * blockLine.length ~/ 3);
  }
  //blockLine = tupel.substring(line1.length ~/ blockSize * blockSize);
  blockLine = tupel.substring(line1.length * 3);
  line1 = line1 + blockLine.substring(0, blockLine.length ~/ 3);
  line2 = line2 + blockLine.substring(blockLine.length ~/ 3, 2 * blockLine.length ~/ 3);
  line3 = line3 + blockLine.substring(2 * blockLine.length ~/ 3);

  for (int i = 0; i < input.length; i++) {
    result.add(DecodeMatrix[line1[i] + line2[i] + line3[i]] ?? '');
  }

  return TrifidOutput(result.join(''), _MatrixToString(alphabet));
}

String _MatrixToString(String alphabet) {
  String result = '';
  result = result + '  |   1      |   2      |   3  \n';
  result = result + '  | 1 2 3    | 1 2 3    | 1 2 3\n';
  result = result + '--+------  --+------  --+------\n';
  result = result +
      '1 | ' +
      alphabet[0] +
      ' ' +
      alphabet[1] +
      ' ' +
      alphabet[2] +
      '  1 | ' +
      alphabet[9] +
      ' ' +
      alphabet[10] +
      ' ' +
      alphabet[11] +
      '  1 | ' +
      alphabet[18] +
      ' ' +
      alphabet[19] +
      ' ' +
      alphabet[20] +
      '\n';
  result = result +
      '2 | ' +
      alphabet[3] +
      ' ' +
      alphabet[4] +
      ' ' +
      alphabet[5] +
      '  2 | ' +
      alphabet[12] +
      ' ' +
      alphabet[13] +
      ' ' +
      alphabet[14] +
      '  2 | ' +
      alphabet[21] +
      ' ' +
      alphabet[22] +
      ' ' +
      alphabet[23] +
      '\n';
  result = result +
      '3 | ' +
      alphabet[6] +
      ' ' +
      alphabet[7] +
      ' ' +
      alphabet[8] +
      '  3 | ' +
      alphabet[15] +
      ' ' +
      alphabet[16] +
      ' ' +
      alphabet[17] +
      '  3 | ' +
      alphabet[24] +
      ' ' +
      alphabet[25] +
      ' ' +
      alphabet[26] +
      '\n';
  return result;
}

Map<String, String> _buildEncodeMatrix(String alphabet) {
  int j = 0;
  int x = 0;
  int y = 0;
  int z = 0;
  Map<String, String> result = <String, String>{};
  for (int i = 0; i < alphabet.length; i++) {
    j = i % 9;
    z = (i ~/ 9) + 1;
    x = j % 3 + 1;
    y = j ~/ 3 + 1;
    result[alphabet[i]] = z.toString() + y.toString() + x.toString();
  }
  return result;
}

bool incompleteCustomAlphabet(String alphabet) {
  String result = '';
  for (int j = 0; j < 26; j++) {
    if (alphabet[j] != '+') {
      result = result + alphabet[j];
    } else {
      for (int i = j + 1; i < 26; i++) {
        result = result + alphabet[i];
      }
      j = 26;
    }
  }
  alphabet = result;
  result = '';
  for (int i = 65; i < 92; i++) {
    for (int j = 0; j < alphabet.length; j++) {
      if (alphabet[j] != String.fromCharCode(i)) {
        result = result + alphabet[j];
      } else {
        for (int k = j + 1; k < alphabet.length; k++) {
          result = result + alphabet[k];
        }
        j = alphabet.length;
      }
    }
    alphabet = result;
    result = '';
  }
  return (alphabet.isNotEmpty);
}
