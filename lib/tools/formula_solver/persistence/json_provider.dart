import 'dart:convert';

import 'package:gc_wizard/application/settings/logic/preferences.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/utils/persistence_utils.dart';
import 'package:prefs/prefs.dart';

void refreshFormulas() {
  var formulas = Prefs.getStringList(PREFERENCE_FORMULASOLVER_FORMULAS);
  if (formulas == null || formulas.length == 0) return;

  formulaGroups = formulas.where((group) => group.length > 0).map((group) {
    return FormulaGroup.fromJson(jsonDecode(group));
  }).toList();
}

_saveData() {
  var jsonData = formulaGroups.map((group) => jsonEncode(group.toMap())).toList();

  Prefs.setStringList(PREFERENCE_FORMULASOLVER_FORMULAS, jsonData);
}

int insertGroup(FormulaGroup group) {
  group.name = group.name ?? '';
  var id = newID(formulaGroups.map((group) => group.id).toList());
  group.id = id;
  formulaGroups.add(group);

  _saveData();

  return id;
}

void updateFormulaGroups() {
  _saveData();
}

void deleteGroup(int groupId) {
  formulaGroups.removeWhere((group) => group.id == groupId);

  _saveData();
}

void _updateFormulaGroup(FormulaGroup group) {
  formulaGroups = formulaGroups.map((formulaGroup) {
    if (formulaGroup.id == group.id) return group;

    return formulaGroup;
  }).toList();
}

int insertFormula(Formula formula, FormulaGroup group) {
  var id = newID(group.formulas.map((formula) => formula.id).toList());
  formula.id = id;
  group.formulas.add(formula);

  _updateFormulaGroup(group);
  _saveData();

  return id;
}

void updateFormula(Formula formula, FormulaGroup group) {
  group.formulas = group.formulas.map((groupFormula) {
    if (groupFormula.id == formula.id) return formula;

    return groupFormula;
  }).toList();

  _updateFormulaGroup(group);
  _saveData();
}

int insertFormulaValue(FormulaValue formulaValue, FormulaGroup group) {
  var id = newID(group.values.map((value) => value.id).toList());
  formulaValue.id = id;
  group.values.add(formulaValue);

  _updateFormulaGroup(group);
  _saveData();

  return id;
}

void updateFormulaValue(FormulaValue formulaValue, FormulaGroup group) {
  group.values = group.values.map((value) {
    if (value.id == formulaValue.id) return formulaValue;

    return value;
  }).toList();

  _updateFormulaGroup(group);
  _saveData();
}

void deleteFormula(int formulaId, FormulaGroup group) {
  group.formulas.removeWhere((formula) => formula.id == formulaId);

  _updateFormulaGroup(group);
  _saveData();
}

void deleteFormulaValue(int formulaValueId, FormulaGroup group) {
  group.values.removeWhere((value) => value.id == formulaValueId);

  _updateFormulaGroup(group);
  _saveData();
}
