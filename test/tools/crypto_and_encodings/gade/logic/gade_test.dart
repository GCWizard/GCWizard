import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/gade/logic/gade.dart';

void main() {
  group("Gade.buildGade:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': '',
        'expectedOutput': {
          'A': '0',
          'B': '1',
          'C': '2',
          'D': '3',
          'E': '4',
          'F': '5',
          'G': '6',
          'H': '7',
          'I': '8',
          'J': '9'
        }
      },
      {
        'input': 'd',
        'expectedOutput': {
          'A': '0',
          'B': '1',
          'C': '2',
          'D': '3',
          'E': '4',
          'F': '5',
          'G': '6',
          'H': '7',
          'I': '8',
          'J': '9'
        }
      },
      {
        'input': '1',
        'expectedOutput': {
          'A': '1',
          'B': '0',
          'C': '2',
          'D': '3',
          'E': '4',
          'F': '5',
          'G': '6',
          'H': '7',
          'I': '8',
          'J': '9'
        }
      },
      {
        'input': 'd 4wt zwer46 89 3',
        'expectedOutput': {
          'A': '3',
          'B': '4',
          'C': '4',
          'D': '6',
          'E': '8',
          'F': '9',
          'G': '0',
          'H': '1',
          'I': '2',
          'J': '5',
          'K': '7'
        }
      },
      {
        'input': '22.04.1968 01.07.1987 11.02.1994',
        'expectedOutput': {
          'A': '0',
          'B': '0',
          'C': '0',
          'D': '0',
          'E': '1',
          'F': '1',
          'G': '1',
          'H': '1',
          'I': '1',
          'J': '1',
          'K': '2',
          'L': '2',
          'M': '2',
          'N': '4',
          'O': '4',
          'P': '6',
          'Q': '7',
          'R': '7',
          'S': '8',
          'T': '8',
          'U': '9',
          'V': '9',
          'W': '9',
          'X': '9',
          'Y': '3',
          'Z': '5'
        }
      },
      // https://gcwiki.dk/doku.php?id=edag_beregningsteknik&s%5b%5d=gade
      {
        'input': 'Geocaching HQ 206-302-7721',
        'expectedOutput': {
          'A': '0',
          'B': '0',
          'C': '1',
          'D': '2',
          'E': '2',
          'F': '2',
          'G': '3',
          'H': '6',
          'I': '7',
          'J': '7',
          'K': '4',
          'L': '5',
          'M': '8',
          'N': '9',
        }
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = calculateGade(GADE_TYPES.GADE, elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Gade.buildEdag", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': '',
        'expectedOutput': {
          'A': '9',
          'B': '8',
          'C': '7',
          'D': '6',
          'E': '5',
          'F': '4',
          'G': '3',
          'H': '2',
          'I': '1',
          'J': '0'
        }
      },
      {
        'input': 'd',
        'expectedOutput': {
          'A': '9',
          'B': '8',
          'C': '7',
          'D': '6',
          'E': '5',
          'F': '4',
          'G': '3',
          'H': '2',
          'I': '1',
          'J': '0'
        }
      },
      {
        'input': '1',
        'expectedOutput': {
          'A': '1',
          'B': '9',
          'C': '8',
          'D': '7',
          'E': '6',
          'F': '5',
          'G': '4',
          'H': '3',
          'I': '2',
          'J': '0'
        }
      },
      {
        'input': 'd 4wt zwer46 89 3',
        'expectedOutput': {
          'A': '9',
          'B': '8',
          'C': '6',
          'D': '4',
          'E': '4',
          'F': '3',
          'G': '7',
          'H': '5',
          'I': '2',
          'J': '1',
          'K': '0'
        }
      },
      {
        'input': '22.04.1968 01.07.1987 11.02.1994',
        'expectedOutput': {
          'A': '9',
          'B': '9',
          'C': '9',
          'D': '9',
          'E': '8',
          'F': '8',
          'G': '7',
          'H': '7',
          'I': '6',
          'J': '4',
          'K': '4',
          'L': '2',
          'M': '2',
          'N': '2',
          'O': '1',
          'P': '1',
          'Q': '1',
          'R': '1',
          'S': '1',
          'T': '1',
          'U': '0',
          'V': '0',
          'W': '0',
          'X': '0',
          'Y': '5',
          'Z': '3'
        }
      },
      // https://gcwiki.dk/doku.php?id=edag_beregningsteknik
      {
        'input': 'Geocaching HQ 206-302-7721',
        'expectedOutput': {
          'A': '7',
          'B': '7',
          'C': '6',
          'D': '3',
          'E': '2',
          'F': '2',
          'G': '2',
          'H': '1',
          'I': '0',
          'J': '0',
          'K': '9',
          'L': '8',
          'M': '5',
          'N': '4',
        }
      },
      // Trafo #18  GCBDY3G:   05086 30
      {
        'input': '05086 30',
        'expectedOutput': {
          'A': '8',
          'B': '6',
          'C': '5',
          'D': '3',
          'E': '0',
          'F': '0',
          'G': '0',
          'H': '9',
          'I': '7',
          'J': '4',
          'K': '2',
          'L': '1'
        }
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = calculateGade(GADE_TYPES.EDAG, elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Gade.buildLowe:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': '',
        'expectedOutput': {
          'A': '0',
          'B': '2',
          'C': '4',
          'D': '6',
          'E': '8',
          'F': '1',
          'G': '3',
          'H': '5',
          'I': '7',
          'J': '9'
        }
      },
      {
        'input': 'd',
        'expectedOutput': {
          'A': '0',
          'B': '2',
          'C': '4',
          'D': '6',
          'E': '8',
          'F': '1',
          'G': '3',
          'H': '5',
          'I': '7',
          'J': '9'
        }
      },
      {
        'input': '1',
        'expectedOutput': {
          'A': '0',
          'B': '2',
          'C': '4',
          'D': '6',
          'E': '8',
          'F': '1',
          'G': '3',
          'H': '5',
          'I': '7',
          'J': '9'
        }
      },
      {
        'input': 'd 4wt zwer46 89 3',
        'expectedOutput': {
          'A': '4',
          'B': '4',
          'C': '6',
          'D': '8',
          'E': '0',
          'F': '2',
          'G': '3',
          'H': '9',
          'I': '1',
          'J': '5',
          'K': '7'
        }
      },
      {
        'input': '22.04.1968 01.07.1987 11.02.1994',
        'expectedOutput': {
          'A': '0',
          'B': '0',
          'C': '0',
          'D': '0',
          'E': '2',
          'F': '2',
          'G': '2',
          'H': '4',
          'I': '4',
          'J': '6',
          'K': '8',
          'L': '8',
          'M': '1',
          'N': '1',
          'O': '1',
          'P': '1',
          'Q': '1',
          'R': '1',
          'S': '7',
          'T': '7',
          'U': '9',
          'V': '9',
          'W': '9',
          'X': '9',
          'Y': '3',
          'Z': '5'
        }
      },
      // https://gcwiki.dk/doku.php?id=edag_beregningsteknik&s%5b%5d=gade
      {
        'input': 'Geocaching HQ 206-302-7721',
        'expectedOutput': {
          'A': '0',
          'B': '0',
          'C': '2',
          'D': '2',
          'E': '2',
          'F': '6',
          'G': '4',
          'H': '8',
          'I': '1',
          'J': '3',
          'K': '7',
          'L': '7',
          'M': '5',
          'N': '9'
        }
      },
      // Trafo #20  GCBDZNE:   72276 83
      {
        'input': '72276 83',
        'expectedOutput': {
          'A': '2',
          'B': '2',
          'C': '6',
          'D': '8',
          'E': '0',
          'F': '4',
          'G': '3',
          'H': '7',
          'I': '7',
          'J': '1',
          'K': '5',
          'L': '9'
        }
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = calculateGade(GADE_TYPES.LOWE, elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Gade.buildEwol:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {
        'input': '',
        'expectedOutput': {
          'A': '9',
          'B': '7',
          'C': '5',
          'D': '3',
          'E': '1',
          'F': '8',
          'G': '6',
          'H': '4',
          'I': '2',
          'J': '0'
        }
      },
      {
        'input': 'd',
        'expectedOutput': {
          'A': '9',
          'B': '7',
          'C': '5',
          'D': '3',
          'E': '1',
          'F': '8',
          'G': '6',
          'H': '4',
          'I': '2',
          'J': '0'
        }
      },
      {
        'input': '1',
        'expectedOutput': {
          'A': '1',
          'B': '9',
          'C': '7',
          'D': '5',
          'E': '3',
          'F': '8',
          'G': '6',
          'H': '4',
          'I': '2',
          'J': '0'
        }
      },
      {
        'input': 'd 4wt zwer46 89 3',
        'expectedOutput': {
          'A': '9',
          'B': '3',
          'C': '7',
          'D': '5',
          'E': '1',
          'F': '8',
          'G': '6',
          'H': '4',
          'I': '4',
          'J': '2',
          'K': '0'
        }
      },
      {
        'input': '22.04.1968 01.07.1987 11.02.1994',
        'expectedOutput': {
          'A': '9',
          'B': '9',
          'C': '9',
          'D': '9',
          'E': '7',
          'F': '7',
          'G': '1',
          'H': '1',
          'I': '1',
          'J': '1',
          'K': '1',
          'L': '1',
          'M': '5',
          'N': '3',
          'O': '8',
          'P': '8',
          'Q': '6',
          'R': '4',
          'S': '4',
          'T': '2',
          'U': '2',
          'V': '2',
          'W': '0',
          'X': '0',
          'Y': '0',
          'Z': '0'
        }
      },
      // https://gcwiki.dk/doku.php?id=ewol
      {
        'input': 'Geocaching HQ 206-302-7721',
        'expectedOutput': {
          'A': '7',
          'B': '7',
          'C': '3',
          'D': '1',
          'E': '9',
          'F': '5',
          'G': '6',
          'H': '2',
          'I': '2',
          'J': '2',
          'K': '0',
          'L': '0',
          'M': '8',
          'N': '4',
        }
      },
      // GC Trafo #17  GCBDY2R:   72478 37 39
      {
        'input': '72478 37 39',
        'expectedOutput': {
          'A': '9',
          'B': '7',
          'C': '7',
          'D': '7',
          'E': '3',
          'F': '3',
          'G': '5',
          'H': '1',
          'I': '8',
          'J': '4',
          'K': '2',
          'L': '6',
          'M': '0',
        }
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = calculateGade(GADE_TYPES.EWOL, elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
