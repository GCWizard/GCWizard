//ported from https://www.geeksforgeeks.org/hill-cipher/

import 'dart:core';
import 'dart:core';
import 'dart:typed_data';

import 'package:gc_wizard/utils/string_utils.dart';

String encryptText(String message, String key) {
  message = removeNonLetters(message.toUpperCase());
  return _hillCipher(message, key);
  // int n = key.length;
  // int padding = n - plaintext.length() % n;
  // if (padding != n) {
  //   plaintext += "X".repeat(padding);
  // }
}


// Following function generates the key matrix for the key string
List<Uint8List> _getKeyMatrix(String key) {
  var keyMatrix = List<Uint8List>.generate(3, (index) => Uint8List(3));
  int k = 0;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      keyMatrix[i][j] = key.codeUnitAt(k) % 65;
      k++;
    }
  }
  return keyMatrix;
}

// Following function encrypts the message
List<Uint8List> _matrix_multiplication(List<Uint8List> keyMatrix, List<Uint8List> messageVector) {
  var matrixSize = keyMatrix.length;
  var resultMatrix = List<Uint8List>.generate(matrixSize, (index) => Uint8List(1));

  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < 1; j++) {
      var tmpValue = 0;
      for (int x = 0; x < matrixSize; x++) {
        tmpValue += keyMatrix[i][x] * messageVector[x][j];
      }
      resultMatrix[i][j] = tmpValue % 26;
    }
  }
  return resultMatrix;
}

List<Uint8List>? _invertMatrix(List<Uint8List> matrix) {
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

    if (augmented[i][i].abs() < 1e-10) {
      return null;
    }

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


// Function to implement Hill Cipher
String _hillCipher(String message, String key) {
  // Get key matrix from the key string
  var keyMatrix = _getKeyMatrix(key);
  var messageVector = List<Uint8List>.generate(3, (index) => Uint8List(1));

  // Generate vector for the message
  for (int i = 0; i < 3; i++) {
    messageVector[i][0] = message.codeUnitAt(i) % 65;
  }

  // Following function generates the encrypted vector
  var cipherMatrix = _matrix_multiplication(keyMatrix, messageVector);

  String cipherText = '';

  // Generate the encrypted text from the encrypted vector
  for (int i = 0; i < 3; i++) {
    cipherText += String.fromCharCode(cipherMatrix[i][0] + 65);
  }

  return cipherText;
}