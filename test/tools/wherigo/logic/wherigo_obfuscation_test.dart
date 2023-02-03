import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/wherigo/logic/earwigo_tools.dart';
import 'package:gc_wizard/tools/wherigo/logic/urwigo_tools.dart';

void main() {
  group("Obfuscation.Earwigo_GSUB_WIG:", () {
    // GC5K2GK „Stets gern für Sie beschäftigt,…"
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'Leider falsch...', 'expectedOutput' : 'CUXRRd PRbhQUxwv'},
      {'input' : 'Probier es weiter...', 'expectedOutput' : 'GhdPVQc Vi kRUeOi10z'},
      {'input' : 'Doppelmuffelofen', 'expectedOutput' : '8eedRXXeWVTZbRPX'},
      {'input' : 'Weiter gehts....', 'expectedOutput' : 'NUXhRd QVXigyxwv'},
      {'input' : ' Soehne - Die Ofenbauer von Auschwitz', 'expectedOutput' : ' IdSUZP 3 6WR ~PVdQOhQc mec 1gdMYmXhm'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = obfuscateEarwigoText(elem['input'], EARWIGO_DEOBFUSCATION.GSUB_WIG);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Obfuscation.Earwigo_WWB_DEOBF:", () {
    // GC27GWW Das Geheimnis des Klosters
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null, 'expectedOutput' : ''},
      {'input' : '', 'expectedOutput' : ''},

      {'input' : 'Bruder Malusvisus, der beste Angler des Klosters Bebenhausen.', 'expectedOutput' : 'K15pr5 cjv548w7@1, pr5 rn24q O2wuo2 qs7 Tvz46s68 Lpnr1wq32pzK'},
      {'input' : 'Schrein zu Ehren des Hl. Hubertus.', 'expectedOutput' : 'bms3rw2 84 Qu5t3 np4 V0N R5nr58@1H'},
      {'input' : 'Entschuldigung! Bitte kommen Sie dem Versuchsgelände nicht zu nahe.', 'expectedOutput' : 'Nx44pv91msr60u! Ks45r z4vwpz gxu npy jt714nt5ut1äypr 2ylr4 -8 3jrpJ'},
      {'input' : 'He, Sie! Hier ist überall Sperrbereich. Und angefasst werden darf hier erst recht nichts. Legen Sie alle Gegenstände wieder an ihren Platz und verlassen Sie das Gelände.', 'expectedOutput' : 'Qo, fwt! Rtq4 x82 üos6quv e2s67ko2qvqwN eyp o2wnpl457 -n1oq0 sq0p tvs6 n135 5tsq3 zvqw91H<\\001\\002>\\n\\003\\003\\003\\003Xrut3 ctq o01n Rqts282äzqs -rooq4 p3 ss3r1 fuk4. 82t 5p3yo78nx evs tj2 SrzäwnpJ'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']}', () {
        var _actual = obfuscateEarwigoText(elem['input'], EARWIGO_DEOBFUSCATION.WWB_DEOBF);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Obfuscation.Urwigo:", () {
    // GC7HCQG  Das Geheimnis der Premiere
    var dtable = '2;f\\nV\\018\\0054?\'_GUJD\\001\\r+pN\\016k,neO5}{\$=6[\\a\\023]\\015SF\\024L\\019\\"mYr 9\\002Z0KRw<\\027E|\\\\\\003:-qPx(sg@th1X\\bcuz\\031\\025CQMi\\021!\\014&%\\029\\017\\fI\\t\\020Tj`)dy.\\022/\\v3\\000vo*W8bH7\\006\\028BAl~^a>\\030\\026\\004#';
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null,  'dtable' : '', 'expectedOutput' : ''},
      {'input' : '',    'dtable' : '', 'expectedOutput' : ''},
      {'input' : null,  'dtable' : dtable, 'expectedOutput' : ''},
      {'input' : '',    'dtable' : dtable, 'expectedOutput' : ''},

      {'input' : 'Erzaehler', 'dtable' : dtable,  'expectedOutput' : '9.Mz\\025Gw\\025.'},
      {'input' : 'Koordinaten', 'dtable' : dtable,  'expectedOutput' : '4ll.cS\\024zF\\025\\024'},
      {'input' : 'Die Theaterbuehne - Bretter die die Welt bedeuten.', 'dtable' : dtable,  'expectedOutput' : '\\015S\\025/_G\\025zF\\025.pL\\025G\\024\\025/>/u.\\025FF\\025./cS\\025/cS\\025/n\\025wF/p\\025c\\025LF\\025\\024e'},
      {'input' : 'Wie lautet die Kombination?', 'dtable' : dtable,  'expectedOutput' : 'nS\\025/wzLF\\025F/cS\\025/4l,pS\\024zFSl\\024\\t'},
      {'input' : 'Es gibt keinen Spielplan. Du bestimmst, wohin Du gehst und was Du tust.', 'dtable' : dtable,  'expectedOutput' : '9C/DSpF/\\022\\025S\\024\\025\\024/&\\019S\\025w\\019wz\\024e/\\015L/p\\025CFS,,CF\\023/6lGS\\024/\\015L/D\\025GCF/L\\024c/6zC/\\015L/FLCFe'}
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']} dtable: ${elem['dtable']}', () {
        var _actual = obfuscateUrwigoText(elem['input'], elem['dtable']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

  group("Obfuscation.Urwigo:", () {
    // ytrohs_und_der Folterknecht aus Bayern
    var dtable = '`:\\024G\\bj\\f\\003IOY\'dAWfC&VbD X\\017eJ\\0159]\\020E}\\nLBil^7TP=\\vw2!Q\\"~1?rs\\025\\r{-(zF\\027kHv\\tR.3)N\\022\\\\a;c\\014u\\002yt>+\\026\\004K\\0304\\018\\028q[6</\\0198_%o\\023*\\000#\\031\\005S\$\\029\\001@m\\016|n\\021x50UhpZ\\a,\\006Mg';
    List<Map<String, dynamic>> _inputsToExpected = [
      {'input' : null,  'dtable' : '', 'expectedOutput' : ''},
      {'input' : '',    'dtable' : '', 'expectedOutput' : ''},
      {'input' : null,  'dtable' : dtable, 'expectedOutput' : ''},
      {'input' : '',    'dtable' : dtable, 'expectedOutput' : ''},

      {'input' : 'Miraculix',
        'dtable' : dtable,
        'expectedOutput' : '~\$4IKM%\$t'},
      {'input' : 'Huette von Papa Schlumpf',
        'dtable' : dtable,
        'expectedOutput' : '?M\\025PP\\025\\022@cr\\022)IyI\\022jKx%Moy\\016'},
    ];

    _inputsToExpected.forEach((elem) {
      test('input: ${elem['input']} dtable: ${elem['dtable']}', () {
        var _actual = obfuscateUrwigoText(elem['input'], elem['dtable']);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });

}
