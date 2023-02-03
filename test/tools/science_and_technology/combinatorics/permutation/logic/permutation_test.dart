import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/combinatorics/permutation/logic/permutation.dart';

void main() {
  group("Combinatorics.Permutations.generatePermutations:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'avoidDuplicates': true, 'expectedOutput' : []},
      {'input' : null, 'avoidDuplicates': false, 'expectedOutput' : []},
      {'input' : '', 'avoidDuplicates': true, 'expectedOutput' : []},
      {'input' : '', 'avoidDuplicates': false, 'expectedOutput' : []},

      {'input' : 'Hallo', 'avoidDuplicates': true, 'expectedOutput' : ['aHllo', 'aHlol', 'aHoll', 'alHlo', 'alHol', 'allHo', 'alloH', 'aloHl', 'alolH', 'aoHll', 'aolHl', 'aollH', 'Hallo', 'Halol', 'Haoll', 'Hlalo', 'Hlaol', 'Hllao', 'Hlloa', 'Hloal', 'Hlola', 'Hoall', 'Holal', 'Holla', 'laHlo', 'laHol', 'lalHo', 'laloH', 'laoHl', 'laolH', 'lHalo', 'lHaol', 'lHlao', 'lHloa', 'lHoal', 'lHola', 'llaHo', 'llaoH', 'llHao', 'llHoa', 'lloaH', 'lloHa', 'loaHl', 'loalH', 'loHal', 'loHla', 'lolaH', 'lolHa', 'oaHll', 'oalHl', 'oallH', 'oHall', 'oHlal', 'oHlla', 'olaHl', 'olalH', 'olHal', 'olHla', 'ollaH', 'ollHa']},
      {'input' : 'Hallo', 'avoidDuplicates': false, 'expectedOutput' : ['aHllo', 'aHllo', 'aHlol', 'aHlol', 'aHoll', 'aHoll', 'alHlo', 'alHlo', 'alHol', 'alHol', 'allHo', 'allHo', 'alloH', 'alloH', 'aloHl', 'aloHl', 'alolH', 'alolH', 'aoHll', 'aoHll', 'aolHl', 'aolHl', 'aollH', 'aollH', 'Hallo', 'Hallo', 'Halol', 'Halol', 'Haoll', 'Haoll', 'Hlalo', 'Hlalo', 'Hlaol', 'Hlaol', 'Hllao', 'Hllao', 'Hlloa', 'Hlloa', 'Hloal', 'Hloal', 'Hlola', 'Hlola', 'Hoall', 'Hoall', 'Holal', 'Holal', 'Holla', 'Holla', 'laHlo', 'laHlo', 'laHol', 'laHol', 'lalHo', 'lalHo', 'laloH', 'laloH', 'laoHl', 'laoHl', 'laolH', 'laolH', 'lHalo', 'lHalo', 'lHaol', 'lHaol', 'lHlao', 'lHlao', 'lHloa', 'lHloa', 'lHoal', 'lHoal', 'lHola', 'lHola', 'llaHo', 'llaHo', 'llaoH', 'llaoH', 'llHao', 'llHao', 'llHoa', 'llHoa', 'lloaH', 'lloaH', 'lloHa', 'lloHa', 'loaHl', 'loaHl', 'loalH', 'loalH', 'loHal', 'loHal', 'loHla', 'loHla', 'lolaH', 'lolaH', 'lolHa', 'lolHa', 'oaHll', 'oaHll', 'oalHl', 'oalHl', 'oallH', 'oallH', 'oHall', 'oHall', 'oHlal', 'oHlal', 'oHlla', 'oHlla', 'olaHl', 'olaHl', 'olalH', 'olalH', 'olHal', 'olHal', 'olHla', 'olHla', 'ollaH', 'ollaH', 'ollHa', 'ollHa']},
      {'input' : '123', 'avoidDuplicates': true, 'expectedOutput' : ['123', '132', '213', '231', '312', '321']},
      {'input' : '122', 'avoidDuplicates': true, 'expectedOutput' : ['122', '212', '221']},
      {'input' : '123', 'avoidDuplicates': false, 'expectedOutput' : ['123', '132', '213', '231', '312', '321']},
      {'input' : '122', 'avoidDuplicates': false, 'expectedOutput' : ['122', '122', '212', '212', '221', '221']},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}, avoidDuplicates: ${elem['avoidDuplicates']}', () {
        var _actual = generatePermutations(elem['input'], avoidDuplicates: elem['avoidDuplicates']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}
