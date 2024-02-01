import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/avemaria/logic/avemaria.dart';

void main() {
  group("AveMaria.encodeAveMaria:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ' '},

      {'input' : 'gc wizard ist toll', 'expectedOutput' : 'GC UIZARD IST TOLL'}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeAveMaria(encodeAveMaria(elem['input'] as String,));
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("AveMaria.decodeAveMaria:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ' '},

      {'expectedOutput' : 'GC UIZARD IST TOLL', 'input' : 'consolator conditor   misericors sapientissimus magnificus deus incompraehensibilis piissimus   iudex omnipotens pacificus   pacificus gloriosus illustrator immortalis'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeAveMaria(elem['input'] as String,);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });


}
