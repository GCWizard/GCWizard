import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

// Definition des Wertebereichs für die Variablen (kann angepasst werden)
const int minVal = 1;
const int maxVal = 9;

// Formel Parser
Parser p = Parser();

// Berechnet den Wert des Ausdrucks mit den angegebenen Variablenwerten
int? evaluateExpression(String formula, Map<String, int> variables) {
  Expression exp = p.parse(formula);
  ContextModel cm = ContextModel();

  variables.forEach((varName, value) {
    cm.bindVariable(Variable(varName), Number(value));
  });

  return (exp.evaluate(EvaluationType.REAL, cm) as int?)?.toInt();
}

// Testet, ob alle Formeln für die aktuelle Variablenbelegung erfüllt sind
bool checkAllFormulas(List<String> formulas, Map<String, int> variables) {
  for (var formula in formulas) {
    List<String> parts = formula.split('=');
    String expr = parts[0].trim();
    int expected = int.parse(parts[1].trim());

    var result = evaluateExpression(expr, variables);
    if (result != expected) {
      return false; // Eine der Formeln wurde nicht erfüllt
    }
  }
  return true; // Alle Formeln wurden erfüllt
}

// Hilfsfunktion zur Anzeige des Fortschritts
void showProgress(int current, int total) {
  double progress = (current / total) * 100;
  print('Fortschritt: ${progress.toStringAsFixed(2)}%');
}

// Rekursive Funktion zur Durchprobierung aller Kombinationen
bool tryCombinations(
    List<String> variables, List<String> formulas, Map<String, int> currentValues, int index, int totalCombinations, int currentCombination) {
  // Basisfall: Wenn wir alle Variablen belegt haben, prüfen wir die Formeln
  if (index == variables.length) {
    // Fortschrittsanzeige
    if (currentCombination % 1000 == 0) {
      showProgress(currentCombination, totalCombinations);
    }

    // Überprüfe, ob die aktuelle Variablenkombination alle Formeln erfüllt
    if (checkAllFormulas(formulas, currentValues)) {
      print('Lösung gefunden: $currentValues');
      return true; // Lösung gefunden
    }

    return false; // Keine Lösung, weiter mit anderen Kombinationen
  }

  // Aktuelle Variable
  String variable = variables[index];

  // Probiere alle möglichen Werte für die aktuelle Variable
  for (int value = minVal; value <= maxVal; value++) {
    currentValues[variable] = value;
    if (tryCombinations(variables, formulas, currentValues, index + 1, totalCombinations, currentCombination + 1)) {
      return true; // Wenn Lösung gefunden, sofort abbrechen
    }
  }

  return false; // Keine Lösung in dieser Kombination
}

// Hauptfunktion zur Lösung des Cryptogramms
void solveCryptogram(List<String> formulas) {
  // Alle eindeutigen Variablen aus den Formeln extrahieren
  Set<String> variablesSet = {};
  RegExp regex = RegExp(r'[A-Z]');
  for (var formula in formulas) {
    variablesSet.addAll(regex.allMatches(formula).map((m) => m.group(0)!));
  }
  List<String> variables = variablesSet.toList();

  print('Gefundene Variablen: $variables');

  // Anzahl der möglichen Kombinationen berechnen
  int varCount = variables.length;
  int totalCombinations = pow((maxVal - minVal + 1), varCount).toInt();

  print('Gesamtzahl der Kombinationen: $totalCombinations');

  // Rekursives Durchprobieren aller Kombinationen
  Map<String, int> currentValues = {}; // Leere Belegung der Variablen
  bool result = tryCombinations(variables, formulas, currentValues, 0, totalCombinations, 0);

  if (!result) {
    print('Keine Lösung gefunden.');
  }
}

void main() {
  // Beispiel-Formeln (Formeln können geändert werden)
  List<String> formulas = [
    'B+A*C+C*A-D=65',
    'E-D+C*A+A-C=27',
    'A*E+C*B-E*B=53',
    'A*B+C-D*A-E=41',
    'B*C+C-F+E*A=77',
    'E*F+C-D+C*A=37',
    'B+F*E*A-D+C=24',
    'D*B+E+C*A+F=31',
  ];

  solveCryptogram(formulas);
}
