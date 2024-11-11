//ported from https://www.geeksforgeeks.org/hill-cipher/

import 'dart:core';
import 'dart:core';
import 'dart:typed_data';

import 'package:gc_wizard/tools/science_and_technology/divisor/logic/divisor.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const _fillCharacter = 'X';
final ALPHABETS = [alphabetAZ];

StringText encryptText(String message, String key, int matrixSize, Alphabet alphabet) {
  message = removeNonLetters(message.toUpperCase());
  return _encryptHillCipher(message, key, matrixSize, alphabet.alphabet.length);
  // int n = key.length;
  // int padding = n - plaintext.length() % n;
  // if (padding != n) {
  //   plaintext += "X".repeat(padding);
  // }
}


// Following function generates the key matrix for the key string
List<Uint8List> _getKeyMatrix(String key, int matrixSize) {
  var keyMatrix = List<Uint8List>.generate(matrixSize, (index) => Uint8List(matrixSize));
  int k = 0;
  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < matrixSize; j++) {
      keyMatrix[i][j] = key.codeUnitAt(k) % 65;
      k++;
    }
  }
  return keyMatrix;
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

StringText _decryptHillCipher(String message, String key, int matrixSize, Alphabet alphabet) {
  // Get inverted key matrix from the key string
  var keyMatrix = _getKeyMatrix(key, matrixSize);
  var keyMatrixInverted = _matrixInvert(keyMatrix);
  if (keyMatrixInverted == null) return StringText('InvalidKey', '');
  var messageVector = List<Uint8List>.generate(matrixSize, (index) => Uint8List(1));

  // Generate vector for the message
  for (int i = 0; i < matrixSize; i++) {
    messageVector[i][0] = message.codeUnitAt(i) % 65;
  }

  // Following function generates the encrypted vector
  var cipherMatrix = _matrixMultiplication(keyMatrix, messageVector, alphabetLength);
  String cipherText = '';

  // Generate the encrypted text from the encrypted vector
  for (int i = 0; i < matrixSize; i++) {
    cipherText += String.fromCharCode(cipherMatrix[i][0] + 65);
  }

  return StringText('', cipherText);
}


// Function to implement Hill Cipher
StringText _encryptHillCipher(String message, String key, int matrixSize, int alphabetLength) {
  // Get key matrix from the key string
  var keyMatrix = _getKeyMatrix(key, matrixSize);
  var messageVector = List<Uint8List>.generate(matrixSize, (index) => Uint8List(1));

  // Generate vector for the message
  for (int i = 0; i < matrixSize; i++) {
    messageVector[i][0] = message.codeUnitAt(i) % 65;
  }

  // Following function generates the encrypted vector
  var cipherMatrix = _matrixMultiplication(keyMatrix, messageVector, alphabetLength);
  String cipherText = '';

  // Generate the encrypted text from the encrypted vector
  for (int i = 0; i < matrixSize; i++) {
    cipherText += String.fromCharCode(cipherMatrix[i][0] + 65);
  }
  var text = _validKeyMatrix(keyMatrix, alphabetLength) ? '' : 'InvalidKey';
  return StringText(text, cipherText);
}

bool _validKeyMatrix(List<Uint8List> keyMatrix, int alphabetLength) {
  var determinante = _matrixDeterminante(keyMatrix).toInt() % alphabetLength;
  var _divisors = divisors(alphabetLength);
  for (int i = 0; i < _divisors.length; i++) {
    if ((determinante % _divisors[i]) == 0) return false;
  }
  return true;
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