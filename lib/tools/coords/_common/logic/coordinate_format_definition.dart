import 'package:collection/collection.dart';
import 'package:gc_wizard/tools/coords/_common/formats/dmm/logic/dmm.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';

final CoordinateFormatDefinitionALL = CoordinateFormatDefinition(
    CoordinateFormatKey.ALL, '', '', (String input) => null, DMMFormatDefinition.defaultCoordinate);

CoordinateFormatDefinition? coordinateFormatDefinitionByPersistenceKey(String key) {
  return allCoordinateFormatDefinitions.firstWhereOrNull((format) => format.persistenceKey == key);
}

CoordinateFormatDefinition? coordinateFormatDefinitionSubtypeByPersistenceKey(String key) {
  return _getAllSubtypeCoordinateFormats().firstWhereOrNull((format) => format.persistenceKey == key);
}

List<CoordinateFormatDefinition> _getAllSubtypeCoordinateFormats() {
  var subtypeFormats = allCoordinateFormatDefinitions.whereType<CoordinateFormatWithSubtypesDefinition>().toList();

  return subtypeFormats.fold(<CoordinateFormatDefinition>[],
      (List<CoordinateFormatDefinition> value, CoordinateFormatWithSubtypesDefinition element) {
    value.addAll(element.subtypes);
    return value;
  });
}

CoordinateFormatDefinition coordinateFormatDefinitionByKey(CoordinateFormatKey type) {
  if (type == CoordinateFormatDefinitionALL.type) {
    return CoordinateFormatDefinitionALL;
  }
  var allFormats = List<CoordinateFormatDefinition>.from(allCoordinateFormatDefinitions);
  allFormats.addAll(_getAllSubtypeCoordinateFormats());

  return allFormats.firstWhere((format) => format.type == type);
}

String persistenceKeyByCoordinateFormatKey(CoordinateFormatKey type) {
  return coordinateFormatDefinitionByKey(type).persistenceKey;
}
