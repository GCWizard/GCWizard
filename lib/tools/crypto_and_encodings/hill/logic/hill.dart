//ported from https://www.geeksforgeeks.org/hill-cipher/

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
  var resultMatrix = List<Uint8List>.generate(3, (index) => Uint8List(1));

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 1; j++) {
      var tmpValue = 0;
      for (int x = 0; x < 3; x++) {
        tmpValue += keyMatrix[i][x] * messageVector[x][j];
      }
      resultMatrix[i][j] = tmpValue % 26;
    }
  }
  return resultMatrix;
}

List<Uint8List>? inverse3x3Matrix(List<Uint8List> matrix) {
  if (matrix.length != 3) return null;
  var determinant = determinant3x3Matrix(matrix);
  if (determinant == 0) return null; // matrix is not invertible

  double invDet = 1 / determinant;

  return [
    Uint8List.fromList([
      (invDet * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])).toInt() % 26,
      (invDet * (matrix[0][2] * matrix[2][1] - matrix[0][1] * matrix[2][2])).toInt() % 26,
      (invDet * (matrix[0][1] * matrix[1][2] - matrix[0][2] * matrix[1][1])).toInt() % 26,
    ]),
    Uint8List.fromList([
      (invDet * (matrix[1][2] * matrix[2][0] - matrix[1][0] * matrix[2][2])).toInt() % 26,
      (invDet * (matrix[0][0] * matrix[2][2] - matrix[0][2] * matrix[2][0])).toInt() % 26,
      (invDet * (matrix[0][2] * matrix[1][0] - matrix[0][0] * matrix[1][2])).toInt() % 26,
    ]),
    Uint8List.fromList([
      (invDet * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])).toInt() % 26,
      (invDet * (matrix[0][1] * matrix[2][0] - matrix[0][0] * matrix[2][1])).toInt() % 26,
      (invDet * (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0])).toInt() % 26,
    ]),
  ];
}

int determinant3x3Matrix(List<Uint8List> matrix) {
  return
      matrix[0][0] * matrix[1][1] * matrix[2][2] +
      matrix[0][1] * matrix[1][2] * matrix[2][0] +
      matrix[0][2] * matrix[1][0] * matrix[2][1] -
      matrix[2][0] * matrix[1][1] * matrix[0][2] -
      matrix[2][1] * matrix[1][2] * matrix[0][0] -
      matrix[2][2] * matrix[1][0] * matrix[0][1];
}

List<Uint8List>? inverse2x2Matrix(List<Uint8List> matrix) {
  if (matrix.length != 3) return null;
  int determinant = determinant2x2Matrix(matrix);
  int scalar = 0;
  if (determinant == 0) return null; // matrix is not invertible

  for (int i = 0; i < 26; i++) {
    int equation = (i * determinant) % 26;
    if (equation == 1) {
      scalar = i;
      break;
    } else {
      continue;
    }
  }
  return [
    Uint8List.fromList([(matrix[1][1] * scalar) % 26, ((-1 * matrix[0][1] % 26) * scalar) % 26]),
    Uint8List.fromList([((-1 * matrix[1][0] % 26) * scalar) % 26, (matrix[0][0] * scalar) % 26])
  ];
}

int determinant2x2Matrix(List<Uint8List> matrix) {
  return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
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