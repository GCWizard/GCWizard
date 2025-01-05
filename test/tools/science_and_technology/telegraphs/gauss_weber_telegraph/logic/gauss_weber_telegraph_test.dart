import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/telegraphs/gauss_weber_telegraph/logic/gauss_weber_telegraph.dart';

void main() {
  group("GaussWeber.encode", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1a, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2a, 'expectedOutput' : ''},

      {'input' : 'gcwizard', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1, 'expectedOutput' : '++--+ +++-+ -+-+- +-+++ --+++ +++++ -++++ +++--'},
      {'input' : 'gcwizard', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1a, 'expectedOutput' : 'lrlrr rrrlr llllr llrll rrlrl rrrrr rrrll rrlrr'},
      {'input' : 'gcwizard', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2, 'expectedOutput' : '+++ ++ +--- +-+ -+-+ + ++-+ +-'},
      {'input' : 'gcwizard', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2a, 'expectedOutput' : 'lrr rrr lrrr rr rrll r rrrl rrl'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encodeGaussWeberTelegraph(elem['input'] as String, elem['version'] as GaussWeberTelegraphMode, );
        expect(_actual, elem['expectedOutput'] as String);
      });
    }
  });

  group("GaussWeber.decode", () { // Mark test
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1a, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2, 'expectedOutput' : ''},
      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2a, 'expectedOutput' : ''},

      {'expectedOutput' : 'GCWIZARD', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1, 'input' : '++--+ +++-+ -+-+- +-+++ --+++ +++++ -++++ +++--'},
      {'expectedOutput' : 'JCWYZARD', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1a, 'input' : 'lrlrr rrrlr llllr llrll rrlrl rrrrr rrrll rrlrr'},
      {'expectedOutput' : 'GCWIZARD', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2, 'input' : '+++ ++ +--- +-+ -+-+ + ++-+ +-'},
      {'expectedOutput' : 'GKWIZARD', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2a, 'input' : 'lrr rrr lrrr rr rrll r rrrl rrl'},

      {'input' : '', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1, 'expectedOutput' : ''},
      {'input' : '--+ -+ +-+- --+ + ++ ++- +-++ -- +-+- -+ --+ --\n+--+ +-+ -+ ++-+ -- +-+- -+ --+ -- ++-- +-+ -+ - -+ --+',
        'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V2,
        'expectedOutput' : 'NEUNACHTFUENFVIERFUENFSIEBEN'},
      {'input' : '''-+++-
+-+++
++-++
++++-
++-++
+--++
+-+--
-+-++
+--+-
+-+--
+-++-
+++++
-++++
-++-+
++-++
+--++
+-+-+
++-++
-+++-
++-++
-++++''', 'version' : GaussWeberTelegraphMode.GAUSS_WEBER_ORIGINAL_V1, 'expectedOutput' : 'SIEBENMVOMKARTENLESER'},

    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decodeGaussWeberTelegraph(elem['input'] as String, elem['version'] as GaussWeberTelegraphMode, );
        expect(_actual, elem['expectedOutput'] as String);
      });
    }
  });


}