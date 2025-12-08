import "package:flutter_test/flutter_test.dart";
import "package:gc_wizard/tools/science_and_technology/regex/logic/regex.dart";

void main() {
  group("regex.evaluate:", () {
    List<Map<String, Object?>> _inputsToExpected = [

      {'text' : '',   'pattern' : '',   'expectedOutput' : []},

      {'text' : '',   'pattern' : '[\\.,].',   'expectedOutput' : []},
      {'text' : 'hallo',   'pattern' : '',   'expectedOutput' : [['hallo']]},

      {'text' : 'susi wacht einsam wenn ulla schläft',   'pattern' : '(eins|zwei|drei|vier|fuenf|sechs|sieben|acht|neun|null)',   'expectedOutput' : [['acht'], ['eins']]},
      {'text' : 'JyMrCgQEUT4o.s6glzFSiw.uq8d9xt,cUaqKJ07zwuXau.hdiX6ea66GrP,t1pAG8XS0B7ENqZxMxkaZ',   'pattern' : '[\\.,].',   'expectedOutput' : [['.s'],['.u'],[',c'],['.h'],[',t'],]},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}, pattern: ${elem['pattern']}', () {
        var _actual = evaluateRegExPattern(elem['text'] as String, elem['pattern'] as String);
        for (int i = 0; i < _actual.length; i++) {
          expect(_actual[i], (elem['expectedOutput'] as List<List<String>>)[i]);
        }
      });
    }
  });

}