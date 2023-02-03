import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/gade/logic/gade.dart';

void main() {
  group("Gade.buildGade:", () {
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : {'A':'0', 'B':'1', 'C':'2', 'D':'3', 'E':'4', 'F':'5', 'G':'6', 'H':'7', 'I':'8', 'J':'9'}},
      {'input' : 'd', 'expectedOutput' : {'A':'0', 'B':'1', 'C':'2', 'D':'3', 'E':'4', 'F':'5', 'G':'6', 'H':'7', 'I':'8', 'J':'9'}},
      {'input' : '1', 'expectedOutput' : {'A':'1', 'B':'0', 'C':'2', 'D':'3', 'E':'4', 'F':'5', 'G':'6', 'H':'7', 'I':'8', 'J':'9'}},
      {'input' : 'd 4wt zwer46 89 3', 'expectedOutput' : {'A':'3', 'B':'4', 'C':'4', 'D':'6', 'E':'8', 'F':'9', 'G':'0', 'H':'1', 'I':'2', 'J':'5', 'K':'7'}},
      {'input' : '22.04.1968 01.07.1987 11.02.1994', 'expectedOutput' : {'A':'0', 'B':'0', 'C':'0', 'D':'0', 'E':'1', 'F':'1', 'G':'1', 'H':'1', 'I':'1', 'J':'1', 'K':'2', 'L':'2', 'M':'2', 'N':'4', 'O':'4', 'P':'6', 'Q':'7', 'R':'7', 'S':'8', 'T':'8', 'U':'9', 'V':'9', 'W':'9', 'X':'9', 'Y':'3', 'Z':'5'}},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = buildGade(elem['input']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

}