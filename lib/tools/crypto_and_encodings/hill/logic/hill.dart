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

List<List<int>> inverseMatrix(List<List<int>> keyMatrix) {
  int determinant = determinantMatrix(keyMatrix);
  int scalar = 0;
  if (determinant == 0 || keyMatrix.length != 2) {
    return [[]];
  }
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
    [(keyMatrix[1][1] * scalar) % 26, ((-1 * keyMatrix[0][1] % 26) * scalar) % 26],
    [((-1 * keyMatrix[1][0] % 26) * scalar) % 26, (keyMatrix[0][0] * scalar) % 26]
  ];
}

int determinantMatrix(List<List<int>> keyMatrix) {
  int determinant = keyMatrix[0][0] * keyMatrix[1][1] - keyMatrix[0][1] * keyMatrix[1][0];
  return determinant;
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