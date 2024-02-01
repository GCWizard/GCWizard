import 'package:flutter/material.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/logic/base.dart';
import 'package:gc_wizard/tools/crypto_and_encodings/base/_common/widget/base.dart';

const String _apiSpecification = '''
{
  "/base_base64" : {
    "alternative_paths": ["base64"],
    "get": {
      "summary": "Base64 Tool",
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
          "description": "Input data for Base64 text",
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

class Base64 extends AbstractBase {
  Base64({Key? key})
      : super(
            key: key,
            encode: encodeBase64,
            decode: decodeBase64,
            searchMultimedia: true,
            apiSpecification: _apiSpecification);
}
