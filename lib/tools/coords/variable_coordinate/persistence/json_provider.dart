import 'dart:convert';

import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/coords/variable_coordinate/persistence/model.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart' as formula_model;
import 'package:gc_wizard/utils/complex_return_types.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/persistence_utils.dart';
import 'package:prefs/prefs.dart';

void refreshFormulas() {
  var formulasList = Prefs.getStringList(PREFERENCE_COORD_VARIABLECOORDINATE_FORMULAS);
  if (formulasList.isEmpty) return;

  formulas = formulasList.where((formula) => formula.isNotEmpty).map((formula) {
    return VariableCoordinateFormula.fromJson(asJsonMap(jsonDecode(formula)));
  }).toList();
}

void _saveData() {
  var jsonData = formulas.map((formula) => jsonEncode(formula.toMap())).toList();
  Prefs.setStringList(PREFERENCE_COORD_VARIABLECOORDINATE_FORMULAS, jsonData);
}

void updateFormulas() {
  _saveData();
}

int insertFormula(VariableCoordinateFormula formula) {
  var id = newID(formulas.map((formula) => formula.id).toList());
  formula.id = id;
  formulas.add(formula);

  _saveData();

  return id;
}

void updateFormula(VariableCoordinateFormula formula) {
  _updateFormula(formula);
  _saveData();
}

void deleteFormula(int formulaId) {
  formulas.removeWhere((formula) => formula.id == formulaId);

  _saveData();
}

void _updateFormula(VariableCoordinateFormula formula) {
  formulas = formulas.map((f) {
    if (f.id == formula.id) return formula;

    return f;
  }).toList();
}

int insertFormulaValue(formula_model.FormulaValue formulaValue, VariableCoordinateFormula formula) {
  var id = newID(formula.values.map((value) => value.id as int?).toList());
  formulaValue.id = id;
  formula.values.add(formulaValue);

  updateFormula(formula);

  return id;
}

void updateFormulaValue(KeyValueBase formulaValue, VariableCoordinateFormula formula) {
  updateFormula(formula);
}
