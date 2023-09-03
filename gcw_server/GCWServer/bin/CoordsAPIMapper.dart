import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_constants.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_format_metadata.dart';
import 'package:gc_wizard/tools/coords/_common/logic/coordinate_parser.dart';
import 'package:gc_wizard/tools/coords/_common/logic/default_coord_getter.dart';

import 'APIMapper.dart';

const String _apiSpecification = '''
{
	"/key_label" : {
		"get": {
			"summary": "Coordinate Converter Tool",
			"responses": {
        "description": "Converted Coordinates."
			}
		},
		"parameters" : [
			{
				"in": "query",
				"name": "input",
				"required": true,
				"description": "Input data for parse coordinates",
				"schema": {
					"type": "string"
				}
			},
			{
				"in": "query",
				"name": "toformat",
				"description": "Target coordinate format",
				"schema": {
					"type": "string",
					"enum": [
						coordinate_formats
					],
					"default": "defaultCoordinateFormat"
				}
			}
		]
	}
}
''';

class CoordsFormatconverterAPIMapper extends APIMapper {
  @override
  String get Key => 'coords_formatconverter';

  @override
  String doLogic() {
    var input = getWebParameter(WEBPARAMETER.input);
    if (input == null) {
      return '';
    }
    var results = parseCoordinates(input);
    if (results.isEmpty) return '';

    results.first.toLatLng();
    var targetFormat = getWebParameter(WEBPARAMETER.toformat);
    var key = _getCoordinateFormatKey(targetFormat ?? '');
    var format = CoordinateFormat(key);

    return format.toString();
  }

  /// convert doLogic output to map
  @override
  Map<String, String> toMap(Object result) {
    return <String, String>{enumName(WEBPARAMETER.result.toString()) : result.toString()};
  }

  @override
  String apiSpecification() {
    var info = _apiSpecification;

    var formats = allCoordinateFormatMetadata.map((entry) => '						"' + entry.persistenceKey + '"').join(',\n');
    info = info.replaceAll('						coordinate_formats', formats);
    return info.replaceAll('/key_label', Key);
  }
}

CoordinateFormatKey _getCoordinateFormatKey(String key) {
  var formatKey = coordinateFormatMetadataByPersistenceKey(key)?.type;
  if (formatKey != null) return formatKey;

  return defaultCoordinateFormat.type;
}
