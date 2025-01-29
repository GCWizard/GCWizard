import 'dart:math';

// Function to replace letters with digits
String replaceLetters(String equation, Map<String, int> letterMap) {
  letterMap.forEach((letter, digit) {
    equation = equation.replaceAll(letter, digit.toString());
  });
  return equation;
}

// Function to check if the current assignment satisfies all equations
bool checkEquations(List<String> equations, Map<String, int> letterMap) {
  for (String equation in equations) {
    List<String> sides = equation.split('=');
    String leftSide = replaceLetters(sides[0], letterMap);
    String rightSide = replaceLetters(sides[1], letterMap);

    try {
      // Check if the equation holds true
      if (evaluateExpression(leftSide) != evaluateExpression(rightSide)) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  return true;
}

// Helper function to evaluate arithmetic expressions
int evaluateExpression(String expr) {
  expr = expr.replaceAll(' ', '');

  // Evaluate the expression with basic arithmetic (+, -, *, /)
  try {
    return eval(expr);
  } catch (e) {
    throw Exception("Invalid expression");
  }
}

// Simple arithmetic evaluator (can be extended)
int eval(String expr) {
  List<String> operators = ['+', '-', '*', '/'];
  for (String operator in operators) {
    if (expr.contains(operator)) {
      List<String> parts = expr.split(operator);
      int left = eval(parts[0]);
      int right = eval(parts[1]);
      switch (operator) {
        case '+':
          return left + right;
        case '-':
          return left - right;
        case '*':
          return left * right;
        case '/':
          return (right != 0) ? left ~/ right : throw Exception('Division by zero');
      }
    }
  }
  return int.parse(expr); // Base case: return the number itself
}

// Function to sort equations by complexity (simplest first)
List<String> sortEquationsByComplexity(List<String> equations) {
  equations.sort((a, b) {
    // Sort by number of unique letters (fewer letters = simpler equation)
    Set<String> lettersA = a.replaceAll(RegExp(r'[^A-Za-z]'), '').split('').toSet();
    Set<String> lettersB = b.replaceAll(RegExp(r'[^A-Za-z]'), '').split('').toSet();
    return lettersA.length.compareTo(lettersB.length);
  });
  return equations;
}

// Optimized Branch and Bound approach to solving the puzzle
Map<String, int>? solveSymbolismPuzzle(List<String> equations, List<String> letters) {
  equations = sortEquationsByComplexity(equations); // Sort equations by complexity
  List<int> allDigits = List.generate(10, (i) => i); // Digits 0-9

  for (List<int> perm in generatePermutations(allDigits, letters.length)) {
    Map<String, int> letterMap = Map.fromIterables(letters, perm);
    if (checkEquations(equations, letterMap)) {
      return letterMap;
    }
  }
  return null;
}

// Function to generate permutations
Iterable<List<T>> generatePermutations<T>(List<T> list, int length) sync* {
  if (length == 0) {
    yield [];
  } else {
    for (int i = 0; i < list.length; i++) {
      List<T> remaining = List.from(list)..removeAt(i);
      for (List<T> perm in generatePermutations(remaining, length - 1)) {
        yield [list[i], ...perm];
      }
    }
  }
}

void main() {
  // Example 1 puzzle
  List<String> equations1 = [
    "ABCB+DEAF=GFFB",
    "AEEF+AHG=AGIG",
    "EBB*AH=HGCF",
    "ABCB-AEEF=EBB",
    "DEAF/AHG=AH",
    "GFFB+AGIG=HGCF"
  ];
  List<String> letters1 = "ABCDEFGHIG".split('');

  // Example 2 puzzle
  List<String> equations2 = [
    "GJ*DJ=LBAC",
    "BJKD+BCCK=DJKB",
    "BJLH-GF=BHJL",
    "BJKD-GJ=BJLH",
    "BCCK/DJ=GF",
    "DJKB-LBAC=BHJL"
  ];
  List<String> letters2 = "GJDKBCFLHA".split('');

  var startTime = DateTime.now();
  // Solve example 1
  Map<String, int>? solution1 = solveSymbolismPuzzle(equations1, letters1);
  print("Solution for Example 1: $solution1");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

   startTime = DateTime.now();
  // Solve example 2
  Map<String, int>? solution2 = solveSymbolismPuzzle(equations2, letters2);
  print("Solution for Example 2: $solution2");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
}
// Solution for Example 1: {A: 1, B: 6, C: 9, D: 2, E: 3, F: 0, G: 4, H: 5, I: 8}
// 2532ms
// Solution for Example 2: {G: 5, J: 7, D: 3, K: 8, B: 1, C: 9, F: 4, L: 2, H: 6, A: 0}
// 8365ms