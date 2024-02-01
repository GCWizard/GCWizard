import 'dart:convert';

import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/utils/json_utils.dart';
import 'package:gc_wizard/utils/persistence_utils.dart';
import 'package:prefs/prefs.dart';

void refreshFormulas() {
  var formulas = Prefs.getStringList(PREFERENCE_FORMULASOLVER_FORMULAS);
  if (formulas.isEmpty) {
    formulaGroups = [];
    return;
  }

  formulaGroups = formulas.where((group) => group.isNotEmpty).map((group) {
    return FormulaGroup.fromJson(asJsonMap(jsonDecode(group)));
  }).toList();
}

void _saveData() {
  var jsonData = formulaGroups.map((group) => jsonEncode(group.toMap())).toList();

  Prefs.setStringList(PREFERENCE_FORMULASOLVER_FORMULAS, jsonData);
}

int insertGroup(FormulaGroup group) {
  group.name = group.name;
  var id = newID(formulaGroups.map((group) => group.id).toList());
  group.id = id;
  formulaGroups.add(group);

  _saveData();

  return id;
}

void updateFormulaGroups() {
  _saveData();
}

int insertFormula(Formula formula, FormulaGroup group) {
  var id = newID(group.formulas.map((formula) => formula.id).toList());
  formula.id = id;
  group.formulas.add(formula);

  updateAndSave(group);

  return id;
}

void updateFormula(Formula formula, FormulaGroup group) {
  group.formulas = group.formulas.map((groupFormula) {
    if (formula.id == null || groupFormula.id == null) {
      throw Exception('Formula id not found');
    }

    if (groupFormula.id == formula.id) return formula;

    return groupFormula;
  }).toList();

  updateAndSave(group);
}

int insertFormulaValue(FormulaValue formulaValue, FormulaGroup group) {
  var id = newID(group.values.map((value) => (value.id as int?)).toList());
  formulaValue.id = id;
  group.values.add(formulaValue);
  updateAndSave(group);
  return id;
}

void updateFormulaValue(FormulaValue formulaValue, FormulaGroup group) {
  group.values = group.values.map((value) {
    if (value.id == null || formulaValue.id == null) {
      throw Exception('Formula value id not found');
    }

    if (value.id == formulaValue.id) return formulaValue;

    return value;
  }).toList();

  updateAndSave(group);
}

void deleteFormula(int? formulaId, FormulaGroup group) {
  if (formulaId == null) {
    throw Exception('Formula id not found');
  }

  if (group.id == null) {
    throw Exception('Formula group id not found');
  }

  group.formulas.removeWhere((formula) => formula.id == formulaId);

  updateAndSave(group);
}

void updateAndSave(FormulaGroup group) {
  _saveData();
}
