import 'dart:collection';

// https://exercism.org/tracks/csharp/exercises/alphametics/solutions/martinfreedman
class Alphametics05 {
  static Map<String, int>? solve(String equation) {
    var chars = equation.unknowns();
    var k = chars.length;
    var tokens = chars.mapCharsToTokens();
    var tokenizedEquation = tokens.tokenise(equation);
    var columns = tokenizedEquation.parse();
    var zeroMask = tokenizedEquation.noLeadingZero().buildZeroMask(k);

    bool canBeZero(List<int> perm) {
      var found = perm.indexWhere((i) => i == 0);
      return found == -1 || zeroMask[found];
    }

    var range = List.generate(10, (i) => i);
    var res = range.kPerms(k).where((l) => canBeZero(l)).firstWhere(
            (p) => colSum(columns, 0, p),
        orElse: () => null);

    return res != null
        ? Map.fromIterables(
        chars, res.map((i) => i))
        : null;
  }

  static final List<int> range = List.generate(10, (i) => i);

  static bool colSum(List<(int, List<(int, int)>)> cols, int carry, List<int> perm) {
    for (var col in cols) {
      var (y, xs) = col;
      var sum = xs.fold(0, (sum, k) => sum + k.$2 * perm[k.$1]) + carry;
      if (perm[y] == sum % 10) {
        carry = sum ~/ 10;
      } else {
        return false;
      }
    }
    return carry == 0;
  }

  static String getOutput(String equation, Map<String, int> result) {
    return replaceLetters(result, equation);
  }

  static String replaceLetters(Map<String, int> tmpDic, String term) {
    tmpDic.forEach((key, value) {
      term = term.replaceAll(key, value.toString());
    });
    return term;
  }
}

extension ListExtension<T> on List<T> {
  void swap(int from, int to) {
    var temp = this[to];
    this[to] = this[from];
    this[from] = temp;
  }

  Iterable<List<T>> iterativeHeapPermute() sync* {
    var n = length;
    var c = List.filled(n, 0);

    yield this;

    var i = 0;

    while (i < n) {
      if (c[i] < i) {
        if (i.isEven) {
          swap(0, i);
        } else {
          swap(c[i], i);
        }

        yield this;

        c[i]++;
        i = 0;
      } else {
        c[i] = 0;
        i++;
      }
    }
  }

  Iterable<List<T>> kPerms(int k) {
    if (k == length) {
      return iterativeHeapPermute();
    } else {
      return combinations(k).expand((v) => v.iterativeHeapPermute());
    }
  }

  Iterable<List<T>> combinations(int k) {
    if (k == 0) {
      return [[]];
    } else {
      return asMap().entries.expand((e) =>
          skip(e.key + 1).combinations(k - 1).map((c) => [e.value, ...c]));
    }
  }
}

extension StringExtension on String {
  Iterable<String> unknowns() {
    return split('').where((c) => !' +=0123456789'.contains(c)).toSet();
  }
}

extension IterableExtension<T> on Iterable<T> {
  Map<T, int> mapCharsToTokens() {
    return Map.fromEntries(
        toList().asMap().entries.map((e) => MapEntry(e.value as String, e.key)));
  }

  List<List<int>> tokenise(String input) {
    return input
        .replaceAll('==', '=')
        .replaceAll(' ', '')
        .split(RegExp(r'[+=0123456789]'))
        .where((c) => c.isNotEmpty)
        .map((item) => item.split('').map((c) => this[c] as int).toList())
        .toList();
  }

  Set<int> noLeadingZero() {
    return map((f) => (f as List<int>).first).toSet();
  }

  List<bool> buildZeroMask(int size) {
    return List.generate(size, (z) => !(this as Set<int>).contains(z));
  }

  List<(int, List<(int, int)>)> parse() {
    return map((l) => (l as List<int>).reversed.map((i) => i + 1))
        .toList()
        .reversed
        .toList()
        .transpose()
        .map((r) => r.where((i) => i > 0).map((i) => i - 1))
        .map((col) => (
    col.first,
    col.skip(1).fold<Map<int, int>>({}, (map, i) {
      map[i] = (map[i] ?? 0) + 1;
      return map;
    }).entries.map((e) => (e.key, e.value)).toList()
    ))
        .toList();
  }

  List<List<T>> transpose() {
    if (isEmpty) return [];
    var first = this.first as List<T>;
    return List.generate(
        first.length,
            (i) => map((list) => (list as List<T>).elementAtOrNull(i))
            .whereType<T>()
            .toList());
  }
}
