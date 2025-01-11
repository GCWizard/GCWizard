
class CryptogramSolver {
  // Die Liste der Formeln
  final List<String> equations;

  CryptogramSolver(this.equations);

  // Funktion, um alle möglichen Kombinationen der Buchstaben zu durchlaufen
  bool solve(Map<String, int> variableValues) {
    // Überprüfe, ob alle Formeln gültig sind
    for (var equation in equations) {
      if (!_isValidEquation(equation, variableValues)) {
        return false;
      }
    }
    return true;
  }

  // Prüft, ob eine gegebene Formel gültig ist
  bool _isValidEquation(String equation, Map<String, int> variableValues) {
    try {
      // Ersetze alle Buchstaben durch ihre entsprechenden Zahlen
      equation = equation.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
        String varName = match.group(0)!;
        return variableValues[varName]?.toString() ?? '0'; // Rückgabe des Werts oder 0, wenn nicht gesetzt
      });

      // Evaluierung der Formel als mathematischen Ausdruck
      return _evaluateExpression(equation);
    } catch (e) {
      return false; // Bei Fehlern (z.B. ungültige Formel) zurückgeben, dass die Formel ungültig ist
    }
  }

  // Diese Methode evaluiert einen mathematischen Ausdruck als String
  bool _evaluateExpression(String expression) {
    try {
      // Berechne das Ergebnis des Ausdrucks
      var result = _calculateExpression(expression);
      return result != 0; //null;
    } catch (e) {
      return false;
    }
  }

  // Berechnet den Wert der mathematischen Expression (einfacher Parser)
  int _calculateExpression(String expression) {
    // Entferne Leerzeichen und bereite den Ausdruck vor
    expression = expression.replaceAll(' ', '');

    // Dart hat keine eingebaute eval-Funktion, also müssen wir den Ausdruck selbst auswerten
    return _evaluateMathExpression(expression);
  }

  // Einfacher Parser, der grundlegende Rechenoperationen unterstützt
  int _evaluateMathExpression(String expression) {
    List<String> tokens = _tokenize(expression);
    return _parse(tokens);
  }

  // Tokenisierung des Ausdrucks
  List<String> _tokenize(String expression) {
    var regExp = RegExp(r'(\d+|\+|\-|\*|\/|\(|\))');
    return regExp.allMatches(expression).map((match) => match.group(0)!).toList();
  }

  // Ein sehr einfacher Evaluator, der nicht perfekt, aber funktional für den ersten Fall ist.
  int _parse(List<String> tokens) {
    var values = <int>[];
    var operators = <String>[];

    int precedence(String op) {
      if (op == '+' || op == '-') return 1;
      if (op == '*' || op == '/') return 2;
      return 0;
    }

    int applyOperator(int a, int b, String op) {
      if (op == '+') return a + b;
      if (op == '-') return a - b;
      if (op == '*') return a * b;
      if (op == '/') return a ~/ b;
      return 0;
    }

    for (var token in tokens) {
      if (RegExp(r'\d').hasMatch(token)) {
        values.add(int.parse(token));
      } else if (token == '(') {
        operators.add(token);
      } else if (token == ')') {
        while (operators.isNotEmpty && operators.last != '(') {
          var op = operators.removeLast();
          var b = values.removeLast();
          var a = values.removeLast();
          values.add(applyOperator(a, b, op));
        }
        operators.removeLast();
      } else if ('+-*/'.contains(token)) {
        while (operators.isNotEmpty &&
            precedence(operators.last) >= precedence(token)) {
          var op = operators.removeLast();
          var b = values.removeLast();
          var a = values.removeLast();
          values.add(applyOperator(a, b, op));
        }
        operators.add(token);
      }
    }

    while (operators.isNotEmpty) {
      var op = operators.removeLast();
      var b = values.removeLast();
      var a = values.removeLast();
      values.add(applyOperator(a, b, op));
    }

    return values.last;
  }

  // Funktion, um alle Variablen zu durchlaufen und mögliche Werte zu setzen
  bool _findSolution(Map<String, int> variableValues, List<String> variables) {
    // Wenn alle Variablen gesetzt wurden, überprüfen wir, ob die Lösung gültig ist
    if (variableValues.length == variables.length) {
      return solve(variableValues);
    }

    // Gehe die Variablen durch und versuche, ihnen Werte zuzuweisen
    for (var variable in variables) {
      // Teste alle möglichen Werte für diese Variable (hier zum Beispiel Werte von 0 bis 9)
      for (var value in List.generate(10, (i) => i)) {
        if (!variableValues.containsKey(variable)) {
          // Sicherstellen, dass jede Variable einen anderen Wert erhält
          if (variableValues.containsValue(value)) {
            continue; // Wenn der Wert bereits verwendet wurde, überspringen
          }

          // Setze den Wert und teste weiter
          variableValues[variable] = value;
          if (_findSolution(variableValues, variables)) {
            return true; // Wenn die Lösung gefunden wurde, geben wir `true` zurück
          }
          // Wenn der Wert nicht zu einer Lösung führt, entfernen wir ihn (Backtracking)
          variableValues.remove(variable);
        }
      }
    }
    return false; // Wenn keine Lösung gefunden wurde
  }

  // Der Einstiegspunkt zum Lösen des Cryptogramms
  Map<String, int> solveCryptogram() {
    // Alle möglichen Variablen extrahieren
    Set<String> variables = {};
    for (var equation in equations) {
      var matches = RegExp(r'[A-Z]').allMatches(equation);
      for (var match in matches) {
        variables.add(match.group(0)!);
      }
    }

    Map<String, int> variableValues = {};
    if (_findSolution(variableValues, variables.toList())) {
      return variableValues; // Lösung gefunden
    } else {
      return {}; // Keine Lösung gefunden
    }
  }
}

void main() {
  var equations = [
    'B+A*C+C*A-D=65',
    'E-D+C*A+A-C=27',
    'A*E+C*B-E*B=53',
    'A*B+C-D*A-E=41',
    'B*C+C-F+E*A=77',
    'E*F+C-D+C*A=37',
    'B+F*E*A-D+C=24',
    'D*B+E+C*A+F=31'
  ];

  var equations1 = [
    'E+F*C+B+C+F=26'
        'B+A*C+C*A-D=65'
        'E-D+C*A+A-C=27'
        'A*E+C*B-E*B=53'
        'A*B+C-D*A-E=41'
        'B*C+C-F+E*A=77'
        'E*F+C-D+C*A=37'
        'B+F*E*A-D+C=24'
        'D*B+E+C*A+F=31'
  ];

  var solver = CryptogramSolver(equations);
  var solution = solver.solveCryptogram();

  if (solution.isNotEmpty) {
    print('Solution found:');
    solution.forEach((key, value) {
      print('$key = $value');
    });
  } else {
    print('No solution found.');
  }
}
