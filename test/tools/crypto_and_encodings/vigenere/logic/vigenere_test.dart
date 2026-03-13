import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/vigenere/logic/vigenere.dart';
import 'package:gc_wizard/utils/alphabets.dart';

void main() {
  group("Vigenere.encrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : '', 'key': 'ABC', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': '', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABC'},
      {'input' : '', 'key': '', 'autoKey': true, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : '', 'key': 'ABC', 'autoKey': true, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': '', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'ABC'},

      {'input' : 'ABC', 'key': 'MNO', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'MOQ'},
      {'input' : 'ABCDEF', 'key': 'MN', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'MOOQQS'},
      {'input' : 'ABCDEF', 'key': 'MN', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'MOCEGI'},

      {'input' : 'Abc', 'key': 'mnO', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'Moq'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'MoOQqS'},
      {'input' : 'ABcdeF', 'key': 'mn', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'MOcegI'},

      {'input' : 'Ab12c', 'key': 'mnO', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'Mo12q'},
      {'input' : ' A%67bC DeF_', 'key': 'MN', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ' M%67oO QqS_'},
      {'input' : 'A Bcd23eF', 'key': 'mn', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'M Oce23gI'},

      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'NpPRrT'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 13, 'expectedOutput' : 'ZbBDdF'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 26, 'expectedOutput' : 'MoOQqS'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 27, 'expectedOutput' : 'NpPRrT'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 52, 'expectedOutput' : 'MoOQqS'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -1, 'expectedOutput' : 'LnNPpR'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -13, 'expectedOutput' : 'ZbBDdF'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -26, 'expectedOutput' : 'MoOQqS'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -27, 'expectedOutput' : 'LnNPpR'},
      {'input' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -52, 'expectedOutput' : 'MoOQqS'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 1, 'expectedOutput' : 'NpDFhJ'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 13, 'expectedOutput' : 'ZbPRtV'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 26, 'expectedOutput' : 'MoCEgI'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 27, 'expectedOutput' : 'NpDFhJ'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 52, 'expectedOutput' : 'MoCEgI'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -1, 'expectedOutput' : 'LnBDfH'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -13, 'expectedOutput' : 'ZbPRtV'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -26, 'expectedOutput' : 'MoCEgI'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -27, 'expectedOutput' : 'LnBDfH'},
      {'input' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -52, 'expectedOutput' : 'MoCEgI'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        if (elem['aValue']  == null) {
          var _actual = encryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = encryptVigenere(
              elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });

  group("Vigenere.encryptIgnoreNonLetters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input' : 'Wie ich sehe hast du das Rätsel gelöst. Du wirst jetzt sicherlich die Koordinaten lesen wollen, keine Sorge, dass wirst du. Aber zunächst ',
        'key': 'beteigeuze',
        'autoKey': false,
        'aValue': 0,
        'expectedOutput' : 'Xmx qil riii liyx cy htw Xänrim zitöwn. Ey aqxwn nfxsx ymwgispbgp hcd Lshvlorusio eiakr vsmpxr, oyhrf Lszmi, hbwl eovms ey. Ihil dvrägpyx '
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        if (elem['aValue']  == null) {
          var _actual = encryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, ignoreNonLetters: false);
          expect(_actual, elem['expectedOutput']);
        } else {
          var _actual = encryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int, ignoreNonLetters: false);
          expect(_actual, elem['expectedOutput']);
        }
      });
    }
  });

  group("Vigenere.encryptKeyNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'AbCDeF', 'key': '12 13', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'MoOQqS'},
      {'input' : 'AbCDeF', 'key': '12    13', 'autoKey': false, 'aValue': 13, 'expectedOutput' : 'MoOQqS'},
      {'input' : 'AbCDeF', 'key': '12 ,13', 'autoKey': true, 'aValue': 1, 'expectedOutput' : 'MoDFhJ'},
      {'input' : 'AbCDeF', 'key': '12, -13', 'autoKey': true, 'aValue': 13, 'expectedOutput' : 'MoPRtV'},

      {'input' : 'Unter', 'key': '1 17 24 16 0', 'autoKey': false, 'aValue': 13, 'expectedOutput' : 'Verur'},
      {'input' : 'AbcxyZ', 'key': '1 2,3,,,4 5; 6', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'BdfbdF'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = encryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int, ignoreNonLetters: false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Vigenere.encryptWithDifferentAlphabets:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'ABC', 'key': 'MNO', 'autoKey': false, 'aValue': 0, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBA', 'expectedOutput' : 'NPR'},
      {'input' : 'ABC', 'key': 'MNO', 'autoKey': false, 'aValue': 0, 'alphabet': 'QWERTZUIOPASDFGHJKLYXCVBNM', 'expectedOutput' : 'PCR'},
      {'input' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'expectedOutput' : 'ü'},
      {'input' : 'ß', 'key': '29', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'expectedOutput' : 'ü'},
      {'input' : 'ß', 'key': 'ẞ', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'expectedOutput' : 'ü'},
      {'input' : 'ẞ', 'key': 'ß', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'expectedOutput' : 'Ü'},
      {'input' : 'ẞ', 'key': 'ẞ', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'expectedOutput' : 'Ü'},
      {'input' : 'ẞ', 'key': 'ẞ', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'expectedOutput' : 'Ü'},
      {'input' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'expectedOutput' : 'ü'},
      {'input' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': 1, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'expectedOutput' : 'ß'},
      {'input' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': -1, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'expectedOutput' : 'ö'},
      {'input' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': 52, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'expectedOutput' : 'u'},
      {'input' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': -52, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'expectedOutput' : 'g'},
      {'input' : 'Außer Spesen nicht gewährt', 'key': 'Xvxcß', 'autoKey': true, 'aValue': -2, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBAÄÖÜẞ', 'expectedOutput' : 'Asßnu Zmhäöi ftüsj ßtbndaa'},
      {'input' : 'Außer Spesen nicht gewährt', 'key': 'Xvxcß', 'autoKey': false, 'aValue': -2, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBAÄÖÜẞ', 'expectedOutput' : 'Asßnu Sneühn lilkt eebchpt'},
      {'input' : 'Außer Spesen nicht gewährt', 'key': '0 2 0, 21 27', 'autoKey': false, 'aValue': -2, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBAÄÖÜẞ', 'expectedOutput' : 'Asßnu Sneühn lilkt eebchpt'},
      {'input' : 'Außer Spesen nicht gewährt', 'key': '0 2 0, 21 27', 'autoKey': true, 'aValue': -2, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBAÄÖÜẞ', 'expectedOutput' : 'Asßnu Zmhäöi ftüsj ßtbndaa'},
      {'input' : 'ABC', 'key': 'abc', 'autoKey': false, 'aValue': -2, 'alphabet': 'abcd', 'expectedOutput' : 'CAC'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}, alphabet: ${elem['alphabet']}', () {
        var _letters = <String, String>{};
        var givenLetters = elem['alphabet'] as String;
        for (int i = 0; i < givenLetters.length; i++) {
          _letters.putIfAbsent(givenLetters[i], () => '');
        }
        var alphabet = Alphabet(key: 'x', alphabet: _letters);

        var _actual = encryptVigenere(
            elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int, alphabet: alphabet);
        expect(_actual, elem['expectedOutput']);

      });
    }
  });

  group("Vigenere.encryptUnrepeatedKey:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'key': '', 'autoKey': false, 'aValue': 1, 'expectedOutput' : '', 'repeatKey' : true},
      {'input' : '', 'key': '', 'autoKey': false, 'aValue': 1, 'expectedOutput' : '', 'repeatKey' : false},
      {'input' : 'ABCDE', 'key': '', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'ABCDE', 'repeatKey' : true},
      {'input' : 'ABCDE', 'key': '', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'ABCDE', 'repeatKey' : false},
      {'input' : '', 'key': 'AB', 'autoKey': false, 'aValue': 1, 'expectedOutput' : '', 'repeatKey' : true},
      {'input' : '', 'key': 'AB', 'autoKey': false, 'aValue': 1, 'expectedOutput' : '', 'repeatKey' : false},

      {'input' : 'ABCDE', 'key': 'AB', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'BDDFF', 'repeatKey' : true},
      {'input' : 'ABCDE', 'key': 'AB', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'BDCDE', 'repeatKey' : false},
      {'input' : 'ABCDE', 'key': 'ABCDE', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'BDFHJ', 'repeatKey' : true},
      {'input' : 'ABCDE', 'key': 'ABCDE', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'BDFHJ', 'repeatKey' : false},
      {'input' : 'ABCDE', 'key': 'ABCDEF', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'BDFHJ', 'repeatKey' : true},
      {'input' : 'ABCDE', 'key': 'ABCDEF', 'autoKey': false, 'aValue': 1, 'expectedOutput' : 'BDFHJ', 'repeatKey' : false},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}, repeatKey: ${elem['repeatKey']}', () {
        var _actual = encryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int, repeatKey: elem['repeatKey'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Vigenere.decrypt:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'MOQ', 'key': 'MNO', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABC'},

      {'input' : '', 'key': '', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : '', 'key': 'ABC', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': '', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABC'},
      {'input' : '', 'key': '', 'autoKey': true, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : '', 'key': 'ABC', 'autoKey': true, 'aValue': 0, 'expectedOutput' : ''},
      {'input' : 'ABC', 'key': '', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'ABC'},

      {'input' : 'MOQ', 'key': 'MNO', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABC'},
      {'input' : 'MOOQQS', 'key': 'MN', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'ABCDEF'},
      {'input' : 'MOCEGI', 'key': 'MN', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'ABCDEF'},

      {'input' : 'Moq', 'key': 'mnO', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'Abc'},
      {'input' : 'MoOQqS', 'key': 'MN', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'AbCDeF'},
      {'input' : 'MOcegI', 'key': 'mn', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'ABcdeF'},

      {'input' : 'Mo12q', 'key': 'mnO', 'autoKey': false, 'aValue': 0, 'expectedOutput' : 'Ab12c'},
      {'input' : ' M%67oO QqS_', 'key': 'MN', 'autoKey': false, 'aValue': 0, 'expectedOutput' : ' A%67bC DeF_'},
      {'input' : 'M Oce23gI', 'key': 'mn', 'autoKey': true, 'aValue': 0, 'expectedOutput' : 'A Bcd23eF'},

      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 1, 'input' : 'NpPRrT'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 13, 'input' : 'ZbBDdF'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 26, 'input' : 'MoOQqS'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 27, 'input' : 'NpPRrT'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': 52, 'input' : 'MoOQqS'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -1, 'input' : 'LnNPpR'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -13, 'input' : 'ZbBDdF'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -26, 'input' : 'MoOQqS'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -27, 'input' : 'LnNPpR'},
      {'expectedOutput' : 'AbCDeF', 'key': 'MN', 'autoKey': false, 'aValue': -52, 'input' : 'MoOQqS'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 1, 'input' : 'NpDFhJ'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 13, 'input' : 'ZbPRtV'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 26, 'input' : 'MoCEgI'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 27, 'input' : 'NpDFhJ'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': 52, 'input' : 'MoCEgI'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -1, 'input' : 'LnBDfH'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -13, 'input' : 'ZbPRtV'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -26, 'input' : 'MoCEgI'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -27, 'input' : 'LnBDfH'},
      {'expectedOutput' : 'AbCDeF', 'key': 'mn', 'autoKey': true, 'aValue': -52, 'input' : 'MoCEgI'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = decryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Vigenere.decryptIgnoreNonLetters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'expectedOutput' : 'Wie ich sehe hast du das Rätsel gelöst. Du wirst jetzt sicherlich die Koordinaten lesen wollen, keine Sorge, dass wirst du. Aber zunächst ',
        'key': 'beteigeuze',
        'autoKey': false,
        'aValue': 0,
        'input' : 'Xmx qil riii liyx cy htw Xänrim zitöwn. Ey aqxwn nfxsx ymwgispbgp hcd Lshvlorusio eiakr vsmpxr, oyhrf Lszmi, hbwl eovms ey. Ihil dvrägpyx '
      },
      {
        'expectedOutput' : 'WIEICHSEHEHASTDUDASRTSELGELSTDUWIRSTJETZTSICHERLICHDIEKOORDINATENLESENWOLLENKEINESORGEDASSWIRSTDUABERZUNCHST',
        'key': 'beteigeuze',
        'autoKey': true,
        'aValue': 0,
        'input' : 'XMXMKNWYGIDIWBFBVEZVASWEJYOSLUNOMCYXUWMCNOQTZXAPBBAVQGRSFCLKUDBIXZSJHVJOEPRYOWMAAGZCKRNEAFAAFJZHXATWNHLFVKMT'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = decryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int, ignoreNonLetters: false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Vigenere.decryptKeyNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : 'AbCDeF', 'key': '12 13', 'autoKey': false, 'aValue': 1, 'input' : 'MoOQqS'},
      {'expectedOutput' : 'AbCDeF', 'key': '12    13', 'autoKey': false, 'aValue': 13, 'input' : 'MoOQqS'},
      {'expectedOutput' : 'AbCDeF', 'key': '12 ,13', 'autoKey': true, 'aValue': 1, 'input' : 'MoDFhJ'},
      {'expectedOutput' : 'AbCDeF', 'key': '12, -13', 'autoKey': true, 'aValue': 13, 'input' : 'MoPRtV'},

      {'expectedOutput' : 'Unter', 'key': '1 17 24 16 0', 'autoKey': false, 'aValue': 13, 'input' : 'Verur'},
      {'expectedOutput' : 'AbcxyZ', 'key': '1 2,3,,,4 5; 6', 'autoKey': false, 'aValue': 1, 'input' : 'BdfbdF'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}', () {
        var _actual = decryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int, ignoreNonLetters: false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Vigenere.decryptWithDifferentAlphabets:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : 'ABC', 'key': 'MNO', 'autoKey': false, 'aValue': 0, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBA', 'input' : 'NPR'},
      {'expectedOutput' : 'ABC', 'key': 'MNO', 'autoKey': false, 'aValue': 0, 'alphabet': 'QWERTZUIOPASDFGHJKLYXCVBNM', 'input' : 'PCR'},
      {'expectedOutput' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'input' : 'ü'},
      {'expectedOutput' : 'ß', 'key': '29', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'input' : 'ü'},
      {'expectedOutput' : 'ß', 'key': 'ẞ', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'input' : 'ü'},
      {'expectedOutput' : 'ẞ', 'key': 'ß', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'input' : 'Ü'},
      {'expectedOutput' : 'ẞ', 'key': 'ẞ', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß', 'input' : 'Ü'},
      {'expectedOutput' : 'ẞ', 'key': 'ẞ', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'input' : 'Ü'},
      {'expectedOutput' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': 0, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'input' : 'ü'},
      {'expectedOutput' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': 1, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'input' : 'ß'},
      {'expectedOutput' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': -1, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'input' : 'ö'},
      {'expectedOutput' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': 52, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'input' : 'u'},
      {'expectedOutput' : 'ß', 'key': 'ß', 'autoKey': false, 'aValue': -52, 'alphabet': 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜẞ', 'input' : 'g'},
      {'expectedOutput' : 'Außer Spesen nicht gewährt', 'key': 'Xvxcß', 'autoKey': true, 'aValue': -2, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBAÄÖÜẞ', 'input' : 'Asßnu Zmhäöi ftüsj ßtbndaa'},
      {'expectedOutput' : 'Außer Spesen nicht gewährt', 'key': 'Xvxcß', 'autoKey': false, 'aValue': -2, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBAÄÖÜẞ', 'input' : 'Asßnu Sneühn lilkt eebchpt'},
      {'expectedOutput' : 'Außer Spesen nicht gewährt', 'key': '0 2 0, 21 27', 'autoKey': false, 'aValue': -2, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBAÄÖÜẞ', 'input' : 'Asßnu Sneühn lilkt eebchpt'},
      {'expectedOutput' : 'Außer Spesen nicht gewährt', 'key': '0 2 0, 21 27', 'autoKey': true, 'aValue': -2, 'alphabet': 'ZYXWVUTSRQPONMLKJIHGFEDCBAÄÖÜẞ', 'input' : 'Asßnu Zmhäöi ftüsj ßtbndaa'},
      {'expectedOutput' : 'ABC', 'key': 'abc', 'autoKey': false, 'aValue': -2, 'alphabet': 'abcd', 'input' : 'CAC'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}, alphabet: ${elem['alphabet']}', () {
        var _letters = <String, String>{};
        var givenLetters = elem['alphabet'] as String;
        for (int i = 0; i < givenLetters.length; i++) {
          _letters.putIfAbsent(givenLetters[i], () => '');
        }
        var alphabet = Alphabet(key: 'x', alphabet: _letters);

        var _actual = decryptVigenere(
            elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int, alphabet: alphabet);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Vigenere.decryptUnrepeatedKey:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : '', 'key': '', 'autoKey': false, 'aValue': 1, 'input' : '', 'repeatKey' : true},
      {'expectedOutput' : '', 'key': '', 'autoKey': false, 'aValue': 1, 'input' : '', 'repeatKey' : false},
      {'expectedOutput' : 'ABCDE', 'key': '', 'autoKey': false, 'aValue': 1, 'input' : 'ABCDE', 'repeatKey' : true},
      {'expectedOutput' : 'ABCDE', 'key': '', 'autoKey': false, 'aValue': 1, 'input' : 'ABCDE', 'repeatKey' : false},
      {'expectedOutput' : '', 'key': 'AB', 'autoKey': false, 'aValue': 1, 'input' : '', 'repeatKey' : true},
      {'expectedOutput' : '', 'key': 'AB', 'autoKey': false, 'aValue': 1, 'input' : '', 'repeatKey' : false},

      {'expectedOutput' : 'ABCDE', 'key': 'AB', 'autoKey': false, 'aValue': 1, 'input' : 'BDDFF', 'repeatKey' : true},
      {'expectedOutput' : 'ABCDE', 'key': 'AB', 'autoKey': false, 'aValue': 1, 'input' : 'BDCDE', 'repeatKey' : false},
      {'expectedOutput' : 'ABCDE', 'key': 'ABCDE', 'autoKey': false, 'aValue': 1, 'input' : 'BDFHJ', 'repeatKey' : true},
      {'expectedOutput' : 'ABCDE', 'key': 'ABCDE', 'autoKey': false, 'aValue': 1, 'input' : 'BDFHJ', 'repeatKey' : false},
      {'expectedOutput' : 'ABCDE', 'key': 'ABCDEF', 'autoKey': false, 'aValue': 1, 'input' : 'BDFHJ', 'repeatKey' : true},
      {'expectedOutput' : 'ABCDE', 'key': 'ABCDEF', 'autoKey': false, 'aValue': 1, 'input' : 'BDFHJ', 'repeatKey' : false},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}, aValue: ${elem['aValue']}, autoKey: ${elem['autoKey']}, repeatKey: ${elem['repeatKey']}', () {
        var _actual = decryptVigenere(elem['input'] as String, elem['key'] as String, elem['autoKey'] as bool, aValue: elem['aValue'] as int, repeatKey: elem['repeatKey'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}