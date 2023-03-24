import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/wherigo/logic/earwigo_tools.dart';

void main() {
  group("Wherigo.Earwigo_GSUB_WIG:", () {
    // GC5K2GK „Stets gern für Sie beschäftigt,…"
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'Leider falsch...', 'expectedOutput' : 'CUXRRd PRbhQUxwv'},
      {'input' : 'Probier es weiter...', 'expectedOutput' : 'GhdPVQc Vi kRUeOi10z'},
      {'input' : 'Doppelmuffelofen', 'expectedOutput' : '8eedRXXeWVTZbRPX'},
      {'input' : 'Weiter gehts....', 'expectedOutput' : 'NUXhRd QVXigyxwv'},
      {'input' : ' Soehne - Die Ofenbauer von Auschwitz', 'expectedOutput' : ' IdSUZP 3 6WR ~PVdQOhQc mec 1gdMYmXhm'}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = obfuscateEarwigoText(elem['input'] as String, EARWIGO_DEOBFUSCATION.GSUB_WIG);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Wherigo.Earwigo_WWB_DEOBF:", () {
    // GC27GWW Das Geheimnis des Klosters
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'Bruder Malusvisus, der beste Angler des Klosters Bebenhausen.', 'expectedOutput' : 'K15pr5 cjv548w7@1, pr5 rn24q O2wuo2 qs7 Tvz46s68 Lpnr1wq32pzK'},
      {'input' : 'Schrein zu Ehren des Hl. Hubertus.', 'expectedOutput' : 'bms3rw2 84 Qu5t3 np4 V0N R5nr58@1H'},
      {'input' : 'Entschuldigung! Bitte kommen Sie dem Versuchsgelände nicht zu nahe.', 'expectedOutput' : 'Nx44pv91msr60u! Ks45r z4vwpz gxu npy jt714nt5ut1äypr 2ylr4 -8 3jrpJ'},
      {'input' : 'He, Sie! Hier ist überall Sperrbereich. Und angefasst werden darf hier erst recht nichts. Legen Sie alle Gegenstände wieder an ihren Platz und verlassen Sie das Gelände.', 'expectedOutput' : 'Qo, fwt! Rtq4 x82 üos6quv e2s67ko2qvqwN eyp o2wnpl457 -n1oq0 sq0p tvs6 n135 5tsq3 zvqw91H Xrut3 ctq o01n Rqts282äzqs -rooq4 p3 ss3r1 fuk4. 82t 5p3yo78nx evs tj2 SrzäwnpJ'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = obfuscateEarwigoText(elem['input'] as String, EARWIGO_DEOBFUSCATION.WWB_DEOBF);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

}
