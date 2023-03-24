import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/enigma/logic/enigma.dart';
import 'package:gc_wizard/utils/complex_return_types.dart';

void main() {
  // test double-step anomaly by checking the rotor setting after calculation
  // double step anomaly https://de.wikipedia.org/wiki/Enigma_(Maschine)#Anomalie (German link)
  group("Enigma.calculateEnigma; test double-step anomaly", () {
    var key = EnigmaKey(
      [
        EnigmaRotorConfiguration(const EnigmaRotor('ETW, Enigma I \'Wehrmacht\'', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', type: EnigmaRotorType.ENTRY_ROTOR)),
        EnigmaRotorConfiguration(const EnigmaRotor('III, Enigma I \'Wehrmacht\'', 'BDFHJLCPRTXVZNYEIWGAKMUSQO', turnovers: 'V'), offset: 1, setting: 21), // U
        EnigmaRotorConfiguration(const EnigmaRotor('II, Enigma I \'Wehrmacht\'', 'AJDKSIRUXBLHWTMCQGZNPYFVOE', turnovers: 'E'), offset: 1, setting: 4),   // D
        EnigmaRotorConfiguration(const EnigmaRotor('I, Enigma I \'Wehrmacht\'', 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', turnovers: 'Q'), offset: 1, setting: 1),    // A
        EnigmaRotorConfiguration(const EnigmaRotor('UKW B, M3 + M4 \'Wehrmacht\'', 'YRUHQSLDPXNGOKMIEBFZCWVJAT', type: EnigmaRotorType.REFLECTOR)),
      ],
    );

    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'AAAA', 'expectedOutput' : 'BFY'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: $key', () {
        var _actual = calculateEnigma(elem['input'] as String, key).value
            .sublist(1,4) //ignore ETW and UKW
            .map((setting) => alphabet_AZIndexes[setting + 1])
            .toList()
            .reversed
            .join();
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  // test auto-decryption of message with message key; source: Enigma GeoCoin
  group("Enigma.calculateEnigmaWithMessageKey", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input' : 'SJDSFTTVWBZXPDUMYUCRNPLNOQDURZLAVGXOGURQIORHNRDKMAIKVUVCXBSHDELVXIIEHCRMJPQWJIANTPWNKDRGPBBEKPSPDCZBNTFKUWBY',
        'key' : EnigmaKey(
            [
              EnigmaRotorConfiguration(const EnigmaRotor('ETW, Enigma I \'Wehrmacht\'', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', type: EnigmaRotorType.ENTRY_ROTOR)),
              EnigmaRotorConfiguration(const EnigmaRotor('III, Enigma I \'Wehrmacht\'', 'BDFHJLCPRTXVZNYEIWGAKMUSQO', turnovers: 'V'), offset: 'E', setting: 'C'),
              EnigmaRotorConfiguration(const EnigmaRotor('VI, M3 + M4 \'Wehrmacht\'', 'JPGVOUMFYQBENHZRDKASXLICTW', turnovers: 'ZM'), offset: 'U', setting: 'G'),
              EnigmaRotorConfiguration(const EnigmaRotor('I, Enigma I \'Wehrmacht\'', 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', turnovers: 'Q'), offset: 'F', setting: 'E'),
              EnigmaRotorConfiguration(const EnigmaRotor('UKW C, M3 + M4 \'Wehrmacht\'', 'FVPJIAOYEDRZXWGCTKUQSBNMHL', type: EnigmaRotorType.REFLECTOR)),
            ],
            plugboard: {'w':'S', 'R':'F', 'Z': 'H', 'B': 'U', 'D': 'C', 'G': 'N', 'J': 'M', 'A': 'E'}
        ),
        'expectedOutput' : [
          IntegerListText('GEOGEOCTYQLIZYHXOTOLWEEDTPQXCDHNCUHZBNXEOXTCVWUOIVZMIOSTPTLJAPYOKVYSXSQBIRGEGKHOOYPJZZUWGRWZHMEXRLPYOENEPDZG', [0, 6, 10, 4, 0]),
          IntegerListText('CONGRATULATIONYOUHAVEDECRYPTSUCCESSFULTHEENIGMAGEOCOINBYFERANDERIPLEASEVISITMISSIONENIGMAINSWITZERLAND', [0, 12, 8, 6, 0]),
        ]
      },
      { //Without Entry Rotor
        'input' : 'SJDSFTTVWBZXPDUMYUCRNPLNOQDURZLAVGXOGURQIORHNRDKMAIKVUVCXBSHDELVXIIEHCRMJPQWJIANTPWNKDRGPBBEKPSPDCZBNTFKUWBY',
        'key' : EnigmaKey(
            [
              EnigmaRotorConfiguration(const EnigmaRotor('III, Enigma I \'Wehrmacht\'', 'BDFHJLCPRTXVZNYEIWGAKMUSQO', turnovers: 'V'), offset: 'E', setting: 'C'),
              EnigmaRotorConfiguration(const EnigmaRotor('VI, M3 + M4 \'Wehrmacht\'', 'JPGVOUMFYQBENHZRDKASXLICTW', turnovers: 'ZM'), offset: 'U', setting: 'G'),
              EnigmaRotorConfiguration(const EnigmaRotor('I, Enigma I \'Wehrmacht\'', 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', turnovers: 'Q'), offset: 'F', setting: 'E'),
              EnigmaRotorConfiguration(const EnigmaRotor('UKW C, M3 + M4 \'Wehrmacht\'', 'FVPJIAOYEDRZXWGCTKUQSBNMHL', type: EnigmaRotorType.REFLECTOR)),
            ],
            plugboard: {'w':'S', 'R':'F', 'Z': 'H', 'B': 'U', 'D': 'C', 'G': 'N', 'J': 'M', 'A': 'E'}
        ),
        'expectedOutput' : [
            IntegerListText('GEOGEOCTYQLIZYHXOTOLWEEDTPQXCDHNCUHZBNXEOXTCVWUOIVZMIOSTPTLJAPYOKVYSXSQBIRGEGKHOOYPJZZUWGRWZHMEXRLPYOENEPDZG', [6, 10, 4, 0]),
            IntegerListText('CONGRATULATIONYOUHAVEDECRYPTSUCCESSFULTHEENIGMAGEOCOINBYFERANDERIPLEASEVISITMISSIONENIGMAINSWITZERLAND', [12, 8, 6, 0]),
          ]
      },
      { //Without Entry Rotor
        'input' : 'SJDSF TTVWB ZXPDU MYUCR NPLNO QDURZ LAVGX OGURQ IORHN RDKMA IKVUV CXBSH DELVX IIEHC RMJPQ WJIAN TPWNK DRGPB BEKPS PDCZB NTFKU WBY',
        'key' : EnigmaKey(
            [
              EnigmaRotorConfiguration(const EnigmaRotor('III, Enigma I \'Wehrmacht\'', 'BDFHJLCPRTXVZNYEIWGAKMUSQO', turnovers: 'V'), offset: 'E', setting: 'C'),
              EnigmaRotorConfiguration(const EnigmaRotor('VI, M3 + M4 \'Wehrmacht\'', 'JPGVOUMFYQBENHZRDKASXLICTW', turnovers: 'ZM'), offset: 'U', setting: 'G'),
              EnigmaRotorConfiguration(const EnigmaRotor('I, Enigma I \'Wehrmacht\'', 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', turnovers: 'Q'), offset: 'F', setting: 'E'),
              EnigmaRotorConfiguration(const EnigmaRotor('UKW C, M3 + M4 \'Wehrmacht\'', 'FVPJIAOYEDRZXWGCTKUQSBNMHL', type: EnigmaRotorType.REFLECTOR)),
            ],
            plugboard: {'w':'S', 'R':'F', 'Z': 'H', 'B': 'U', 'D': 'C', 'G': 'N', 'J': 'M', 'A': 'E'}
        ),
        'expectedOutput' : [
            IntegerListText('GEOGEOCTYQLIZYHXOTOLWEEDTPQXCDHNCUHZBNXEOXTCVWUOIVZMIOSTPTLJAPYOKVYSXSQBIRGEGKHOOYPJZZUWGRWZHMEXRLPYOENEPDZG', [6, 10, 4, 0]),
            IntegerListText('CONGRATULATIONYOUHAVEDECRYPTSUCCESSFULTHEENIGMAGEOCOINBYFERANDERIPLEASEVISITMISSIONENIGMAINSWITZERLAND', [12, 8, 6, 0]),
          ]
        },
      {
        'input' : 'CONGRATULATIONYOUHAVEDECRYPTSUCCESSFULTHEENIGMAGEOCOINBYFERANDERIPLEASEVISITMISSIONENIGMAINSWITZERLAND',
        'key' : EnigmaKey(
            [
              EnigmaRotorConfiguration(const EnigmaRotor('ETW, Enigma I \'Wehrmacht\'', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', type: EnigmaRotorType.ENTRY_ROTOR)),
              EnigmaRotorConfiguration(const EnigmaRotor('III, Enigma I \'Wehrmacht\'', 'BDFHJLCPRTXVZNYEIWGAKMUSQO', turnovers: 'V'), offset: 'E', setting: 'O'),
              EnigmaRotorConfiguration(const EnigmaRotor('VI, M3 + M4 \'Wehrmacht\'', 'JPGVOUMFYQBENHZRDKASXLICTW', turnovers: 'ZM'), offset: 'U', setting: 'E'),
              EnigmaRotorConfiguration(const EnigmaRotor('I, Enigma I \'Wehrmacht\'', 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', turnovers: 'Q'), offset: 'F', setting: 'G'),
              EnigmaRotorConfiguration(const EnigmaRotor('UKW C, M3 + M4 \'Wehrmacht\'', 'FVPJIAOYEDRZXWGCTKUQSBNMHL', type: EnigmaRotorType.REFLECTOR)),
            ],
            plugboard: {'W':'S', 'R':'F', 'Z': 'H', 'B': 'U', 'D': 'C', 'G': 'N', 'J': 'M', 'A': 'E'}
        ),
        'expectedOutput' : [
            IntegerListText('TVWBZXPDUMYUCRNPLNOQDURZLAVGXOGURQIORHNRDKMAIKVUVCXBSHDELVXIIEHCRMJPQWJIANTPWNKDRGPBBEKPSPDCZBNTFKUWBY', [0, 12, 8, 6, 0]),
          ]
      },
      {
        'input' : 'GEOGEOCTYQLIZYHXOTOLWEEDTPQXCDHNCUHZBNXEOXTCVWUOIVZMIOSTPTLJAPYOKVYSXSQBIRGEGKHOOYPJZZUWGRWZHMEXRLPYOENEPDZG',
        'key' : EnigmaKey(
            [
              EnigmaRotorConfiguration(const EnigmaRotor('ETW, Enigma I \'Wehrmacht\'', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', type: EnigmaRotorType.ENTRY_ROTOR)),
              EnigmaRotorConfiguration(const EnigmaRotor('III, Enigma I \'Wehrmacht\'', 'BDFHJLCPRTXVZNYEIWGAKMUSQO', turnovers: 'V'), offset: 'E', setting: 'C'),
              EnigmaRotorConfiguration(const EnigmaRotor('VI, M3 + M4 \'Wehrmacht\'', 'JPGVOUMFYQBENHZRDKASXLICTW', turnovers: 'ZM'), offset: 'U', setting: 'G'),
              EnigmaRotorConfiguration(const EnigmaRotor('I, Enigma I \'Wehrmacht\'', 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', turnovers: 'Q'), offset: 'F', setting: 'E'),
              EnigmaRotorConfiguration(const EnigmaRotor('UKW C, M3 + M4 \'Wehrmacht\'', 'FVPJIAOYEDRZXWGCTKUQSBNMHL', type: EnigmaRotorType.REFLECTOR)),
            ],
            plugboard: {'W':'S', 'R':'F', 'Z': 'H', 'B': 'U', 'D': 'C', 'G': 'N', 'J': 'M', 'A': 'E'}
        ),
        'expectedOutput' : [
            IntegerListText('SJDSFTTVWBZXPDUMYUCRNPLNOQDURZLAVGXOGURQIORHNRDKMAIKVUVCXBSHDELVXIIEHCRMJPQWJIANTPWNKDRGPBBEKPSPDCZBNTFKUWBY', [0, 6, 10, 4, 0]),
          ]
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, key: ${elem['key']}', () {
        var _actual = calculateEnigmaWithMessageKey(elem['input'] as String, elem['key'] as EnigmaKey);

        var expected =elem['expectedOutput'] as List<IntegerListText>;
        expect(_actual.length, expected.length);

        for (var i=0; i< _actual.length; i++){
          expect(_actual[i], _actual[i]);
        }
      });
    }
  });
}