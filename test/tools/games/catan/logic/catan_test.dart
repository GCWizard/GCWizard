import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/catan/logic/catan.dart';

void main() {
  group("Catan.encode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'mode': CatanMode.BASE, 'expectedOutput' : []},
      {'input' : ' ', 'mode': CatanMode.BASE, 'expectedOutput' : []},
      {'input' : '1234567890', 'mode': CatanMode.BASE, 'expectedOutput' : []},

      {'input' : 'A', 'mode': CatanMode.BASE, 'expectedOutput' : [5]},
      {'input' : 'a', 'mode': CatanMode.BASE, 'expectedOutput' : [5]},
      {'input' : 'ABC', 'mode': CatanMode.BASE, 'expectedOutput' : [5, 2, 6]},
      {'input' : 'S', 'mode': CatanMode.BASE, 'expectedOutput' : []},
      {'input' : 'AS', 'mode': CatanMode.BASE, 'expectedOutput' : [5]},
      {'input' : 'ASA', 'mode': CatanMode.BASE, 'expectedOutput' : [5,5]},
      {'input' : 'A.A', 'mode': CatanMode.BASE, 'expectedOutput' : [5,5]},
      {'input' : 'A     A', 'mode': CatanMode.BASE, 'expectedOutput' : [5,5]},
      {'input' : 'A    ', 'mode': CatanMode.BASE, 'expectedOutput' : [5]},

      {'input' : 'A', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2]},
      {'input' : 'a', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2]},
      {'input' : 'ABC', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2, 5, 4]},
      {'input' : 'S', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [10]},
      {'input' : 'AS', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2, 10]},
      {'input' : 'ASA', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2, 10, 2]},
      {'input' : 'A.A', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2,2]},
      {'input' : 'A     A', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2, 2]},

      {'input' : 'ZA', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [3]},
      {'input' : 'ZaA', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [3, 2]},
      {'input' : 'ZAaZB', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [3, 2, 2]},
      {'input' : 'ZAA zB', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [3, 2, 2]},
      {'input' : 'bzcC ZB', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [5, 6, 4, 2]},

      {'input' : 'Z', 'mode': CatanMode.EXPANSION, 'expectedOutput' : []},
      {'input' : 'AZ', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2]},
      {'input' : 'A Z', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2]},
      {'input' : 'A ZC', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [2, 6]},
      {'input' : 'ZD', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [6]},
      {'input' : 'ZDA', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [6, 2]},
      {'input' : 'BZDA', 'mode': CatanMode.EXPANSION, 'expectedOutput' : [5, 6, 2]},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, mode: ${elem['mode']}', () {
        var _actual = encodeCatan(elem['input'] as String, elem['mode'] as CatanMode);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}