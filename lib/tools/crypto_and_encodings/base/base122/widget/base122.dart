import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

const String _apiSpecification = '''
{
  "/base_base122" : {
    "alternative_paths": ["base122"],
    "get": {
      "summary": "Base122 Tool",
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
          "description": "Input data for Base122 text",
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

class Base122 extends AbstractBase {
  Base122({Key? key})
      : super(
            key: key,
            encode: encodeBase122,
            decode: decodeBase122,
            searchMultimedia: false,
            apiSpecification: _apiSpecification);
}
