import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/_common/logic/crypt_alphabet_modification.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

void main() {
  group("Polybios.createPolybiosAlphabet:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'gridDimension' : null, 'firstLetters': null, 'mode': null, 'fillAlphabet': null, 'expectedOutput' : null},
      {'gridDimension' : 5, 'firstLetters': null, 'mode': PolybiosMode.AZ09, 'fillAlphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : 'ABCDEFGHIKLMNOPQRSTUVWXYZ'},
      {'gridDimension' : 5, 'firstLetters': '', 'mode': PolybiosMode.AZ09, 'fillAlphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : 'ABCDEFGHIKLMNOPQRSTUVWXYZ'},

      {'gridDimension' : 5, 'firstLetters': 'XYZ', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : 'XYZABCDEFGHIKLMNOPQRSTUVW'},
      {'gridDimension' : 5, 'firstLetters': 'XYZ', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : 'XYZABCDEFGHIKLMNOPQRSTUVW'},
      {'gridDimension' : 5, 'firstLetters': 'XYZ', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXCVBNM', 'expectedOutput' : 'XYZQWERTUIOPASDFGHKLCVBNM'},
      {'gridDimension' : 5, 'firstLetters': 'XYZ', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKL', 'expectedOutput' : 'XYZQWERTUIOPASDFGHKLBCMNV'},
      {'gridDimension' : 5, 'firstLetters': null, 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXCVBNM', 'expectedOutput' : 'QWERTZUIOPASDFGHKLYXCVBNM'},
      {'gridDimension' : 6, 'firstLetters': 'XYZ', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : 'XYZABCDEFGHIJKLMNOPQRSTUVW0123456789'},
    ];

    for (var elem in _inputsToExpected) {
      test(
          'gridDimension: ${elem['gridDimension']}, firstLetters: ${elem['firstLetters']}, mode: ${elem['mode']}, fillAlphabet: ${elem['fillAlphabet']}', () {
        var _actual = createPolybiosAlphabet(
            elem['gridDimension'] as int,
            firstLetters: elem['firstLetters'] as String?,
            mode: elem['mode'] as PolybiosMode,
            fillAlphabet: elem['fillAlphabet'] as String?
        );
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Polybios.encryptPolybios:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'mode': PolybiosMode.AZ09, 'fillAlphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : null},
      {'input' : 'ABC', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': null, 'expectedOutput' : '11 12 13'},
      {'input' : 'ABC', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': '', 'expectedOutput' : '11 12 13'},
      {'input' : 'ABC', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': null, 'expectedOutput' : '11 12 13'},
      {'input' : 'ABC', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': '', 'expectedOutput' : '11 12 13'},

      {'input' : 'HALLO', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '23 11 31 31 34'},
      {'input' : 'Hallo', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '23 11 31 31 34'},
      {'input' : 'Hallo123', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '23 11 31 31 34'},
      {'input' : 'jippie', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '24 24 35 35 24 15'},

      {'input' : 'HALLO', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '22 11 26 26 33'},
      {'input' : 'Hallo', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '22 11 26 26 33'},
      {'input' : 'Hallo123', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '22 11 26 26 33 54 55 56'},
      {'input' : 'Hallo123!', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '22 11 26 26 33 54 55 56'},
      {'input' : 'Jippie', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'expectedOutput' : '24 23 34 34 23 15'},

      {'input' : 'AB CD.12 23 AB', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'CA EC EA CC CA EC'},
      {'input' : 'JM', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'BC EE'},
      {'input' : 'AB CD.12 23 AB', 'key': 'ABCDJ', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'CA JC JA CC CA JC'},
      {'input' : 'AB CD.12 23 AB', 'key': 'Secr3', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'CS 3C 3S CC CS 3C'},
      {'input' : 'AB CD.12 23 AB', 'key': 'ABCDEF', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'BE DF DD CA ED EE EE EF BE DF'},
      {'input' : 'AB CD.12 23 AB', 'key': 'ABCDJF', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'BJ DF DD CA JD JJ JJ JF BJ DF'},
      {'input' : 'AB CD.12 23 AB', 'key': 'Secr3t', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'E3 RT RR CS 3R 33 33 3T E3 RT'},
      {'input' : 'AB CD.12 23 AB', 'key': 'Secret', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'EE RT RR CS ER EE EE ET EE RT'},
      {'input' : 'AB CD.12 23 AB', 'key': '11111', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : '11 11 11 11 11 11'},
      {'input' : 'AB CD.12 23 AB', 'key': '111111', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : '11 11 11 11 11 11 11 11 11 11'},

      {'input' : 'AB CD.12 23 AB', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM', 'expectedOutput' : '31 53 51 33 31 53'},
      {'input' : 'AB CD.12 23 AB', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWRTZUIOPASDFGHKLYXJCVBNM0123456789', 'expectedOutput' : 'BE EB DE CB BE EB'},
      {'input' : 'AB CD.12 23 AB', 'key': 'Secr3', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123;_()=.', 'expectedOutput' : 'CS 3C 3S CC CS 3C'},
      {'input' : 'AB CD.12 23 AB', 'key': 'ABCDE9', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWRTZUIOPASDFGHKLYXJCVBNM0123456789.', 'expectedOutput' : 'BD DE DC B9 99 EC ED ED EE BD DE'},
      {'input' : 'AB CD.12 23 AB', 'key': 'Secr3t', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123;_()=.', 'expectedOutput' : 'E3 RT RR CS TT 3R 33 33 3T E3 RT'},

      {'input' : 'AB CD.12 23 AB', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPA', 'expectedOutput' : 'CA CB CC CD CA CB'},
      {'input' : 'AB CD.12 23 AB', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'AAAAAAAAAAAAAAAAAAAAAAAAA', 'expectedOutput' : 'AA AB AC AD AA AB'},

      {'input' : 'ABJICKWVQ', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : '11 12 24 24 13 25 52 51 41'},
      {'input' : 'ABJICKWVQ', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : '11 12 24 23 25 25 52 51 41'},
      {'input' : 'ABJICKWVQ', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.W_TO_VV, 'expectedOutput' : '11 12 25 24 13 31 52 52 52 42'},
      {'input' : 'ABJICKWVQ', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.REMOVE_Q, 'expectedOutput' : '11 12 25 24 13 31 52 51'},
      {'input' : 'ABJICKWVQ', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'modificationMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : '31 53 23 23 51 42 12 52 11'},
      {'input' : 'ABJICKWVQ', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'modificationMode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : '31 53 51 23 42 42 12 52 11'},
      {'input' : 'ABJICKWVQ', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'modificationMode': AlphabetModificationMode.W_TO_VV, 'expectedOutput' : '25 53 45 22 51 41 52 52 52 11'},
      {'input' : 'ABJICKWVQ', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'modificationMode': AlphabetModificationMode.REMOVE_Q, 'expectedOutput' : '25 53 45 22 51 41 11 52'},
      {'input' : 'ABJICKWVQ', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.J_TO_I, 'expectedOutput' : '11 12 24 23 13 25 45 44 35'},
      {'input' : 'ABJICKWVQ', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.C_TO_K, 'expectedOutput' : '11 12 24 23 13 25 45 44 35'},
      {'input' : 'ABJICKWVQ', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.W_TO_VV, 'expectedOutput' : '11 12 24 23 13 25 45 44 35'},
      {'input' : 'ABJICKWVQ', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.REMOVE_Q, 'expectedOutput' : '11 12 24 23 13 25 45 44 35'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, mode: ${elem['mode']}, modMode: ${elem['modificationMode']}, fillAlphabet: ${elem['fillAlphabet']}', () {
        PolybiosOutput? _actual;
        if (elem['modificationMode'] != null) {
          _actual = encryptPolybios(elem['input'] as String, elem['key'] as String, mode: elem['mode'] as PolybiosMode, fillAlphabet: elem['fillAlphabet'] as String?, modificationMode: elem['modificationMode'] as AlphabetModificationMode);
        } else {
          _actual = encryptPolybios(elem['input'] as String, elem['key'] as String, mode: elem['mode'] as PolybiosMode, fillAlphabet: elem['fillAlphabet'] as String?);
        }

        expect(_actual?.output, elem['expectedOutput']);
      });
    }
  });

  group("Polybios.decryptPolybios:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'mode': PolybiosMode.AZ09, 'fillAlphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : null},
      {'input' : 'AB CD', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 'expectedOutput' : null},
      {'input' : '12 34', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': null, 'expectedOutput' : 'BO'},
      {'input' : '12 34', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': '', 'expectedOutput' : 'BO'},
      {'input' : '12 34', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': null, 'expectedOutput' : 'BP'},
      {'input' : '12 34', 'key': '123456', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': '', 'expectedOutput' : 'BP'},
      {'input' : '12 34', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPA', 'expectedOutput' : null},
      {'input' : '12 34', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'AAAAAAAAAAAAAAAAAAAAAAAAA', 'expectedOutput' : null},

      {'expectedOutput' : 'HALLO', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'input' : '23 11 31 31 34'},
      {'expectedOutput' : 'HALLO', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'input' : '23 11 31 31 34 2'},
      {'expectedOutput' : 'IIPPIE', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'input' : '24 24 35 35 24 15'},

      {'expectedOutput' : 'HALLO', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'input' : '22 11 26 26 33'},
      {'expectedOutput' : 'HALLO123', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'input' : '22 11 26 26 33 54 55 56'},
      {'expectedOutput' : 'HALLO123', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'input' : '22 11 26 26 33 54 55 56 4'},
      {'expectedOutput' : 'JIPPIE', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'input' : '24 23 34 34 23 15'},

      {'expectedOutput' : 'ABCDAB', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'CA EC EA CC CA EC'},
      {'expectedOutput' : 'IM', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'BC EE'},
      {'expectedOutput' : 'ABCDAB', 'key': 'ABCDJ', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'CA JC JA CC CA JC'},
      {'expectedOutput' : 'ABCDAB', 'key': 'Secr3', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'CS 3C 3S CC CS 3C'},
      {'expectedOutput' : 'ABCD1223AB', 'key': 'ABCDEF', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'BE DF DD CA ED EE EE EF BE DF'},
      {'expectedOutput' : 'ABCD1223AB', 'key': 'ABCDJF', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'BJ DF DD CA JD JJ JJ JF BJ DF'},
      {'expectedOutput' : 'ABCD1223AB', 'key': 'Secr3t', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'E3 RT RR CS 3R 33 33 3T E3 RT'},
      {'expectedOutput' : 'IBCDPIISIB', 'key': 'Secret', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'EE RT RR CS ER EE EE ET EE RT'},
      {'expectedOutput' : 'QQQQQQ', 'key': '11111', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : '11 11 11 11 11 11'},
      {'expectedOutput' : 'QQQQQQQQQQ', 'key': '111111', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : '11 11 11 11 11 11 11 11 11 11'},

      {'expectedOutput' : 'ABCDAB', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM', 'input' : '31 53 51 33 31 53'},
      {'expectedOutput' : 'ABCDAB', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWRTZUIOPASDFGHKLYXJCVBNM0123456789', 'input' : 'BE EB DE CB BE EB'},
      {'expectedOutput' : 'ABCDAB', 'key': 'Secr3', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123;_()=.', 'input' : 'CS 3C 3S CC CS 3C'},
      {'expectedOutput' : 'ABCD.1223AB', 'key': 'ABCDE9', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWRTZUIOPASDFGHKLYXJCVBNM0123456789.', 'input' : 'BD DE DC B9 99 EC ED ED EE BD DE'},
      {'expectedOutput' : 'ABCD.1223AB', 'key': 'Secr3t', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123;_()=.', 'input' : 'E3 RT RR CS TT 3R 33 33 3T E3 RT'},

      {'input' : 'AA AB AC AD AA AB', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'AAAAAAAAAAAAAAAAAAAAAAAAA', 'expectedOutput' : 'ABCDAB'},
      {'input' : 'CA CB CC CD CA CB', 'key': 'ABCDE', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPA', 'expectedOutput' : 'ABCDAB'},

      {'expectedOutput' : 'ABIICKWVQ', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.J_TO_I, 'input' : '11 12 24 24 13 25 52 51 41'},
      {'expectedOutput' : 'ABJIKKWVQ', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.C_TO_K, 'input' : '11 12 24 23 25 25 52 51 41'},
      {'expectedOutput' : 'ABJICKVVVQ', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.W_TO_VV, 'input' : '11 12 25 24 13 31 52 52 52 42'},
      {'expectedOutput' : 'ABJICKWV', 'key': '12345', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.REMOVE_Q, 'input' : '11 12 25 24 13 31 52 51'},
      {'expectedOutput' : 'ABIICKWVQ', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'modificationMode': AlphabetModificationMode.J_TO_I, 'input' : '31 53 23 23 51 42 12 52 11'},
      {'expectedOutput' : 'ABJIKKWVQ', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'modificationMode': AlphabetModificationMode.C_TO_K, 'input' : '31 53 51 23 42 42 12 52 11'},
      {'expectedOutput' : 'ABJICKVVVQ', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'modificationMode': AlphabetModificationMode.W_TO_VV, 'input' : '25 53 45 22 51 41 52 52 52 11'},
      {'expectedOutput' : 'ABJICKWV', 'key': '12345', 'mode': PolybiosMode.CUSTOM, 'fillAlphabet': 'QWERTZUIOPASDFGHKLYXJCVBNM0123456789', 'modificationMode': AlphabetModificationMode.REMOVE_Q, 'input' : '25 53 45 22 51 41 11 52'},
      {'expectedOutput' : 'ABJICKWVQ', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.J_TO_I, 'input' : '11 12 24 23 13 25 45 44 35'},
      {'expectedOutput' : 'ABJICKWVQ', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.C_TO_K, 'input' : '11 12 24 23 13 25 45 44 35'},
      {'expectedOutput' : 'ABJICKWVQ', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.W_TO_VV, 'input' : '11 12 24 23 13 25 45 44 35'},
      {'expectedOutput' : 'ABJICKWVQ', 'key': '123456', 'mode': PolybiosMode.AZ09, 'fillAlphabet': null, 'modificationMode': AlphabetModificationMode.REMOVE_Q, 'input' : '11 12 24 23 13 25 45 44 35'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, mode: ${elem['mode']}, modMode: ${elem['modificationMode']}, alphabet: ${elem['fillAlphabet']}', () {
        PolybiosOutput? _actual;
        if (elem['modificationMode'] != null) {
          _actual = decryptPolybios(elem['input'] as String, elem['key'] as String, mode: elem['mode'] as PolybiosMode, fillAlphabet: elem['fillAlphabet'] as String?, modificationMode: elem['modificationMode'] as AlphabetModificationMode);
        } else {
          _actual = decryptPolybios(elem['input'] as String, elem['key'] as String, mode: elem['mode'] as PolybiosMode, fillAlphabet: elem['fillAlphabet'] as String?);
        }
        expect(_actual?.output, elem['expectedOutput']);
      });
    }
  });
}