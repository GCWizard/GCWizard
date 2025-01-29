// // Function to replace letters with digits
// String replaceLetters(String equation, Map<String, int> letterMap) {
//   letterMap.forEach((letter, digit) {
//     equation = equation.replaceAll(letter, digit.toString());
//   });
//   return equation;
// }

// // Function to check if the current assignment satisfies all equations
// bool checkEquations(List<String> equations, Map<String, int> letterMap) {
//   for (String equation in equations) {
//     List<String> sides = equation.split('=');
//     String leftSide = replaceLetters(sides[0], letterMap);
//     String rightSide = replaceLetters(sides[1], letterMap);
//
//     try {
//       // Check if the equation holds true
//       if (evaluateExpression(leftSide) != evaluateExpression(rightSide)) {
//         return false;
//       }
//     } catch (e) {
//       return false;
//     }
//   }
//   return true;
// }

// // Helper function to evaluate arithmetic expressions
// int evaluateExpression(String expr) {
//   expr = expr.replaceAll(' ', '');
//
//   // Evaluate the expression with basic arithmetic (+, -, *, /)
//   try {
//     return eval(expr);
//   } catch (e) {
//     throw Exception("Invalid expression");
//   }
// }
//
// // Simple arithmetic evaluator (can be extended)
// int eval(String expr) {
//   List<String> operators = ['+', '-', '*', '/'];
//   for (String operator in operators) {
//     if (expr.contains(operator)) {
//       List<String> parts = expr.split(operator);
//       int left = eval(parts[0]);
//       int right = eval(parts[1]);
//       switch (operator) {
//         case '+':
//           return left + right;
//         case '-':
//           return left - right;
//         case '*':
//           return left * right;
//         case '/':
//           return (right != 0) ? left ~/ right : throw Exception('Division by zero');
//       }
//     }
//   }
//   return int.parse(expr); // Base case: return the number itself
// }

// Function to check if any assigned letter represents a number with leading zeros
bool hasLeadingZeros(Map<String, int> letterMap, List<String> equations) {
  for (String equation in equations) {
    List<String> sides = equation.split('=');
    String leftSide = replaceLetters(sides[0], letterMap);
    String rightSide = replaceLetters(sides[1], letterMap);

    // Check if any number has leading zeros
    List<String> terms = [...leftSide.split(RegExp(r'[+*/=-]')), ...rightSide.split(RegExp(r'[+*/=-]'))];
    for (String term in terms) {
      if (term.length > 1 && term[0] == '0') {
        return true; // Invalid assignment due to leading zero
      }
    }
  }
  return false;
}

// Optimized Backtracking approach with constraints on leading zeros and division validity
bool solveSymbolismPuzzleBacktracking(
    List<String> equations, List<String> letters, Map<String, int> letterMap, Set<int> usedDigits) {
  if (letterMap.length == letters.length) {
    // All letters are assigned, check equations
    if (checkEquations(equations, letterMap) && !hasLeadingZeros(letterMap, equations)) {
      return true;
    }
    return false;
  }

  // Get the next unassigned letter
  String nextLetter = letters[letterMap.length];

  for (int digit = 0; digit <= 9; digit++) {
    if (usedDigits.contains(digit)) continue; // Skip if digit is already used

    letterMap[nextLetter] = digit;
    usedDigits.add(digit);

    // Continue with the next letter
    if (solveSymbolismPuzzleBacktracking(equations, letters, letterMap, usedDigits)) {
      return true;
    }

    // Backtrack
    letterMap.remove(nextLetter);
    usedDigits.remove(digit);
  }

  return false;
}

// Wrapper function for backtracking with leading zeros check
Map<String, int>? solveSymbolismPuzzle(List<String> equations, List<String> letters) {
  Map<String, int> letterMap = {};
  Set<int> usedDigits = {};

  // Sort equations to prioritize harder ones (e.g., with division/multiplication)
  equations.sort((a, b) => b.length.compareTo(a.length)); // Longer equations first

  if (solveSymbolismPuzzleBacktracking(equations, letters, letterMap, usedDigits)) {
    return letterMap;
  }
  return null;
}

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
          if (right == 0 || left % right != 0) return throw Exception('Invalid division');
          return left ~/ right;
      }
    }
  }
  return int.parse(expr); // Base case: return the number itself
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
