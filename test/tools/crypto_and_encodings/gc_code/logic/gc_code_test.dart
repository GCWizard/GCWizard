import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/gc_code/logic/gc_code.dart';

void main() {
  group("GCCode.gcCodeToID:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : '', 'expectedOutput' : null},

      {'input' : 'GC0', 'expectedOutput' : 0},
      {'input' : 'GC1', 'expectedOutput' : 1},
      {'input' : 'GC77', 'expectedOutput' : 119},
      {'input' : 'GCFFF', 'expectedOutput' : 4095},
      {'input' : 'GC1000', 'expectedOutput' : 4096},
      {'input' : 'GCFFFF', 'expectedOutput' : 65535},
      {'input' : 'GCG000', 'expectedOutput' : 65536},
      {'input' : 'GCZZZZ', 'expectedOutput' : 512400},
      {'input' : 'GC10000', 'expectedOutput' : 512401},
      {'input' : 'GC3JKKD', 'expectedOutput' : 2914542},
      {'input' : 'GC55555', 'expectedOutput' : 4360405},
      {'input' : 'GCZZZZZ', 'expectedOutput' : 28218030},
      {'input' : 'GC100000', 'expectedOutput' : 28218031},

      {'input' : 'GCGCGC', 'expectedOutput' : 77576},
      {'input' : 'GCGCGCGC', 'expectedOutput' : 469226244},
      {'input' : '  GC85P95  ', 'expectedOutput' : 7147429},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = gcCodeToID(elem['input'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("GCCode.gcCodeToID.noValidGCCode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'GCG'},
      {'input' : 'GCFFFG'},
      {'input' : 'GCILOSU'},
      {'input' : 'GC85P9599999999999999'},
      {'input' : 'GC85P95  99999999999999'},
      {'input' : 'GC85P  95'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        try {
          gcCodeToID(elem['input'] as String);
          expect(false, true);
        } catch(e) {
          expect(true, true);
        }
      });
    }
  });

  group("GCCode.idToGCCode:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : -1, 'expectedOutput' : ''},

      {'expectedOutput' : 'GC0', 'input' : 0},
      {'expectedOutput' : 'GC1', 'input' : 1},
      {'expectedOutput' : 'GC77', 'input' : 119},
      {'expectedOutput' : 'GCFFF', 'input' : 4095},
      {'expectedOutput' : 'GC1000', 'input' : 4096},
      {'expectedOutput' : 'GCFFFF', 'input' : 65535},
      {'expectedOutput' : 'GCG000', 'input' : 65536},
      {'expectedOutput' : 'GCZZZZ', 'input' : 512400},
      {'expectedOutput' : 'GC10000', 'input' : 512401},
      {'expectedOutput' : 'GC3JKKD', 'input' : 2914542},
      {'expectedOutput' : 'GC55555', 'input' : 4360405},
      {'expectedOutput' : 'GCZZZZZ', 'input' : 28218030},
      {'expectedOutput' : 'GC100000', 'input' : 28218031},

      {'expectedOutput' : 'GCGCGC', 'input' : 77576},
      {'expectedOutput' : 'GCGCGCGC', 'input' : 469226244},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}', () {
        var _actual = idToGCCode(elem['input'] as int);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}