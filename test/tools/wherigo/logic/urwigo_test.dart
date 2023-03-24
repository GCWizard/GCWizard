import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/wherigo/logic/urwigo_tools.dart';

void main() {

  group("Wherigo.Urwigo:", () {
    // GC7HCQG  Das Geheimnis der Premiere
    var dtable = '2;f\\nV\\018\\0054?\'_GUJD\\001\\r+pN\\016k,neO5}{\$=6[\\a\\023]\\015SF\\024L\\019\\"mYr 9\\002Z0KRw<\\027E|\\\\\\003:-qPx(sg@th1X\\bcuz\\031\\025CQMi\\021!\\014&%\\029\\017\\fI\\t\\020Tj`)dy.\\022/\\v3\\000vo*W8bH7\\006\\028BAl~^a>\\030\\026\\004#';
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '',    'dtable' : '', 'expectedOutput' : ''},
      {'input' : '',    'dtable' : dtable, 'expectedOutput' : ''},

      {'input' : 'Erzaehler', 'dtable' : dtable,  'expectedOutput' : '9.Mz\\025Gw\\025.'},
      {'input' : 'Koordinaten', 'dtable' : dtable,  'expectedOutput' : '4ll.cS\\024zF\\025\\024'},
      {'input' : 'Die Theaterbuehne - Bretter die die Welt bedeuten.', 'dtable' : dtable,  'expectedOutput' : '\\015S\\025/_G\\025zF\\025.pL\\025G\\024\\025/>/u.\\025FF\\025./cS\\025/cS\\025/n\\025wF/p\\025c\\025LF\\025\\024e'},
      {'input' : 'Wie lautet die Kombination?', 'dtable' : dtable,  'expectedOutput' : 'nS\\025/wzLF\\025F/cS\\025/4l,pS\\024zFSl\\024\\t'},
      {'input' : 'Es gibt keinen Spielplan. Du bestimmst, wohin Du gehst und was Du tust.', 'dtable' : dtable,  'expectedOutput' : '9C/DSpF/\\022\\025S\\024\\025\\024/&\\019S\\025w\\019wz\\024e/\\015L/p\\025CFS,,CF\\023/6lGS\\024/\\015L/D\\025GCF/L\\024c/6zC/\\015L/FLCFe'}
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} dtable: ${elem['dtable']}', () {
        var _actual = obfuscateUrwigoText(elem['input'] as String, elem['dtable'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Wherigo.Urwigo:", () {
    // ytrohs_und_der Folterknecht aus Bayern
    var dtable = '`:\\024G\\bj\\f\\003IOY\'dAWfC&VbD X\\017eJ\\0159]\\020E}\\nLBil^7TP=\\vw2!Q\\"~1?rs\\025\\r{-(zF\\027kHv\\tR.3)N\\022\\\\a;c\\014u\\002yt>+\\026\\004K\\0304\\018\\028q[6</\\0198_%o\\023*\\000#\\031\\005S\$\\029\\001@m\\016|n\\021x50UhpZ\\a,\\006Mg';
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '',    'dtable' : '', 'expectedOutput' : ''},
      {'input' : '',    'dtable' : dtable, 'expectedOutput' : ''},

      {'input' : 'Miraculix',
        'dtable' : dtable,
        'expectedOutput' : '~\$4IKM%\$t'},
      {'input' : 'Huette von Papa Schlumpf',
        'dtable' : dtable,
        'expectedOutput' : '?M\\025PP\\025\\022@cr\\022)IyI\\022jKx%Moy\\016'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']} dtable: ${elem['dtable']}', () {
        var _actual = obfuscateUrwigoText(elem['input'] as String, elem['dtable'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
