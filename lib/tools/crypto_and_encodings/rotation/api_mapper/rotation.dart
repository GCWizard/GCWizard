import 'package:gc_wizard/application/webapi/api_mapper.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/rotation/logic/rotation.dart';

const String _apiSpecification = '''
{
  "/key_label" : {
    "get": {
      "summary": "Rotation Tool",
      "responses": {
        "200": {
          "description": "Encoded or decoded text."
        },
        "400": {
          "description": "Bad Request"
        },
        "500": {
          "description": "Internal Server Error"
        }        
      },
      "parameters" : [
        {
          "in": "query",
          "name": "input",
          "required": true,
          "description": "Input data for rotate text",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "parameter1",
          "description": "Shifts letters count",
          "schema": {
            "type": "string",
            "default": "0"
          }
        }
      ]
    }
  }
}
''';

class RotatorAPIMapper extends APIMapper {
  @override
  String get Key => 'rotation_general';

  @override
  String doLogic() {
    var input = getWebParameter(WEBPARAMETER.input);
    if (input == null) {
      return '';
    }
    var parameter1 = getWebParameter(WEBPARAMETER.parameter1);
    var key = 0;
    if (parameter1 != null && parameter1.isNotEmpty) {
      key = int.parse(parameter1);
    }

    return Rotator().rotate(input, key);
  }

  /// convert doLogic output to map
  @override
  Map<String, String> toMap(Object result) {
    return <String, String>{enumName(WEBPARAMETER.result.toString()): result.toString()};
  }

  @override
  String apiSpecification() {
    return _apiSpecification.replaceAll('/key_label', Key);
  }
}
