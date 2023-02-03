import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';

List<Formula> formulas = [];

class ProjectionFormula {
  String distance;
  String distanceUnit;
  String bearing;
  bool reverse;

  ProjectionFormula(this.distance, this.distanceUnit, this.bearing, this.reverse);

  Map<String, dynamic> toMap() => {
        'distance': distance,
        'distanceUnit': distanceUnit,
        'bearing': bearing,
        'reverse': reverse,
      };

  ProjectionFormula.fromJson(Map<String, dynamic> json)
      : distance = json['distance'],
        distanceUnit = json['distanceUnit'],
        bearing = json['bearing'],
        reverse = json['reverse'];

  @override
  String toString() {
    return toMap().toString();
  }
}

class Formula {
  int id;
  String name;
  String formula;
  ProjectionFormula projection;
  List<FormulaValue> values = [];

  Formula(this.name);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'formula': formula,
        'projection': projection == null ? {} : projection.toMap(),
        'values': values.map((value) => value.toMap()).toList(),
      };

  Formula.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        formula = json['formula'],
        projection = ProjectionFormula.fromJson(json['projection']),
        values = List<FormulaValue>.from(json['values'].map((value) => FormulaValue.fromJson(value)));

  @override
  String toString() {
    return toMap().toString();
  }
}
