import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/rsa/logic/rsa.dart';

void main() {
  group("RSA.encryptRSA:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      //'WIKIPEDIA IST 42!'
      {'input' : [BigInt.from(87), BigInt.from(73), BigInt.from(75), BigInt.from(73), BigInt.from(80), BigInt.from(69), BigInt.from(68), BigInt.from(73), BigInt.from(65), BigInt.from(32), BigInt.from(73), BigInt.from(83), BigInt.from(84), BigInt.from(32), BigInt.from(52), BigInt.from(50), BigInt.from(33)],
        'e': BigInt.from(1721), 'p': BigInt.from(307), 'q': BigInt.from(859),
        'expectedOutput' : [BigInt.from(35225), BigInt.from(253912), BigInt.from(163314), BigInt.from(253912), BigInt.from(251016), BigInt.from(133372), BigInt.from(139634), BigInt.from(253912), BigInt.from(114917), BigInt.from(191731), BigInt.from(253912), BigInt.from(218980), BigInt.from(211928), BigInt.from(191731), BigInt.from(33825), BigInt.from(241474), BigInt.from(192628)]},
      {'input' : [BigInt.from(1921)], 'e': BigInt.from(17), 'p': BigInt.from(71), 'q': BigInt.from(83), 'expectedOutput' : [BigInt.from(1172)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, e: ${elem['e']}, p${elem['p']}, q: ${elem['q']},', () {
        var _actual = encryptRSA(elem['input'] as List<BigInt>, elem['e'] as BigInt, elem['p'] as BigInt, elem['q'] as BigInt);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("RSA.decryptRSA:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : [BigInt.from(35225), BigInt.from(253912), BigInt.from(163314), BigInt.from(253912), BigInt.from(251016), BigInt.from(133372), BigInt.from(139634), BigInt.from(253912), BigInt.from(114917), BigInt.from(191731), BigInt.from(253912), BigInt.from(218980), BigInt.from(211928), BigInt.from(191731), BigInt.from(33825), BigInt.from(241474), BigInt.from(192628)],
       'd': BigInt.from(1373), 'p': BigInt.from(307), 'q': BigInt.from(859),
        //'WIKIPEDIA IST 42!'
        'expectedOutput' : [BigInt.from(87), BigInt.from(73), BigInt.from(75), BigInt.from(73), BigInt.from(80), BigInt.from(69), BigInt.from(68), BigInt.from(73), BigInt.from(65), BigInt.from(32), BigInt.from(73), BigInt.from(83), BigInt.from(84), BigInt.from(32), BigInt.from(52), BigInt.from(50), BigInt.from(33)]},

      {'input' : [BigInt.from(1172)], 'd': BigInt.from(1013), 'p': BigInt.from(71), 'q': BigInt.from(83), 'expectedOutput' : [BigInt.from(1921)]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, d: ${elem['e']}, p${elem['p']}, q: ${elem['q']},', () {
        var _actual = decryptRSA(elem['input'] as List<BigInt>, elem['d'] as BigInt, elem['p'] as BigInt, elem['q'] as BigInt);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("RSA.calculateD:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'e': BigInt.from(1721), 'p': BigInt.from(307), 'q': BigInt.from(859), 'expectedOutput' : BigInt.from(1373)},
      {'e': BigInt.from(17), 'p': BigInt.from(71), 'q': BigInt.from(83), 'expectedOutput' : BigInt.from(1013)},
    ];

    for (var elem in _inputsToExpected) {
      test('e: ${elem['e']}p${elem['p']}, q: ${elem['q']},', () {
        var _actual = calculateD(elem['e'] as BigInt, elem['p'] as BigInt, elem['q'] as BigInt);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}