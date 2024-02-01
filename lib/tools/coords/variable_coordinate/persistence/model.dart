import 'package:gc_wizard/tools/coords/_common/logic/ellipsoid.dart';
import 'package:gc_wizard/tools/formula_solver/persistence/model.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/default_units_getter.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/length.dart';
import 'package:gc_wizard/tools/science_and_technology/unit_converter/logic/unit.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';

List<VariableCoordinateFormula> formulas = [];

class ProjectionData {
  String distance;
  Length distanceUnit;
  String bearing;
  bool reverse;
  Ellipsoid? ellipsoid;

  ProjectionData(this.distance, this.distanceUnit, this.bearing, this.reverse, [this.ellipsoid]);

  Map<String, Object?> toMap() => {
        'distance': distance,
        'distanceUnit': distanceUnit.name,
        'bearing': bearing,
        'reverse': reverse,
      };

  ProjectionData.fromJson(Map<String, Object?> json)
      : distance = toStringOrNull(json['distance']) ?? '',
        distanceUnit =
            getUnitByName<Length>(allLengths(), toStringOrNull(json['distanceUnit']) ?? '') ?? defaultLengthUnit,
        bearing = toStringOrNull(json['bearing']) ?? '',
        reverse = toBoolOrNull(json['reverse']) ?? false;

  @override
  String toString() {
    return toMap().toString();
  }
}

class VariableCoordinateFormula extends FormulaBase {
  String formula = '';
  ProjectionData? projection;
  List<FormulaValue> values = [];

  VariableCoordinateFormula(String name) : super(name);

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'formula': formula,
        'projection': projection == null ? {} : projection!.toMap(),
        'values': values.map((value) => value.toMap()).toList(),
      };

  static VariableCoordinateFormula fromJson(Map<String, Object?> json) {
    var newFormula =
        VariableCoordinateFormula(toStringOrNull(json['name']) ?? ''); // TODO Proper default types if key is not in map
    newFormula.id = toIntOrNull(json['id']);
    newFormula.formula = toStringOrNull(json['formula']) ?? '';
    newFormula.projection = ProjectionData.fromJson(asJsonMapOrNull(json['projection']) ?? <String, Object?>{});

    var valuesRaw = toObjectWithNullableContentListOrNull(json['values']);
    newFormula.values = <FormulaValue>[];
    if (valuesRaw != null) {
      for (var element in valuesRaw) {
        var value = asJsonMapOrNull(element);
        if (value == null) continue;

        newFormula.values.add(FormulaValue.fromJson(value));
      }
    }
    return newFormula;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
