import 'package:gc_wizard/application/webapi/api_mapper.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/roman_numbers/roman_numbers/logic/roman_numbers.dart';
import 'package:gc_wizard/utils/string_utils.dart';

const String _apiSpecification = '''
{
  "/key_label" : {
    "get": {
      "summary": "Roman numbers Tool",
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
          "description": "Input data for encoding or decoding Roman Numbers",
          "schema": {
            "type": "string"
          }
        },
        {
          "in": "query",
          "name": "mode",
          "description": "Defines encoding or decoding mode",
          "schema": {
            "type": "string",
            "enum": [
              "encode",
              "decode"
            ],
            "default": "decode"
          }
        }
      ]
    }
  }
}
''';

class RomanNumbersAPIMapper extends APIMapper {
  @override
  String get Key => 'roman_numbers';

  @override
  String doLogic() {
    var input = getWebParameter(WEBPARAMETER.input);
    if (input == null) {
      return '';
    }

    if (getWebParameter(WEBPARAMETER.mode) == enumName(MODE.encode.toString())) {
      return encodeRomanNumbers(int.tryParse(input) ?? 0);
    } else {
      return decodeRomanNumbers(input)?.toString() ?? '';
    }
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
