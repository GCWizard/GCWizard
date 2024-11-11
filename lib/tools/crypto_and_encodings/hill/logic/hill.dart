//ported from https://www.geeksforgeeks.org/hill-cipher/

import 'dart:core';
import 'dart:typed_data';

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
List<Uint8List> _encrypt(List<Uint8List> keyMatrix, List<Uint8List> messageVector) {
  var cipherMatrix = List<Uint8List>.generate(3, (index) => Uint8List(1));

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 1; j++) {
      var tmpValue = 0;
      for (int x = 0; x < 3; x++) {
        tmpValue += keyMatrix[i][x] * messageVector[x][j];
      }
      cipherMatrix[i][j] = tmpValue % 26;
    }
  }
  return cipherMatrix;
}

// Function to implement Hill Cipher
String HillCipher(String message, String key) {
  // Get key matrix from the key string
  var keyMatrix = _getKeyMatrix(key);
  var messageVector = List<Uint8List>.generate(3, (index) => Uint8List(1));

  // Generate vector for the message
  for (int i = 0; i < 3; i++) {
    messageVector[i][0] = message.codeUnitAt(i) % 65;
  }

  // Following function generates the encrypted vector
  var cipherMatrix = _encrypt(keyMatrix, messageVector);

  String cipherText = '';

  // Generate the encrypted text from the encrypted vector
  for (int i = 0; i < 3; i++) {
    cipherText += String.fromCharCode(cipherMatrix[i][0] + 65);
  }

  return cipherText;
}