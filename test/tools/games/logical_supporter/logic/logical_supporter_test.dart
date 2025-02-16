import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/games/logical_supporter/logic/logical_supporter.dart';

void main() {
  group("logical_supporter.setValues:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'categoriesCount': 4, 'itemsCount': 4, 'setValues': [[1, 5, Logical.plusValue], [1, 9, Logical.plusValue]],
        'expectedValidOutput' : true,
        'expectedOutput' : '[[[,,,,][,,,,][,,,,][,,,,]][[,,,,][,,,,][,,,,][,,,,]][[,,,,][,,,,][,,,,][,,,,]]][[[,-1,,][-11-1-1][,-1,,][,-1,,]][[,-1,,][-11-1-1][,-1,,][,-1,,]]][[[,-1,,][-11-1-1][,-1,,][,-1,,]]]',
      },
      {'categoriesCount': 4, 'itemsCount': 4, 'setValues': [[1, 5, Logical.plusValue], [1, 2, Logical.plusValue]],
        'expectedValidOutput' : true,
        'expectedOutput' : '[[[,-1,,][,-1,,][-11-1-1][,-1,,]][[,,,,][,,,,][,,,,][,,,,]][[,-1,,][,-1,,][-11-1-1][,-1,,]]][[[,-1,,][-11-1-1][,-1,,][,-1,,]][[,,,,][,,,,][,,,,][,,,,]]][[[,,,,][,,,,][,,,,][,,,,]]]',
      },
      {'categoriesCount': 4, 'itemsCount': 4, 'setValues': [[1, 5, Logical.plusValue], [1, 3, Logical.minusValue]],
        'expectedValidOutput' : true,
        'expectedOutput' : '[[[,,,,][,,,,][,,,,][,-1,,]][[,,,,][,,,,][,,,,][,,,,]][[,,,,][,,,,][,,,,][,-1,,]]][[[,-1,,][-11-1-1][,-1,,][,-1,,]][[,,,,][,,,,][,,,,][,,,,]]][[[,,,,][,,,,][,,,,][,,,,]]]',
      },
      {'categoriesCount': 4, 'itemsCount': 4, 'setValues': [[1, 5, Logical.plusValue], [5, 5, Logical.plusValue]],
        'expectedValidOutput' : true,
        'expectedOutput' : '[[[,,,,][,,,,][,,,,][,,,,]][[,,,,][,,,,][,,,,][,,,,]][[,,,,][,,,,][,,,,][,,,,]]][[[,-1,,][-11-1-1][,-1,,][,-1,,]][[,-1,,][-11-1-1][,-1,,][,-1,,]]][[[,-1,,][-11-1-1][,-1,,][,-1,,]]]',
      },
      {'categoriesCount': 4, 'itemsCount': 4, 'setValues': [[1, 5, Logical.plusValue], [1, 6, Logical.plusValue]],
        'expectedValidOutput' : false,
        'expectedOutput' : '[[[,,,,][,,,,][,,,,][,,,,]][[,,,,][,,,,][,,,,][,,,,]][[,,,,][,,,,][,,,,][,,,,]]][[[,,,,][,1,,][,,,,][,,,,]][[,,,,][,,,,][,,,,][,,,,]]][[[,,,,][,,,,][,,,,][,,,,]]]',
      },
    ];

    for (var elem in _inputsToExpected) {
      test('categoriesCount: ${elem['categoriesCount']} itemsCount: ${elem['itemsCount']}  setValues: ${elem['setValues']}', () {

        var _actual = Logical(elem['categoriesCount'] as int, elem['itemsCount'] as int);
        var valid = true;
        for (var e in (elem['setValues'] as List<List<int>>)) {
          valid &= _actual.setValue(e[0], e[1], e[2], LogicalFillType.USER_FILLED);
        }
        expect(valid, elem['expectedValidOutput']);

        expect(_actual.blocksToString(), elem['expectedOutput']);
      });
    }
  });
}