import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';

List<FormulaGroup> formulaGroups = [];

class FormulaGroup {
  int? id;
  late String name;
  List<Formula> formulas = [];
  List<FormulaValue> values = [];

  FormulaGroup(this.name);

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'formulas': formulas.map((formula) => formula.toMap()).toList(),
        'values': values.map((value) => value.toMap()).toList(),
      };

  FormulaGroup.fromJson(Map<String, Object?> json) {
    name = toStringOrNull(json['name']) ?? ''; // TODO Proper default types if key is not in map
    id = toIntOrNull(json['id']);

    var formulasRaw = toObjectWithNullableContentListOrNull(json['formulas']);
    formulas = <Formula>[];
    if (formulasRaw != null) {
      for (var element in formulasRaw) {
        var formula = asJsonMapOrNull(element);
        if (formula == null) continue;

        formulas.add(Formula.fromJson(formula));
      }
    }

    var valuesRaw = toObjectWithNullableContentListOrNull(json['values']);
    values = <FormulaValue>[];
    if (valuesRaw != null) {
      for (var element in valuesRaw) {
        var value = asJsonMapOrNull(element);
        if (value == null) continue;

        values.add(FormulaValue.fromJson(value));
      }
    }
  }


  @override
  String toString() {
    return toMap().toString();
  }
}

class Formula {
  int? id;
  String formula;
  String? name;

  Formula(this.formula);

  Map<String, Object?> toMap() {
    var map = {
      'id': id,
      'formula': formula,
    };

    if (name != null && name!.isNotEmpty) map.putIfAbsent('name', () => name);

    return map;
  }

  Formula.fromJson(Map<String, Object?> json)
      : id = toIntOrNull(json['id']),
        formula = toStringOrNull(json['formula']) ?? '', // TODO Proper default types if key is not in map
        name = toStringOrNull(json['name']) ?? '';

  static Formula fromFormula(Formula formula) {
    var newFormula = Formula(formula.formula);
    newFormula.id = formula.id;
    newFormula.name = formula.name;
    return newFormula;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

enum FormulaValueType { FIXED, INTERPOLATED, TEXT }

const _FORMULAVALUETYPE_INTERPOLATE = 'interpolate';
const _FORMULAVALUETYPE_TEXT = 'text';

FormulaValueType _readType(String? jsonType) {
  switch (jsonType) {
    case _FORMULAVALUETYPE_INTERPOLATE:
      return FormulaValueType.INTERPOLATED;
    case _FORMULAVALUETYPE_TEXT:
      return FormulaValueType.TEXT;
    default:
      return FormulaValueType.FIXED;
  }
}

class FormulaValue {
  int? id;
  String key;
  String value;
  FormulaValueType? type;

  FormulaValue(this.key, this.value, {this.type});
  
  FormulaValue.fromJson(Map<String, Object?> json)
      : id = toIntOrNull(json['id']),
        key = toStringOrNull(json['key']) ?? '',  // TODO Proper default types if key is not in map
        value = toStringOrNull(json['value']) ?? '',
        type = _readType(json['type'] as String?);

  Map<String, Object?> toMap() {
    var map = {
      'id': id,
      'key': key,
      'value': value,
    };

    String? mapType;
    switch (type) {
      case FormulaValueType.INTERPOLATED:
        mapType = _FORMULAVALUETYPE_INTERPOLATE;
        break;
      case FormulaValueType.TEXT:
        mapType = _FORMULAVALUETYPE_TEXT;
        break;
      default:
        break;
    }
    if (mapType != null) map.putIfAbsent('type', () => mapType);

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
