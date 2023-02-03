List<FormulaGroup> formulaGroups = [];

class FormulaGroup {
  int id;
  String name;
  List<Formula> formulas = [];
  List<FormulaValue> values = [];

  FormulaGroup(this.name);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'formulas': formulas.map((formula) => formula.toMap()).toList(),
        'values': values.map((value) => value.toMap()).toList(),
      };

  FormulaGroup.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        formulas = List<Formula>.from(json['formulas'].map((formula) => Formula.fromJson(formula))),
        values = List<FormulaValue>.from(json['values'].map((value) => FormulaValue.fromJson(value)));

  @override
  String toString() {
    return toMap().toString();
  }
}

class Formula {
  int id;
  String formula;
  String name;

  Formula(this.formula);

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'formula': formula,
    };

    if (name != null && name.isNotEmpty) map.putIfAbsent('name', () => name);

    return map;
  }

  Formula.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        formula = json['formula'],
        name = json['name'];

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

FormulaValueType _readType(String jsonType) {
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
  int id;
  String key;
  String value;
  FormulaValueType type;

  FormulaValue(this.key, this.value, {this.type});

  FormulaValue.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        value = json['value'],
        type = _readType(json['type']);

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'key': key,
      'value': value,
    };

    var mapType;
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
