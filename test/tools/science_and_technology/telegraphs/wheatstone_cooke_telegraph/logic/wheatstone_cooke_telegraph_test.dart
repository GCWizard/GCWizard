import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/telegraphs/gauss_weber_telegraph/logic/gauss_weber_telegraph.dart';

void main() {
  group("WheatstoneCooke.encode", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_1, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_2, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_5, 'expectedOutput' : ''},

      {'input' : 'gcwizard', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_1, 'expectedOutput' : '//\\ \\\\\\\\ \\\\\\/ ///\\ /\\\\/ \\\\ \\/ /\\'},
      {'input' : 'gcwizard', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_2, 'expectedOutput' : '[/// |] [\\/ |] [/ /] [| \\\\]  [\\\\  |] [\\ \\] [/\\ |]'},
      {'input' : 'gcwizard', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_5, 'expectedOutput' : '||/|\\  |||/ |/\\||  /|||\\ \\|/|| |/||\\'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeGaussWeberTelegraph(elem['input'] as String, elem['version'] as GaussWeberTelegraphMode, );
        expect(_actual, elem['expectedOutput'] as String);
      });
    }
  });

  group("WheatstoneCooke.decode", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_1, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_2, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_5, 'expectedOutput' : ''},

      {'expectedOutput' : 'GCWIZARD', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_1, 'input' : '//\\ \\\\\\\\ \\\\\\/ ///\\ /\\\\/ \\\\ \\/ /\\'},
      {'expectedOutput' : 'GCWIRD', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_2, 'input' : '[/// |] [\\/ |] [/ /] [| \\\\]  [\\\\  |] [\\ \\] [/\\ |]'},
      {'expectedOutput' : 'GWIARD', 'version' : GaussWeberTelegraphMode.WHEATSTONE_COOKE_5, 'input' : '||/|\\  |||/ |/\\||  /|||\\ \\|/|| |/||\\'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeGaussWeberTelegraph(elem['input'] as String, elem['version'] as GaussWeberTelegraphMode, );
        expect(_actual, elem['expectedOutput'] as String);
      });
    }
  });


}