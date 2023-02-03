import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/primes/_common/logic/primes.dart';

void main() {
  group("Primes.getNthPrime:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : -1},
      {'input' : -1, 'expectedOutput' : -1},
      {'input' : 0, 'expectedOutput' : -1},
      {'input' : 1, 'expectedOutput' : 2},
      {'input' : 78499, 'expectedOutput' : 1000003},
      {'input' : 78500, 'expectedOutput' : -1},

      {'input' : 12345, 'expectedOutput' : 132241},
      {'input' : 42000, 'expectedOutput' : 506131},
      {'input' : 77777, 'expectedOutput' : 989999},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = getNthPrime(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Primes.getPrimeIndex:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : -1},
      {'input' : -1, 'expectedOutput' : -1},
      {'input' : 0, 'expectedOutput' : -1},
      {'input' : 1, 'expectedOutput' : -1},
      {'input' : 42, 'expectedOutput' : -1},
      {'input' : 506396, 'expectedOutput' : -1},
      {'input' : 1000004, 'expectedOutput' : -1},
      {'input' : 1000033, 'expectedOutput' : -1},

      {'expectedOutput' : 1, 'input' : 2},
      {'expectedOutput' : 2, 'input' : 3},
      {'expectedOutput' : 3, 'input' : 5},
      {'expectedOutput' : 78499, 'input' : 1000003},
      {'expectedOutput' : 12345, 'input' : 132241},
      {'expectedOutput' : 42000, 'input' : 506131},
      {'expectedOutput' : 77777, 'input' : 989999},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = getPrimeIndex(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Primes.getNearestPrime:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : -100, 'expectedOutput' : [2]},
      {'input' : -1, 'expectedOutput' : [2]},
      {'input' : 0, 'expectedOutput' : [2]},
      {'input' : 1, 'expectedOutput' : [2]},
      {'input' : 2, 'expectedOutput' : [2]},
      {'input' : 3, 'expectedOutput' : [3]},
      {'input' : 4, 'expectedOutput' : [3,5]},

      {'input' : 100000, 'expectedOutput' : [100003]},
      {'input' : 224740, 'expectedOutput' : [224737,224743]},
      {'input' : 350008, 'expectedOutput' : [350003]},
      {'input' : 506125, 'expectedOutput' : [506119,506131]},


      {'input' : 84533, 'expectedOutput' : [84533]},
      {'input' : 84551, 'expectedOutput' : [84551]},
      {'input' : 84542, 'expectedOutput' : [84533,84551]}, //2 Values from different lists

      {'input' : 1000000, 'expectedOutput' : [1000003]},
      {'input' : 1000001, 'expectedOutput' : null}, //too big input
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = getNearestPrime(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Primes.getNextPrime:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : 1000001, 'expectedOutput' : null},


      {'input' : -1, 'expectedOutput' : 2},
      {'input' : 0, 'expectedOutput' : 2},
      {'input' : 1, 'expectedOutput' : 2},
      {'input' : 2, 'expectedOutput' : 3},
      {'input' : 3, 'expectedOutput' : 5},
      {'input' : 5, 'expectedOutput' : 7},
      {'input' : 691, 'expectedOutput' : 701},
      {'input' : 1000000, 'expectedOutput' : 1000003},

      {'input' : 42, 'expectedOutput' : 43},
      {'input' : 682, 'expectedOutput' : 683},
      {'input' : 683, 'expectedOutput' : 691},
      {'input' : 684, 'expectedOutput' : 691},
      {'input' : 690, 'expectedOutput' : 691},
      {'input' : 691, 'expectedOutput' : 701},
      {'input' : 692, 'expectedOutput' : 701},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = getNextPrime(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Primes.getPreviousPrime:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : null},
      {'input' : -1, 'expectedOutput' : null},
      {'input' : 0, 'expectedOutput' : null},
      {'input' : 1, 'expectedOutput' : null},
      {'input' : 2, 'expectedOutput' : null},

      {'input' : 3, 'expectedOutput' : 2},
      {'input' : 5, 'expectedOutput' : 3},
      {'input' : 7, 'expectedOutput' : 5},
      {'input' : 701, 'expectedOutput' : 691},

      {'input' : 42, 'expectedOutput' : 41},
      {'input' : 700, 'expectedOutput' : 691},
      {'input' : 692, 'expectedOutput' : 691},
      {'input' : 691, 'expectedOutput' : 683},
      {'input' : 690, 'expectedOutput' : 683},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = getPreviousPrime(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}