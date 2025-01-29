const String letters = "ABCDFGHJKL";
List<int> numbers = List.generate(10, (i) => i); // [0,1,2,3,4,5,6,7,8,9]

const List<List<String>> raetsel = [
  ['GJ', '*', 'DJ', '=', 'LBAC'],
  ['BJKD', '+', 'BCCK', '=', 'DJKB'],
  ['BJLH', '-', 'GF', '=', 'BHJL'],
  ['BJKD', '-', 'GJ', '=', 'BJLH'],
  ['BCCK', '/', 'DJ', '=', 'GF'],
  ['DJKB', '-', 'LBAC', '=', 'BHJL']
];

int txtToInt(String text, Map<String, int> mapping) {
  return int.parse(text.split('').map((char) => mapping[char]!.toString()).join());
}

double calculate(double a, double b, String operator) {
  switch (operator) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      return a / b;
    default:
      throw ArgumentError('Ungültiger Operator');
  }
}

List<List<int>> reduceSolutions(List<List<int>> perms, int formulaId) {
  List<List<int>> solutions = [];

  for (var perm in perms) {
    Map<String, int> mapping = Map.fromIterables(letters.split(''), perm);
    List<String> line = raetsel[formulaId];

    try {
      int a = txtToInt(line[0], mapping);
      int b = txtToInt(line[2], mapping);
      int c = txtToInt(line[4], mapping);
      String operator = line[1];

      if (calculate(a.toDouble(), b.toDouble(), operator) == c.toDouble()) {
        solutions.add(perm);
      }
    } catch (e) {
      continue;
    }
  }

  return solutions;
}

void solveSymbolism() {
  List<List<int>> solutions = generatePermutations(numbers);

  for (int i = 0; i < raetsel.length; i++) {
    print("Prüfe Formel ${i + 1}...");
    solutions = reduceSolutions(solutions, i);
    if (solutions.isEmpty) {
      print("Keine Lösung gefunden!");
      return;
    }
  }

  for (var solution in solutions) {
    print(Map.fromIterables(letters.split(''), solution));
  }
}

// **Optimierte Permutationsberechnung mit Heap’s Algorithmus**
List<List<int>> generatePermutations(List<int> list) {
  List<List<int>> result = [];

  void heapPermutation(int n, List<int> arr) {
    if (n == 1) {
      result.add(List.from(arr));
      return;
    }
    for (int i = 0; i < n; i++) {
      heapPermutation(n - 1, arr);
      if (n % 2 == 1) {
        arr.swap(0, n - 1); // Wenn n ungerade ist, tausche erstes und letztes Element
      } else {
        arr.swap(i, n - 1); // Wenn n gerade ist, tausche i-tes und letztes Element
      }
    }
  }

  heapPermutation(list.length, List.from(list));
  return result;
}

// Hilfsfunktion zum Tauschen von Elementen in einer Liste
extension Swap<T> on List<T> {
  void swap(int i, int j) {
    T temp = this[i];
    this[i] = this[j];
    this[j] = temp;
  }
}

void main() {
  var startTime = DateTime.now();
  solveSymbolism();
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
}