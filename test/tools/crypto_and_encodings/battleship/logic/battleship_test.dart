import 'package:flutter_test/flutter_test.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/battleship/logic/battleship.dart';

void main() {
  group("Battleship.encodeTextToNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'expectedOutput': ''},
      {
        'input': 'hallo',
        'expectedOutput':
            '3,1 16,1 22,1 3,2 16,2 22,2 3,3 4,3 10,3 11,3 16,3 22,3 28,3 3,4 5,4 9,4 11,4 16,4 22,4 27,4 29,4 3,5 5,5 9,5 11,5 16,5 22,5 27,5 29,5 3,6 5,6 9,6 11,6 16,6 22,6 27,6 29,6 3,7 5,7 9,7 10,7 11,7 12,7 17,7 23,7 28,7'
      },
      {
        'input': 'HALLO',
        'expectedOutput':
            '2,1 6,1 10,1 14,1 20,1 27,1 28,1 29,1 2,2 6,2 9,2 11,2 14,2 20,2 26,2 30,2 2,3 6,3 8,3 12,3 14,3 20,3 26,3 30,3 2,4 3,4 4,4 5,4 6,4 8,4 9,4 10,4 11,4 12,4 14,4 20,4 26,4 30,4 2,5 6,5 8,5 12,5 14,5 20,5 26,5 30,5 2,6 6,6 8,6 12,6 14,6 20,6 26,6 30,6 2,7 6,7 8,7 12,7 14,7 15,7 16,7 17,7 18,7 20,7 21,7 22,7 23,7 24,7 27,7 28,7 29,7'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBattleship(elem['input'] as String, true, true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Battleship.encodeTextToExcel:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'expectedOutput': ''},
      {
        'input': 'hallo',
        'expectedOutput':
            'C1 P1 V1 C2 P2 V2 C3 D3 J3 K3 P3 V3 AB3 C4 E4 I4 K4 P4 V4 AA4 AC4 C5 E5 I5 K5 P5 V5 AA5 AC5 C6 E6 I6 K6 P6 V6 AA6 AC6 C7 E7 I7 J7 K7 L7 Q7 W7 AB7'
      },
      {
        'input': 'HALLO',
        'expectedOutput':
            'B1 F1 J1 N1 T1 AA1 AB1 AC1 B2 F2 I2 K2 N2 T2 Z2 AD2 B3 F3 H3 L3 N3 T3 Z3 AD3 B4 C4 D4 E4 F4 H4 I4 J4 K4 L4 N4 T4 Z4 AD4 B5 F5 H5 L5 N5 T5 Z5 AD5 B6 F6 H6 L6 N6 T6 Z6 AD6 B7 F7 H7 L7 N7 O7 P7 Q7 R7 T7 U7 V7 W7 X7 AA7 AB7 AC7'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBattleship(elem['input'] as String, true, false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Battleship.encodeGraphicToNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'expectedOutput': ''},
      {
        'input': '  #            #     #       \n' +
            '  #            #     #       \n' +
            '  ##     ##    #     #     # \n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   ####    #     #    # ',
        'expectedOutput':
            '3,1 16,1 22,1 3,2 16,2 22,2 3,3 4,3 10,3 11,3 16,3 22,3 28,3 3,4 5,4 9,4 11,4 16,4 22,4 27,4 29,4 3,5 5,5 9,5 11,5 16,5 22,5 27,5 29,5 3,6 5,6 9,6 11,6 16,6 22,6 27,6 29,6 3,7 5,7 9,7 10,7 11,7 12,7 17,7 23,7 28,7'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBattleship(elem['input'] as String, false, true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Battleship.encodeGraphicToExcel:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'expectedOutput': ''},
      {
        'input': ' #   #   #   #     #      ### \n' +
            ' #   #  # #  #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' ##### ##### #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' #   # #   # ##### #####  ### ',
        'expectedOutput':
            'B1 F1 J1 N1 T1 AA1 AB1 AC1 B2 F2 I2 K2 N2 T2 Z2 AD2 B3 F3 H3 L3 N3 T3 Z3 AD3 B4 C4 D4 E4 F4 H4 I4 J4 K4 L4 N4 T4 Z4 AD4 B5 F5 H5 L5 N5 T5 Z5 AD5 B6 F6 H6 L6 N6 T6 Z6 AD6 B7 F7 H7 L7 N7 O7 P7 Q7 R7 T7 U7 V7 W7 X7 AA7 AB7 AC7'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeBattleship(elem['input'] as String, false, false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Battleship.decodeNumbers:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'expectedOutput': ''},

      {'input': 'MIKE', 'expectedOutput': 'battleship_error_invalid_pair ( [MIKE] )\n\n\n'},

      {
        'expectedOutput': '  #            #     #       \n' +
            '  #            #     #       \n' +
            '  ##     ##    #     #     # \n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   ####    #     #    # ',
        'input':
            '3,1 16,1 22,1 3,2 16,2 22,2 3,3 4,3 10,3 11,3 16,3 22,3 28,3 3,4 5,4 9,4 11,4 16,4 22,4 27,4 29,4 3,5 5,5 9,5 11,5 16,5 22,5 27,5 29,5 3,6 5,6 9,6 11,6 16,6 22,6 27,6 29,6 3,7 5,7 9,7 10,7 11,7 12,7 17,7 23,7 28,7'
      },
      {
        'expectedOutput': ' #   #   #   #     #      ### \n' +
            ' #   #  # #  #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' ##### ##### #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' #   # #   # ##### #####  ### ',
        'input':
            '2,1 6,1 10,1 14,1 20,1 27,1 28,1 29,1 2,2 6,2 9,2 11,2 14,2 20,2 26,2 30,2 2,3 6,3 8,3 12,3 14,3 20,3 26,3 30,3 2,4 3,4 4,4 5,4 6,4 8,4 9,4 10,4 11,4 12,4 14,4 20,4 26,4 30,4 2,5 6,5 8,5 12,5 14,5 20,5 26,5 30,5 2,6 6,6 8,6 12,6 14,6 20,6 26,6 30,6 2,7 6,7 8,7 12,7 14,7 15,7 16,7 17,7 18,7 20,7 21,7 22,7 23,7 24,7 27,7 28,7 29,7'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBattleship(elem['input'] as String, true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Battleship.decodeNumbers_toManyLines:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '1,1000', 'expectedOutput': 'battleship_error_to_many_rows ( 1,1000 )'},
      {'input': '1000,1', 'expectedOutput': 'battleship_error_to_many_colums ( 1000,1 )'},
      {'input': '1000,1000', 'expectedOutput': 'battleship_error_to_many_colums ( 1000,1000 )'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBattleship(elem['input'] as String, true);
        expect(_actual.split('\n')[0], elem['expectedOutput']);
      });
    }
  });
  
  group("Battleship.decodeExcel:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': '', 'expectedOutput': ''},

      {'input': 'MIKE', 'expectedOutput': 'battleship_error_invalid_pair ( MIKE, )\nbattleship_error_to_many_colums ( MIKE, )\n\n\n'},

      {
        'expectedOutput': '  #            #     #       \n' +
            '  #            #     #       \n' +
            '  ##     ##    #     #     # \n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   # #    #     #    # #\n' +
            '  # #   ####    #     #    # ',
        'input':
            'C1 P1 V1 C2 P2 V2 C3 D3 J3 K3 P3 V3 AB3 C4 E4 I4 K4 P4 V4 AA4 AC4 C5 E5 I5 K5 P5 V5 AA5 AC5 C6 E6 I6 K6 P6 V6 AA6 AC6 C7 E7 I7 J7 K7 L7 Q7 W7 AB7'
      },
      {
        'expectedOutput': ' #   #   #   #     #      ### \n' +
            ' #   #  # #  #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' ##### ##### #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' #   # #   # #     #     #   #\n' +
            ' #   # #   # ##### #####  ### ',
        'input':
            'B1 F1 J1 N1 T1 AA1 AB1 AC1 B2 F2 I2 K2 N2 T2 Z2 AD2 B3 F3 H3 L3 N3 T3 Z3 AD3 B4 C4 D4 E4 F4 H4 I4 J4 K4 L4 N4 T4 Z4 AD4 B5 F5 H5 L5 N5 T5 Z5 AD5 B6 F6 H6 L6 N6 T6 Z6 AD6 B7 F7 H7 L7 N7 O7 P7 Q7 R7 T7 U7 V7 W7 X7 AA7 AB7 AC7'
      },
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBattleship(elem['input'] as String, false);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Battleship.decodeExcel_toManyLines:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input': 'A1000', 'expectedOutput': 'battleship_error_to_many_rows ( A,1000 )'},
      {'input': 'AAAAA1', 'expectedOutput': 'battleship_error_to_many_colums ( AAAAA,1 )'},
      {'input': 'AAAAA1000', 'expectedOutput': 'battleship_error_to_many_colums ( AAAAA,1000 )'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeBattleship(elem['input'] as String, false);
        expect(_actual.split('\n')[0], elem['expectedOutput']);
      });
    }
  });
  
}
