import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/kenny/logic/kenny.dart';

void main() {
  group("KennysCode.encryptKenny:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'replaceCharacters': <String>[], 'expectedOutput' : '', 'caseSensitive' : false},
      {'input' : 'A', 'replaceCharacters': <String>[], 'expectedOutput' : '', 'caseSensitive' : false},
      {'input' : 'A', 'replaceCharacters': ['m', 'p'], 'expectedOutput' : '', 'caseSensitive' : false},
      {'input' : 'A', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'mmm', 'caseSensitive' : false},
      {'input' : 'A', 'replaceCharacters': ['m', 'p', 'f', 'a'], 'expectedOutput' : 'mmm', 'caseSensitive' : false},

      {'input' : 'AbcZ', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'mmmmmpmmfffp', 'caseSensitive' : false},
      {'input' : 'AbcZ', 'replaceCharacters': ['ma', 'pbd', 'f1'], 'expectedOutput' : 'mamamamamapbdmamaf1f1f1pbd', 'caseSensitive' : false},
      {'input' : 'Nein noch nicht', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'pppmppmffppp pppppfmmfmfp pppmffmmfmfpfmp', 'caseSensitive' : false},
      {'input' : 'Nein noch nicht', 'replaceCharacters': ['mfg', 'ps', 'fd1'], 'expectedOutput' : 'pspspsmfgpspsmfgfd1fd1pspsps pspspspspsfd1mfgmfgfd1mfgfd1ps pspspsmfgfd1fd1mfgmfgfd1mfgfd1psfd1mfgps', 'caseSensitive' : false},

      {'input' : '1', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : '1', 'caseSensitive' : false},
      {'input' : 'A1', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'mmm1', 'caseSensitive' : false},

      {'input' : '', 'replaceCharacters': <String>[], 'expectedOutput' : '', 'caseSensitive' : true},
      {'input' : 'A', 'replaceCharacters': <String>[], 'expectedOutput' : '', 'caseSensitive' : true},
      {'input' : 'A', 'replaceCharacters': ['m', 'p'], 'expectedOutput' : '', 'caseSensitive' : true},
      {'input' : 'A', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'Mmm', 'caseSensitive' : true},
      {'input' : 'A', 'replaceCharacters': ['m', 'p', 'f', 'a'], 'expectedOutput' : 'Mmm', 'caseSensitive' : true},

      {'input' : 'AbcZ', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'MmmmmpmmfFfp', 'caseSensitive' : true},
      {'input' : 'AbcZ', 'replaceCharacters': ['ma', 'pbd', 'f1'], 'expectedOutput' : 'Mamamamamapbdmamaf1F1f1pbd', 'caseSensitive' : true},
      {'input' : 'Nein noch nicht', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'Pppmppmffppp pppppfmmfmfp pppmffmmfmfpfmp', 'caseSensitive' : true},
      {'input' : 'Nein noch nicht', 'replaceCharacters': ['mfg', 'ps', 'fd1'], 'expectedOutput' : 'Pspspsmfgpspsmfgfd1fd1pspsps pspspspspsfd1mfgmfgfd1mfgfd1ps pspspsmfgfd1fd1mfgmfgfd1mfgfd1psfd1mfgps', 'caseSensitive' : true},

      {'input' : '1', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : '1', 'caseSensitive' : true},
      {'input' : 'A1', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'Mmm1', 'caseSensitive' : true},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = encryptKenny(elem['input'] as String, elem['replaceCharacters'] as List<String>, elem['caseSensitive'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("KennysCode.decryptKenny:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'replaceCharacters': <String>[], 'expectedOutput' : '', 'caseSensitive' : true},
      {'input' : 'A', 'replaceCharacters': <String>[], 'expectedOutput' : '', 'caseSensitive' : true},
      {'input' : 'A', 'replaceCharacters': ['m', 'p'], 'expectedOutput' : '', 'caseSensitive' : true},
      {'input' : 'mmm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},
      {'input' : 'mmm', 'replaceCharacters': ['m', 'p', 'f', 'a'], 'expectedOutput' : 'a', 'caseSensitive' : true},

      {'input' : 'm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'm', 'caseSensitive' : true},
      {'input' : 'mm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'mm', 'caseSensitive' : true},
      {'input' : 'mmm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},
      {'input' : 'mmmp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'ap', 'caseSensitive' : true},
      {'input' : 'mmmpp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'app', 'caseSensitive' : true},
      {'input' : 'mmmppp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'an', 'caseSensitive' : true},
      {'input' : 'f', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'f', 'caseSensitive' : true},
      {'input' : 'ff', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'ff', 'caseSensitive' : true},
      {'input' : 'fff', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'fff', 'caseSensitive' : true},
      {'input' : 'ma', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'ma', 'caseSensitive' : true},
      {'input' : 'mam', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'mam', 'caseSensitive' : true},
      {'input' : 'mamm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'mamm', 'caseSensitive' : true},
      {'input' : 'mammm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'maa', 'caseSensitive' : true},
      {'input' : 'm111mmm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'm111a', 'caseSensitive' : true},

      {'input' : 'M', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'M', 'caseSensitive' : true},
      {'input' : 'MM', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'MM', 'caseSensitive' : true},
      {'input' : 'Mmm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : true},
      {'input' : 'MMm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : true},
      {'input' : 'MMM', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : true},
      {'input' : 'mmM', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},
      {'input' : 'mMm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},
      {'input' : 'mMM', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},

      {'input' : 'Mamama', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : true},
      {'input' : 'MaMama', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : true},
      {'input' : 'MaMAMa', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : true},
      {'input' : 'MAMaMa', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : true},
      {'input' : 'mamaMa', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},
      {'input' : 'maMama', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},
      {'input' : 'maMaMa', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},
      {'input' : 'mAMaMa', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},
      {'input' : 'mAMAMA', 'replaceCharacters': ['ma', 'p', 'f'], 'expectedOutput' : 'a', 'caseSensitive' : true},

      {'input' : 'mmmP', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'aP', 'caseSensitive' : true},
      {'input' : 'Mmmpp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'App', 'caseSensitive' : true},
      {'input' : 'mmmPpp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'aN', 'caseSensitive' : true},
      {'input' : 'mmmpPp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'an', 'caseSensitive' : true},
      {'input' : 'F', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'F', 'caseSensitive' : true},
      {'input' : 'FF', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'FF', 'caseSensitive' : true},
      {'input' : 'FFF', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'FFF', 'caseSensitive' : true},
      {'input' : 'mA', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'mA', 'caseSensitive' : true},
      {'input' : 'mAm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'mAm', 'caseSensitive' : true},
      {'input' : 'maMm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'maMm', 'caseSensitive' : true},
      {'input' : 'maMmm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'maA', 'caseSensitive' : true},
      {'input' : 'M111mmm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'M111a', 'caseSensitive' : true},

      {'input' : 'mmmmmpmmfffp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'abcz', 'caseSensitive' : true},
      {'input' : 'MamamaMamapbdmamaf1f1f1pbd', 'replaceCharacters': ['ma', 'pbd', 'f1'], 'expectedOutput' : 'ABcz', 'caseSensitive' : true},
      {'input' : 'MAMAmAMamapbdmAMaf1f1f1pbD', 'replaceCharacters': ['ma', 'pbd', 'f1'], 'expectedOutput' : 'ABcz', 'caseSensitive' : true},
      {'input' : 'pppmppmffppp pppppfmmfmfp pppmffmmfmfpfmp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'nein noch nicht', 'caseSensitive' : true},
      {'input' : 'pspspsmfgpspsmfgfd1fd1pspsps pspspspspsfd1mfgmfgfd1mfgfd1ps Pspspsmfgfd1fd1mfgmfgfd1mfgfd1psfd1mfgps', 'replaceCharacters': ['mfg', 'ps', 'fd1'], 'expectedOutput' : 'nein noch Nicht', 'caseSensitive' : true},
      {'input' : 'Pmpmppppppppffm Mmfppfmpmmpp mmmfmfmmfmfp fmmmmfmfpppfppp mpmpffmffppp?', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'Kenny Code auch schon drin?', 'caseSensitive' : true},
      {'input' : 'Mmmas', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'Aas', 'caseSensitive' : true},
      {'input' : 'mMmmas', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'amas', 'caseSensitive' : true},

      {'input' : 'MpfaPff', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'FaR', 'caseSensitive' : true},
      {'input' : 'MpfAPFf', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'FAR', 'caseSensitive' : true},
      {'input' : 'Mfmfmffmp mfmmppppmmmmmmfmfpfmp!', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'Gut gemacht!', 'caseSensitive' : true},

      {'input' : '', 'replaceCharacters': <String>[], 'expectedOutput' : '', 'caseSensitive' : false},
      {'input' : 'A', 'replaceCharacters': <String>[], 'expectedOutput' : '', 'caseSensitive' : false},
      {'input' : 'A', 'replaceCharacters': ['m', 'p'], 'expectedOutput' : '', 'caseSensitive' : false},
      {'input' : 'Mmm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : false},
      {'input' : 'mmm', 'replaceCharacters': ['m', 'p', 'f', 'a'], 'expectedOutput' : 'A', 'caseSensitive' : false},

      {'input' : 'm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'M', 'caseSensitive' : false},
      {'input' : 'mm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'MM', 'caseSensitive' : false},
      {'input' : 'mmm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'A', 'caseSensitive' : false},
      {'input' : 'mmmp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'AP', 'caseSensitive' : false},
      {'input' : 'mmmPp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'APP', 'caseSensitive' : false},
      {'input' : 'mmMPpp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'AN', 'caseSensitive' : false},
      {'input' : 'f', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'F', 'caseSensitive' : false},
      {'input' : 'FF', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'FF', 'caseSensitive' : false},
      {'input' : 'Fff', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'FFF', 'caseSensitive' : false},
      {'input' : 'ma', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'MA', 'caseSensitive' : false},
      {'input' : 'mam', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'MAM', 'caseSensitive' : false},
      {'input' : 'mamm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'MAMM', 'caseSensitive' : false},

      {'input' : 'mammm', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'MAA', 'caseSensitive' : false},
      {'input' : 'm111mMM', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'M111A', 'caseSensitive' : false},

      {'input' : 'mmmmmpmMFffp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'ABCZ', 'caseSensitive' : false},
      {'input' : 'mamamamaMApbdmamaF1f1f1pbd', 'replaceCharacters': ['ma', 'pbd', 'f1'], 'expectedOutput' : 'ABCZ', 'caseSensitive' : false},
      {'input' : 'pppmppmffppp pppppfmmfmfp ppPMffmmfmfPFMp', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'NEIN NOCH NICHT', 'caseSensitive' : false},
      {'input' : 'pspspsmfgpspsmfgfd1fd1pspsps pspspspspsfd1mfgmfgfd1mfgfd1ps pspspsmfgfd1fd1mfgmfgfd1mfgfd1psfd1mfgps', 'replaceCharacters': ['mfg', 'ps', 'fd1'], 'expectedOutput' : 'NEIN NOCH NICHT', 'caseSensitive' : false},
      {'input' : 'pmpmppppppppffm mmfppfmpmmpp mmmfmfmmfmfp fmmmmfmfpppfppp mpmpffmffppp?', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'KENNY CODE AUCH SCHON DRIN?', 'caseSensitive' : false},
      {'input' : 'mmmas', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'AAS', 'caseSensitive' : false},
      {'input' : 'mmmmas', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'AMAS', 'caseSensitive' : false},

      {'input' : 'Mpfapff', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'FAR', 'caseSensitive' : false},

      {'input' : 'MfmFmffmp mfmmppppmmmmmmfmfpfmp!', 'replaceCharacters': ['m', 'p', 'f'], 'expectedOutput' : 'GUT GEMACHT!', 'caseSensitive' : false},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = decryptKenny(elem['input'] as String, elem['replaceCharacters'] as List<String>, elem['caseSensitive'] as bool);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}