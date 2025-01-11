import 'package:math_expressions/math_expressions.dart';

void main() {
  // Die Formeln als Strings
  List<String> formeln = [
    "B + A * C + C * A - D = 65",
    "E - D + C * A + A - C = 27",
    "A * E + C * B - E * B = 53",
    "A * B + C - D * A - E = 41",
    "B * C + C - F + E * A = 77",
    "E * F + C - D + C * A = 37",
    "B + F * E * A - D + C = 24",
    "D * B + E + C * A + F = 31"
  ];

  // Die Variablen A bis F
  List<String> variablen = ['A', 'B', 'C', 'D', 'E', 'F'];

  // Der Wertebereich der Variablen, hier von 1 bis 10
  List<int> werteBereich = List.generate(10, (i) => i + 1);

  // Alle Kombinationen durchgehen
  var loesung = solve(formeln, variablen, werteBereich);

  if (loesung != null) {
    print("Lösung gefunden: $loesung");
    // Setze die Werte in die Formeln ein und prüfe die Korrektheit
    for (var i = 0; i < formeln.length; i++) {
      var formel = formeln[i];
      var korrekt = pruefeFormel(formel, loesung);
      print("Formel ${i + 1}: ${korrekt ? "Korrekt" : "Fehler"}");
    }
  } else {
    print("Keine Lösung gefunden.");
  }
}

// Funktion zum Auswerten einer Formel
bool pruefeFormel(String formel, Map<String, int> werte) {
  // Formel in die linke und rechte Seite aufteilen
  var teile = formel.split('=');
  if (teile.length != 2) return false;

  String linkeSeite = teile[0];
  String rechteSeite = teile[1];

  // Parser für math_expressions
  var parser = Parser();
  var expressionLinks = parser.parse(linkeSeite);
  var expressionRechts = parser.parse(rechteSeite);

  // Kontext der Variablen füllen
  var context = <String, Variable>{};
  for (var entry in werte.entries) {
    context[entry.key] = Variable(entry.key);
  }

  // Variable values in den Kontext setzen
  var contextValues = <String, double>{};
  for (var entry in werte.entries) {
    contextValues[entry.key] = entry.value.toDouble();
  }

  // Prüfe, ob die Variablen in den Formeln gesetzt wurden
  var evaluator = ContextModel();
  contextValues.forEach((String key, double value) {
    evaluator.bindVariable(Variable(key), Number(value));
  });
  //evaluator.bindAll(contextValues);

  // Werte berechnen
  var links = expressionLinks.evaluate(EvaluationType.REAL, evaluator);
  var rechts = expressionRechts.evaluate(EvaluationType.REAL, evaluator);

  // Die Formel sollte links und rechts gleich sein
  return links == rechts;
}

// Methode zur Lösung der Gleichungen
Map<String, int>? solve(List<String> formeln, List<String> variablen, List<int> werteBereich) {
  var n = variablen.length;
  var werte = <String, int>{};

  bool pruefeFormeln() {
    for (var formel in formeln) {
      if (!pruefeFormel(formel, werte)) return false;
    }
    return true;
  }

  bool sucheLoesung(int index) {
    if (index == n) {
      // Alle Variablen wurden zugewiesen, prüfe die Formeln
      return pruefeFormeln();
    }

    String variable = variablen[index];
    for (var wert in werteBereich) {
      werte[variable] = wert;

      // Frühzeitige Beendigung, wenn eine Formel nicht passt
      if (index >= formeln.length || pruefeFormel(formeln[index], werte)) {
        if (sucheLoesung(index + 1)) return true;
      }
    }
    return false;
  }

  if (sucheLoesung(0)) {
    return werte;
  }
  return null;
}
