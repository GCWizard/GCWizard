//ported from https://www.geeksforgeeks.org/hill-cipher/

import 'dart:core';
import 'dart:typed_data';

import 'package:gc_wizard/tools/science_and_technology/divisor/logic/divisor.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const _fillCharacter = 'X';
final ALPHABETS = [alphabetAZ, alphabetAZ0, alphabetAZ09];

const Alphabet alphabetAZ0 = Alphabet(key: 'alphabet_name_az0', type: AlphabetType.STANDARD, alphabet: {
  'A': '0', 'B': '1', 'C': '2', 'D': '3', 'E': '4', 'F': '5', 'G': '6', 'H': '7', 'I': '8', 'J': '9', 'K': '10',
  'L': '11', 'M': '12', 'N': '13', 'O': '14', 'P': '15', 'Q': '16', 'R': '17', 'S': '18', 'T': '19', 'U': '20',
  'V': '21', 'W': '22', 'X': '23', 'Y': '24', 'Z': '25'});

const Alphabet alphabetAZ09 = Alphabet(key: 'alphabet_name_az09', type: AlphabetType.STANDARD, alphabet: {
  'A': '0', 'B': '1', 'C': '2', 'D': '3', 'E': '4', 'F': '5', 'G': '6', 'H': '7', 'I': '8', 'J': '9', 'K': '10',
  'L': '11', 'M': '12', 'N': '13', 'O': '14', 'P': '15', 'Q': '16', 'R': '17', 'S': '18', 'T': '19', 'U': '20',
  'V': '21', 'W': '22', 'X': '23', 'Y': '24', 'Z': '25',
  '0': '26', '1': '27', '2': '28', '3': '29', '4': '30', '5': '31', '6': '32', '7': '33', '8': '34', '9': '35'});

StringText encryptText(String message, String key, int matrixSize, Alphabet alphabet) {
  message = removeNonLetters(message.toUpperCase());
  key = removeNonLetters(key.toUpperCase());
  return _encryptHillCipher(message, key, matrixSize, alphabet);
  // int n = key.length;
  // int padding = n - plaintext.length() % n;
  // if (padding != n) {
  //   plaintext += "X".repeat(padding);
  // }
}

StringText _decryptHillCipher(String message, String key, int matrixSize, Alphabet alphabet) {
  if (key.isEmpty) {
    return StringText('KeyEmpty', '');
  }
  // Get inverted key matrix from the key string
  var keyMatrix = _getKeyMatrix(key, matrixSize, alphabet);
  var keyMatrixInverted = _matrixInvert(keyMatrix);
  if (keyMatrixInverted == null) return StringText('InvalidKey', '');
  var messageVector = List<Uint8List>.generate(matrixSize, (index) => Uint8List(1));

  // Generate vector for the message
  for (int i = 0; i < matrixSize; i++) {
    messageVector[i][0] = _charToValue(message[i], alphabet.alphabet);
  }

  // Following function generates the encrypted vector
  var cipherMatrix = _matrixMultiplication(keyMatrix, messageVector, alphabet.alphabet.length);
  String cipherText = '';
  var alphabetMap = switchMapKeyValue(alphabet.alphabet);

  // Generate the encrypted text from the encrypted vector
  for (int i = 0; i < matrixSize; i++) {
    cipherText += _valueToChar(cipherMatrix[i][0], alphabetMap);
  }

  var text = _validKeyMatrix(keyMatrix, alphabet.alphabet.length) ? '' : 'InvalidKey';
  return StringText(text, cipherText);
}

// Function to implement Hill Cipher
StringText _encryptHillCipher(String message, String key, int matrixSize, Alphabet alphabet) {
  if (key.isEmpty) {
    return StringText('KeyEmpty', '');
  }
  // Get key matrix from the key string
  var keyMatrix = _getKeyMatrix(key, matrixSize, alphabet);
  var messageVector = List<Uint8List>.generate(matrixSize, (index) => Uint8List(1));
  var cipherMatrix = Uint8List(message.length);
  var k = 0;

  do {
    // Generate vector for the message
    for (int i = 0; i < matrixSize; i++) {
      messageVector[i][0] = _charToValue(k + i < message.length
          ? message[k + i]
          : _fillCharacter, alphabet.alphabet); //alphabet.alphabet.keys.last'
    }

    // Following function generates the encrypted vector
    _matrixMultiplication(keyMatrix, messageVector, alphabet.alphabet.length).forEach((value) {
      if (k < cipherMatrix.length) cipherMatrix[k] = value[0];
      k++;
    });
  } while (k < message.length);

  String cipherText = '';
  var alphabetMap = switchMapKeyValue(alphabet.alphabet);

  // Generate the encrypted text from the encrypted vector
  for (int i = 0; i < cipherMatrix.length; i++) {
    cipherText += _valueToChar(cipherMatrix[i], alphabetMap);
  }
  var text = _validKeyMatrix(keyMatrix, alphabet.alphabet.length) ? '' : 'InvalidKey';
  return StringText(text, cipherText);
}

// Following function generates the key matrix for the key string
List<Uint8List> _getKeyMatrix(String key, int matrixSize, Alphabet alphabet) {
  var keyMatrix = List<Uint8List>.generate(matrixSize, (index) => Uint8List(matrixSize));
  int k = 0;
  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < matrixSize; j++) {
      keyMatrix[i][j] = _charToValue(k < key.length ? key[k]
          : alphabet.alphabet.keys.elementAt(k - key.length), alphabet.alphabet);
      k++;
    }
  }
  print(keyMatrix);
  return keyMatrix;
}

int _charToValue(String char, Map<String, String> alphabet) {
  var value = alphabet[char.toUpperCase()];
  return value == null ? -1 : int.parse(value);
}

String _valueToChar(int value, Map<String, String> alphabet) {
  var char = alphabet[value.toString()];
  return char ?? UNKNOWN_ELEMENT;
}

bool _validKeyMatrix(List<Uint8List> keyMatrix, int alphabetLength) {
  return true;
  var determinante = _matrixDeterminante(keyMatrix).toInt() % alphabetLength;
  var _divisors = divisors(alphabetLength);
  _divisors.remove(1);
  _divisors.remove(alphabetLength);
  for (int i = 0; i < _divisors.length; i++) {
    if ((determinante % _divisors[i]) == 0) return false;
  }
  return true;
}

// Following function encrypts the message
List<Uint8List> _matrixMultiplication(List<Uint8List> keyMatrix, List<Uint8List> messageVector, int alphabetLength) {
  var matrixSize = keyMatrix.length;
  var resultMatrix = List<Uint8List>.generate(matrixSize, (index) => Uint8List(1));

  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < 1; j++) {
      var tmpValue = 0;
      for (int x = 0; x < matrixSize; x++) {
        tmpValue += keyMatrix[i][x] * messageVector[x][j];
      }
      resultMatrix[i][j] = tmpValue % alphabetLength;
    }
  }
  return resultMatrix;
}

List<Uint8List>? _matrixInvert(List<Uint8List> matrix) {
  int n = matrix.length;
  var augmented = List<List<double>>.generate(n, (index) => List<double>.filled(n * 2, 0));

  // Initialize augmented matrix with the input matrix and the identity matrix
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      augmented[i][j] = matrix[i][j].toDouble();
      augmented[i][j + n] = (i == j) ? 1 : 0;
    }
  }

  // Apply Gaussian elimination
  for (int i = 0; i < n; i++) {
    int pivotRow = i;
    for (int j = i + 1; j < n; j++) {
      if (augmented[j][i].abs() > (augmented[pivotRow][i].abs())) {
        pivotRow = j;
      }
    }

    if (pivotRow != i) {
      for (int k = 0; k < 2 * n; k++) {
        double temp = augmented[i][k];
        augmented[i][k] = augmented[pivotRow][k];
        augmented[pivotRow][k] = temp;
      }
    }

    if (augmented[i][i].abs() < 1e-10) return null;

    var pivot = augmented[i][i];
    for (int j = 0; j < 2 * n; j++) {
      augmented[i][j] /= pivot;
    }

    for (int j = 0; j < n; j++) {
      if (j != i) {
        var factor = augmented[j][i];
        for (int k = 0; k < 2 * n; k++) {
          augmented[j][k] -= factor * augmented[i][k];
        }
      }
    }
  }

  var result = List<Uint8List>.generate(n, (index) => Uint8List(n));
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      result[i][j] = augmented[i][j + n].toInt() % 26;
    }
  }

  return result;
}

double _matrixDeterminante(List<Uint8List> matrix) {
  int n = matrix.length;
  var matrixD = List<List<double>>.generate(n, (rowIndex) =>
    List<double>.generate(matrix[rowIndex].length, (columnIndex) => matrix[rowIndex][columnIndex].toDouble()));

  for (int i = 0; i < n; i++) {
    if (matrixD[i][i] == 0) {
      for (int row = i; row < n; row++) {
        if (matrixD[i][row] != 0) { //flip row
          for (int k = 0; k < n; k++) {
            double tmp = matrixD[k][i];
            matrixD[k][i] = matrixD[k][row];
            matrixD[k][row] = tmp;
          }
        }
      }
    }
    if (matrixD[i][i] == 0) continue;
    for (int j = i + 1; j < n; j++) {
      //generate 0s by addition
      double faktor = -matrixD[j][i] / matrixD[i][i];
      for (int k = 0; k < n; k++) {
        matrixD[j][k] += faktor * matrixD[i][k];
      }
    }
  }
  double result = 1;
  for (int i = 0; i < n; i++) {
    result *= matrixD[i][i];
  }
  return result;
}