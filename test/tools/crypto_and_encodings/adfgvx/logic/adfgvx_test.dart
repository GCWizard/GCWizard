import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/adfgvx/logic/adfgvx.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/polybios/logic/polybios.dart';

void main() {
  group("ADFGVX.encryptADFGX:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'substitutionKey' : 'Wikipedia', 'transpositionKey': 'Beobachtungsliste', 'polybiosMode' : PolybiosMode.ZA90, 'expectedOutput' : ''},
      {'input' : 'Munitionierung beschleunigen Punkt Soweit nicht eingesehen auch bei Tag', 'substitutionKey' : '', 'transpositionKey': '', 'polybiosMode' : PolybiosMode.ZA90, 'expectedOutput' : 'FGDAF FGDDD GDFDF FGDXA DGDAF FGGXG XADFX FGFFX XADAF FGDGG XAFFF ADAFF GADDD FFDAG XAGDD DFFGD XFGFD DXAGD FFGGX ADFXA GFXAF FXXDA XFGFX GXAGD DDXXG G'},
      {'input' : 'Munitionierung beschleunigen Punkt Soweit nicht eingesehen auch bei Tag', 'substitutionKey' : '', 'transpositionKey': 'Beobachtungsliste', 'polybiosMode' : PolybiosMode.ZA90, 'expectedOutput' : 'FGFAG DXXFD XAADX DADFF AGFXF DXDDF XGGXF FGXAD GFXDD FGGGF AGAGG AXADF DGDXD DFXGF GGDXF XDGAG FXFDA GFXAF DDXFD DDFFA GFGAX DFAFD GAFDG FFGAD FDFFG X'},
      {'input' : 'Munitionierung beschleunigen Punkt Soweit nicht eingesehen auch bei Tag', 'substitutionKey' : 'Wikipedia', 'transpositionKey': '', 'polybiosMode' : PolybiosMode.ZA90, 'expectedOutput' : 'GGFDG FADFF ADGDG FADAX FXFDG FXDXX AXFGX GXAGX AXFDG FADXD AXGFA GFDGF AFFFF GGDAA AXADF FGFAD XGXAF FAXAD GFXDA XFGAX XAAXG FDDFD XGXAX XAXAD FFDDX D'},
      {'input' : 'Munitionierung beschleunigen Punkt Soweit nicht eingesehen auch bei Tag', 'substitutionKey' : 'Wikipedia', 'transpositionKey': 'Beobachtungsliste', 'polybiosMode' : PolybiosMode.ZA90, 'expectedOutput' : 'GXGGA DDDGD XXAFA DDFAA XAFDF FXFDG DXGAG GAAXF AGADF AAADG FAXXA DADFF FDDAD FGAXG XAFXG XFXDA FAGFX XFAXG FDXFF DFAGX XGXXA DGXGF XDFFD GAXXF FFFGD X'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutionKey: ${elem['substitutionKey']}, transpositionKey: ${elem['transpositionKey']}, polybiosMode: ${elem['polybiosMode']}, alphabet: ${elem['alphabet']}', () {
        var _actual = encryptADFGX(elem['input'] as String, elem['substitutionKey'] as String, elem['transpositionKey'] as String, polybiosMode: elem['polybiosMode'] as PolybiosMode, alphabet: elem['alphabet'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ADFGVX.encryptADFGVX:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'attack at 1200am', 'substitutionKey' : 'nachtbommenwerper', 'transpositionKey': 'PRIVACY', 'polybiosMode' : PolybiosMode.ZA90, 'expectedOutput' : 'AFXDV AGDAF XXADA XDAVX VGVAA DXD'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutionKey: ${elem['substitutionKey']}, transpositionKey: ${elem['transpositionKey']}, polybiosMode: ${elem['polybiosMode']}, alphabet: ${elem['alphabet']}', () {
        var _actual = encryptADFGVX(elem['input'] as String, elem['substitutionKey'] as String, elem['transpositionKey'] as String, polybiosMode: elem['polybiosMode'] as PolybiosMode, alphabet: elem['alphabet'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ADFGVX.decryptADFGX:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : null, 'substitutionKey' : 'Wikipedia', 'transpositionKey': 'Beobachtungsliste', 'polybiosMode' : PolybiosMode.ZA90, 'input' : ''},
      {'expectedOutput' : 'MUNITIONIERUNGBESCHLEUNIGENPUNKTSOWEITNICHTEINGESEHENAUCHBEITAG', 'substitutionKey' : '', 'transpositionKey': '', 'polybiosMode' : PolybiosMode.ZA90, 'input' : 'FGDAF FGDDD GDFDF FGDXA DGDAF FGGXG XADFX FGFFX XADAF FGDGG XAFFF ADAFF GADDD FFDAG XAGDD DFFGD XFGFD DXAGD FFGGX ADFXA GFXAF FXXDA XFGFX GXAGD DDXXG G'},
      {'expectedOutput' : 'MUNITIONIERUNGBESCHLEUNIGENPUNKTSOWEITNICHTEINGESEHENAUCHBEITAG', 'substitutionKey' : '', 'transpositionKey': 'Beobachtungsliste', 'polybiosMode' : PolybiosMode.ZA90, 'input' : 'FGFAG DXXFD XAADX DADFF AGFXF DXDDF XGGXF FGXAD GFXDD FGGGF AGAGG AXADF DGDXD DFXGF GGDXF XDGAG FXFDA GFXAF DDXFD DDFFA GFGAX DFAFD GAFDG FFGAD FDFFG X'},
      {'expectedOutput' : 'MUNITIONIERUNGBESCHLEUNIGENPUNKTSOWEITNICHTEINGESEHENAUCHBEITAG', 'substitutionKey' : 'Wikipedia', 'transpositionKey': '', 'polybiosMode' : PolybiosMode.ZA90, 'input' : 'GGFDG FADFF ADGDG FADAX FXFDG FXDXX AXFGX GXAGX AXFDG FADXD AXGFA GFDGF AFFFF GGDAA AXADF FGFAD XGXAF FAXAD GFXDA XFGAX XAAXG FDDFD XGXAX XAXAD FFDDX D'},
      {'expectedOutput' : 'MUNITIONIERUNGBESCHLEUNIGENPUNKTSOWEITNICHTEINGESEHENAUCHBEITAG', 'substitutionKey' : 'Wikipedia', 'transpositionKey': 'Beobachtungsliste', 'polybiosMode' : PolybiosMode.ZA90, 'input' : 'GXGGA DDDGD XXAFA DDFAA XAFDF FXFDG DXGAG GAAXF AGADF AAADG FAXXA DADFF FDDAD FGAXG XAFXG XFXDA FAGFX XFAXG FDXFF DFAGX XGXXA DGXGF XDFFD GAXXF FFFGD X'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutionKey: ${elem['substitutionKey']}, transpositionKey: ${elem['transpositionKey']}, polybiosMode: ${elem['polybiosMode']}, alphabet: ${elem['alphabet']}', () {
        var _actual = decryptADFGX(elem['input'] as String, elem['substitutionKey'] as String, elem['transpositionKey'] as String, polybiosMode: elem['polybiosMode'] as PolybiosMode, alphabet: elem['alphabet'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("ADFGVX.decryptADFGVX:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'expectedOutput' : 'ATTACKAT1200AM', 'substitutionKey' : 'nachtbommenwerper', 'transpositionKey': 'PRIVACY', 'polybiosMode' : PolybiosMode.ZA90, 'input' : 'AFXDV AGDAF XXADA XDAVX VGVAA DXD'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, substitutionKey: ${elem['substitutionKey']}, transpositionKey: ${elem['transpositionKey']}, polybiosMode: ${elem['polybiosMode']}, alphabet: ${elem['alphabet']}', () {
        var _actual = decryptADFGVX(elem['input'] as String, elem['substitutionKey'] as String, elem['transpositionKey'] as String, polybiosMode: elem['polybiosMode'] as PolybiosMode, alphabet: elem['alphabet'] as String?);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}