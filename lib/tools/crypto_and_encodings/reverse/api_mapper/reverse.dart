import 'package:gc_wizard/tools/crypto_and_encodings/reverse/logic/reverse.dart';

import 'package:gc_wizard/application/webapi/api_mapper.dart';

const String _apiSpecification = '''
{
	"/key_label" : {
		"get": {
			"summary": "Reverse Text Tool",
			"responses": {
        "description": "Reversed text."
			}
		},
		"parameters" : [
			{
				"in": "query",
				"name": "input",
				"required": true,
				"description": "Input data for reverse text",
				"schema": {
					"type": "string"
				}
			},
		]
	}
}
''';

class ReverseAPIMapper extends APIMapper {
  @override
  String get Key => 'reverse';

  @override
  String doLogic() {
    var input = getWebParameter(WEBPARAMETER.input);
    if (input == null) {
      return '';
    }
    return reverse(input);
  }

  /// convert doLogic output to map
  @override
  Map<String, String> toMap(Object result) {
    return <String, String>{enumName(WEBPARAMETER.result.toString()) : result.toString()};
  }

  @override
  String apiSpecification() {
    return _apiSpecification.replaceAll('/key_label', Key);
  }
}
