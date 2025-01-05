import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/formula_solver/logic/formula_painter.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';

void main() {
  var formulaPainter = FormulaPainter();

  group("formula_painter.paintFormula:", () {
    Map<String, String> values = {
      'A':'3', 'B':'20', 'C': '100', 'D': '5', 'E': 'Pi',
      'Q': '1', 'R': '0', 'S': '200', 'T': '20', 'U': '12', 'V': '9', 'W': '4', 'X': '30', 'Y':'4', 'Z': '50'
    };

    List<Map<String, Object?>> _inputsToExpected = [
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
      {'formula' : 'π', 'values': values, 'expectedOutput' : 'g'},
      {'formula' : 'E * π', 'values': values, 'expectedOutput' : 'rrbbg'},
      {'formula' : 'E [PI]', 'values': values, 'expectedOutput' : 'ttbggb'},
      {'formula' : '[A*B*2].[C+d+D];', 'values': values, 'expectedOutput' : 'brbrbgbtbrbrbrbt'},
      {'formula' : 'N 52 [QR].[S+T*U*2] E 12 [V*W].[XY + Z]', 'values': values, 'expectedOutput' : 'tttttbrrbtbrbrbrbgbttttttbrbrbtbrrrbbrb'},
      {'formula' : 'A + B [A + B]', 'values': values, 'expectedOutput' : 'ttttttbrrbbrb'},
      {'formula' : 'A + B]', 'values': values, 'expectedOutput' : 'rrbbrB'},
      {'formula' : '[A + B', 'values': values, 'expectedOutput' : 'Brrbbr'},

      //variables with names which are included in other variable names
      {'formula' : 'A1 + A10', 'values': {'A1': '1', 'A10': '3'}, 'expectedOutput' : 'rrrbbrrr'},
      {'formula' : 'A10 + A1', 'values': {'A1': '1', 'A10': '3'}, 'expectedOutput' : 'rrrrbbrr'},
      {'formula' : 'A1 + A10', 'values': {'A10': '3'}, 'expectedOutput' : 'RGGbbrrr'},
      {'formula' : 'A1 + A10', 'values': {'A1': '1'}, 'expectedOutput' : 'rrrbbrrG'},
      {'formula' : 'A1 + A10', 'values': {'A10': '3', 'A1': '1'}, 'expectedOutput' : 'rrrbbrrr'},
      {'formula' : 'BC + ABCD', 'values': {'ABCD': '3', 'BC': '1'}, 'expectedOutput' : 'rrrbbrrrr'},
      {'formula' : 'BC + ABCD', 'values': {'BC': '1', 'ABCD': '1'}, 'expectedOutput' : 'rrrbbrrrr'},
      {'formula' : 'Bc + ABCD', 'values': {'ABCD': '3', 'bc': '1'}, 'expectedOutput' : 'rrrbbrrrr'},
      {'formula' : 'BC + AbcD', 'values': {'ABCD': '3', 'bc': '1'}, 'expectedOutput' : 'rrrbbrrrr'},
      {'formula' : 'bc + ABCD', 'values': {'BC': '1', 'AbcD': '3'}, 'expectedOutput' : 'rrrbbrrrr'},
      {'formula' : 'ABCD + bc', 'values': {'BC': '1', 'AbcD': '3'}, 'expectedOutput' : 'rrrrrbbrr'},
      {'formula' : 'ABCD + bc', 'values': {'BD': '1', 'AbcD': '3'}, 'expectedOutput' : 'rrrrrbbRR'},

      //Trim empty space
      {'formula' : 'sin(0) ', 'values': <String, String>{}, 'expectedOutput' : 'bbbbgbb'},

      //math library testing
      {'formula' : '36^(1/2)', 'expectedOutput' : 'ggbbgbgb'},
      {'formula' : 'phi * 2', 'expectedOutput' : 'ggggbbg'},
      {'formula' : 'log(100,10)', 'expectedOutput' : 'bbbbgggbggb'}, // 1 comma
      {'formula' : 'log(10,100)', 'expectedOutput' : 'bbbbggbgggb'},
      {'formula' : 'log(100)', 'expectedOutput' : 'bbbbRRRb'},
      {'formula' : 'log(100,2,1)', 'expectedOutput' : 'bbbbgggbgBGb'},
      {'formula' : 'sqrt(4)', 'expectedOutput' : 'bbbbbgb'},
      {'formula' : 'sqrt(4,2)', 'expectedOutput' : 'bbbbbgBGb'},
      {'formula' : 'sqrt(4,2,12)', 'expectedOutput' : 'bbbbbgBGBGGb'},
      {'formula' : 'sqrt(4 , - 44.123)', 'expectedOutput' : 'bbbbbggBBBBGGGGGGb'},
      {'formula' : 'sinDeg(-4.3)', 'expectedOutput' : 'bbbbbbbbgggb'},
      {'formula' : 'sinDeg(-4.3 , - 44.123)', 'expectedOutput' : 'bbbbbbbbggggBBBBGGGGGGb'},
      {'formula' : 'round(1)', 'expectedOutput' : 'bbbbbbgb'},  // 0 or 1 comma
      {'formula' : 'round(1.247)', 'expectedOutput' : 'bbbbbbgggggb'},
      {'formula' : 'round(1.247,2)', 'expectedOutput' : 'bbbbbbgggggbgb'},
      {'formula' : 'round(1.234,2,1)', 'expectedOutput' : 'bbbbbbgggggbgBGb'},
      {'formula' : 'cs(88,99)', 'expectedOutput' : 'bbbggbggb'}, // any number of commas
      {'formula' : 'csi(88,99)', 'expectedOutput' : 'bbbbggbggb'}, // any number of commas
      {'formula' : 'MIN(8.1,99.0,123.213)', 'expectedOutput' : 'bbbbgggbggggbgggggggb'}, // any number of commas
      {'formula' : 'MAX(8.1,99.0,123.213)', 'expectedOutput' : 'bbbbgggbggggbgggggggb'}, // any number of commas
      {'formula' : 'nth(1234)', 'expectedOutput' : 'bbbbggggb'},
      {'formula' : 'nth(1234.)', 'expectedOutput' : 'bbbbgggggb'},
      {'formula' : 'nth(1234.1)', 'expectedOutput' : 'bbbbggggggb'},
      {'formula' : 'nth(1234,2)', 'expectedOutput' : 'bbbbggggbgb'},
      {'formula' : 'nth(1234,2,3)', 'expectedOutput' : 'bbbbggggbgbgb'},
      {'formula' : 'nth(1234.,2,3)', 'expectedOutput' : 'bbbbgggggbgbgb'},
      {'formula' : 'nth(1234.1,2,3)', 'expectedOutput' : 'bbbbggggggbgbgb'},
      {'formula' : 'nth(567,3,8,2)', 'expectedOutput' : 'bbbbgggbgbgBGb'},
      {'formula' : 'nth("ABC", 1)', 'expectedOutput' : 'bbbbGGGGGbggb'},
      {'formula' : 'max()', 'expectedOutput' : 'BBBBB'},
      {'formula' : 'max(1)', 'expectedOutput' : 'bbbbgb'},
      {'formula' : 'max(1,2)', 'expectedOutput' : 'bbbbgbgb'},
      {'formula' : 'max(1,2,3)', 'expectedOutput' : 'bbbbgbgbgb'},
      {'formula' : 'max(1,2,3,4)', 'expectedOutput' : 'bbbbgbgbgbgb'},
      {'formula' : 'cs(33)', 'expectedOutput' : 'bbbggb'},
      {'formula' : 'cs(33 , 444,  55)', 'expectedOutput' : 'bbbgggbggggbggggb'},
      {'formula' : 'cs(A)', 'values': <String, String>{}, 'expectedOutput' : 'bbbRb'},
      {'formula' : 'cs(A)', 'values': {'A': ''}, 'expectedOutput' : 'bbbRb'},
      {'formula' : 'cs(A)', 'values': {'A': '1'}, 'expectedOutput' : 'bbbrb'},
      {'formula' : 'cs(A)', 'values': {'A': 'X'}, 'expectedOutput' : 'bbbRb'}, // no number in number function
      {'formula' : 'cs(A)', 'values': {'A': '"X"'}, 'expectedOutput' : 'bbbRb'}, // no number in number function
      {'formula' : 'cs(AB)', 'values': {'A': '1'}, 'expectedOutput' : 'bbbrRb'},
      {'formula' : 'cs(AB)', 'values': {'A': '1', 'B': ''}, 'expectedOutput' : 'bbbrRb'},
      {'formula' : 'cs(AB)', 'values': {'A': '1', 'B': '2'}, 'expectedOutput' : 'bbbrrb'},
      {'formula' : 'cs(AB)', 'values': {'A': '1', 'B': 'Y'}, 'expectedOutput' : 'bbbrRb'},
      {'formula' : 'cs(AB)', 'values': {'A': '1', 'B': '\'Y\''}, 'expectedOutput' : 'bbbrRb'},
      {'formula' : 'csi(AB)', 'values': {'A': '1'}, 'expectedOutput' : 'bbbbrRb'},
      {'formula' : 'csi(AB)', 'values': {'A': '1', 'B': ''}, 'expectedOutput' : 'bbbbrRb'},
      {'formula' : 'csi(AB)', 'values': {'A': '1', 'B': '2'}, 'expectedOutput' : 'bbbbrrb'},
      {'formula' : 'csi(AB)', 'values': {'A': '1', 'B': 'Y'}, 'expectedOutput' : 'bbbbrRb'},


      {'formula' : 'min(A)', 'values': {'A': 'X'}, 'expectedOutput' : 'bbbbRb'}, // no number in number function
      {'formula' : 'max(A)', 'values': {'A': 'X'}, 'expectedOutput' : 'bbbbRb'}, // no number in number function
      {'formula' : 'max(A)', 'values': {'A': '"X"'}, 'expectedOutput' : 'bbbbRb'}, // no number in number function

      {'formula' : 'bww(c)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbRb'}, //no text
      {'formula' : 'bww(c)', 'values': {'C':'"1"'}, 'expectedOutput' : 'bbbbrb'},
      {'formula' : 'bww(c)', 'expectedOutput' : 'bbbbGb'}, // no text
      {'formula' : 'bww("c")', 'expectedOutput' : 'bbbbgggb'}, // no text
      {'formula' : 'bww()', 'expectedOutput' : 'BBBBB'},
      {'formula' : 'bww(\'\')', 'expectedOutput' : 'bbbbggb'},
      {'formula' : 'bww(xyz)', 'expectedOutput' : 'bbbbGGGb'},
      {'formula' : 'bww("xyz")', 'expectedOutput' : 'bbbbgggggb'},
      {'formula' : 'bww(xyz,xyz,xyz)', 'expectedOutput' : 'bbbbGGGBGGGBGGGb'},
      {'formula' : 'bww(xcz)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbGRGb'},
      {'formula' : 'bww(xcz, abc)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbGRGBBGGRb'},
      {'formula' : 'bww(223)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbGGGb'},
      {'formula' : 'bww("223")', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbgggggb'},
      {'formula' : 'bww(223)', 'expectedOutput' : 'bbbbGGGb'},
      {'formula' : 'bww("223")', 'expectedOutput' : 'bbbbgggggb'},
      {'formula' : 'bww("223\')', 'expectedOutput' : 'bbbbGGGGGb'},
      {'formula' : 'bww(A)', 'values': <String, String>{}, 'expectedOutput' : 'bbbbGb'},  // no set variable makes any text inside a text function to pure text input (= green)
      {'formula' : 'bww(A)', 'values': {'A': ''}, 'expectedOutput' : 'bbbbRb'},
      {'formula' : 'bww(A)', 'values': {'A': '1'}, 'expectedOutput' : 'bbbbRb'},
      {'formula' : 'bww(A)', 'values': {'A': 'X'}, 'expectedOutput' : 'bbbbRb'},
      {'formula' : 'bww(A)', 'values': {'A': '"X"'}, 'expectedOutput' : 'bbbbrb'},
      {'formula' : 'bww(A)', 'values': {'A': '"1"'}, 'expectedOutput' : 'bbbbrb'},
      {'formula' : 'bww(AB)', 'values': {'A': '1'}, 'expectedOutput' : 'bbbbRGb'},  // no set variable makes any text inside a text function to pure text input (= green)
      {'formula' : 'bww(AB)', 'values': {'A': '"1"'}, 'expectedOutput' : 'bbbbrGb'},
      {'formula' : 'bww(A\'B\')', 'values': {'A': '"1"'}, 'expectedOutput' : 'bbbbrgggb'},
      {'formula' : 'bww(AB)', 'values': {'A': '1', 'B': ''}, 'expectedOutput' : 'bbbbRRb'}, // set variable is not text
      {'formula' : 'bww(AB)', 'values': {'A': '"1"', 'B': '""'}, 'expectedOutput' : 'bbbbrrb'},
      {'formula' : 'av(c)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbRb'},
      {'formula' : 'av(c)', 'values': {'C':'"1"'}, 'expectedOutput' : 'bbbrb'},
      {'formula' : 'av(c)', 'expectedOutput' : 'bbbGb'},
      {'formula' : 'av("c")', 'expectedOutput' : 'bbbgggb'},
      {'formula' : 'av(xyz)', 'expectedOutput' : 'bbbGGGb'},
      {'formula' : 'av(xcz)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbGRGb'},
      {'formula' : 'av(\'x\'c"z")', 'values': {'C':'"1"'}, 'expectedOutput' : 'bbbgggrgggb'},
      {'formula' : 'len(xcz)', 'values': {'C':'1'}, 'expectedOutput' : 'bbbbGRGb'},
      {'formula' : 'len(xcz, 123)', 'values': {'C':'"1"'}, 'expectedOutput' : 'bbbbGrGgGGGGb'},

      {'formula' : 'N [1', 'values': values, 'expectedOutput' : 'RRBG'},
      {'formula' : 'N []', 'values': values, 'expectedOutput' : 'ttBB'},
      {'formula' : 'N [F', 'values': values, 'expectedOutput' : 'RRBR'},
      {'formula' : 'N [F]', 'values': values, 'expectedOutput' : 'ttbRb'},
      {'formula' : 'N [A].[{B}]', 'values': values, 'expectedOutput' : 'ttbrbtbbBbb'},
      {'formula' : 'N [A].[{H}]', 'values': values, 'expectedOutput' : 'ttbrbtbbBbb'},
      {'formula' : 'N [A].[{04}]', 'values': values, 'expectedOutput' : 'ttbrbtbbBBbb'},
      {'formula' : 'N [A].[{(B)}]', 'values': values, 'expectedOutput' : 'ttbrbtbbBBBbb'},
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
      //special characters
      {'formula' : '10  B (West) - 3  A (Ost) - 4  C (west)', 'values': <String, String>{'b (west)': '63', 'c (west)': '7', 'A (Ost)': '3'}, 'expectedOutput' : 'ggggrrrrrrrrrbbgggrrrrrrrrbbgggrrrrrrrr'},
      {'formula' : r".-\", 'values': {'.':'3', '-':'2', r'\':'2'}, 'expectedOutput' : 'rrr'},
      {'formula' : r'",', 'values': {'"':'3', ',':'2'}, 'expectedOutput' : 'rr'},

      {'formula' : 'SIN(12)', 'values': <String, String>{}, 'expectedOutput' : 'bbbbggb'},
      {'formula' : 'sin(12)', 'values': <String, String>{}, 'expectedOutput' : 'bbbbggb'},
      {'formula' : 'sin( pi * 2.3  )', 'values': <String, String>{}, 'expectedOutput' : 'bbbbbgggbbgggggb'},
      {'formula' : 'sin + (12)', 'expectedOutput' : 'RRRRbbbggb'},
      {'formula' : 'sin + (12)', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'rrrrbbbggb'},
      {'formula' : 'sin + (12)', 'values': {'SI': '1'}, 'expectedOutput' : 'rrRRbbbggb'},
      {'formula' : 'sin + (12)', 'values': {'SI': '1', 'N': '3'}, 'expectedOutput' : 'rrrrbbbggb'},
      {'formula' : 'sin(12.2) + S + (I) + n + cOs( IN )', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'bbbbggggbbbbrrbbbrbbbbrrbbbbbbbrrrb'},
      {'formula' : 'sin(  )', 'values': <String, String>{}, 'expectedOutput' : 'BBBBBBB'},
      {'formula' : 'SI(12)', 'values': <String, String>{}, 'expectedOutput' : 'RRBGGB'}, // missing operator
      {'formula' : 'SI(12)', 'values': {'S': '1', 'I': '2', 'N': '3'}, 'expectedOutput' : 'rrBGGB'},

      {'formula' : '+1', 'values': <String, String>{}, 'expectedOutput' : 'Bg'},
      {'formula' : '-1', 'values': <String, String>{}, 'expectedOutput' : 'bg'},  // or gg
      {'formula' : '+-1', 'values': <String, String>{}, 'expectedOutput' : 'BBg'}, // or Bbg, Bgg
      {'formula' : '-+1', 'values': <String, String>{}, 'expectedOutput' : 'BBg'},
      {'formula' : '1+2', 'values': <String, String>{}, 'expectedOutput' : 'gbg'},
      {'formula' : '1++2', 'values': <String, String>{}, 'expectedOutput' : 'gBBg'},
      {'formula' : '1+-2', 'values': <String, String>{}, 'expectedOutput' : 'gbbg'},
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
      {'formula' : 'A{ 2 }B', 'values': <String, String>{}, 'formulaId': 3, 'expectedOutput' : 'RbbbbbR'}, // IF: formula id >= 2
      {'formula' : 'A{f2}B', 'values': <String, String>{}, 'formulaId': 3, 'expectedOutput' : 'RbBBbR'}, // IF: formula id > 2
      {'formula' : 'A{F2}B', 'values': <String, String>{}, 'formulaId': 3, 'expectedOutput' : 'RbBBbR'}, // IF: formula id > 2
      {'formula' : 'A{f2}B', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'RbBBbR'}, // IF: formula id <= 2
      {'formula' : 'A{A2}B', 'values': <String, String>{}, 'expectedOutput' : 'RbBBbR'},
      {'formula' : 'A{X}B', 'values': <String, String>{}, 'expectedOutput' : 'RbBbR'},
      {'formula' : 'A{[1 + 1]}B', 'values': <String, String>{}, 'expectedOutput' : 'ttbggbbgbtt'},
      {'formula' : 'A{[A + 1]}B', 'values': <String, String>{}, 'expectedOutput' : 'ttbRRbbgbtt'},
      {'formula' : 'A{[A + 1]}B', 'values': {'A':'1'}, 'expectedOutput' : 'ttbrrbbgbtt'},
      {'formula' : 'A{1 + 1}B', 'values': <String, String>{}, 'expectedOutput' : 'RbBBBBBbR'},
      {'formula' : 'A{2}B[A+B]', 'values': <String, String>{}, 'formulaId': 3, 'expectedOutput' : 'tbbbtbRbRb'},  // IF: formula id > 2
      {'formula' : 'A{2}B[A+B]', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'tbBbtbRbRb'},  // IF: formula id <= 2
      {'formula' : 'AB[A+B]{2}', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'ttbRbRbbBb'},  // IF: formula id <= 2
      {'formula' : '[AB]{2}[A+B]', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bRRbbBbbRbRb'},  // IF: formula id <= 2

      {'formula' : '{form1}+{form2}', 'values': <String, String>{'A': '1'}, 'formulaId': 2, 'formulaNames': ['form1', 'form2', '', 'form3' ], 'expectedOutput' : 'bbbbbbbbbbbbbbb'},
      {'formula' : '{1}+{form2}', 'values': <String, String>{'A': '1'}, 'formulaId': 2, 'formulaNames': ['form1', 'form2', '', 'form3' ], 'expectedOutput' : 'bbbbbbbbbbb'},
      {'formula' : '{1}+{ form2 }', 'values': <String, String>{'A': '1'}, 'formulaId': 2, 'formulaNames': ['form1', 'form2', '', 'form3' ], 'expectedOutput' : 'bbbbbbbbbbbbb'},
      {'formula' : '{1}+{ form3 }', 'values': <String, String>{'A': '1'}, 'formulaId': 2, 'formulaNames': ['form1', 'form2', '', 'form3' ], 'expectedOutput' : 'bbbbbbBBBBBbb'},
      {'formula' : '{ Alpha }', 'values': <String, String>{'A': '1'}, 'formulaId': 2, 'formulaNames': ['form1', 'form2', '', 'form3' ], 'expectedOutput' : 'bbBBBBBbb'},

      // empty variable value
      {'formula' : '[A]', 'values': {'A':''}, 'expectedOutput' : 'bRb'},

      // new line
      {'formula' : 'sindeg(90)\r\nsindeg(90)', 'expectedOutput' : 'bbbbbbbggbbbbbbbbbbggb'},
      {'formula' : 'sindeg(90)\nsindeg(90)', 'expectedOutput' : 'bbbbbbbggbbbbbbbbbggb'},
      {'formula' : 'sindeg(90)\rsindeg(90)', 'expectedOutput' : 'bbbbbbbggbbbbbbbbbggb'},
      {'formula' : 'sindeg(90)\n\nsindeg(90)', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bbbbbbbggbbbbbbbbbbggb'},

      {'formula' : '[ 48*I - 2]', 'values': {'I': '1'}, 'formulaId': 2, 'expectedOutput' : 'bbggbrrbbgb'},

      {'formula' : 'nth(567,nrt(3,8))', 'expectedOutput' : 'bbbbgggbbbbbgbgbb'},
      {'formula' : 'nth((nth(67,2) +6)!,3)', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bbbbbbbbbggbgbbbgbbbgb'},
      {'formula' : 'sqrt(nrt(2,16))', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bbbbbbbbbgbggbb'},
      {'formula' : '5!', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'gb'},
      {'formula' : '5  !', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'gggb'},
      {'formula' : '!5', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bg'},
      {'formula' : '! 5', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bbg'},
      {'formula' : '!!5', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bbg'},
      {'formula' : '! !5', 'values': <String, String>{}, 'formulaId': 2, 'expectedOutput' : 'bbbg'},
      {'formula' : '3!+!4', 'expectedOutput' : 'gbbbg'},
      {'formula' : '3 ! + ! 4', 'expectedOutput' : 'ggbbbbbbg'},

      //nested functions with >1 parameter
      {'formula' : 'sqrt(log(10,2))', 'expectedOutput' : 'bbbbbbbbbggbgbb'},
      {'formula' : 'log(log(10 ,2), 2)', 'expectedOutput' : 'bbbbbbbbgggbgbbggb'},
      {'formula' : 'log(2, log(10,2,2), 2)', 'expectedOutput' : 'bbbbgbbbbbbggbgBGbBGGb'},
      {'formula' : 'log(sqrt(4),2)', 'expectedOutput' : 'bbbbbbbbbgbbgb'},
      {'formula' : 'log(sqrt(),2)', 'expectedOutput' : 'bbbbBBBBBBbgb'},
      {'formula' : 'log(sqrt(4,2),2)', 'expectedOutput' : 'bbbbbbbbbgBGbbgb'},
      {'formula' : 'log(10, sqrt (4) )', 'expectedOutput' : 'bbbbggbbbbbbbbgbbb'},
      {'formula' : 'log(sqrt(4), sqrt(sqrt(4)))', 'expectedOutput' : 'bbbbbbbbbgbbbbbbbbbbbbbgbbb'},
      {'formula' : 'log(  2   ,   log  (  10,2)   )', 'expectedOutput' : 'bbbbggggggbbbbbbbbbbggggbgbbbbb'},
      {'formula' : 'log(log(10,2),nth(10,2,3))', 'expectedOutput' : 'bbbbbbbbggbgbbbbbbggbgbgbb'},
      {'formula' : 'log(log(10,2),nth(10,2,3,4,5))', 'expectedOutput' : 'bbbbbbbbggbgbbbbbbggbgbgBGBGbb'},
      {'formula' : 'round(1.4, max(1,2,3,4))', 'expectedOutput' : 'bbbbbbgggbbbbbbgbgbgbgbb'},
      {'formula' : 'round(1.4, max(1))', 'expectedOutput' : 'bbbbbbgggbbbbbbgbb'},
      {'formula' : 'max(1, round(1.4,1))', 'expectedOutput' : 'bbbbgbbbbbbbbgggbgbb'},
      {'formula' : 'max(round(1.4,1,2))', 'expectedOutput' : 'bbbbbbbbbbgggbgBGbb'},
      {'formula' : 'max(1.321, round(1.4,1,2))', 'expectedOutput' : 'bbbbgggggbbbbbbbbgggbgBGbb'},
      {'formula' : 'round( - 1.321,sqrt(2))', 'expectedOutput' : 'bbbbbbbbbgggggbbbbbbgbb'},
      {'formula' : 'log(log(10, 2),log(round(10,2),2))', 'expectedOutput' : 'bbbbbbbbggbggbbbbbbbbbbbbggbgbbgbb'},
      {'formula' : 'log(2,bww(ABC))', 'expectedOutput' : 'bbbbgbbbbbGGGbb'},
      {'formula' : 'log(2,bww(ABC))', 'values': {'C': '1'}, 'expectedOutput' : 'bbbbgbbbbbGGRbb'},
      {'formula' : 'log(2,bww(ABC, ABC))', 'expectedOutput' : 'bbbbgbbbbbGGGBBGGGbb'},
      {'formula' : 'log(2,bww(ABC, ABC), 2)', 'expectedOutput' : 'bbbbgbbbbbGGGBBGGGbBGGb'},
      {'formula' : 'log(2,bww(ABC, ABC), 2)', 'values': {'C': '1'}, 'expectedOutput' : 'bbbbgbbbbbGGRBBGGRbBGGb'},
      {'formula' : 'csi(log(bww(A), 2))', 'expectedOutput' : 'bbbbbbbbbbbbGbbggbb'},
      {'formula' : 'csi(log(bww(A),2), log(2,bww(A)), log(bww(A)))', 'expectedOutput' : 'bbbbbbbbbbbbGbbgbbbbbbbgbbbbbGbbbbbbbbRRRRRRbb'},
      {'formula' : 'log(2, 2, round(12, 3))', 'expectedOutput' : 'bbbbgbggBBBBBBBBGGBGGBb'},
      {'formula' : 'N [log(2,bww(ABC))!]° [log(cs(23,23), csi(123,1,2,3))] E [csi(log(bww(A), 2))]°', 'expectedOutput' : 'ttbbbbbgbbbbbGGGbbbbttbbbbbbbbggbggbbbbbbbgggbgbgbgbbbtttbbbbbbbbbbbbbGbbggbbbt'},
      {'formula' : 'N 51° 09.[315- ( (A+1)! - A! + 2 )] E 013° 01.[056 + ( 2*A! - A² + 3 )]', 'expectedOutput' : 'tttttttttbgggbbbbbRbgbbbbbRbbbbggbbtttttttttttbggggbbbbgbRbbbbRbggbbggb'},

      //Interpolated value types
      {'formula' : 'cs(A)', 'values': {'A': ''}, 'expectedOutput' : 'bbbRb'},
      {'formula' : 'cs(A)', 'values': {'A': '1'}, 'expectedOutput' : 'bbbrb'},
      {'formula' : 'cs(A)', 'values': {FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED)}, 'expectedOutput' : 'bbbrb'},
      {'formula' : 'cs(A)', 'values': {FormulaValue('A', '1-6#2', type: FormulaValueType.INTERPOLATED)}, 'expectedOutput' : 'bbbrb'},
      {'formula' : 'cs(A)', 'values': {FormulaValue('A', '1-6#2,7', type: FormulaValueType.INTERPOLATED)}, 'expectedOutput' : 'bbbrb'},

      {'formula' : 'bww(A)', 'values': {'A': ''}, 'expectedOutput' : 'bbbbRb'},
      {'formula' : 'bww(A)', 'values': {'A': '1'}, 'expectedOutput' : 'bbbbRb'},
      {'formula' : 'bww(A)', 'values': {FormulaValue('A', '1-3', type: FormulaValueType.INTERPOLATED)}, 'expectedOutput' : 'bbbbRb'},
      {'formula' : 'bww(A)', 'values': {FormulaValue('A', '1-6#2', type: FormulaValueType.INTERPOLATED)}, 'expectedOutput' : 'bbbbRb'},
      {'formula' : 'bww(A)', 'values': {FormulaValue('A', '1-6#2,7', type: FormulaValueType.INTERPOLATED)}, 'expectedOutput' : 'bbbbRb'},

      {'formula' : 'cs(A) + bww(B)', 'values': {FormulaValue('A', '1-6#2,7', type: FormulaValueType.INTERPOLATED), FormulaValue('B', '1-3', type: FormulaValueType.INTERPOLATED)}, 'expectedOutput' : 'bbbrbbbbbbbbRb'},

      //empty variables are always hint for forgotten values, so always R
      {'formula' : 'A', 'values': <String, String>{}, 'expectedOutput' : 'R'},
      {'formula' : 'A', 'values': {'A': ''}, 'expectedOutput' : 'R'},
      {'formula' : 'A', 'values': {'A': '1'}, 'expectedOutput' : 'r'},
      {'formula' : 'A', 'values': {'A': '"1"'}, 'expectedOutput' : 'r'},

      //recursive values
      // {'formula' : 'A', 'values': {'A': 'B', 'B': 'C', 'C': '12'}, 'expectedOutput' : 'r'},
      // {'formula' : 'A', 'values': {'A': 'B', 'B': 'C', 'C': 'DE', 'D': '1', 'E': 'F', 'F': '2'}, 'expectedOutput' : 'r'},
      // {'formula' : 'A', 'values': {'A': 'B', 'B': 'C', 'C': 'DE', 'D': '1', 'E': 'F'}, 'expectedOutput' : 'R'},
      // {'formula' : 'cs(A)', 'values': {'A': 'B', 'B': 'C', 'C': 'DE', 'D': '1-2', 'E': 'F', 'F': 'bww("ABC")'}, 'expectedOutput' : 'bbbrb'},
      // {'formula' : 'cs(A)', 'values': {'A': 'B', 'B': 'C', 'C': 'DE', 'D': '"XYZ"', 'E': 'F', 'F': '"ABC"'}, 'expectedOutput' : 'bbbRb'},
      // {'formula' : 'cs(A)', 'values': {'A': 'B', 'B': 'C', 'C': 'DE', 'D': '1-2', 'E': 'F', 'F': '"ABC"'}, 'expectedOutput' : 'bbbRb'},
      // {'formula' : 'bww(A)', 'values': {'A': 'B', 'B': 'C', 'C': 'DE', 'D': '1-2', 'E': 'F', 'F': 'bww("ABC")'}, 'expectedOutput' : 'bbbbRb'},
      // {'formula' : 'bww(A)', 'values': {'A': 'B', 'B': 'C', 'C': 'DE', 'D': '"XYZ"', 'E': 'F', 'F': '"ABC"'}, 'expectedOutput' : 'bbbbRb'},
      // {'formula' : 'bww(A)', 'values': {'A': 'B', 'B': 'C', 'C': 'DE', 'D': '1-2', 'E': 'F', 'F': '"ABC"'}, 'expectedOutput' : 'bbbbrb'},

      //formulas in values
      {'formula' : 'A', 'values': {'A': '1 + 2'}, 'expectedOutput' : 'r'},
      {'formula' : 'A', 'values': {'A': '1 + "ABC"'}, 'expectedOutput' : 'r'},
      {'formula' : 'A', 'values': {'A': 'bww("ABC")'}, 'expectedOutput' : 'r'},
      {'formula' : 'A', 'values': {'A': 'b', 'B': '"ABC"'}, 'expectedOutput' : 'r'},
      // {'formula' : 'A + 1', 'values': {'A': 'b', 'B': '"ABC"'}, 'expectedOutput' : 'rrBBG'},
      {'formula' : 'A', 'values': {'A': 'bww(b)', 'B': '"ABC"'}, 'expectedOutput' : 'r'},
      //{'formula' : 'A', 'values': {'A': 'bww(b)', 'B': '123'}, 'expectedOutput' : 'R'},
      {'formula' : 'A', 'values': {'A': 'cs(b)', 'B': '123'}, 'expectedOutput' : 'r'},
      {'formula' : 'A', 'values': {'A': 'cs(b - 2)', 'B': 'cs(123) + 24'}, 'expectedOutput' : 'r'},
      {'formula' : 'cs(A)', 'values': {'A': '1 + 2'}, 'expectedOutput' : 'bbbrb'},
      {'formula' : 'cs(A)', 'values': {'A': '1 + bww("ABC")'}, 'expectedOutput' : 'bbbrb'},
      //{'formula' : 'cs(A)', 'values': {'A': '1 + "ABC"'}, 'expectedOutput' : 'bbbRb'},
      {'formula' : 'cs(A)', 'values': {'A': 'b', 'B': '"ABC"'}, 'expectedOutput' : 'bbbRb'},
      {'formula' : 'cs(A)', 'values': {'A': 'bww(b)', 'B': '"ABC"'}, 'expectedOutput' : 'bbbrb'},
      //{'formula' : 'cs(A)', 'values': {'A': 'bww(b)', 'B': '123'}, 'expectedOutput' : 'bbbRb'},
      {'formula' : 'cs(A)', 'values': {'A': 'cs(b)', 'B': '123'}, 'expectedOutput' : 'bbbrb'},
      {'formula' : 'bww(A)', 'values': {'A': '1 + 2'}, 'expectedOutput' : 'bbbbRb'},
      //{'formula' : 'bww(A)', 'values': {'A': '1 + bww("ABC")'}, 'expectedOutput' : 'bbbRb'},
      //{'formula' : 'bww(A)', 'values': {'A': 'bww(b)', 'B': '123'}, 'expectedOutput' : 'bbbRb'},

      //text
      {'formula' : '\'\'', 'expectedOutput' : 'gg'},
      {'formula' : '""', 'expectedOutput' : 'gg'},
      {'formula' : '"\'"', 'expectedOutput' : 'ggg'},
      {'formula' : '\'"\'', 'expectedOutput' : 'ggg'},
      {'formula' : '"\'', 'expectedOutput' : 'GG'},
      {'formula' : '\'"', 'expectedOutput' : 'GG'},
      {'formula' : '\'', 'expectedOutput' : 'G'},
      {'formula' : '"', 'expectedOutput' : 'G'},

     {'formula' : 'ABCD', 'expectedOutput' : 'RRRR'},
     {'formula' : '\'ABCD\'', 'expectedOutput' : 'gggggg'},
     {'formula' : '"ABCD"', 'expectedOutput' : 'gggggg'},
     {'formula' : '"ABCD\'"', 'expectedOutput' : 'ggggggg'},
     {'formula' : '\'ABCD"\'', 'expectedOutput' : 'ggggggg'},
     {'formula' : '\'ABCD"', 'expectedOutput' : 'GGGGGG'},
     {'formula' : '"ABCD\'', 'expectedOutput' : 'GGGGGG'},
     {'formula' : '"ABCD', 'expectedOutput' : 'GGGGG'},
     {'formula' : '\'ABCD', 'expectedOutput' : 'GGGGG'},
     {'formula' : 'ABCD\'', 'expectedOutput' : 'RRRRG'},
     {'formula' : '"AB"\'CD\'', 'expectedOutput' : 'gggggggg'},

     {'formula' : 'A', 'values': {'A': '"ABC"'}, 'expectedOutput' : 'r'},
     {'formula' : 'AB', 'values': {'A': '"ABC"', 'B': '\'xyz\''}, 'expectedOutput' : 'rr'},
     {'formula' : 'A B', 'values': {'A': '"ABC"', 'B': '\'xyz\''}, 'expectedOutput' : 'rrr'},
     {'formula' : 'A "C" B', 'values': {'A': '"ABC"', 'B': '\'xyz\''}, 'expectedOutput' : 'rrggggr'},
     {'formula' : 'A C B', 'values': {'A': '"ABC"', 'B': '\'xyz\''}, 'expectedOutput' : 'rrRRr'},
     {'formula' : '"A"C"B"', 'expectedOutput' : 'gggGggg'},
     {'formula' : '"A"C"B"', 'values': {'C': ''}, 'expectedOutput' : 'gggRggg'},
     {'formula' : '"A"C"B"', 'values': {'C': '""'}, 'expectedOutput' : 'gggrggg'},
     {'formula' : '"A"C"B"', 'values': {'C': '1'}, 'expectedOutput' : 'gggRggg'}, // mix of text and numbers
     {'formula' : 'bww("A"C"B")', 'values': {'C': '1'}, 'expectedOutput' : 'bbbbgggRgggb'},
     {'formula' : '"A"C"B"', 'values': {'C': '"1"'}, 'expectedOutput' : 'gggrggg'},
     {'formula' : '"A"1"B"', 'expectedOutput' : 'gggGggg'}, // mix of text and numbers
     {'formula' : '"A""B"', 'values': {'C': '"1"'}, 'expectedOutput' : 'gggggg'},

     // {'formula' : '1 + "ABC"', 'expectedOutput' : 'ggbbRRRRR'},
     // {'formula' : '"ABC" + 1', 'expectedOutput' : 'rrrrrrBBG'},
     {'formula' : 'len(ABC)', 'expectedOutput' : 'bbbbGGGb'},
     {'formula' : 'len("ABC")', 'expectedOutput' : 'bbbbgggggb'},
     {'formula' : 'len(ABC)', 'values': {'A': 'ABC'}, 'expectedOutput' : 'bbbbRGGb'},
     {'formula' : 'len(ABC)', 'values': {'A': '"ABC"'}, 'expectedOutput' : 'bbbbrGGb'},
     {'formula' : 'len(ABC)', 'values': {'ABC': '"ABC"'}, 'expectedOutput' : 'bbbbrrrb'},
     {'formula' : 'len(ABC)', 'values': {'A': '"ABC"', 'BC': '"BC"'}, 'expectedOutput' : 'bbbbrrrb'},
     {'formula' : 'len(ABC)', 'values': {'A': '"ABC"', 'B': '\'BC\'', 'C': '"AB"'}, 'expectedOutput' : 'bbbbrrrb'},
     {'formula' : 'len(A BC)', 'values': {'A': '"ABC"', 'BC': '"BC"'}, 'expectedOutput' : 'bbbbrrrrb'},
     {'formula' : 'len(A"  "BC)', 'values': {'A': '"ABC"', 'BC': '"BC"'}, 'expectedOutput' : 'bbbbrggggrrb'},
     {'formula' : 'len("ABC")', 'values': {'A': '"ABC"', 'BC': '"BC"'}, 'expectedOutput' : 'bbbbgggggb'},
     {'formula' : 'len(ABC)', 'values': {'A': '"ABC"', 'C': '"BC"'}, 'expectedOutput' : 'bbbbrGrb'},
     {'formula' : 'len(ABC)', 'values': {'A': '"ABC"', 'BC': '\'BC\''}, 'expectedOutput' : 'bbbbrrrb'},
     {'formula' : 'len(ABC)', 'values': {'A': '"ABC"', 'BC': "''BC'"}, 'expectedOutput' : 'bbbbrRRb'}, // BC -> ''BC' --> first both apostrophes mark separate string, therefore B is not in the string.
     {'formula' : 'len(ABC)', 'values': {'A': '"ABC\'"', 'BC': "'\"BC'"}, 'expectedOutput' : 'bbbbrrrb'},
     {'formula' : 'len(ABC)', 'values': {'A': "'\"BC'", 'BC': '"ABC\'"'}, 'expectedOutput' : 'bbbbrrrb'},
     {'formula' : 'len(ABC)', 'values': {'A': "'BC'", 'BC': '"\'ABC\'"'}, 'expectedOutput' : 'bbbbrrrb'},
     {'formula' : 'len(ABC)', 'values': {'A': "'\"BC\"'", 'BC': '"\'ABC\'"'}, 'expectedOutput' : 'bbbbrrrb'},
     {'formula' : 'len(A,B,C)', 'values': {'A': '"ABC"'}, 'expectedOutput' : 'bbbbrgGgGb'},
     {'formula' : 'len(A,B,C)', 'expectedOutput' : 'bbbbGgGgGb'},
     {'formula' : 'len(A,B,C")', 'values': {'A': '"ABC'}, 'expectedOutput' : 'bbbbRgGgGGb'},
     {'formula' : 'cs(bww(\'ABCDE\')) * len("55")', 'expectedOutput' : 'bbbbbbbgggggggbbbbbbbbbggggb'},
     {'formula' : 'cs(\'ABCDE\')', 'expectedOutput' : 'bbbGGGGGGGb'},
     {'formula' : 'bww(AB)', 'values': {'A': '""', 'B': 'C'}, 'expectedOutput' : 'bbbbrRb'},
     {'formula' : 'bww(AB)', 'values': {'A': '""', 'B': 'C', 'C': "'A'"}, 'expectedOutput' : 'bbbbrRb'},
     {'formula' : 'bww(AB)', 'values': {'A': '', 'B': 'C'}, 'expectedOutput' : 'bbbbRRb'},
     {'formula' : 'bww(AB)', 'values': {'A': '""', 'B': '"C"'}, 'expectedOutput' : 'bbbbrrb'},
     {'formula' : 'bww(AB)', 'values': {'A': '', 'B': '"C"'}, 'expectedOutput' : 'bbbbRrb'},
     {'formula' : 'bww(AB)', 'values': {'A': '""', 'B': 'C', 'C': 'DE', 'D': "'A'", 'E': 'F', 'F': '"A"'}, 'expectedOutput' : 'bbbbrRb'},
     {'formula' : 'bww(AB)', 'values': {'A': '""', 'B': 'C', 'C': 'DE', 'D': "'A'", 'E': 'F', 'F': 'X'}, 'expectedOutput' : 'bbbbrRb'},
     {'formula' : 'len(A)', 'values': {'A': ''}, 'expectedOutput' : 'bbbbRb'},
     {'formula' : 'len(AB)', 'values': {'A': '', 'B': '"C"'}, 'expectedOutput' : 'bbbbRrb'},
     {'formula' : 'len(AB)', 'values': {'A': '""', 'B': "C"}, 'expectedOutput' : 'bbbbrRb'},
     {'formula' : 'nth(A, 1)', 'values': {'A': '10'}, 'expectedOutput' : 'bbbbrbggb'},
     {'formula' : 'nth(A, 1)', 'values': {'A': '"AB"'}, 'expectedOutput' : 'bbbbRbggb'},
     {'formula' : 'len("ABC") * bww(\'55\')', 'expectedOutput' : 'bbbbgggggbbbbbbbbggggb'},
     {'formula' : 'len("ABC) * bww(\'55\')', 'expectedOutput' : 'bbbbGGGGbbbbbbbbggggb'}, // Text begins at "ABC and never ends, so also ) * bww('55') is part of the string
     {'formula' : 'len("ABC) * bww("55")', 'expectedOutput' : 'bbbbGGGGbbbbbbbbggggb'}, // String ends at bww(", so 55 is normal number and a new string without end starts at ")
    ];

    for (var elem in _inputsToExpected) {
      test('formula: ${elem['formula']}, values: ${elem['values']}', () {
        var variables = <FormulaValue>[];
        var formulaNames = <String>[];

        if (elem['values'] is Map<String, String>) {
          (elem['values'] as Map<String, String>).forEach((key, value) {
            variables.add(FormulaValue(key, value));
          });
        }  else if (elem['values'] is List<FormulaValue> ) {
          variables = elem['values'] as List<FormulaValue>;
        }  else if (elem['values'] is Set<FormulaValue>) {
          variables = (elem['values'] as Set<FormulaValue>).toList();
        }

        if (elem['formulaNames'] is List<String>) {
          formulaNames = elem['formulaNames'] as List<String>;
        }

        var _actual = formulaPainter.paintFormula(elem['formula'] as String, variables, (elem['formulaId'] ?? 0) as int, formulaNames, true);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
