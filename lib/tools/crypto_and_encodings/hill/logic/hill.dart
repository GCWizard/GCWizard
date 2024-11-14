//ported from https://www.geeksforgeeks.org/hill-cipher/

import 'dart:core';
import 'dart:typed_data';

import 'package:gc_wizard/tools/science_and_technology/divisor/logic/divisor.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/math_utils.dart';
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

StringText decryptText(String message, String key, int matrixSize, Alphabet alphabet) {
  message = removeNonLetters(message.toUpperCase());
  key = removeNonLetters(key.toUpperCase());
  return _decryptHillCipher(message, key, matrixSize, alphabet);
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
  var messageVector = List<List<double>>.generate(matrixSize, (index) => List<double>.filled(1, 0));
  var cipherMatrix = List<double>.filled(message.length, 0);
  var k = 0;

  do {
    // Generate vector for the message
    for (int i = 0; i < matrixSize; i++) {
      messageVector[i][0] = _charToValue(k + i < message.length
          ? message[k + i]
          : _fillCharacter, alphabet.alphabet).toDouble(); //alphabet.alphabet.keys.last'
    }

    // Following function generates the encrypted vector
    _matrixMultiplication(keyMatrix, messageVector, alphabet.alphabet.length).forEach((value) {
      if (k < cipherMatrix.length) cipherMatrix[k] = value[0];
      k++;
    });
  } while (k < message.length);

  String cipherText = '';
  var alphabetMap = switchMapKeyValue(alphabet.alphabet);

  // Generate the decrypted text from the decrypted vector
  for (int i = 0; i < cipherMatrix.length; i++) {
    cipherText += _valueToChar(cipherMatrix[i].round(), alphabetMap);
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
  var messageVector = List<List<double>>.generate(matrixSize, (index) => List<double>.filled(1, 0));
  var cipherMatrix = List<double>.filled(message.length, 0);
  var k = 0;

  do {
    // Generate vector for the message
    for (int i = 0; i < matrixSize; i++) {
      messageVector[i][0] = _charToValue(k + i < message.length
          ? message[k + i]
          : _fillCharacter, alphabet.alphabet).toDouble(); //alphabet.alphabet.keys.last'
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
    cipherText += _valueToChar(cipherMatrix[i].round(), alphabetMap);
  }
  var text = _validKeyMatrix(keyMatrix, alphabet.alphabet.length) ? '' : 'InvalidKey';
  return StringText(text, cipherText);
}

// Following function generates the key matrix for the key string
List<List<double>> _getKeyMatrix(String key, int matrixSize, Alphabet alphabet) {
  var keyMatrix = List<List<double>>.generate(matrixSize, (index) => List<double>.filled(matrixSize, 0));
  int k = 0;
  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < matrixSize; j++) {
      keyMatrix[i][j] = _charToValue(k < key.length ? key[k]
          : alphabet.alphabet.keys.elementAt(k - key.length), alphabet.alphabet).toDouble();
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

bool _validKeyMatrix(List<List<double>> keyMatrix, int alphabetLength) {
  var determinante = matrixDeterminante(keyMatrix).toInt() % alphabetLength;
  return true;
  //var determinante = matrixDeterminante(keyMatrix).toInt() % alphabetLength;
  var _divisors = divisors(alphabetLength);
  _divisors.remove(1);
  _divisors.remove(alphabetLength);
  for (int i = 0; i < _divisors.length; i++) {
    if ((determinante % _divisors[i]) == 0) return false;
  }
  return true;
}

// Following function encrypts the message
List<List<double>> _matrixMultiplication(List<List<double>> keyMatrix, List<List<double>> messageVector, int alphabetLength) {
  var resultMatrix = matrixMultiplication(keyMatrix, messageVector);

  for (int i = 0; i < resultMatrix!.length; i++) {
    for (int j = 0; j < resultMatrix[i].length; j++) {
      resultMatrix[i][j] = resultMatrix[i][j] % alphabetLength;
    }
  }
  return resultMatrix;
}

List<List<double>>? _matrixInvert(List<List<double>> matrix) {
  int n = matrix.length;
  var _matrix = List<List<double>>.generate(matrix.length, (row) =>
    List<double>.generate(matrix[row].length, (column) => matrix[row][column].toDouble()));

  var result = matrixInvert(_matrix);
return result;
  //var _result = List<Uint8List>.generate(result!.length, (row) => Uint8List.fromList());

}

double _matrixDeterminante(List<Uint8List> matrix) {
  var matrixD = List<List<double>>.generate(matrix.length, (rowIndex) =>
      List<double>.generate(matrix[rowIndex].length, (columnIndex) => matrix[rowIndex][columnIndex].toDouble()));
  return matrixDeterminante(matrixD);
}
//https://dev.to/rk042/how-to-inverse-a-matrix-in-c-12jg
// to invert [[6, 24, 1], [13, 16, 10], [20, 17, 15]]
// result
// determinante 441
