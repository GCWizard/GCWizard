import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/widgets/tools/formula_solver/formula_painter.dart';

void main() {
  var formulaPainter = FormulaPainter();

  group("formula_painter.paintFormula:", () {
    Map<String, String> values = {
      'A':'3', 'B':'20', 'C': '100', 'D': '5', 'E': 'Pi',
      'Q': '1', 'R': '0', 'S': '200', 'T': '20', 'U': '12', 'V': '9', 'W': '4', 'X': '30', 'Y':'4', 'Z': '50'
    };

    List<Map<String, dynamic>> _inputsToExpected = [
      {'formula' : 'bww(c)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbrb'},

      {'formula' : null, 'values': null, 'expectedOutput' : null},
      {'formula' : null, 'values': <String, String>{}, 'expectedOutput' : null},
      {'formula' : null, 'expectedOutput' : null},
      {'formula' : '', 'expectedOutput' : ''},
      {'formula' : ' ', 'expectedOutput' : 'S'},
      {'formula' : 'A', 'values': null, 'expectedOutput' : 'R'},
      {'formula' : '0', 'values': null, 'expectedOutput' : 'g'},
      {'formula' : 'A', 'values': <String, String>{}, 'expectedOutput' : 'R'},
      {'formula' : '0', 'values': <String, String>{}, 'expectedOutput' : 'g'},

      {'formula' : '1', 'values': values, 'expectedOutput' : 'g'},
      {'formula' : '-1', 'values': values, 'expectedOutput' : 'bg'},
      {'formula' : '-1.23', 'values': values, 'expectedOutput' : 'bgggg'},
      {'formula' : '1.', 'values': values, 'expectedOutput' : 'gg'},
      {'formula' : '.5', 'values': values, 'expectedOutput' : 'gg'},
      {'formula' : '1,23', 'values': values, 'expectedOutput' : 'gBGG'},
      {'formula' : '-1.23 + A', 'values': values, 'expectedOutput' : 'bgggggbbr'},
      {'formula' : '-1,23 + 200', 'values': values, 'expectedOutput' : 'bgBGGGbbggg'},

      {'formula' : 'A', 'values': values, 'expectedOutput' : 'r'},
      {'formula' : 'AB', 'values': values, 'expectedOutput' : 'rr'},
      {'formula' : 'AB', 'values': {'AB':'3', 'B':'2'}, 'expectedOutput' : 'rr'},
      {'formula' : 'AB', 'values': {'AB':'3', 'B':'20'}, 'expectedOutput' : 'rr'},
      {'formula' : 'AB', 'values': {'AB':'30', 'B':'20'}, 'expectedOutput' : 'rr'},
      {'formula' : 'ABC', 'values': {'AB':'30'}, 'expectedOutput' : 'rrR'},
      {'formula' : 'ABC', 'values': {'AB':'30', 'C': '1'}, 'expectedOutput' : 'rrr'},
      {'formula' : 'ABC', 'values': {'AB':'30', 'BC': '1'}, 'expectedOutput' : 'rrR'},
      {'formula' : 'ABC', 'values': {'AB':'30', 'C': 'AB'}, 'expectedOutput' : 'rrr'},

      {'formula' : 'A+B', 'values': values, 'expectedOutput' : 'rbr'},
      {'formula' : 'A + B', 'values': values, 'expectedOutput' : 'rrbbr'},
      {'formula' : '[A + B]', 'values': values, 'expectedOutput' : 'brrbbrb'},
      {'formula' : '[A] + [B]', 'values': values, 'expectedOutput' : 'brbtttbrb'},
      {'formula' : 'AB + C', 'values': values, 'expectedOutput' : 'rrrbbr'},
      {'formula' : '(AB) + C', 'values': values, 'expectedOutput' : 'brrbbbbr'},
      {'formula' : 'A(B + C)', 'values': values, 'expectedOutput' : 'rBRRBBRB'},
      {'formula' : '[A][(B + C)]', 'values': values, 'expectedOutput' : 'brbbbrrbbrbb'},
      {'formula' : 'A*(B + C)', 'values': values, 'expectedOutput' : 'rbbrrbbrb'},
      {'formula' : '[]', 'values': values, 'expectedOutput' : 'BB'},
      {'formula' : '()', 'values': values, 'expectedOutput' : 'BB'},
      {'formula' : '?!', 'values': values, 'expectedOutput' : 'RR'},
      {'formula' : 'A []', 'values': values, 'expectedOutput' : 'ttBB'},
      {'formula' : 'N []', 'values': values, 'expectedOutput' : 'ttBB'},
      {'formula' : 'N', 'values': values, 'expectedOutput' : 'R'},
      {'formula' : 'E', 'values': values, 'expectedOutput' : 'r'},
      {'formula' : 'e', 'values': values, 'expectedOutput' : 'r'},
      {'formula' : 'Pi', 'values': values, 'expectedOutput' : 'gg'},
      {'formula' : 'pi', 'values': values, 'expectedOutput' : 'gg'},
      {'formula' : 'pi * A', 'values': values, 'expectedOutput' : 'gggbbr'},
      {'formula' : 'E * PI', 'values': values, 'expectedOutput' : 'rrbbgg'},
      {'formula' : 'E [PI]', 'values': values, 'expectedOutput' : 'ttbggb'},
      {'formula' : '[A*B*2].[C+d+D];', 'values': values, 'expectedOutput' : 'brbrbgbtbrbrbrbt'},
      {'formula' : 'N 52 [QR].[S+T*U*2] E 12 [V*W].[XY + Z]', 'values': values, 'expectedOutput' : 'tttttbrrbtbrbrbrbgbttttttbrbrbtbrrrbbrb'},
      {'formula' : 'A + B [A + B]', 'values': values, 'expectedOutput' : 'ttttttbrrbbrb'},
      {'formula' : 'A + B]', 'values': values, 'expectedOutput' : 'rrbbrB'},
      {'formula' : '[A + B', 'values': values, 'expectedOutput' : 'Brrbbr'},

      //Trim empty space
      {'formula' : 'sin(0) ', 'values': <String, String>{}, 'expectedOutput' : 'bbbbgbb'},

      //math library testing
      {'formula' : '36^(1/2)', 'expectedOutput' : 'ggbbgbgb'},
      {'formula' : 'phi * 2', 'expectedOutput' : 'ggggbbg'},
      {'formula' : 'log(100,10)', 'expectedOutput' : 'bbbbgggbggb'},
      {'formula' : 'log(10,100)', 'expectedOutput' : 'bbbbggbgggb'},
      {'formula' : 'round(1)', 'expectedOutput' : 'bbbbbbgb'},
      {'formula' : 'round(1.247)', 'expectedOutput' : 'bbbbbbgggggb'},
      {'formula' : 'round(1.247,2)', 'expectedOutput' : 'bbbbbbgggggbgb'}, //log EXAKT 1 komma; round kein oder ein komma; MIN/MAX/CS/CSI beliebig viele
      {'formula' : 'ROUND(1.247,2)', 'expectedOutput' : 'bbbbbbgggggbgb'},
      {'formula' : 'csi(88,99)', 'expectedOutput' : 'bbbbggbggb'},
      {'formula' : 'MIN(8.1,99.0,123.213)', 'expectedOutput' : 'bbbbgggbggggbgggggggb'},

      {'formula' : 'bww(c)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbrb'},
      {'formula' : 'bww(c)', 'expectedOutput' : 'bbbbgb'},
      {'formula' : 'bww(xyz)', 'expectedOutput' : 'bbbbgggb'},
      {'formula' : 'bww(xcz)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbgrgb'},
      {'formula' : 'av(c)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbrb'},
      {'formula' : 'av(c)', 'expectedOutput' : 'bbbgb'},
      {'formula' : 'av(xyz)', 'expectedOutput' : 'bbbgggb'},
      {'formula' : 'av(xcz)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbgrgb'},
      {'formula' : 'len(xcz)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbgrgb'},



      {'formula' : 'N [1', 'values': values, 'expectedOutput' : 'RRBG'},
      {'formula' : 'N []', 'values': values, 'expectedOutput' : 'ttBB'},
      {'formula' : 'N [F', 'values': values, 'expectedOutput' : 'RRBR'},
      {'formula' : 'N [F]', 'values': values, 'expectedOutput' : 'ttbRb'},
      {'formula' : 'N [A].[{B}]', 'values': values, 'expectedOutput' : 'ttbrbtbbrbb'},
      {'formula' : 'N [A].[{H}]', 'values': values, 'expectedOutput' : 'ttbrbtbbRbb'},
      {'formula' : 'N [A].[{04}]', 'values': values, 'expectedOutput' : 'ttbrbtbbggbb'},
      {'formula' : 'N [A].[{(B)}]', 'values': values, 'expectedOutput' : 'ttbrbtbbbrbbb'},
      {'formula' : 'N [A].[({B)}]', 'values': values, 'expectedOutput' : 'ttbrbtbbBrbBb'},
      {'formula' : '  N [A].[({B)}]', 'values': values, 'expectedOutput' : 'ttttbrbtbbBrbBb'},
      {'formula' : '  N [AB].[({B)}]', 'values': values, 'expectedOutput' : 'ttttbrrbtbbBrbBb'},
      {'formula' : '  N [AB].[B]', 'values': {'AB':'3', 'B':'20'}, 'expectedOutput' : 'ttttbrrbtbrb'},
      {'formula' : '  N [AB].[B]', 'values': {'AB':'3', 'B':'20'}, 'expectedOutput' : 'ttttbrrbtbrb'},

      {'formula' : 'E', 'values': <String, String>{}, 'expectedOutput' : 'R'},
      {'formula' : 'e', 'values': <String, String>{}, 'expectedOutput' : 'R'},
      {'formula' : 'e', 'values': {'E':'1'}, 'expectedOutput' : 'r'},
      {'formula' : 'e(1)', 'values': <String, String>{}, 'expectedOutput' : 'bbgb'},
      {'formula' : 'e(1)', 'values': <String, String>{'E':'1'}, 'expectedOutput' : 'bbgb'},
      {'formula' : 'E    (1)', 'values': <String, String>{}, 'expectedOutput' : 'bbbbbbgb'},
      {'formula' : 'E()', 'values': <String, String>{}, 'expectedOutput' : 'BBB'}, //invalid function
      {'formula' : 'e   ()', 'values': <String, String>{}, 'expectedOutput' : 'BBBBBB'},
      {'formula' : 'e   ()', 'values': {'E':'1'}, 'expectedOutput' : 'BBBBBB'},
      {'formula' : 'e   (e)', 'values': {'E':'1'}, 'expectedOutput' : 'bbbbbrb'},
      {'formula' : 'E1)', 'values': <String, String>{}, 'expectedOutput' : 'RGB'},
      {'formula' : 'E(1', 'values': <String, String>{}, 'expectedOutput' : 'RBG'},
      {'formula' : 'E(1', 'values': {'E':'1'}, 'expectedOutput' : 'rBG'},
      {'formula' : 'E(', 'values': <String, String>{}, 'expectedOutput' : 'RB'},
      {'formula' : 'E)', 'values': <String, String>{}, 'expectedOutput' : 'RB'},

      {'formula' : 'SIN(12)', 'values': <String, String>{}, 'expectedOutput' : 'bbbbggb'},
      {'formula' : 'sin(12)', 'values': <String, String>{}, 'expectedOutput' : 'bbbbggb'},
      {'formula' : 'sin( pi * 2.3  )', 'values': <String, String>{}, 'expectedOutput' : 'bbbbbgggbbgggggb'},
      {'formula' : 'sin + (12)', 'expectedOutput' : 'RRRRbbbggb'},
      {'formula' : 'sin + (12)', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'rrrrbbbggb'},
      {'formula' : 'sin + (12)', 'values': {'SI': '1'}, 'expectedOutput' : 'rrRRbbbggb'},
      {'formula' : 'sin + (12)', 'values': {'SI': '1', 'N': '3'}, 'expectedOutput' : 'rrrrbbbggb'},
      {'formula' : 'sin(12.2) + S + (I) + n + cOs( IN )', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'bbbbggggbbbbrrbbbrbbbbrrbbbbbbbrrrb'},
      {'formula' : 'sin(  )', 'values': <String, String>{}, 'expectedOutput' : 'BBBBBBB'},
      {'formula' : 'SI(12)', 'values': <String, String>{}, 'expectedOutput' : 'RRBGGB'}, //Operator davor
      {'formula' : 'SI(12)', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'rrBGGB'},

      {'formula' : '+1', 'values': <String, String>{}, 'expectedOutput' : 'Bg'},
      {'formula' : '-1', 'values': <String, String>{}, 'expectedOutput' : 'bg'},  // oder, einfacher, bg, gg
      {'formula' : '+-1', 'values': <String, String>{}, 'expectedOutput' : 'BBg'}, // oder Bbg, Bgg
      {'formula' : '-+1', 'values': <String, String>{}, 'expectedOutput' : 'BBg'},
      {'formula' : '1+2', 'values': <String, String>{}, 'expectedOutput' : 'gbg'},
      {'formula' : '1++2', 'values': <String, String>{}, 'expectedOutput' : 'gBBg'},
      {'formula' : '1+-2', 'values': <String, String>{}, 'expectedOutput' : 'gbbg'}, // oder gbbg
      {'formula' : '1-2', 'values': <String, String>{}, 'expectedOutput' : 'gbg'},
      {'formula' : '1+*2', 'values': <String, String>{}, 'expectedOutput' : 'gBBg'},
      {'formula' : '1+++2', 'values': <String, String>{}, 'expectedOutput' : 'gBBBg'},
      {'formula' : '1++-2', 'values': <String, String>{}, 'expectedOutput' : 'gBBBg'},
      {'formula' : '1+-+2', 'values': <String, String>{}, 'expectedOutput' : 'gBBBg'},
      {'formula' : '1-----2', 'values': <String, String>{}, 'expectedOutput' : 'gbbbbbg'},
      {'formula' : '1*-2', 'values': <String, String>{}, 'expectedOutput' : 'gbbg'},

      {'formula' : '1()+2', 'values': <String, String>{}, 'expectedOutput' : 'gBBbg'},
      {'formula' : '1+()2', 'values': <String, String>{}, 'expectedOutput' : 'gbBBG'},
      {'formula' : '()1+()2', 'values': <String, String>{}, 'expectedOutput' : 'BBGbBBG'},
      {'formula' : '1+()+2', 'values': <String, String>{}, 'expectedOutput' : 'gbBBbg'},
      {'formula' : '1+(3)+2', 'values': <String, String>{}, 'expectedOutput' : 'gbbgbbg'},
      {'formula' : '1+(3)2', 'values': <String, String>{}, 'expectedOutput' : 'gbbgbG'},
      {'formula' : '1+(3)-2', 'values': <String, String>{}, 'expectedOutput' : 'gbbgbbg'},
      {'formula' : '1sin()+2', 'values': <String, String>{}, 'expectedOutput' : 'gBBBBBbg'},
      {'formula' : 'sin()+2', 'values': <String, String>{}, 'expectedOutput' : 'BBBBBbg'},
      {'formula' : 'sin(2)+2', 'values': <String, String>{}, 'expectedOutput' : 'bbbbgbbg'},
      {'formula' : '1sin(0)+2', 'values': <String, String>{}, 'expectedOutput' : 'gBBBBgBbg'},
      {'formula' : '1*sin (0)+2', 'values': <String, String>{}, 'expectedOutput' : 'gbbbbbbgbbg'},
      {'formula' : '1*sin (0)+2', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'gbbbbbbgbbg'},
      {'formula' : '1*si (0)+2', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'gbrrrBGBbg'},
      {'formula' : '1*si (0)+2', 'values': <String, String>{}, 'expectedOutput' : 'gbRRRBGBbg'},
      {'formula' : '1*si +2', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'gbrrrbg'},
      {'formula' : 'A(0)', 'values': <String, String>{}, 'expectedOutput' : 'RBGB'},
      {'formula' : '(0)A', 'values': <String, String>{}, 'expectedOutput' : 'bgbR'},
      {'formula' : 'S(0)', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'rBGB'},
      {'formula' : '(0)s', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'bgbr'},

      {'formula' : 'A{2}B', 'values': <String, String>{}, 'formulaId': 3, 'expectedOutput' : 'RbbbR'}, // IF: formula id >= 2
      {'formula' : 'A{2}B', 'values': <String, String>{}, 'formulaId': 1, 'expectedOutput' : 'RbBbR'}, // IF: formula id < 2
      {'formula' : 'A{f2}B', 'values': <String, String>{}, 'formulaId': 3, 'expectedOutput' : 'RBRGBR'}, // IF: formula id > 2
      {'formula' : 'A{F2}B', 'values': <String, String>{}, 'formulaId': 3, 'expectedOutput' : 'RBRGBR'}, // IF: formula id > 2
      {'formula' : 'A{f2}B', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'RBRGBR'}, // IF: formula id <= 2
      {'formula' : 'A{A2}B', 'values': <String, String>{}, 'expectedOutput' : 'RBRGBR'},
      {'formula' : 'A{X}B', 'values': <String, String>{}, 'expectedOutput' : 'RBRBR'},
      {'formula' : 'A{[1 + 1]}B', 'values': <String, String>{}, 'expectedOutput' : 'ttbggbbgbtt'},
      {'formula' : 'A{[A + 1]}B', 'values': <String, String>{}, 'expectedOutput' : 'ttbRRbbgbtt'},
      {'formula' : 'A{[A + 1]}B', 'values': {'A':'1'}, 'expectedOutput' : 'ttbrrbbgbtt'},
      {'formula' : 'A{1 + 1}B', 'values': <String, String>{}, 'expectedOutput' : 'RBGGBBGBR'},
      {'formula' : 'A{2}B[A+B]', 'values': <String, String>{}, 'formulaId': 3, 'expectedOutput' : 'tbbbtbRbRb'},  // IF: formula id > 2
      {'formula' : 'A{2}B[A+B]', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'tbBbtbRbRb'},  // IF: formula id <= 2
      {'formula' : 'AB[A+B]{2}', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'ttbRbRbbBb'},  // IF: formula id <= 2
      {'formula' : '[AB]{2}[A+B]', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bRRbbBbbRbRb'},  // IF: formula id <= 2
    ];

    _inputsToExpected.forEach((elem) {
      test('formula: ${elem['formula']}, values: ${elem['values']}', () {
        var _actual = formulaPainter.paintFormula(elem['formula'], elem['values'], elem['formulaId'], true);
        expect(_actual, elem['expectedOutput']);
      });
    });
  });
}
