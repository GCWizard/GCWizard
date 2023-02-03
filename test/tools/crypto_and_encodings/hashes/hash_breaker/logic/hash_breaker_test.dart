import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/variable_string_expander.dart';
import "package:gc_wizard/tools/crypto_and_encodings/hashes/hash_breaker/logic/hash_breaker.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/hashes/logic/hashes.dart';

void main() {
  group("HashBreaker.breakHash:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'searchMask': null, 'substitutions': null, 'hashFunction': null, 'expectedOutput' : null},

      {'input' : 'EAF498C0576778AB60648148D8A6FC66', 'searchMask': 'ABC', 'substitutions': {'A':'1-3', 'B': '2,4,10'}, 'hashFunction': md5Digest, 'expectedOutput' : {'state': 'ok', 'text': '210C'}},
      {'input' : '09c70fb216d5f22f5fcdca8bdf5870f585b1cb88', 'searchMask': 'N49 32.[a][b][c] E010 59.[d][e][f]', 'substitutions': {'a':'3-5', 'B': '1-3', 'c': '6-8', 'D': '4-6', 'e': '7', 'F': '0-2'}, 'hashFunction': sha1Digest, 'expectedOutput' : {'state': 'ok', 'text': 'N49 32.427 E010 59.472'}},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, searchMask: ${elem['searchMask']}, substitutions: ${elem['substitutions']}', () {
        var _actual = breakHash(elem['input'], elem['searchMask'], elem['substitutions'], elem['hashFunction']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("HashBreaker.preCheck:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'substitutions': {'A':'100-300', 'B': '1000-3000'}, 'expectedOutput' : 402201},
    ];

    _inputsToExpected.forEach((elem) {
      test('substitutions: ${elem['substitutions']}', () {
        var _actual = preCheckCombinations(elem['substitutions']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}