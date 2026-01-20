import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/nema/logic/nema.dart';

void main() {

  group("NEMA.exer:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // empty Input
      {'input' : '',
        'innerKey': '',
        'outerKey': '',
        'type': NEMA_TYPE.EXER,
        'expectedOutput' : ''},
      {'input' : 'hallo gc wizard',
        'innerKey': '16-A 19-B 20-C 21-D',
        'outerKey': 'AAAAAAAAAA',
        'type': NEMA_TYPE.EXER,
        'expectedOutput' : 'WUZJY AVBLJ KXJ'},
      {'input' : 'WUZJY AVBLJ KXJ',
        'innerKey': '16-A 19-B 20-C 21-D',
        'outerKey': 'AAAAAAAAAA',
        'type': NEMA_TYPE.EXER,
        'expectedOutput' : 'HALLO GCWIZ ARD'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, innerKey: ${elem['innerKey']}, outerKey: ${elem['outerKey']}, type: ${elem['type']}', () {
        NEMAOutput _actual = nema(elem['input'] as String, elem['type'] as NEMA_TYPE, elem['innerKey'] as String, elem['outerKey'] as String,);
        expect(_actual.output, elem['expectedOutput']);
      });
    }
  });

  group("NEMA.oper:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // empty Input
      {'input' : '',
        'innerKey': '',
        'outerKey': '',
        'type': NEMA_TYPE.OPER,
        'expectedOutput' : ''},
      {'input' : 'hallo gc wizard',
        'innerKey': '12-A 13-B 14-C 15-D',
        'outerKey': 'AAAAAAAAAA',
        'type': NEMA_TYPE.OPER,
        'expectedOutput' : 'KGFFE AOKDE FKP'},
      {'input' : 'KGFFE AOKDE FKP',
        'innerKey': '12-A 13-B 14-C 14-D',
        'outerKey': 'AAAAAAAAAA',
        'type': NEMA_TYPE.OPER,
        'expectedOutput' : 'HALLO GCWIZ ARD'},
      ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, innerKey: ${elem['innerKey']}, outerKey: ${elem['outerKey']}, type: ${elem['type']}', () {
        NEMAOutput _actual = nema(elem['input'] as String, elem['type'] as NEMA_TYPE, elem['innerKey'] as String, elem['outerKey'] as String,);
        expect(_actual.output, elem['expectedOutput']);
      });
    }
  });

  group("NEMA.digits:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'input' : 'final bei nord x12y punkt 345y und ost x67y und x890y',
        'innerKey': '12-A 13-B 14-C 15-D',
        'outerKey': 'AAAAAAAAAA',
        'type': NEMA_TYPE.OPER,
        'expectedOutput' : 'CFYZB VJYFP DSEXZ NVDLR VXHYA SHWJF IKLYM GPSSR ZGG'},
      {'input' : 'CFYZB VJYFP DSEXZ NVDLR VXHYA SHWJF IKLYM GPSSR ZGG',
        'innerKey': '12-A 13-B 14-C 15-D',
        'outerKey': 'AAAAAAAAAA',
        'type': NEMA_TYPE.OPER,
        'expectedOutput' : 'FINAL BEINO RDXQW YPUNK TERTY UNDOS TXZUY UNDXI OPY'},
    ];

    for (var elem in _inputsToExpected) {
      test('input: ${elem['input']}, innerKey: ${elem['innerKey']}, outerKey: ${elem['outerKey']}, type: ${elem['type']}', () {
        NEMAOutput _actual = nema(elem['input'] as String, elem['type'] as NEMA_TYPE, elem['innerKey'] as String, elem['outerKey'] as String,);
        expect(_actual.output, elem['expectedOutput']);
      });
    }
  });
}