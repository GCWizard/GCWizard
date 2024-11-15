//ported from https://www.geeksforgeeks.org/hill-cipher/

import 'dart:core';

import 'package:gc_wizard/tools/science_and_technology/divisor/logic/divisor.dart';
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/collection_utils.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/constants.dart';
import 'package:gc_wizard/utils/math_utils.dart';

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

StringText encryptText(String message, String key, int matrixSize, Map<String, String> alphabet,
    [String fillCharacter = "X"]) {
  key = _removeNonAlphabetCharacters(key, alphabet);
  return _encryptHillCipher(message, key, matrixSize, alphabet, fillCharacter);
  // int n = key.length;
  // int padding = n - plaintext.length() % n;
  // if (padding != n) {
  //   plaintext += "X".repeat(padding);
  // }
}

StringText decryptText(String message, String key, int matrixSize, Map<String, String> alphabet,
    [String fillCharacter = "X"]) {
  key = _removeNonAlphabetCharacters(key, alphabet);
  return _decryptHillCipher(message, key, matrixSize, alphabet, fillCharacter);
  // int n = key.length;
  // int padding = n - plaintext.length() % n;
  // if (padding != n) {
  //   plaintext += "X".repeat(padding);
  // }
}

StringText _decryptHillCipher(String message, String key, int matrixSize, Map<String, String> alphabet,
    String fillCharacter) {
  if (key.isEmpty) {
    return StringText('KeyEmpty', '');
  }

  // Get inverted key matrix from the key string
  var keyMatrix = _getKeyMatrix(key, matrixSize, alphabet);
  var keyMatrixInverted = matrixInvert(keyMatrix);
  if ((keyMatrixInverted == null) || !_validKeyMatrix(keyMatrix, alphabet.length)) return StringText('InvalidKey', '');

  var determinant = matrixDeterminant(keyMatrix);
  var inversDeterminant = _multiplicativeInverseOfDeterminant(determinant.round(), alphabet.length);

  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < matrixSize; j++) {
      keyMatrixInverted[i][j] = (keyMatrixInverted[i][j] * determinant * inversDeterminant) % alphabet.length;
    }
  }
//https://crypto.interactive-maths.com/hill-cipher.html

  return _convertMessage(message, alphabet, keyMatrixInverted, fillCharacter);
}

StringText _encryptHillCipher(String message, String key, int matrixSize, Map<String, String> alphabet,
    String fillCharacter) {
  if (key.isEmpty) {
    return StringText('KeyEmpty', '');
  }
  // Get key matrix from the key string
  var keyMatrix = _getKeyMatrix(key, matrixSize, alphabet);
  var cipherText = _convertMessage(message, alphabet, keyMatrix, fillCharacter);
  var errorText = cipherText.text;

  if (errorText.isEmpty) {
    var keyMatrixInverted = matrixInvert(keyMatrix);
    errorText = ((keyMatrixInverted == null) || !_validKeyMatrix(keyMatrix, alphabet.length)) ? 'InvalidKey' : '';
  }
  return StringText(errorText, cipherText.value);
}

StringText _convertMessage(String message, Map<String, String> alphabet, List<List<double>> keyMatrix,
    String fillCharacter) {
  var messageVector = List<List<double>>.generate(keyMatrix.length, (index) => List<double>.filled(1, 0));
  var alphabetMap = switchMapKeyValue(alphabet);
  var _message = _removeNonAlphabetCharacters(message, alphabet);
  String convertedText = '';
  var k = 0;
  var k1 = 0;

  if (message.isEmpty || _message.isEmpty) return StringText('', message);
  if ((fillCharacter.isEmpty || fillCharacter.length != 1) && _message.length % keyMatrix.length != 0) {
    return StringText('InvalidFillCharacter', '');
  }

  do {
    // Generate vector for the message
    for (int i = 0; i < keyMatrix.length; i++) {
      messageVector[i][0] = _charToValue(k + i < _message.length
          ? _message[k + i]
          : fillCharacter, alphabet).toDouble();
    }

    // Following function generates the converted vector
    _matrixMultiplication(keyMatrix, messageVector, alphabet.length)?.forEach((value) {
      while (k1 < message.length && !alphabet.containsKey(message[k1].toUpperCase())) {
        convertedText += message[k1];
        k1++;
      }
      // Generate the text from the vector
      convertedText += _valueToChar(value[0].round() % alphabet.length, alphabetMap);

      k++;
      k1++;
    });
  } while (k < _message.length);
  return StringText('', convertedText);
}

// Following function generates the key matrix for the key string
List<List<double>> _getKeyMatrix(String key, int matrixSize, Map<String, String> alphabet) {
  var keyMatrix = List<List<double>>.generate(matrixSize, (index) => List<double>.filled(matrixSize, 0));
  int k = 0;
  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < matrixSize; j++) {
      keyMatrix[i][j] = _charToValue(k < key.length ? key[k]
          : alphabet.keys.elementAt(k - key.length), alphabet).toDouble();
      k++;
    }
  }
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
  var determinant = matrixDeterminant(keyMatrix);
  var inversDeterminant = _multiplicativeInverseOfDeterminant(determinant.round(), alphabetLength);
  if (inversDeterminant == 0) return false;

  return true;
  //var determinant = matrixDeterminante(keyMatrix).toInt() % alphabetLength;
  var _divisors = divisors(alphabetLength);
  _divisors.remove(1);
  _divisors.remove(alphabetLength);
  for (int i = 0; i < _divisors.length; i++) {
    if ((determinant % _divisors[i]) == 0) return false;
  }
  return true;
}

String _removeNonAlphabetCharacters(String text, Map<String, String> alphabet ) {
  var text1 = text.split('').map((char) => alphabet.containsKey(char.toUpperCase()) ? char : '').join();
  return text1;
}

// Following function convert the message
List<List<double>>? _matrixMultiplication(List<List<double>> keyMatrix, List<List<double>> messageVector, int alphabetLength) {
  var resultMatrix = matrixMultiplication(keyMatrix, messageVector);
  if (resultMatrix == null) return null;

  for (int i = 0; i < resultMatrix.length; i++) {
    for (int j = 0; j < resultMatrix[i].length; j++) {
      resultMatrix[i][j] %= alphabetLength;
    }
  }
  return resultMatrix;
}

int _multiplicativeInverseOfDeterminant(int matrixDeterminant, int modulo) {
  for (int i = 1; i < modulo; i++) {
    if (((matrixDeterminant * i) % modulo) == 1) return i;
  }
  return 0;
}