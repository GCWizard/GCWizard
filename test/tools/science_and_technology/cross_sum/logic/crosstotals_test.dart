import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/science_and_technology/cross_sums/logic/crosstotals.dart';

void main() {
  group("Crosstotals.sum:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,3,1,1,1,100], 'expectedOutput' : 109},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -31},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = sum(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.product:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,3,1,1,1,100], 'expectedOutput' : 600},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 961129483776},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -200},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = product(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.crossSum:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 13},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -4},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = crossSum(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.crossProduct:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 0},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : 0},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = crossProduct(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.crossSumIterated:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 4},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 2},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -4},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = crossSumIterated(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.crossProductIterated:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 0},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 0},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : 0},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = crossProductIterated(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.crossSumAlternatedForward:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : -1},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : -4},
      {'list' : [191,9191,9,19,1919], 'expectedOutput' : -56},
      {'list' : [91,9191,9,19,19191], 'expectedOutput' : 56},
      {'list' : [1, 0, -1], 'expectedOutput' : null},
      {'list' : [-20, -10, -1], 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = crossSumAlternatedForward(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.crossSumAlternatedBackward:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 1},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 4},
      {'list' : [191,9191,9,19,1919], 'expectedOutput' : 56},
      {'list' : [91,9191,9,19,19191], 'expectedOutput' : -56},
      {'list' : [1, 0, -1], 'expectedOutput' : null},
      {'list' : [-20, -10, -1], 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = crossSumAlternatedBackward(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.crossProductAlternated:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 0},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : -627056640},
      {'list' : [191,9191,9,19,1919], 'expectedOutput' : -4782969},
      {'list' : [91,9191,9,19,19191], 'expectedOutput' : -4782969},
      {'list' : [1, 0, -1], 'expectedOutput' : null},
      {'list' : [-20, -10, -1], 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = crossProductAlternated(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.sumAlternatedBackward:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 131},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : -1249},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : 7092},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : -10072},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -11},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = sumAlternatedBackward(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.sumAlternatedForward:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 131},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : -1249},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : -7092},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : 10072},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -11},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = sumAlternatedForward(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.productAlternated:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : -6600},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 961129483776},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : -576059334669},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : -24702470179569},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : 200},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = productAlternated(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.sumCrossSum:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 13},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 11},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : 8},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : 16},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -4},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = sumCrossSum(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.productCrossSum:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 12},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 63},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : 63},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : 63},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -2},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = productCrossSum(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.sumCrossSumIterated:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 4},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 2},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : 8},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : 7},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -4},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = sumCrossSumIterated(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.productCrossSumIterated:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 3},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 9},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : 9},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : 9},
      {'list' : [1, 0, -1], 'expectedOutput' : 0},
      {'list' : [-20, -10, -1], 'expectedOutput' : -2},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = productCrossSumIterated(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.sumCrossSumAlternatedForward:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 7},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : -3},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : 0},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : -2},
      {'list' : [1, 0, -1], 'expectedOutput' : null},
      {'list' : [-20, -10, -1], 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = sumCrossSumAlternatedForward(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.sumCrossSumAlternatedBackward:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 7},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : 3},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : 0},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : -2},
      {'list' : [1, 0, -1], 'expectedOutput' : null},
      {'list' : [-20, -10, -1], 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = sumCrossSumAlternatedBackward(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.productCrossSumAlternatedForward:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [1,2,33,1,1,1,100], 'expectedOutput' : 0},
      {'list' : <int>[], 'expectedOutput' : 0},
      {'list' : [891,589,1,2336,784], 'expectedOutput' : -11},
      {'list' : [191,9191,9,19,1919,1], 'expectedOutput' : -5},
      {'list' : [91,9191,9,19,19191,9], 'expectedOutput' : 5},
      {'list' : [1, 0, -1], 'expectedOutput' : null},
      {'list' : [-20, -10, -1], 'expectedOutput' : null},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = productCrossSumAlternatedForward(elem['list'] as List<int>);
        expect(_actual.toString(), elem['expectedOutput'].toString());
      });
    }
  });

  group("Crosstotals.countCharacters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [-20, -10, -1, 891, 589, 1, 2, 336, 784], 'expectedOutput' : 9},
      {'list' : <int>[], 'expectedOutput' : 0},
     ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = countCharacters(elem['list'] as List<int>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Crosstotals.countDistinctCharacters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'list' : [-20, -10, -1, 891, 589, 1, 2, 336, 784, -10, -1, 891, -1], 'expectedOutput' : 9},
      {'list' : <int>[], 'expectedOutput' : 0},
    ];

    for (var elem in _inputsToExpected) {
      test('list: ${elem['list']}', () {
        var _actual = countDistinctCharacters(elem['list'] as List<int>);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Crosstotals.countLetters:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text' : ' zIo120/k Da.ßÀöẞ? ', 'expectedOutput' : 10},
      {'text' : '', 'expectedOutput' : 0},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = countLetters(elem['text'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("Crosstotals.countDigits:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'text' : ' zIo120/k Da.ßÀö? ', 'expectedOutput' : 3},
      {'text' : '', 'expectedOutput' : 0},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = countDigits(elem['text'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}
