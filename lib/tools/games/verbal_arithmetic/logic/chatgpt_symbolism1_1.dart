import 'dart:math';

import 'package:math_expressions/math_expressions.dart';

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
  // Remove all whitespaces for cleaner processing
  expr = expr.replaceAll(' ', '');

  // Simple logic to evaluate +, -, *, and / operations
  // Ideally, use a proper parser library to handle complex expressions
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

// Branch and Bound approach to solving the puzzle
Map<String, int>? solveSymbolismPuzzle(List<String> equations, List<String> letters) {
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
  // Beispiel 1 Rätsel
  List<String> gleichungen1 = [
    "ABCB+DEAF=GFFB",
    "AEEF+AHG=AGIG",
    "EBB*AH=HGCF",
    "ABCB-AEEF=EBB",
    "DEAF/AHG=AH",
    "GFFB+AGIG=HGCF"
  ];
  List<String> buchstaben1 = "ABCDEFGHIG".split('');

  // Beispiel 2 Rätsel
  List<String> gleichungen2 = [
    "GJ*DJ=LBAC",
    "BJKD+BCCK=DJKB",
    "BJLH-GF=BHJL",
    "BJKD-GJ=BJLH",
    "BCCK/DJ=GF",
    "DJKB-LBAC=BHJL"
  ];
  List<String> buchstaben2 = "GJDKBCFLHA".split('');

  var startTime = DateTime.now();
  // Löse das Beispiel 1
  Map<String, int>? loesung1 = solveSymbolismPuzzle(gleichungen1, buchstaben1);
  print("Lösung für Beispiel 1: $loesung1");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');

   startTime = DateTime.now();
  // Löse das Beispiel 2
  Map<String, int>? loesung2 = solveSymbolismPuzzle(gleichungen2, buchstaben2);
  print("Lösung für Beispiel 2: $loesung2");
  print(DateTime.now().difference(startTime).inMilliseconds.toString() + 'ms');
}

// Lösung für Beispiel 1: {A: 1, B: 6, C: 9, D: 2, E: 3, F: 0, G: 4, H: 5, I: 8}
// 2398ms
// Lösung für Beispiel 2: {G: 5, J: 7, D: 3, K: 8, B: 1, C: 9, F: 4, L: 2, H: 6, A: 0}
// 6811ms