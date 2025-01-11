import 'dart:math';

import 'package:math_expressions/math_expressions.dart';


class Helper {
  static Iterable<List<int>> iterativeHeapPermute(List<int> A) sync* {
    var n = A.length;
    var c = List<int>.filled(n, 0);

    yield A.toList();

    var i = 0;

    while (i < n) {
      if (c[i] < i) {
        if ((i & 1) == 0) {
          swap(A, 0, i);
        } else {
          swap(A, c[i], i);
        }

        yield A.toList();

        c[i]++;
        i = 0;
      } else {
        c[i] = 0;
        i++;
      }
    }
  }

  static Iterable<List<int>> combinations(List<int> values, int k) sync* {
    if (k == 0) {
      yield [];
    } else {
      for (var i = 0; i < values.length; i++) {
        var e = values[i];
        for (var c in combinations(values.sublist(i + 1), k - 1)) {
          yield [e, ...c];
        }
      }
    }
  }

  static Iterable<List<int>> kPerms(List<int> values, int k) sync* {
    if (k == values.length) {
      yield* iterativeHeapPermute(values);
    } else {
      for (var combination in combinations(values, k)) {
        yield* iterativeHeapPermute(combination.toList());
      }
    }
  }

  static Iterable<List<int>> transpose(Iterable<Iterable<int>> list) sync* {
    if (list.isEmpty) {
      yield [];
    } else {
      var firstRow = list.first.toList();
      for (var i = 0; i < firstRow.length; i++) {
        yield list.map((row) => row.elementAt(i)).toList();
      }
    }
  }

  static Iterable<String> unknowns(String equation) {
    return equation
        .split('')
        .where((c) => !'+*-/='.contains(c))
        .toSet();
  }

  static Map<String, int> mapCharsToTokens(Iterable<String> chars) {
    var result = <String, int>{};
    var i = 0;
    for (var c in chars) {
      result[c] = i++;
    }
    return result;
  }

  static List<List<int>> tokenise(Map<String, int> tokens, String input) {
    return input
        .replaceAll('==', '=')
        .replaceAll(' ', '')
        .split(RegExp(r'[+*-/=0123456789]'))
        .map((item) => item.split('').map((c) => tokens[c]!).toList())
        .toList();
  }

  static Set<int> noLeadingZero(Iterable<Iterable<int>> input) {
    return input.map((f) => f.first).toSet();
  }

  static List<bool> buildZeroMask(Set<int> noZeroSet, int size) {
    return List.generate(size, (z) => !noZeroSet.contains(z));
  }

  // static List<Tuple2<int, List<Tuple2<int, int>>>> parse(Iterable<Iterable<int>> input) {
  //   var list = input
  //       .map((l) => l.toList().reversed.map((i) => i + 1).toList())
  //       .where((e) => e.isNotEmpty)
  //       .toList().reversed;
  //
  //   var l1 = transpose(list);
  //
  //   var l2 = l1.map((r) => r.where((i) => i > 0).map((i) => i - 1));
  //
  //   // return l2
  //   //     .map((col) => Tuple2(col.first, col.skip(1).groupBy((i) => i)
  //   //     .map((grp) => Tuple2(grp.key, grp.length)).toList()))
  //   //     .toList();
  //
  //   var l3 = l2.map((col) => Tuple2(col.first, col.skip(1).groupBy((i) => i)
  //       .map<int, List<int>>((key, value) => MapEntry(key, value)).toList()))
  //       .toList();
  // }

  static final List<int> range = List.generate(10, (i) => i);

  static void swap(List<int> list, int i, int j) {
    var temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
}



// class Tuple2<T1, T2> {
//   final T1 item1;
//   final T2 item2;
//   Tuple2(this.item1, this.item2);
// }

extension GroupByExtension<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) {
    var map = <K, List<E>>{};
    for (var element in this) {
      var key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }
}
final parser = Parser();

class Formula {
  late String formula;
  late List<Token> token;
  bool onlyAddition = false;
  Set<String> usedMembers = <String>{};


  Formula(String expression) {
    formula = expression;
    token = parser.lex.tokenize(formula);

    print(token.where((t) => t.type == TokenType.VAR).length);
  usedMembers = token.where((t) => t.type == TokenType.VAR).map((t) => t.text).toSet() ;
    print(usedMembers);
    if (usedMembers.length == 1) {
      var exp = parser.parse(formula);
      Expression expDerived = exp.derive(usedMembers.first);
      print(usedMembers.first + ' ' + expDerived.toString());
      print(usedMembers.first + ' ' + expDerived.simplify().toString());
      final context = ContextModel();
      print(usedMembers.first + ' ' + expDerived.evaluate(EvaluationType.REAL, context).toString());
    }
  }
}

class PossibleValues {
  final Map<String, List<int>> _possibleValues;

  PossibleValues(this._possibleValues);

  bool isSuccess() {
    return _possibleValues.values.every((v) => v.length == 1);
  }

  /// Returns a list of possible dictionaries under the assumption that the specified character is equal to the specified value.
  List<Map<String, int>> getPossibleDictionaries(String letter, int possibleValue, Set<String> usedMembers) {
    var result = <Map<String, int>>[];
    var keysSortedByCountOfValues = _possibleValues.keys
        .where((member) => usedMembers.contains(member))
        .toList()
      ..sort((a, b) => _possibleValues[a]!.length.compareTo(_possibleValues[b]!.length));

    for (var key in keysSortedByCountOfValues) {
      var values = key == letter ? [possibleValue] : _possibleValues[key]!;

      if (result.isEmpty) {
        for (var i in values) {
          result.add({key: i});
        }
      } else {
        var tmp = <Map<String, int>>[];

        for (var j = 0; j < result.length; j++) {
          var curDic = result[j];
          var curValues = values.where((v) => !curDic.containsValue(v)).toList();

          if (curValues.isEmpty) {
            result.removeAt(j);
            j--;
            continue;
          }

          for (var curValue in curValues) {
            if (!curDic.containsKey(key)) {
              curDic[key] = curValue;
            } else {
              var newDictionary = Map<String, int>.from(curDic);
              newDictionary[key] = curValue;
              tmp.add(newDictionary);
            }
          }
        }
        result.addAll(tmp);
      }
    }

    return result.where((dic) => dic.keys.length == usedMembers.length).toList();
  }

  Map<String, int> getResult() {
    return _possibleValues.map((c, i) => MapEntry(c, i[0]));
  }

  Map<String, List<int>> getPossibleValues() {
    return _possibleValues;
  }

  Iterable<MapEntry<String, List<int>>> getPossibleValuesForMembers(Set<String> usedMembers) {
    return _possibleValues.entries
        .where((entry) => usedMembers.contains(entry.key));
        //.map((key, value) => MapEntry(key, value));
  }

  /// Set the only possible value for the character.
  void set(String ch, int val) {
    _possibleValues[ch] = [val];

    for (var key in _possibleValues.keys.where((k) => k != ch)) {
      remove(key, val);
    }
  }

  /// Remove value from the list of possible.
  void remove(String ch, int val) {
    if (!_possibleValues[ch]!.contains(val)) return;

    _possibleValues[ch]!.remove(val);

    if (_possibleValues[ch]!.isEmpty) {
      throw ArgumentError("No solution");
    }

    if (_possibleValues[ch]!.length == 1) {
      for (var key in _possibleValues.keys.where((k) => k != ch)) {
        remove(key, _possibleValues[ch]![0]);
      }
    }
  }

  /// The leading digit of a multi-digit number must not be zero.
  void removeLeadingZero(List<String> terms, String result) {
    if (_possibleValues.containsKey(result[0])) remove(result[0], 0);

    for (var ch in terms.map((t) => t[0]).toSet()) {
      if (_possibleValues.containsKey(ch)) remove(ch, 0);
    }
  }

  void checkFirstLetterInResult(List<String> terms, String result) {
    var maxSum = terms
        .map((t) => pow(10, t.length) as int)
        .reduce((a, b) => a + b);
    var maxSumStr = maxSum.toString();

    if (maxSumStr.length > result.length) return;

    if (maxSumStr.startsWith('1')) {
      set(result[0], 1);
    } else {
      for (var i = int.parse(maxSumStr[0]) + 1; i < 10; i++) {
        remove(result[0], i);
      }
    }
  }

  // Cartesian product to get permutations without duplicates.
  Iterable<List<int>> permutations1(Set<String> usedMembers) {
    Iterable<List<int>> emptyList = [<int>[]];
    var val = getPossibleValuesForMembers(usedMembers).map((entry) => entry.value);

    return val.fold(emptyList, (accumulator, sequence) {
      return [
        for (var accseq in accumulator)
          for (var item in sequence.where((value) => !accseq.contains(value)))
            [...accseq, item]
      ];
    });
  }
}

