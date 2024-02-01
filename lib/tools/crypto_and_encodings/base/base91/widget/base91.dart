import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

const String _apiSpecification = '''
{
  "/base_base91" : {
    "alternative_paths": ["base91"],
    "get": {
      "summary": "Base91 Tool",
      "responses": {
        "204": {
          "description": "Tool loaded. No response data."
        }
      },
      "parameters" : [
        {
          "in": "query",
          "name": "input",
          "required": true,
          "description": "Input data for Base91 text",
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

class Base91 extends AbstractBase {
  Base91({Key? key})
      : super(
            key: key,
            encode: encodeBase91,
            decode: decodeBase91,
            searchMultimedia: false,
            apiSpecification: _apiSpecification);
}
