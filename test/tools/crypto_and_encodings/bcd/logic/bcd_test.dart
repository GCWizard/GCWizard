import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/bcd/_common/logic/bcd.dart';

void main() {

  // Original ---------------------------------------------------------------------

  group("BCD.encodeOriginal", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0001 1001 0110 1000'},
      {'input' : '2ab2', 'expectedOutput' : '0010 0010'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.ORIGINAL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeOriginal:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0001 1001 0110 1000'},
      {'expectedOutput' : '22', 'input' : '0010 0010'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.ORIGINAL);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Aiken ---------------------------------------------------------------------

  group("BCD.encodeAiken", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0001 1111 1100 1110'},
      {'input' : '2ab2', 'expectedOutput' : '0010 0010'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.AIKEN);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeAiken:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0001 1111 1100 1110'},
      {'expectedOutput' : '22', 'input' : '0010 0010'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.AIKEN);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Libaw-Craig ---------------------------------------------------------------

  group("BCD.encodeLibawCraig", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '00001 10000 11110 11000'},
      {'input' : '2ab2', 'expectedOutput' : '00011 00011'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.LIBAWCRAIG);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeLibawCraig:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '00001 10000 11110 11000'},
      {'expectedOutput' : '22', 'input' : '00011 00011'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.LIBAWCRAIG);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Stibitz -------------------------------------------------------------------

  group("BCD.encodeStibitz", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0100 1100 1001 1011'},
      {'input' : '2ab2', 'expectedOutput' : '0101 0101'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.STIBITZ);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeStibitz:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0100 1100 1001 1011'},
      {'expectedOutput' : '22', 'input' : '0101 0101'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.STIBITZ);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Gray -------------------------------------------------------------------

  group("BCD.encodeGray", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0001 1101 0101 1100'},
      {'input' : '2ab2', 'expectedOutput' : '0011 0011'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.GRAY);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeGray:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0001 1101 0101 1100'},
      {'expectedOutput' : '22', 'input' : '0011 0011'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.GRAY);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Glixon -------------------------------------------------------------------

  group("BCD.encodeGlixon", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0001 1000 0101 1100'},
      {'input' : '2ab2', 'expectedOutput' : '0011 0011'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.GLIXON);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeGlixon:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0001 1000 0101 1100'},
      {'expectedOutput' : '22', 'input' : '0011 0011'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.GLIXON);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // O'Brien -------------------------------------------------------------------

  group("BCD.encodeOBrien", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0011 1001 1110 1011'},
      {'input' : '2ab2', 'expectedOutput' : '0010 0010'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.OBRIEN);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeOBrien:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0011 1001 1110 1011'},
      {'expectedOutput' : '22', 'input' : '0010 0010'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.OBRIEN);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Petherick -------------------------------------------------------------------

  group("BCD.encodePetherick", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0001 1101 1010 1001'},
      {'input' : '2ab2', 'expectedOutput' : '0011 0011'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.PETHERICK);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodePetherick:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0001 1101 1010 1001'},
      {'expectedOutput' : '22', 'input' : '0011 0011'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.PETHERICK);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Tompkins -------------------------------------------------------------------

  group("BCD.encodeTompkins", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0011 1010 1101 1011'},
      {'input' : '2ab2', 'expectedOutput' : '0111 0111'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.TOMPKINS);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeTompkins:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0011 1010 1101 1011'},
      {'expectedOutput' : '22', 'input' : '0111 0111'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.TOMPKINS);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Hamming -------------------------------------------------------------------

  group("BCD.encodeHamming", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0000111 1001100 0110011 1001011'},
      {'input' : '2ab2', 'expectedOutput' : '0011001 0011001'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.HAMMING);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeHamming:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0000111 1001100 0110011 1001011'},
      {'expectedOutput' : '22', 'input' : '0011001 0011001'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.HAMMING);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // Biquinaer -------------------------------------------------------------------

  group("BCD.encodeBiquinaer", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '1000010 0110000 0100010 0101000'},
      {'input' : '2ab2', 'expectedOutput' : '1000100 1000100'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.BIQUINARY);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodeBiquinaer:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '1000010 0110000 0100010 0101000'},
      {'expectedOutput' : '22', 'input' : '1000100 1000100'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.BIQUINARY);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // 1of10 -------------------------------------------------------------------

  group("BCD.encode1of10", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '0000000010 1000000000 0001000000 0100000000'},
      {'input' : '2ab2', 'expectedOutput' : '0000000100 0000000100'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.ONEOFTEN);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decode1of10:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '0000000010 1000000000 0001000000 0100000000'},
      {'expectedOutput' : '22', 'input' : '0000000100 0000000100'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.ONEOFTEN);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // 2of5 -------------------------------------------------------------------

  group("BCD.encode2of5", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '00101 11000 10001 10100'},
      {'input' : '2ab2', 'expectedOutput' : '00110 00110'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.TWOOFFIVE);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decode2of5:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '00101 11000 10001 10100'},
      {'expectedOutput' : '22', 'input' : '00110 00110'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.TWOOFFIVE);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group


  // 2of5Planet -------------------------------------------------------------------

  group("BCD.encodePostnet", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '00011 10100 01100 10010'},
      {'input' : '2ab2', 'expectedOutput' : '00101 00101'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.POSTNET);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodePostnet:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '00011 10100 01100 10010'},
      {'expectedOutput' : '22', 'input' : '00101 00101'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.POSTNET);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group

  // 2of5Postnet -------------------------------------------------------------------

  group("BCD.encodePlanet", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : '19 68', 'expectedOutput' : '11100 01011 10011 01101'},
      {'input' : '2ab2', 'expectedOutput' : '11010 11010'},
      {'input' : 'Haus', 'expectedOutput' : ''},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBCD(elem['input'] as String, BCDType.PLANET);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("BCD.decodePlanet:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'expectedOutput' : '1968', 'input' : '11100 01011 10011 01101'},
      {'expectedOutput' : '22', 'input' : '11010 11010'},
      {'expectedOutput' : '', 'input' : 'Haus'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBCD(elem['input'] as String, BCDType.PLANET);
        expect(_actual, elem['expectedOutput']);
      });
    }
  }); // group

}