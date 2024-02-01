import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

const String _apiSpecification = '''
{
  "/base_base16" : {
    "alternative_paths": ["base16"],
    "get": {
      "summary": "Base16 Tool",
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
          "description": "Input data for Base16 text",
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

class Base16 extends AbstractBase {
  Base16({Key? key})
      : super(
            key: key,
            encode: encodeBase16,
            decode: decodeBase16,
            searchMultimedia: false,
            apiSpecification: _apiSpecification);
}
