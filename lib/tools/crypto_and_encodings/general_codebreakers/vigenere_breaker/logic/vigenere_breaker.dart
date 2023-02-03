import 'dart:math';

import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/bigrams/logic/bigrams.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/general_codebreakers/vigenere_breaker/guballa/logic/breaker.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';

enum VigenereBreakerType { VIGENERE, AUTOKEYVIGENERE, BEAUFORT }

enum VigenereBreakerAlphabet { ENGLISH, GERMAN, SPANISH, FRENCH }

enum VigenereBreakerErrorCode {
  OK,
  KEY_LENGTH,
  KEY_TOO_LONG,
  CONSOLIDATE_PARAMETER,
  TEXT_TOO_SHORT,
  ALPHABET_TOO_LONG,
  WRONG_GENERATE_TEXT
}

class VigenereBreakerJobData {
  final String input;
  final VigenereBreakerType vigenereBreakerType;
  final bool ignoreNonLetters;
  final VigenereBreakerAlphabet alphabet;
  final int keyLengthMin;
  final int keyLengthMax;

  VigenereBreakerJobData(
      {this.input = '',
      this.vigenereBreakerType,
      this.ignoreNonLetters = false,
      this.alphabet,
      this.keyLengthMin = 0,
      this.keyLengthMax = 0});
}

class VigenereBreakerResult {
  String plaintext;
  String key;
  double fitness;
  double fitnessFiltered;
  String alphabet;
  VigenereBreakerErrorCode errorCode;

  VigenereBreakerResult(
      {this.plaintext = '',
      this.key = '',
      this.fitness = 0.0,
      this.fitnessFiltered = 0.0,
      this.alphabet = '',
      this.errorCode = VigenereBreakerErrorCode.OK});
}

const DEFAULT_ALPHABET = "abcdefghijklmnopqrstuvwxyz";
var _progress = 0;
var _countCombinations = 0;
var _progressStep = 1;
var _sendAsyncPort;

Future<VigenereBreakerResult> break_cipherAsync(dynamic jobData) async {
  if (jobData.parameters == null) return VigenereBreakerResult(errorCode: VigenereBreakerErrorCode.OK);

  _sendAsyncPort = jobData.sendAsyncPort;

  var output = break_cipher(
      jobData.parameters.input,
      jobData.parameters.vigenereBreakerType,
      jobData.parameters.alphabet,
      jobData.parameters.keyLengthMin,
      jobData.parameters.keyLengthMax,
      jobData.parameters.ignoreNonLetters,
      counterFunction: progressCounter);

  if (jobData.sendAsyncPort != null) jobData.sendAsyncPort.send(output);

  return output;
}

progressCounter() {
  _progress++;
  if (_sendAsyncPort != null && (_progress % _progressStep == 0))
    _sendAsyncPort.send({'progress': _progress / _countCombinations});
}

VigenereBreakerResult break_cipher(String input, VigenereBreakerType vigenereBreakerType,
    VigenereBreakerAlphabet alphabet, int keyLengthMin, int keyLengthMax, bool ignoreNonLetters,
    {Function counterFunction}) {
  if (input == null || input == '') return VigenereBreakerResult(errorCode: VigenereBreakerErrorCode.OK);

  if (((keyLengthMin < 3) || (keyLengthMin > 1000)) || ((keyLengthMax < 3) || (keyLengthMax > 1000)))
    // key length not in the valid range 3..1000
    return VigenereBreakerResult(errorCode: VigenereBreakerErrorCode.KEY_LENGTH);

  var bigrams = getBigrams(alphabet);

  var vigenereSquare =
      _createVigenereEncodeSquare(bigrams.alphabet.length, vigenereBreakerType == VigenereBreakerType.BEAUFORT);
  var cipher_bin = <int>[];
  var resultList = <VigenereBreakerResult>[];
  VigenereBreakerResult best_result;

  iterateText(input, bigrams.alphabet, ignoreNonLetters: ignoreNonLetters).forEach((char) {
    cipher_bin.add(char);
  });

  var cipher_binLength = cipher_bin.where((element) => element > 0).length;
  if (cipher_binLength < 3) return VigenereBreakerResult(errorCode: VigenereBreakerErrorCode.TEXT_TOO_SHORT);

  if ((keyLengthMin > cipher_binLength) && (keyLengthMax > cipher_binLength))
    // Minimum key length must be equal or greater than the length of the ciphertext
    return VigenereBreakerResult(errorCode: VigenereBreakerErrorCode.KEY_TOO_LONG);

  keyLengthMax = min(keyLengthMax, cipher_bin.length);

  _progress = 0;
  _countCombinations = 0;
  for (int keyLength = keyLengthMin; keyLength <= keyLengthMax; keyLength++)
    _countCombinations += pow(bigrams.alphabet.length, 2) * keyLength;

  _progressStep = max(_countCombinations ~/ 100, 1); // 100 steps

  for (int keyLength = keyLengthMin; keyLength <= keyLengthMax; keyLength++) {
    var breakerResult = break_vigenere(cipher_bin, keyLength, vigenereSquare, bigrams.bigrams,
        vigenereBreakerType == VigenereBreakerType.AUTOKEYVIGENERE,
        counterFunction: counterFunction);
    var result = VigenereBreakerResult();

    resultList.add(result);

    result.key = breakerResult.key.map((x) => bigrams.alphabet[x].toUpperCase()).join();

    result.plaintext = decryptVigenere(input, result.key, vigenereBreakerType == VigenereBreakerType.AUTOKEYVIGENERE,
        ignoreNonLetters: ignoreNonLetters);
    result.fitness = calc_fitnessBigrams(result.plaintext, bigrams);
  }
  best_result = _bestSolution(resultList);

  return VigenereBreakerResult(
      plaintext: best_result.plaintext,
      key: best_result.key,
      fitness: best_result.fitness,
      errorCode: VigenereBreakerErrorCode.OK);
}

VigenereBreakerResult _bestSolution(List<VigenereBreakerResult> keyList) {
  if (keyList == null || keyList.length == 0) return null;

  keyList = _highPassFilter(2, keyList);
  var bestFitness = keyList[0];
  for (var i = 1; i < keyList.length; ++i)
    if (bestFitness.fitnessFiltered < keyList[i].fitnessFiltered) bestFitness = keyList[i];

  return bestFitness;
}

/// HighPass Filter
List<VigenereBreakerResult> _highPassFilter(double alpha, List<VigenereBreakerResult> keyList) {
  for (var i = 0; i < keyList.length; ++i)
    keyList[i].fitnessFiltered = alpha * keyList[i].fitness -
        (i > 0 ? keyList[i - 1].fitness : keyList[i].fitness) -
        (i < keyList.length - 1 ? keyList[i + 1].fitness : keyList[i].fitness);

  return keyList;
}

List<List<int>> _createVigenereEncodeSquare(int size, bool beaufortVariant) {
  var vigenereSquare = List.generate(size, (index) => <int>[]);

  if (beaufortVariant) {
    for (int row = 0; row < vigenereSquare.length; row++) {
      vigenereSquare[row] = List.generate(vigenereSquare.length, (index) => (index - row) % vigenereSquare.length);
    }
  } else {
    for (int row = 0; row < vigenereSquare.length; row++) {
      vigenereSquare[row] = List.generate(
          vigenereSquare.length, (index) => (vigenereSquare.length - index + row) % vigenereSquare.length);
    }
  }

  return vigenereSquare;
}
